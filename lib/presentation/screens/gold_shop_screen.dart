import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/purchase_service.dart';
import '../../core/services/ad_service.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/repositories/currency_repository.dart';

/// ゴールドショップ画面（IAPによるゴールド購入）
class GoldShopScreen extends StatefulWidget {
  const GoldShopScreen({super.key});

  @override
  State<GoldShopScreen> createState() => _GoldShopScreenState();
}

class _GoldShopScreenState extends State<GoldShopScreen> {
  late PurchaseService _purchaseService;
  late CurrencyRepository _currencyRepo;
  late AdService _adService;
  StreamSubscription<PurchaseState>? _purchaseSub;

  CurrencyWallet? _wallet;
  bool _loading = true;
  PurchaseState _purchaseState = PurchaseState.idle;
  String? _purchasingProductId;
  int _adWatchCount = 0;
  bool _isWatchingAd = false;

  @override
  void initState() {
    super.initState();
    _purchaseService = PurchaseService();
    _currencyRepo = CurrencyRepository();
    _adService = AdService();
    _loadWallet();
    _loadAdWatchCount();

    _purchaseSub = _purchaseService.purchaseStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _purchaseState = state;
        if (state != PurchaseState.pending) _purchasingProductId = null;
      });

      if (state == PurchaseState.success) {
        _loadWallet();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ゴールドを獲得しました！')),
        );
      } else if (state == PurchaseState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('購入に失敗しました: ${_purchaseService.lastError ?? "不明なエラー"}')),
        );
      }
    });
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }

  Future<void> _loadWallet() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    final wallet = await _currencyRepo.getWallet(userId);
    if (!mounted) return;
    setState(() {
      _wallet = wallet;
      _loading = false;
    });
  }

  void _buy(String productId) {
    setState(() => _purchasingProductId = productId);
    _purchaseService.buyGoldPack(productId);
  }

  Future<void> _loadAdWatchCount() async {
    final count = await _adService.getTodayWatchCount();
    if (!mounted) return;
    setState(() => _adWatchCount = count);
  }

  Future<void> _watchAd() async {
    setState(() => _isWatchingAd = true);
    final earned = await _adService.showRewardedAdForGold();
    if (!mounted) return;
    setState(() => _isWatchingAd = false);

    if (earned) {
      await _loadWallet();
      await _loadAdWatchCount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_adService.rewardGoldAmount}ゴールドを獲得しました！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('広告を表示できませんでした。しばらくしてから再度お試しください')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final goldPacks = _purchaseService.goldPackProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('ゴールドショップ')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GoldBalanceCard(gold: _wallet?.gold ?? 0),
                  const SizedBox(height: 16),
                  _WatchAdCard(
                    watchCount: _adWatchCount,
                    dailyLimit: _adService.dailyWatchLimit,
                    rewardAmount: _adService.rewardGoldAmount,
                    isWatching: _isWatchingAd,
                    onWatch: _watchAd,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ゴールドパック',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_purchaseService.isAvailable)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'ストアに接続できません',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else if (goldPacks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          '現在購入可能な商品がありません',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...goldPacks.map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GoldPackCard(
                          product: product,
                          goldAmount:
                              PurchaseService.goldPackAmounts[product.id] ?? 0,
                          isPurchasing: _purchaseState == PurchaseState.pending &&
                              _purchasingProductId == product.id,
                          isDisabled: _purchaseState == PurchaseState.pending,
                          onBuy: () => _buy(product.id),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _GoldBalanceCard extends StatelessWidget {
  final int gold;

  const _GoldBalanceCard({required this.gold});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.25),
            Colors.orange.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '所持ゴールド',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '$gold',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WatchAdCard extends StatelessWidget {
  final int watchCount;
  final int dailyLimit;
  final int rewardAmount;
  final bool isWatching;
  final VoidCallback onWatch;

  const _WatchAdCard({
    required this.watchCount,
    required this.dailyLimit,
    required this.rewardAmount,
    required this.isWatching,
    required this.onWatch,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (dailyLimit - watchCount).clamp(0, dailyLimit);
    final canWatch = remaining > 0 && !isWatching;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withOpacity(0.2),
            Colors.cyan.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.tealAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Colors.tealAccent, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '広告を見て$rewardAmountゴールド獲得',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8D5B0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '本日あと$remaining/$dailyLimit回',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 88,
            child: ElevatedButton(
              onPressed: canWatch ? onWatch : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
              ),
              child: isWatching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(remaining > 0 ? '視聴する' : '上限到達'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldPackCard extends StatelessWidget {
  final ProductDetails product;
  final int goldAmount;
  final bool isPurchasing;
  final bool isDisabled;
  final VoidCallback onBuy;

  const _GoldPackCard({
    required this.product,
    required this.goldAmount,
    required this.isPurchasing,
    required this.isDisabled,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$goldAmount ゴールド',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE8D5B0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 88,
              child: ElevatedButton(
                onPressed: isDisabled ? null : onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                ),
                child: isPurchasing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(product.price),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
