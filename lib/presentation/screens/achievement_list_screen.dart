import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../core/services/firebase_service.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/achievement_display.dart';
import 'achievement_detail_view.dart';

class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {
  late AchievementRepository _achievementRepo;
  late FirebaseService _firebaseService;
  
  AchievementCategory? _selectedCategory;
  AchievementDifficulty? _selectedDifficulty;
  _UnlockFilter _unlockFilter = _UnlockFilter.all;
  _SortBy _sortBy = _SortBy.name;
  
  List<Achievement> _allAchievements = [];
  final Map<String, bool> _unlockedStatus = {}; // achievementId -> isUnlocked

  @override
  void initState() {
    super.initState();
    _achievementRepo = AchievementRepository();
    _firebaseService = FirebaseService();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final achievements = _achievementRepo.getAllAchievements();
    final userId = _firebaseService.userId;
    
    setState(() {
      _allAchievements = achievements;
    });
    
    // Load user's achievement progress
    if (userId != null) {
      for (final achievement in achievements) {
        final progress = await _achievementRepo.getAchievementProgress(
          userId,
          achievement.id,
        );
        setState(() {
          _unlockedStatus[achievement.id] = progress?.isUnlocked ?? false;
        });
      }
    }
  }

  List<Achievement> get _filteredAchievements {
    var filtered = _allAchievements.toList();
    
    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((a) => a.category == _selectedCategory).toList();
    }
    
    // Filter by difficulty
    if (_selectedDifficulty != null) {
      filtered = filtered.where((a) => a.difficulty == _selectedDifficulty).toList();
    }
    
    // Filter by unlock status
    switch (_unlockFilter) {
      case _UnlockFilter.unlocked:
        filtered = filtered.where((a) => _unlockedStatus[a.id] ?? false).toList();
        break;
      case _UnlockFilter.locked:
        filtered = filtered.where((a) => !(_unlockedStatus[a.id] ?? false)).toList();
        break;
      case _UnlockFilter.all:
        break;
    }
    
    // Sort
    switch (_sortBy) {
      case _SortBy.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortBy.difficulty:
        final diffOrder = {
          AchievementDifficulty.bronze: 0,
          AchievementDifficulty.silver: 1,
          AchievementDifficulty.gold: 2,
          AchievementDifficulty.diamond: 3,
        };
        filtered.sort((a, b) => 
          (diffOrder[a.difficulty] ?? 0).compareTo(diffOrder[b.difficulty] ?? 0)
        );
        break;
      case _SortBy.category:
        filtered.sort((a, b) => a.category.name.compareTo(b.category.name));
        break;
    }
    
    return filtered;
  }

  String _getCategoryLabel(AppLocalizations l10n, AchievementCategory category) {
    switch (category) {
      case AchievementCategory.combat:
        return l10n.achievementCategoryCombat;
      case AchievementCategory.progression:
        return l10n.achievementCategoryProgression;
      case AchievementCategory.prestige:
        return l10n.achievementCategoryPrestige;
      case AchievementCategory.cosmetic:
        return l10n.achievementCategoryCosmetic;
      case AchievementCategory.milestone:
        return l10n.achievementCategoryMilestone;
      case AchievementCategory.event:
        return l10n.achievementCategoryEvent;
    }
  }

  String _getDifficultyLabel(AppLocalizations l10n, AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return l10n.achievementDifficultyBronze;
      case AchievementDifficulty.silver:
        return l10n.achievementDifficultySilver;
      case AchievementDifficulty.gold:
        return l10n.achievementDifficultyGold;
      case AchievementDifficulty.diamond:
        return l10n.achievementDifficultyDiamond;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredAchievements = _filteredAchievements;
    final unlockedCount = _unlockedStatus.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.achievementListTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Statistics
            _AchievementStatistics(
              unlockedCount: unlockedCount,
              totalCount: _allAchievements.length,
            ),
            const SizedBox(height: 16),

            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.achievementFilterTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Filter
                  _FilterChipGroup(
                    label: l10n.achievementFilterCategory,
                    options: [
                      l10n.achievementFilterAll,
                      ...AchievementCategory.values.map((c) => _getCategoryLabel(l10n, c)),
                    ],
                    selectedIndex: _selectedCategory == null
                        ? 0
                        : AchievementCategory.values.indexOf(_selectedCategory!) + 1,
                    onChanged: (index) {
                      setState(() {
                        _selectedCategory = index == 0
                            ? null
                            : AchievementCategory.values[index - 1];
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Difficulty Filter
                  _FilterChipGroup(
                    label: l10n.achievementFilterDifficulty,
                    options: [
                      l10n.achievementFilterAll,
                      ...AchievementDifficulty.values.map((d) => _getDifficultyLabel(l10n, d)),
                    ],
                    selectedIndex: _selectedDifficulty == null
                        ? 0
                        : AchievementDifficulty.values.indexOf(_selectedDifficulty!) + 1,
                    onChanged: (index) {
                      setState(() {
                        _selectedDifficulty = index == 0
                            ? null
                            : AchievementDifficulty.values[index - 1];
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Unlock Status Filter
                  _FilterChipGroup(
                    label: l10n.achievementFilterStatus,
                    options: [
                      l10n.achievementFilterAll,
                      l10n.achievementFilterUnlocked,
                      l10n.achievementFilterLocked,
                    ],
                    selectedIndex: _unlockFilter.index,
                    onChanged: (index) {
                      setState(() {
                        _unlockFilter = _UnlockFilter.values[index];
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Sort
                  _FilterChipGroup(
                    label: l10n.achievementFilterSort,
                    options: [
                      l10n.achievementSortName,
                      l10n.achievementFilterDifficulty,
                      l10n.achievementFilterCategory,
                    ],
                    selectedIndex: _sortBy.index,
                    onChanged: (index) {
                      setState(() {
                        _sortBy = _SortBy.values[index];
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Achievement List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredAchievements.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          l10n.achievementEmptyFiltered,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: filteredAchievements.length,
                      itemBuilder: (context, index) {
                        final achievement = filteredAchievements[index];
                        final isUnlocked = _unlockedStatus[achievement.id] ?? false;
                        
                        return AchievementCard(
                          achievement: achievement,
                          isUnlocked: isUnlocked,
                          onTap: () => _showDetailView(context, achievement, isUnlocked),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showDetailView(
    BuildContext context,
    Achievement achievement,
    bool isUnlocked,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF2A1A0A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AchievementDetailView(
        achievement: achievement,
        isUnlocked: isUnlocked,
      ),
    );
  }
}

enum _UnlockFilter { all, unlocked, locked }
enum _SortBy { name, difficulty, category }

class _AchievementStatistics extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;

  const _AchievementStatistics({
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalCount > 0 ? (unlockedCount / totalCount * 100).toInt() : 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B6914), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.achievementClearRate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              Text(
                '$unlockedCount / $totalCount',
                style: const TextStyle(
                  fontSize: 16,
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
        ],
      ),
    );
  }
}

class _FilterChipGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final int selectedIndex;
  final Function(int) onChanged;

  const _FilterChipGroup({
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB0A090),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(
            options.length,
            (index) => FilterChip(
              label: Text(options[index]),
              selected: selectedIndex == index,
              onSelected: (_) => onChanged(index),
              backgroundColor: Colors.transparent,
              selectedColor: const Color(0xFF8B1A1A),
              side: BorderSide(
                color: selectedIndex == index
                    ? const Color(0xFF8B1A1A)
                    : const Color(0xFF8B6914),
              ),
              labelStyle: TextStyle(
                color: selectedIndex == index
                    ? Colors.white
                    : const Color(0xFFE8D5B0),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
