import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/user_progression.dart';
import '../../data/models/cosmetic.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../../domain/progression/prestige_manager.dart';
import '../widgets/screen_transition.dart';

/// プレスティジコスメティック・ショーケース画面
class PrestigeCosmeticsShowcaseScreen extends StatefulWidget {
  const PrestigeCosmeticsShowcaseScreen({super.key});

  @override
  State<PrestigeCosmeticsShowcaseScreen> createState() =>
      _PrestigeCosmeticsShowcaseScreenState();
}

class _PrestigeCosmeticsShowcaseScreenState
    extends State<PrestigeCosmeticsShowcaseScreen> {
  late ProgressionRepository _progressionRepo;
  late RewardRepository _rewardRepo;
  late PrestigeManager _prestigeManager;

  UserProgression? _userProgression;
  List<Cosmetic> _prestigeCosmetics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _progressionRepo = ProgressionRepository();
    _rewardRepo = RewardRepository();
    _prestigeManager = PrestigeManager(
      progressionRepository: _progressionRepo,
      rewardRepository: _rewardRepo,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final progression = await _progressionRepo.getUserProgression(userId);
      final cosmetics = await _rewardRepo.getUserCosmetics(userId);

      // フィルター：プレスティジ報酬のコスメティックのみ
      final prestigeCosmetics = cosmetics
          .where((c) => c.acquisitionMethod == AcquisitionMethod.prestigeReward)
          .toList();

      setState(() {
        _userProgression = progression;
        _prestigeCosmetics = prestigeCosmetics;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading prestige showcase data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('プレスティジコスメティック')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final progression = _userProgression;

    return Scaffold(
      appBar: AppBar(title: const Text('プレスティジコスメティック')),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (progression != null)
                _PrestigeProgressCard(progression: progression),
              const SizedBox(height: 24),
              ..._buildTierSections(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTierSections() {
    return PrestigeTier.values.map((tier) {
      final tierCosmetics = _prestigeCosmetics
          .where(
            (c) =>
                c.id.contains(tier.name) ||
                _cosmeticsBelongsToTier(c.id, tier),
          )
          .toList();

      final isUnlocked =
          _userProgression != null && _userProgression!.prestigeRank.index >= tier.index;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PrestigeTierHeader(
            tier: tier,
            isUnlocked: isUnlocked,
            playerProgress: _userProgression,
          ),
          const SizedBox(height: 12),
          if (tierCosmetics.isNotEmpty)
            _PrestigeCosmeticsList(
              tier: tier,
              cosmetics: tierCosmetics,
              isUnlocked: isUnlocked,
            )
          else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'このランクのコスメティックはまだありません',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  bool _cosmeticsBelongsToTier(String cosmeticId, PrestigeTier tier) {
    return cosmeticId.contains('prestige_${tier.name}');
  }
}

class _PrestigeProgressCard extends StatelessWidget {
  final UserProgression progression;

  const _PrestigeProgressCard({required this.progression});

  @override
  Widget build(BuildContext context) {
    final currentTier = progression.prestigeRank;
    final nextTierIndex = currentTier.index + 1;
    final hasNextTier = nextTierIndex < PrestigeTier.values.length;
    final nextTier =
        hasNextTier ? PrestigeTier.values[nextTierIndex] : null;

    final progressToNext = nextTier != null
        ? (progression.prestigePoints / nextTier.pointsRequired)
            .clamp(0.0, 1.0)
        : 1.0;

    return Card(
      color: Color(currentTier.color).withOpacity(0.2),
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
                    const Text(
                      '現在のプレスティジランク',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentTier.displayName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(currentTier.color),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(currentTier.color).withOpacity(0.1),
                    border: Border.all(
                      color: Color(currentTier.color),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _getTierEmoji(currentTier),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (nextTier != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '次のランク: ${nextTier.displayName}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${progression.prestigePoints} / ${nextTier.pointsRequired}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressToNext,
                  minHeight: 8,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(nextTier.color),
                  ),
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '最高ランク: ${currentTier.displayName}に到達しました！',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(currentTier.color),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'リセット回数: ${progression.prestigeResetCount}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTierEmoji(PrestigeTier tier) {
    return switch (tier) {
      PrestigeTier.bronze => '🥉',
      PrestigeTier.silver => '🥈',
      PrestigeTier.gold => '🥇',
      PrestigeTier.platinum => '💎',
      PrestigeTier.diamond => '👑',
    };
  }
}

class _PrestigeTierHeader extends StatelessWidget {
  final PrestigeTier tier;
  final bool isUnlocked;
  final UserProgression? playerProgress;

  const _PrestigeTierHeader({
    required this.tier,
    required this.isUnlocked,
    required this.playerProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(tier.color).withOpacity(0.15),
        border: Border(
          left: BorderSide(
            color: Color(tier.color),
            width: 3,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tier.displayName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(tier.color),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '必要ポイント: ${tier.pointsRequired}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Color(tier.color).withOpacity(0.2),
                border: Border.all(color: Color(tier.color)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '解放済み',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(tier.color),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(color: Colors.grey[700]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '未解放',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PrestigeCosmeticsList extends StatelessWidget {
  final PrestigeTier tier;
  final List<Cosmetic> cosmetics;
  final bool isUnlocked;

  const _PrestigeCosmeticsList({
    required this.tier,
    required this.cosmetics,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cosmetics.asMap().entries.map((entry) {
        final index = entry.key;
        final cosmetic = entry.value;

        return Column(
          children: [
            _PrestigeCosmeticCard(
              tier: tier,
              cosmetic: cosmetic,
              isUnlocked: isUnlocked,
              index: index,
            ),
            if (index < cosmetics.length - 1)
              const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }
}

class _PrestigeCosmeticCard extends StatefulWidget {
  final PrestigeTier tier;
  final Cosmetic cosmetic;
  final bool isUnlocked;
  final int index;

  const _PrestigeCosmeticCard({
    required this.tier,
    required this.cosmetic,
    required this.isUnlocked,
    required this.index,
  });

  @override
  State<_PrestigeCosmeticCard> createState() => _PrestigeCosmeticCardState();
}

class _PrestigeCosmeticCardState extends State<_PrestigeCosmeticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: widget.isUnlocked
              ? Color(widget.tier.color).withOpacity(0.1)
              : Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cosmetic.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isUnlocked
                              ? Color(widget.tier.color)
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.cosmetic.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isUnlocked
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'タイプ: ${widget.cosmetic.type.displayName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isUnlocked
                        ? Color(widget.tier.color).withOpacity(0.2)
                        : Colors.grey[800],
                    border: Border.all(
                      color: widget.isUnlocked
                          ? Color(widget.tier.color)
                          : Colors.grey[700]!,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.isUnlocked ? '取得済み' : 'ロック中',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: widget.isUnlocked
                          ? Color(widget.tier.color)
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
