/// ユーザープログレッションシステムのモデル

/// ユーザーの進捗・レベル・プレスティジ情報
class UserProgression {
  final String userId;
  final int experiencePoints; // 累積経験値
  final int currentLevel; // 現在レベル（1-100）
  final PrestigeTier prestigeRank; // プレスティジランク
  final int prestigePoints; // プレスティジポイント
  final int totalPlayTime; // プレイ時間（秒）
  final String? favoriteScenario; // お気に入りシナリオ
  final List<String> unlockedCosmetics; // アンロック済みコスメティック
  final String? equippedUnitSkin; // 装備中のユニットスキン
  final String? equippedUiTheme; // 装備中のUIテーマ
  final int prestigeResetCount; // プレスティジリセット回数
  final DateTime lastUpdated; // 最終更新時刻

  UserProgression({
    required this.userId,
    required this.experiencePoints,
    required this.currentLevel,
    required this.prestigeRank,
    required this.prestigePoints,
    required this.totalPlayTime,
    this.favoriteScenario,
    this.unlockedCosmetics = const [],
    this.equippedUnitSkin,
    this.equippedUiTheme,
    this.prestigeResetCount = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// 次のレベルまでの進捗（0.0-1.0）
  double get progressToNextLevel {
    if (currentLevel >= 100) return 1.0;
    final currentLevelXp = LevelingSystem.getXpRequiredForLevel(currentLevel);
    final nextLevelXp = LevelingSystem.getXpRequiredForLevel(currentLevel + 1);
    final progressXp = experiencePoints - currentLevelXp;
    final totalForLevel = nextLevelXp - currentLevelXp;
    return (progressXp / totalForLevel).clamp(0.0, 1.0);
  }

  /// プレスティジ可能か
  bool get canPrestige =>
      currentLevel >= 100 && prestigePoints >= 1000;

  /// このユーザーがまだ一度もプレスティジしていないか
  bool get isFirstPrestige => prestigeResetCount == 0;

  factory UserProgression.fromJson(Map<String, dynamic> json) {
    return UserProgression(
      userId: json['userId'] as String,
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      prestigeRank: PrestigeTier.values.byName(
        json['prestigeRank'] as String? ?? 'bronze',
      ),
      prestigePoints: json['prestigePoints'] as int? ?? 0,
      totalPlayTime: json['totalPlayTime'] as int? ?? 0,
      favoriteScenario: json['favoriteScenario'] as String?,
      unlockedCosmetics: List<String>.from(
        json['unlockedCosmetics'] as List? ?? [],
      ),
      equippedUnitSkin: json['equippedUnitSkin'] as String?,
      equippedUiTheme: json['equippedUiTheme'] as String?,
      prestigeResetCount: json['prestigeResetCount'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'experiencePoints': experiencePoints,
        'currentLevel': currentLevel,
        'prestigeRank': prestigeRank.name,
        'prestigePoints': prestigePoints,
        'totalPlayTime': totalPlayTime,
        'favoriteScenario': favoriteScenario,
        'unlockedCosmetics': unlockedCosmetics,
        'equippedUnitSkin': equippedUnitSkin,
        'equippedUiTheme': equippedUiTheme,
        'prestigeResetCount': prestigeResetCount,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  UserProgression copyWith({
    int? experiencePoints,
    int? currentLevel,
    PrestigeTier? prestigeRank,
    int? prestigePoints,
    int? totalPlayTime,
    String? favoriteScenario,
    List<String>? unlockedCosmetics,
    String? equippedUnitSkin,
    String? equippedUiTheme,
    int? prestigeResetCount,
  }) {
    return UserProgression(
      userId: userId,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      currentLevel: currentLevel ?? this.currentLevel,
      prestigeRank: prestigeRank ?? this.prestigeRank,
      prestigePoints: prestigePoints ?? this.prestigePoints,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      favoriteScenario: favoriteScenario ?? this.favoriteScenario,
      unlockedCosmetics: unlockedCosmetics ?? this.unlockedCosmetics,
      equippedUnitSkin: equippedUnitSkin ?? this.equippedUnitSkin,
      equippedUiTheme: equippedUiTheme ?? this.equippedUiTheme,
      prestigeResetCount: prestigeResetCount ?? this.prestigeResetCount,
      lastUpdated: DateTime.now(),
    );
  }
}

/// プレスティジランク（ターン効率に基づく）
enum PrestigeTier {
  bronze('ブロンズ', 0, 0xFFCD7F32),
  silver('シルバー', 1000, 0xFFC0C0C0),
  gold('ゴールド', 2000, 0xFFFFD700),
  platinum('プラチナ', 3500, 0xFFE5E4E2),
  diamond('ダイヤモンド', 5000, 0xFF00D9FF);

  final String displayName;
  final int pointsRequired;
  final int color;

  const PrestigeTier(this.displayName, this.pointsRequired, this.color);
}

/// レベルシステムのロジック
class LevelingSystem {
  static const int maxLevel = 100;
  static const int baseXpPerLevel = 1000;
  static const double xpCurveMultiplier = 1.08; // 指数関数的な成長

  /// 指定レベルに到達するために必要な累積XP
  static int getXpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    if (level > maxLevel) return getXpRequiredForLevel(maxLevel);

    int totalXp = 0;
    for (int i = 2; i <= level; i++) {
      totalXp += (baseXpPerLevel * pow(xpCurveMultiplier, (i - 1).toDouble()))
          .toInt();
    }
    return totalXp;
  }

  /// 指定XPから現在のレベルを計算
  static int getLevelFromXp(int totalXp) {
    for (int level = maxLevel; level >= 1; level--) {
      if (totalXp >= getXpRequiredForLevel(level)) {
        return level;
      }
    }
    return 1;
  }

  /// このレベルがマイルストーンか（報酬あり）
  static bool isMilestoneLevel(int level) =>
      level == 10 ||
      level == 25 ||
      level == 50 ||
      level == 75 ||
      level == 100;

  /// マイルストーンの報酬を取得
  static String? getMilestoneReward(int level) {
    return switch (level) {
      10 => '初級ユニットスキン解放',
      25 => 'UI テーマ「紅葉」解放',
      50 => 'UI テーマ「夜間」解放',
      75 => '上級ユニットスキン解放',
      100 => 'プレスティジシステム解放',
      _ => null,
    };
  }
}

// pow が標準ライブラリにない場合のポリフィル
double pow(double base, double exponent) {
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}

/// XP獲得履歴
class XpGainRecord {
  final int xpGained;
  final String source; // "battle", "challenge", "achievement"
  final DateTime timestamp;
  final Map<String, double> multipliers; // difficulty, streak, mastery など

  XpGainRecord({
    required this.xpGained,
    required this.source,
    DateTime? timestamp,
    this.multipliers = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  factory XpGainRecord.fromJson(Map<String, dynamic> json) {
    return XpGainRecord(
      xpGained: json['xpGained'] as int,
      source: json['source'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      multipliers: Map<String, double>.from(
        json['multipliers'] as Map? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'xpGained': xpGained,
        'source': source,
        'timestamp': timestamp.toIso8601String(),
        'multipliers': multipliers,
      };
}
