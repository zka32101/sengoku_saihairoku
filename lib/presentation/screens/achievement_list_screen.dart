import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../core/services/firebase_service.dart';
import '../widgets/achievement_display.dart';

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
  Map<String, bool> _unlockedStatus = {}; // achievementId -> isUnlocked

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

  String _getCategoryLabel(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.combat:
        return '戦闘';
      case AchievementCategory.progression:
        return '進行度';
      case AchievementCategory.prestige:
        return 'プレスティジ';
      case AchievementCategory.cosmetic:
        return 'コスメティック';
      case AchievementCategory.milestone:
        return 'マイルストーン';
      case AchievementCategory.event:
        return 'イベント';
    }
  }

  String _getDifficultyLabel(AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return 'ブロンズ';
      case AchievementDifficulty.silver:
        return 'シルバー';
      case AchievementDifficulty.gold:
        return 'ゴールド';
      case AchievementDifficulty.diamond:
        return 'ダイヤモンド';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAchievements = _filteredAchievements;
    final unlockedCount = _unlockedStatus.values.where((v) => v).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('実績'),
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
                  const Text(
                    'フィルター',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Category Filter
                  _FilterChipGroup(
                    label: 'カテゴリー',
                    options: [
                      'すべて',
                      ...AchievementCategory.values.map((c) => _getCategoryLabel(c)),
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
                    label: '難易度',
                    options: [
                      'すべて',
                      ...AchievementDifficulty.values.map((d) => _getDifficultyLabel(d)),
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
                    label: 'ステータス',
                    options: const ['すべて', 'クリア済み', 'ロック中'],
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
                    label: 'ソート',
                    options: const ['名前', '難易度', 'カテゴリー'],
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
                          'フィルター条件に一致する実績がありません',
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
              const Text(
                'クリア率',
                style: TextStyle(
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
