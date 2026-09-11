/// ゲーム内アチーブメント（実績）システム
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon; // emoji or icon name
  final AchievementCategory category;
  final int points; // ポイント（表彰用）
  final AchievementCondition condition;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.points,
    required this.condition,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: AchievementCategory.values.byName(json['category'] as String),
      points: json['points'] as int,
      condition: AchievementCondition.fromJson(
        json['condition'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'category': category.name,
        'points': points,
        'condition': condition.toJson(),
      };
}

/// アチーブメントの条件
class AchievementCondition {
  final String type; // 'win_count', 'scenario', 'difficulty', 'tp_count', 'time', 'combo'
  final Map<String, dynamic> parameters;

  AchievementCondition({
    required this.type,
    required this.parameters,
  });

  factory AchievementCondition.fromJson(Map<String, dynamic> json) {
    return AchievementCondition(
      type: json['type'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'parameters': parameters,
      };

  /// 条件が満たされているか確認
  bool isMet(AchievementProgress progress) {
    return switch (type) {
      'win_count' => progress.totalWins >= (parameters['required'] as int),
      'scenario' => (parameters['scenarios'] as List?)
              ?.contains(progress.lastScenario) ??
          false,
      'difficulty' => parameters['difficulty'] == progress.lastDifficulty,
      'tp_count' => progress.maxTPsAchieved >= (parameters['required'] as int),
      'time' => progress.fastestBattleTime <= (parameters['seconds'] as int),
      'combo' => progress.maxCombo >= (parameters['required'] as int),
      _ => false,
    };
  }
}

/// アチーブメントカテゴリ
enum AchievementCategory {
  beginner('初心者向け', '👶'),
  victory('勝利', '⚔️'),
  mastery('マスター', '🏆'),
  challenge('チャレンジ', '💪'),
  exploration('発見', '🔍'),
  skill('スキル', '✨');

  final String displayName;
  final String icon;

  const AchievementCategory(this.displayName, this.icon);
}

/// ユーザーのアチーブメント進捗
class AchievementProgress {
  final String achievementId;
  final bool unlocked;
  final DateTime? unlockedAt;
  final int progressValue; // 進捗値（0-100）

  // 進捗追跡用のフィールド
  final int totalWins;
  final int totalBattles;
  final String? lastScenario;
  final String? lastDifficulty;
  final int maxTPsAchieved;
  final int fastestBattleTime; // 秒単位
  final int maxCombo;

  AchievementProgress({
    required this.achievementId,
    required this.unlocked,
    this.unlockedAt,
    this.progressValue = 0,
    this.totalWins = 0,
    this.totalBattles = 0,
    this.lastScenario,
    this.lastDifficulty,
    this.maxTPsAchieved = 0,
    this.fastestBattleTime = 999999,
    this.maxCombo = 0,
  });

  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'] as String,
      unlocked: json['unlocked'] as bool,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      progressValue: json['progressValue'] as int? ?? 0,
      totalWins: json['totalWins'] as int? ?? 0,
      totalBattles: json['totalBattles'] as int? ?? 0,
      lastScenario: json['lastScenario'] as String?,
      lastDifficulty: json['lastDifficulty'] as String?,
      maxTPsAchieved: json['maxTPsAchieved'] as int? ?? 0,
      fastestBattleTime: json['fastestBattleTime'] as int? ?? 999999,
      maxCombo: json['maxCombo'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'achievementId': achievementId,
        'unlocked': unlocked,
        if (unlockedAt != null) 'unlockedAt': unlockedAt!.toIso8601String(),
        'progressValue': progressValue,
        'totalWins': totalWins,
        'totalBattles': totalBattles,
        if (lastScenario != null) 'lastScenario': lastScenario,
        if (lastDifficulty != null) 'lastDifficulty': lastDifficulty,
        'maxTPsAchieved': maxTPsAchieved,
        'fastestBattleTime': fastestBattleTime,
        'maxCombo': maxCombo,
      };

  /// 進捗パーセンテージを取得（テーブル用）
  double get progressPercent => (progressValue / 100).clamp(0.0, 1.0);
}

/// アチーブメントの進捗バッジ
class AchievementBadge {
  final String achievementId;
  final String name;
  final String icon;
  final int points;
  final bool unlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 ～ 1.0

  AchievementBadge({
    required this.achievementId,
    required this.name,
    required this.icon,
    required this.points,
    required this.unlocked,
    this.unlockedAt,
    this.progress = 0.0,
  });
}
