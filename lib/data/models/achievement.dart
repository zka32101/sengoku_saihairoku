import 'package:cloud_firestore/cloud_firestore.dart';

/// 実績のカテゴリー
enum AchievementCategory {
  combat,      // 戦闘関連
  progression, // 進行度関連
  prestige,    // プレスティジ関連
  cosmetic,    // コスメティック関連
  milestone,   // マイルストーン関連
  event,       // イベント関連
}

/// 実績の難易度
enum AchievementDifficulty {
  bronze,  // 簡単
  silver,  // 普通
  gold,    // 難しい
  diamond, // 非常に難しい
}

/// 実績の獲得条件タイプ
enum AchievementConditionType {
  battleWins,        // 戦闘勝利回数
  levelReached,      // レベル到達
  prestigeRank,      // プレスティジランク到達
  prestigeResetCount,// プレスティジリセット回数
  turnEfficiency,    // ターン効率
  cosmeticUnlocked,  // コスメティック解放数
  totalPlayTime,     // 総プレイ時間
  scenarioCleared,   // シナリオクリア
  perfectBattle,     // パーフェクト戦闘
}

/// 実績定義
class Achievement {
  final String id;
  final String name;
  final String description;
  final String? icon; // emoji or asset path
  final AchievementCategory category;
  final AchievementDifficulty difficulty;
  final AchievementConditionType conditionType;
  final int conditionValue;
  final String? reward; // cosmetic id or special reward
  final int? points; // achievement points for ranking

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.category,
    required this.difficulty,
    required this.conditionType,
    required this.conditionValue,
    this.reward,
    this.points,
  });

  /// JSON からの生成
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      category: AchievementCategory.values.byName(json['category'] as String),
      difficulty: AchievementDifficulty.values.byName(json['difficulty'] as String),
      conditionType: AchievementConditionType.values.byName(json['conditionType'] as String),
      conditionValue: json['conditionValue'] as int,
      reward: json['reward'] as String?,
      points: json['points'] as int?,
    );
  }

  /// JSON への変換
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'category': category.name,
    'difficulty': difficulty.name,
    'conditionType': conditionType.name,
    'conditionValue': conditionValue,
    'reward': reward,
    'points': points,
  };
}

/// ユーザーの実績進捗
class AchievementProgress {
  final String userId;
  final String achievementId;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int? progress; // 進捗値（0-100など）
  final DateTime createdAt;
  final DateTime updatedAt;

  const AchievementProgress({
    required this.userId,
    required this.achievementId,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firestore ドキュメントからの生成
  factory AchievementProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AchievementProgress(
      userId: data['userId'] as String,
      achievementId: data['achievementId'] as String,
      isUnlocked: data['isUnlocked'] as bool? ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
      progress: data['progress'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Firestore ドキュメントへの変換
  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'achievementId': achievementId,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
    'progress': progress,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}

/// 実績統計情報
class AchievementStats {
  final int totalAchievements;
  final int unlockedCount;
  final double unlockedPercentage;
  final int totalPoints;
  final Map<AchievementCategory, int> categoryProgress;
  final DateTime lastUnlockedAt;

  const AchievementStats({
    required this.totalAchievements,
    required this.unlockedCount,
    required this.unlockedPercentage,
    required this.totalPoints,
    required this.categoryProgress,
    required this.lastUnlockedAt,
  });
}
