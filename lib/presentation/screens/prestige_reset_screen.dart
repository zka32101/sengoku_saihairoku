import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/user_progression.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../../domain/progression/prestige_manager.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/screen_transition.dart';

/// プレスティジリセット画面
class PrestigeResetScreen extends StatefulWidget {
  const PrestigeResetScreen({super.key});

  @override
  State<PrestigeResetScreen> createState() => _PrestigeResetScreenState();
}

class _PrestigeResetScreenState extends State<PrestigeResetScreen> {
  late ProgressionRepository _progressionRepo;
  late PrestigeManager _prestigeManager;
  UserProgression? _userProgression;
  bool _isLoading = true;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _progressionRepo = ProgressionRepository();
    _prestigeManager = PrestigeManager(
      progressionRepository: _progressionRepo,
      rewardRepository: RewardRepository(),
    );
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final progression = await _progressionRepo.getUserProgression(userId);
      setState(() {
        _userProgression = progression;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmPrestige() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _PrestigeConfirmationDialog(
        userProgression: _userProgression!,
      ),
    );

    if (confirmed == true) {
      await _performPrestige();
    }
  }

  Future<void> _performPrestige() async {
    final l10n = AppLocalizations.of(context)!;
    final userId = FirebaseService().userId;
    if (userId == null) return;

    setState(() => _isResetting = true);

    try {
      await _prestigeManager.performPrestige(userId);

      // UIを更新
      await _loadUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.prestigeResetSuccessMessage),
            duration: const Duration(seconds: 2),
          ),
        );

        // 成功画面を表示
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error performing prestige: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.prestigeResetErrorMessage(e.toString()))),
        );
      }
    } finally {
      setState(() => _isResetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prestigeResetTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_userProgression == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prestigeResetTitle)),
        body: Center(child: Text(l10n.profileLoadError)),
      );
    }

    final progression = _userProgression!;
    final canPrestige = progression.currentLevel >= 100 &&
        progression.prestigePoints >= 1000;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.prestigeResetTitle)),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PrestigeInfoCard(progression: progression, l10n: l10n),
              const SizedBox(height: 24),
              if (progression.currentLevel < 100)
                _LockedCard(
                    reason: l10n.prestigeResetLockedLevelReason, l10n: l10n)
              else if (!canPrestige)
                _LockedCard(
                  reason: l10n.prestigeResetLockedPointsReason(
                      progression.prestigePoints),
                  l10n: l10n,
                )
              else
                _PrestigeActionCard(
                  isResetting: _isResetting,
                  onPrestige: _confirmPrestige,
                  l10n: l10n,
                ),
              const SizedBox(height: 24),
              _PrestigeBenefitsCard(l10n: l10n),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrestigeInfoCard extends StatelessWidget {
  final UserProgression progression;
  final AppLocalizations l10n;

  const _PrestigeInfoCard({required this.progression, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final tier = progression.prestigeRank;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(tier.color).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(tier.color),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '✦',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(tier.color),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.prestigeResetCurrentRankLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        tier.displayName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(tier.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFF8B6914)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileLevelLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progression.currentLevel}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.profilePrestigePoints,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progression.prestigePoints}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(tier.color),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.prestigeResetCountSuffix(progression.prestigeResetCount),
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
}

class _LockedCard extends StatelessWidget {
  final String reason;
  final AppLocalizations l10n;

  const _LockedCard({required this.reason, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[900]?.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.lock,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.prestigeResetLockedTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE8D5B0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              reason,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrestigeActionCard extends StatelessWidget {
  final bool isResetting;
  final VoidCallback onPrestige;
  final AppLocalizations l10n;

  const _PrestigeActionCard({
    required this.isResetting,
    required this.onPrestige,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF8B1A1A).withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.prestigeResetActionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.prestigeResetActionDescription,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isResetting ? null : onPrestige,
              icon: isResetting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.star),
              label: Text(isResetting
                  ? l10n.prestigeResetProcessing
                  : l10n.prestigeResetActionTitle),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrestigeBenefitsCard extends StatelessWidget {
  final AppLocalizations l10n;

  const _PrestigeBenefitsCard({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.prestigeResetBenefitsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF8B6914)),
            const SizedBox(height: 12),
            _BenefitRow(
              icon: Icons.restart_alt,
              title: l10n.prestigeResetBenefit1Title,
              description: l10n.prestigeResetBenefit1Desc,
            ),
            const SizedBox(height: 12),
            _BenefitRow(
              icon: Icons.star,
              title: l10n.prestigeResetBenefit2Title,
              description: l10n.prestigeResetBenefit2Desc,
            ),
            const SizedBox(height: 12),
            _BenefitRow(
              icon: Icons.card_giftcard,
              title: l10n.prestigeResetBenefit3Title,
              description: l10n.prestigeResetBenefit3Desc,
            ),
            const SizedBox(height: 12),
            _BenefitRow(
              icon: Icons.trending_up,
              title: l10n.prestigeResetBenefit4Title,
              description: l10n.prestigeResetBenefit4Desc,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFFFD700),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8D5B0),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrestigeConfirmationDialog extends StatelessWidget {
  final UserProgression userProgression;

  const _PrestigeConfirmationDialog({required this.userProgression});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.prestigeResetConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.prestigeResetConfirmIntro,
            style: TextStyle(color: Colors.grey[300]),
          ),
          const SizedBox(height: 16),
          _ConfirmationItem(
            label: l10n.prestigeResetConfirmCurrentLevel,
            value: '${userProgression.currentLevel}',
            willReset: true,
          ),
          const SizedBox(height: 8),
          _ConfirmationItem(
            label: l10n.profilePrestigePoints,
            value: '${userProgression.prestigePoints}',
            willReset: false,
          ),
          const SizedBox(height: 8),
          _ConfirmationItem(
            label: l10n.prestigeResetConfirmRank,
            value: userProgression.prestigeRank.displayName,
            willReset: false,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              border: Border.all(color: Colors.orange, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.orange[400], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.prestigeResetIrreversibleWarning,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.black,
          ),
          child: Text(l10n.prestigeResetConfirmExecuteButton),
        ),
      ],
    );
  }
}

class _ConfirmationItem extends StatelessWidget {
  final String label;
  final String value;
  final bool willReset;

  const _ConfirmationItem({
    required this.label,
    required this.value,
    required this.willReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              willReset ? Icons.refresh : Icons.check_circle,
              size: 16,
              color: willReset ? Colors.red : Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}
