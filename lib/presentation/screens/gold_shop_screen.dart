import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/purchase_service.dart';
import '../../core/services/ad_service.dart';
import '../../data/models/currency_wallet.dart';
import '../../data/repositories/currency_repository.dart';
import '../../l10n/generated/app_localizations.dart';

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

      final l10n = AppLocalizations.of(context)!;
      if (state == PurchaseState.success) {
        _loadWallet();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.goldShopPurchaseSuccess)),
        );
      } else if (state == PurchaseState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.goldShopPurchaseFailure(
                _purchaseService.lastError ?? l10n.goldShopUnknownError)),
          ),
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
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isWatchingAd = true);
    final earned = await _adService.showRewardedAdForGold();
    if (!mounted) return;
    setState(() => _isWatchingAd = false);

    if (earned) {
      await _loadWallet();
      await _loadAdWatchCount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(l10n.goldShopAdRewardEarned(_adService.rewardGoldAmount))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.goldShopAdFailure)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final goldPacks = _purchaseService.goldPackProducts;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goldShopTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GoldBalanceCard(gold: _wallet?.gold ?? 0, l10n: l10n),
                  const SizedBox(height: 16),
                  _WatchAdCard(
                    watchCount: _adWatchCount,
                    dailyLimit: _adService.dailyWatchLimit,
                    rewardAmount: _adService.rewardGoldAmount,
                    isWatching: _isWatchingAd,
                    onWatch: _watchAd,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.goldShopPacksTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_purchaseService.isAvailable)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.goldShopStoreUnavailable,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else if (goldPacks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.goldShopNoProducts,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...goldPacks.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final product = entry.value;
                        // goldPackProductsは小→大の順。中間パックを「人気」、
                        // 最大パックを「もっともお得」としてアンカリングし、
                        // 購入検討時の比較を後押しする。
                        final isLast = index == goldPacks.length - 1;
                        final isMiddle =
                            goldPacks.length >= 3 && index == goldPacks.length - 2;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _GoldPackCard(
                            product: product,
                            goldAmount:
                                PurchaseService.goldPackAmounts[product.id] ?? 0,
                            isPurchasing: _purchaseState == PurchaseState.pending &&
                                _purchasingProductId == product.id,
                            isDisabled: _purchaseState == PurchaseState.pending,
                            badgeLabel: isLast
                                ? l10n.goldShopBestValueBadge
                                : (isMiddle ? l10n.goldShopPopularBadge : null),
                            onBuy: () => _buy(product.id),
                            l10n: l10n,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}

class _GoldBalanceCard extends StatelessWidget {
  final int gold;
  final AppLocalizations l10n;

  const _GoldBalanceCard({required this.gold, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.25),
            Colors.orange.withValues(alpha: 0.15),
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
              Text(
                l10n.goldShopBalanceLabel,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
  final AppLocalizations l10n;

  const _WatchAdCard({
    required this.watchCount,
    required this.dailyLimit,
    required this.rewardAmount,
    required this.isWatching,
    required this.onWatch,
    required this.l10n,
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
            Colors.teal.withValues(alpha: 0.2),
            Colors.cyan.withValues(alpha: 0.1),
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
                  l10n.goldShopWatchAdTitle(rewardAmount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8D5B0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.goldShopWatchAdRemaining(remaining, dailyLimit),
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
                  : Text(remaining > 0
                      ? l10n.goldShopWatchButton
                      : l10n.goldShopWatchLimitReached),
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
  final String? badgeLabel;
  final VoidCallback onBuy;
  final AppLocalizations l10n;

  const _GoldPackCard({
    required this.product,
    required this.goldAmount,
    required this.isPurchasing,
    required this.isDisabled,
    this.badgeLabel,
    required this.onBuy,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = badgeLabel != null;

    return Card(
      shape: highlighted
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.amber, width: 2),
            )
          : null,
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
                  Row(
                    children: [
                      Text(
                        l10n.goldShopGoldAmount(goldAmount),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE8D5B0),
                        ),
                      ),
                      if (badgeLabel != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeLabel!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ],
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
