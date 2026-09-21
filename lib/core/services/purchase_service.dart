import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'firebase_service.dart';
import '../../data/repositories/battle_pass_repository.dart';

/// 購入フローの状態
enum PurchaseState { idle, pending, success, error }

/// アプリ内課金（IAP）を管理するサービス
///
/// 現在対応している商品：
/// - バトルパス プレミアムトラック（非消耗型・買い切り）
///
/// 注意：ここでのレシート保存はクライアント側の記録に過ぎない。
/// 本番運用では Cloud Functions 等でストアのレシートをサーバー検証し、
/// 検証済みの場合のみ `activatePremium` を呼ぶ構成に強化すること
/// （クライアントのみの実装は改ざん・リプレイに対して脆弱）。
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  static const String battlePassPremiumProductId = 'battle_pass_premium_season';

  static const Set<String> _productIds = {battlePassPremiumProductId};

  final InAppPurchase _iap = InAppPurchase.instance;
  final BattlePassRepository _battlePassRepo = BattlePassRepository();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final StreamController<PurchaseState> _stateController =
      StreamController<PurchaseState>.broadcast();

  bool _available = false;
  bool _initialized = false;
  List<ProductDetails> _products = [];
  String? _lastError;

  /// 購入状態の変化を通知するストリーム
  Stream<PurchaseState> get purchaseStateStream => _stateController.stream;

  bool get isAvailable => _available;
  String? get lastError => _lastError;

  ProductDetails? get battlePassPremiumProduct {
    for (final product in _products) {
      if (product.id == battlePassPremiumProductId) return product;
    }
    return null;
  }

  /// 初期化（ストア接続確認・購入ストリーム購読・商品情報取得）
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      _available = await _iap.isAvailable();
      if (!_available) {
        print('⚠️ In-app purchases not available on this device');
        return;
      }

      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (Object error) {
          _lastError = error.toString();
          _stateController.add(PurchaseState.error);
        },
      );

      final response = await _iap.queryProductDetails(_productIds);
      if (response.error != null) {
        print('❌ Error querying products: ${response.error}');
      }
      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found in store: ${response.notFoundIDs}');
      }
      _products = response.productDetails;
      print('✅ PurchaseService initialized (${_products.length} products)');
    } catch (e) {
      print('❌ Error initializing PurchaseService: $e');
    }
  }

  /// バトルパス プレミアムトラックの購入を開始
  Future<void> buyPremiumBattlePass() async {
    final product = battlePassPremiumProduct;
    if (!_available || product == null) {
      _lastError = 'ストアに接続できません';
      _stateController.add(PurchaseState.error);
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: product);
    _stateController.add(PurchaseState.pending);
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _lastError = e.toString();
      _stateController.add(PurchaseState.error);
    }
  }

  /// 過去の購入を復元（機種変更・再インストール時など）
  Future<void> restorePurchases() async {
    if (!_available) return;
    _stateController.add(PurchaseState.pending);
    try {
      await _iap.restorePurchases();
    } catch (e) {
      _lastError = e.toString();
      _stateController.add(PurchaseState.error);
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _stateController.add(PurchaseState.pending);
        case PurchaseStatus.error:
          _lastError = purchase.error?.message;
          _stateController.add(PurchaseState.error);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _deliverProduct(purchase);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        case PurchaseStatus.canceled:
          _stateController.add(PurchaseState.idle);
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      _lastError = 'ユーザーが認証されていません';
      _stateController.add(PurchaseState.error);
      return;
    }

    if (purchase.productID != battlePassPremiumProductId) return;

    try {
      // 購入記録を保存（監査・重複付与防止用）
      final recordId = purchase.purchaseID ??
          '${purchase.productID}_${purchase.transactionDate ?? DateTime.now().millisecondsSinceEpoch}';

      final recordRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('purchases')
          .doc(recordId);

      final existing = await recordRef.get();
      if (existing.exists) {
        // すでに処理済みの購入（復元時の重複配布を防止）
        _stateController.add(PurchaseState.success);
        return;
      }

      await recordRef.set({
        'productId': purchase.productID,
        'verificationSource': purchase.verificationData.source,
        'serverVerificationData':
            purchase.verificationData.serverVerificationData,
        'transactionDate': purchase.transactionDate,
        'recordedAt': FieldValue.serverTimestamp(),
      });

      await _battlePassRepo.activatePremium(userId);
      _stateController.add(PurchaseState.success);
    } catch (e) {
      _lastError = e.toString();
      _stateController.add(PurchaseState.error);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }
}
