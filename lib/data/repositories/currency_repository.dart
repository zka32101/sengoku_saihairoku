import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/currency_wallet.dart';

/// ゴールド（ゲーム内通貨）残高を管理するリポジトリ
class CurrencyRepository {
  static final CurrencyRepository _instance = CurrencyRepository._internal();
  factory CurrencyRepository() => _instance;
  CurrencyRepository._internal();

  DocumentReference _walletRef(String userId) => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('wallet')
      .doc('gold');

  CollectionReference _transactionsRef(String userId) => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('wallet_transactions');

  /// 現在のゴールド残高を取得（未作成なら空ウォレットを返す）
  Future<CurrencyWallet> getWallet(String userId) async {
    try {
      final doc = await _walletRef(userId).get();
      if (!doc.exists) {
        return CurrencyWallet.empty(userId);
      }
      return CurrencyWallet.fromFirestore(doc);
    } catch (e) {
      print('Error getting wallet: $e');
      return CurrencyWallet.empty(userId);
    }
  }

  /// ゴールドを加算（バトルパス報酬・IAP購入など）
  Future<CurrencyWallet> addGold(
    String userId,
    int amount, {
    required String source,
  }) async {
    if (amount <= 0) return getWallet(userId);
    return _applyDelta(userId, amount, source);
  }

  /// ゴールドを消費。残高不足の場合は false を返し、残高は変更しない
  Future<bool> spendGold(
    String userId,
    int amount, {
    required String source,
  }) async {
    if (amount <= 0) return true;

    final current = await getWallet(userId);
    if (current.gold < amount) return false;

    await _applyDelta(userId, -amount, source);
    return true;
  }

  Future<CurrencyWallet> _applyDelta(
    String userId,
    int delta,
    String source,
  ) async {
    try {
      final walletRef = _walletRef(userId);
      final updated = await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(walletRef);
        final current = snapshot.exists
            ? CurrencyWallet.fromFirestore(snapshot)
            : CurrencyWallet.empty(userId);

        final newBalance = (current.gold + delta).clamp(0, 1 << 31);
        final next = current.copyWith(gold: newBalance);
        tx.set(walletRef, next.toFirestore());
        return next;
      });

      await _transactionsRef(userId).add(
        CurrencyTransaction(
          amount: delta,
          source: source,
          createdAt: DateTime.now(),
        ).toFirestore(),
      );

      return updated;
    } catch (e) {
      print('Error applying currency delta: $e');
      return getWallet(userId);
    }
  }
}
