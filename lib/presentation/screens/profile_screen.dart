import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/user_progression.dart';
import '../../data/models/cosmetic.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/screen_transition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProgressionRepository _progressionRepo;
  late RewardRepository _rewardRepo;
  late AchievementRepository _achievementRepo;
  UserProgression? _userProgression;
  List<Cosmetic> _userCosmetics = [];
  int _unlockedAchievementCount = 0;
  int _totalAchievementCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _progressionRepo = ProgressionRepository();
    _rewardRepo = RewardRepository();
    _achievementRepo = AchievementRepository();
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
      final cosmetics = await _rewardRepo.getUserCosmetics(userId);
      final userAchievements = await _achievementRepo.getUserAchievements(userId);
      final unlockedCount = userAchievements.where((a) => a.isUnlocked).length;
      final totalCount = _achievementRepo.getAllAchievements().length;

      setState(() {
        _userProgression = progression;
        _userCosmetics = cosmetics;
        _unlockedAchievementCount = unlockedCount;
        _totalAchievementCount = totalCount;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_userProgression == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.profileTitle)),
        body: Center(child: Text(l10n.profileLoadError)),
      );
    }

    final progression = _userProgression!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LevelCard(progression: progression, l10n: l10n),
              const SizedBox(height: 16),
              _PrestigeCard(progression: progression, l10n: l10n),
              const SizedBox(height: 16),
              _AchievementStatsCard(
                unlockedCount: _unlockedAchievementCount,
                totalCount: _totalAchievementCount,
                onViewAll: () => Navigator.pushNamed(context, '/achievements'),
                l10n: l10n,
              ),
              const SizedBox(height: 16),
              _CosmeticsCard(cosmetics: _userCosmetics, l10n: l10n),
              const SizedBox(height: 16),
              _ProgressionDetailsCard(progression: progression, l10n: l10n),
              const SizedBox(height: 24),
              _ActionButtonsCard(
                  context: context, progression: progression, l10n: l10n),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final UserProgression progression;
  final AppLocalizations l10n;

  const _LevelCard({required this.progression, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final progressPercent = progression.progressToNextLevel * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                      l10n.profileLevelLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${progression.currentLevel}',
                      style: const TextStyle(
                        fontSize: 36,
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
                      l10n.profileXpLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.profileXpSuffix(
                        progression.experiencePoints.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]},',
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // XP進捗バー
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.profileNextLevelProgress,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${progressPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progression.progressToNextLevel,
                    minHeight: 8,
                    backgroundColor: Colors.grey[700],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFD700),
                    ),
                  ),
                ),
              ],
            ),
            if (progression.currentLevel >= 100)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.profileMaxLevelReached,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PrestigeCard extends StatelessWidget {
  final UserProgression progression;
  final AppLocalizations l10n;

  const _PrestigeCard({required this.progression, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final prestigeTier = progression.prestigeRank;
    final prestigePercent =
        (progression.prestigePoints / prestigeTier.pointsRequired * 100)
            .clamp(0.0, 100.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(prestigeTier.color).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(prestigeTier.color),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '✦',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(prestigeTier.color),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profilePrestigeRank,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        prestigeTier.displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(prestigeTier.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF8B6914)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profilePrestigePoints,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  '${progression.prestigePoints} / ${prestigeTier.pointsRequired}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(prestigeTier.color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: prestigePercent / 100,
                minHeight: 6,
                backgroundColor: Colors.grey[700],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(prestigeTier.color),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.profilePrestigeResetCount(progression.prestigeResetCount),
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

class _CosmeticsCard extends StatelessWidget {
  final List<Cosmetic> cosmetics;
  final AppLocalizations l10n;

  const _CosmeticsCard({required this.cosmetics, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final unitSkins = cosmetics.where((c) => c.type == CosmeticType.unitSkin).toList();
    final uiThemes = cosmetics.where((c) => c.type == CosmeticType.uiTheme).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileCosmeticsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 16),
            if (unitSkins.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileUnitSkinsLabel(unitSkins.length),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: unitSkins.map((cosmetic) {
                      return _CosmeticBadge(cosmetic: cosmetic);
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            if (uiThemes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileUiThemesLabel(uiThemes.length),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: uiThemes.map((cosmetic) {
                      return _CosmeticBadge(cosmetic: cosmetic);
                    }).toList(),
                  ),
                ],
              ),
            if (cosmetics.isEmpty)
              Center(
                child: Text(
                  l10n.profileCosmeticsEmpty,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CosmeticBadge extends StatelessWidget {
  final Cosmetic cosmetic;

  const _CosmeticBadge({required this.cosmetic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cosmetic.isEquipped
            ? const Color(0xFF8B1A1A).withValues(alpha: 0.3)
            : Colors.grey[800],
        border: Border.all(
          color: cosmetic.isEquipped
              ? const Color(0xFFFFD700)
              : Colors.grey[600]!,
          width: cosmetic.isEquipped ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            cosmetic.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cosmetic.isEquipped
                  ? const Color(0xFFFFD700)
                  : Colors.grey[300],
            ),
          ),
          if (cosmetic.isEquipped) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.check_circle,
              size: 14,
              color: Color(0xFFFFD700),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressionDetailsCard extends StatelessWidget {
  final UserProgression progression;
  final AppLocalizations l10n;

  const _ProgressionDetailsCard({required this.progression, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileProgressionDetailsTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF8B6914)),
            const SizedBox(height: 12),
            _DetailRow(
              label: l10n.profileUserIdLabel,
              value: progression.userId.length > 20
                  ? '${progression.userId.substring(0, 20)}...'
                  : progression.userId,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              label: l10n.profilePlayTimeLabel,
              value: _formatPlayTime(l10n, progression.totalPlayTime),
            ),
            const SizedBox(height: 10),
            _DetailRow(
              label: l10n.profileLastUpdatedLabel,
              value: _formatDateTime(l10n, progression.lastUpdated),
            ),
            const SizedBox(height: 10),
            _DetailRow(
              label: l10n.profileUnlockedCosmeticsLabel,
              value: l10n.profileUnlockedCosmeticsCount(
                  progression.unlockedCosmetics.length),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPlayTime(AppLocalizations l10n, int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return l10n.profilePlayTimeFormat(hours, minutes);
  }

  String _formatDateTime(AppLocalizations l10n, DateTime dateTime) {
    return l10n.profileDateFormat(
        dateTime.year, dateTime.month, dateTime.day);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE8D5B0),
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButtonsCard extends StatelessWidget {
  final BuildContext context;
  final UserProgression progression;
  final AppLocalizations l10n;

  const _ActionButtonsCard({
    required this.context,
    required this.progression,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.profileActionsTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/cosmetics_equipment'),
              icon: const Icon(Icons.palette),
              label: Text(l10n.profileCosmeticsSettingsButton),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 8),
            if (progression.currentLevel >= 100)
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/prestige_reset'),
                icon: const Icon(Icons.star),
                label: Text(l10n.profilePrestigeButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.lock),
                label: Text(l10n.profilePrestigeLockedButton(100)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AchievementStatsCard extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final VoidCallback onViewAll;
  final AppLocalizations l10n;

  const _AchievementStatsCard({
    required this.unlockedCount,
    required this.totalCount,
    required this.onViewAll,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalCount > 0 ? (unlockedCount / totalCount * 100).toInt() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.profileAchievementsTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                Text(
                  '$unlockedCount / $totalCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8D5B0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalCount > 0 ? unlockedCount / totalCount : 0,
                minHeight: 8,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 80
                      ? Colors.green
                      : percentage >= 50
                          ? Colors.yellow
                          : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFE8D5B0),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewAll,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(l10n.profileAchievementsViewAllButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
