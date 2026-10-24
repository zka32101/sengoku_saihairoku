import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/purchase_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/repositories/battle_pass_repository.dart';
import '../../data/models/battle_pass.dart';
import '../../l10n/generated/app_localizations.dart';

class BattlePassScreen extends StatefulWidget {
  const BattlePassScreen({super.key});

  @override
  State<BattlePassScreen> createState() => _BattlePassScreenState();
}

class _BattlePassScreenState extends State<BattlePassScreen> {
  late BattlePassRepository _battlePassRepo;
  late FirebaseService _firebaseService;
  late PurchaseService _purchaseService;
  StreamSubscription<PurchaseState>? _purchaseSub;

  BattlePass? _currentBattlePass;
  BattlePassProgress? _userProgress;
  bool _loading = true;
  PurchaseState _purchaseState = PurchaseState.idle;

  @override
  void initState() {
    super.initState();
    _battlePassRepo = BattlePassRepository();
    _firebaseService = FirebaseService();
    _purchaseService = PurchaseService();
    _loadBattlePassData();

    _purchaseSub = _purchaseService.purchaseStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _purchaseState = state);

      final l10n = AppLocalizations.of(context)!;
      if (state == PurchaseState.success) {
        _loadBattlePassData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.battlePassPremiumUnlockedSnackbar)),
        );
      } else if (state == PurchaseState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.battlePassPurchaseFailedSnackbar(
                _purchaseService.lastError ?? l10n.battlePassUnknownError)),
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

  Future<void> _loadBattlePassData() async {
    final userId = _firebaseService.userId;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      setState(() {
        _currentBattlePass = _battlePassRepo.getCurrentBattlePass();
      });

      final progress = await _battlePassRepo.getUserBattlePassProgress(userId);
      setState(() {
        _userProgress = progress;
        _loading = false;
      });

      // シーズン終了が近い場合はリマインダーを予約、そうでなければ解除
      final daysRemaining = _battlePassRepo.getDaysRemaining();
      if (daysRemaining > 0 && daysRemaining <= 3) {
        await NotificationService().scheduleBattlePassExpiryReminder(daysRemaining);
      } else {
        await NotificationService().cancelBattlePassExpiryReminder();
      }
    } catch (e) {
      debugPrint('Error loading battle pass data: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading || _currentBattlePass == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.battlePassTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final progress = _userProgress ?? _BattlePassProgressPlaceholder();
    final daysRemaining = _battlePassRepo.getDaysRemaining();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.battlePassTitle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Season Header
            _SeasonHeader(
              battlePass: _currentBattlePass!,
              daysRemaining: daysRemaining,
              l10n: l10n,
            ),
            const SizedBox(height: 24),

            // Current Tier Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CurrentTierCard(
                progress: progress,
                battlePass: _currentBattlePass!,
                l10n: l10n,
              ),
            ),
            const SizedBox(height: 24),

            if (!progress.hasPremium)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PremiumUpsellCard(
                  product: _purchaseService.battlePassPremiumProduct,
                  isStoreAvailable: _purchaseService.isAvailable,
                  isPurchasing: _purchaseState == PurchaseState.pending,
                  missedRewardCount:
                      _currentBattlePass!.missedPremiumRewardCount(progress),
                  onBuy: () => _purchaseService.buyPremiumBattlePass(),
                  onRestore: () => _purchaseService.restorePurchases(),
                  l10n: l10n,
                ),
              ),
            if (!progress.hasPremium) const SizedBox(height: 24),

            // Tier List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.battlePassTierRewardsTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentBattlePass!.tiers.length,
              itemBuilder: (context, index) {
                final tier = _currentBattlePass!.tiers[index];
                final isUnlocked = progress.unlockedRewards.contains(tier.rewardId);
                final isCurrentTier = progress.currentTier == tier.tierNumber;

                return _TierRewardCard(
                  tier: tier,
                  isUnlocked: isUnlocked,
                  isCurrentTier: isCurrentTier,
                  currentProgress: progress,
                  userHasPremium: progress.hasPremium,
                  l10n: l10n,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SeasonHeader extends StatelessWidget {
  final BattlePass battlePass;
  final int daysRemaining;
  final AppLocalizations l10n;

  const _SeasonHeader({
    required this.battlePass,
    required this.daysRemaining,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.2),
            Colors.cyan.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            battlePass.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            battlePass.description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.battlePassSeasonEndLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.battlePassSeasonEndDate(battlePass.endDate.year,
                        battlePass.endDate.month, battlePass.endDate.day),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.battlePassDaysRemainingLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.battlePassDaysRemainingValue(daysRemaining),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: daysRemaining > 7 ? Colors.cyan : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumUpsellCard extends StatelessWidget {
  final ProductDetails? product;
  final bool isStoreAvailable;
  final bool isPurchasing;
  final int missedRewardCount;
  final VoidCallback onBuy;
  final VoidCallback onRestore;
  final AppLocalizations l10n;

  const _PremiumUpsellCard({
    required this.product,
    required this.isStoreAvailable,
    required this.isPurchasing,
    required this.missedRewardCount,
    required this.onBuy,
    required this.onRestore,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final priceLabel =
        product?.price ?? (isStoreAvailable ? '---' : l10n.battlePassStoreUnavailable);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.25),
            Colors.deepPurple.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.purple, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.battlePassPremiumUnlockTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.battlePassPremiumUnlockDescription,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (missedRewardCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.battlePassMissedRewardWarning(missedRewardCount),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isStoreAvailable && product != null && !isPurchasing)
                  ? onBuy
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: isPurchasing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.battlePassUnlockForPrice(priceLabel)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: isPurchasing ? null : onRestore,
              child: Text(
                l10n.battlePassRestorePurchase,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentTierCard extends StatelessWidget {
  final BattlePassProgressView progress;
  final BattlePass battlePass;
  final AppLocalizations l10n;

  const _CurrentTierCard({
    required this.progress,
    required this.battlePass,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final currentTier = progress.currentTier;
    final maxTier = battlePass.maxTier;
    final currentTierData = currentTier <= battlePass.tiers.length
        ? battlePass.tiers[currentTier - 1]
        : null;

    final progressPercent = currentTier >= maxTier
        ? 1.0
        : (currentTierData != null
            ? (progress.currentXp / currentTierData.xpRequired).clamp(0.0, 1.0)
            : 0.0);

    final xpUntilNext = currentTier >= maxTier
        ? 0
        : (currentTierData?.xpRequired ?? 0) - progress.currentXp;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.battlePassCurrentTierLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.battlePassTierOfMax(currentTier, maxTier),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
                if (progress.hasPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.2),
                      border: Border.all(color: Colors.purple, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.battlePassPremiumBadge,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (currentTier < maxTier) ...[
              // XP Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.battlePassProgressLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        l10n.battlePassXpOfTotal(
                            progress.currentXp, currentTierData?.xpRequired ?? 0),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      minHeight: 8,
                      backgroundColor: Colors.grey[700],
                      valueColor: AlwaysStoppedAnimation(
                        progressPercent > 0.7
                            ? Colors.cyan
                            : Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.battlePassXpUntilNextTier(xpUntilNext),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ] else
              Center(
                child: Text(
                  l10n.battlePassMaxTierReached,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TierRewardCard extends StatelessWidget {
  final BattlePassTier tier;
  final bool isUnlocked;
  final bool isCurrentTier;
  final BattlePassProgressView currentProgress;
  final bool userHasPremium;
  final AppLocalizations l10n;

  const _TierRewardCard({
    required this.tier,
    required this.isUnlocked,
    required this.isCurrentTier,
    required this.currentProgress,
    required this.userHasPremium,
    required this.l10n,
  });

  bool get _canAccess {
    if (tier.track == BattlePassTrack.free) return true;
    if (tier.track == BattlePassTrack.premium) return userHasPremium;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final canAccess = _canAccess;
    // プレミアム未加入でも、既に通過したティアはunlockedRewardsに
    // 記録される（gainXp参照）が、実際に報酬が付与されるのは
    // canAccessがtrueの場合のみ。「受け取り済み」表示は両方を満たす時だけ。
    final isClaimed = isUnlocked && canAccess;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Opacity(
        opacity: canAccess ? 1.0 : 0.6,
        child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isClaimed
              ? const Color(0xFF1A2A1A).withValues(alpha: 0.8)
              : const Color(0xFF2A1A0A),
          border: Border.all(
            color: isClaimed
                ? Colors.green
                : (canAccess ? Colors.grey[600]! : Colors.grey[700]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Tier Number
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCurrentTier
                    ? Colors.cyan.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
                border: Border.all(
                  color: isCurrentTier ? Colors.cyan : Colors.grey[600]!,
                  width: isCurrentTier ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  tier.tierNumber.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        isCurrentTier ? Colors.cyan : const Color(0xFFE8D5B0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Reward Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tier.rewardName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isClaimed
                              ? Colors.cyan
                              : const Color(0xFFE8D5B0),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: tier.track == BattlePassTrack.free
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.purple.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tier.track == BattlePassTrack.free
                              ? l10n.battlePassFreeBadge
                              : l10n.battlePassPremiumBadge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: tier.track == BattlePassTrack.free
                                ? Colors.green
                                : Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (tier.rewardDescription != null)
                    Text(
                      tier.rewardDescription!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Status Icon
            if (isClaimed)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              )
            else if (!canAccess)
              const Icon(
                Icons.lock,
                color: Colors.grey,
                size: 24,
              )
            else
              const Icon(
                Icons.lock_open,
                color: Colors.grey,
                size: 24,
              ),
          ],
        ),
        ),
      ),
    );
  }
}

/// Placeholder for when no progress is loaded
class _BattlePassProgressPlaceholder implements BattlePassProgressView {
  @override
  int get currentTier => 1;

  @override
  int get currentXp => 0;

  @override
  List<String> get unlockedRewards => [];

  @override
  bool get hasPremium => false;
}
