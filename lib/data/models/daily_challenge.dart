import 'scenario_data.dart';
import 'difficulty_mode.dart';

/// 日替わりチャレンジシステムのモデル

/// チャレンジの成功条件タイプ
enum ChallengeConditionType {
  victory('勝利'),                    // シナリオクリア
  turnLimit('ターン数制限'),          // 指定ターン数以下
  noDefeats('無傷クリア'),            // 主要ユニット損失率0%
  tpTarget('TP達成'),                 // 指定TP数以上達成
  scoreTarget('スコア達成');          // 指定スコア以上

  final String displayName;
  const ChallengeConditionType(this.displayName);
}

/// チャレンジの条件定義
class ChallengeCondition {
  final ChallengeConditionType type;
  final int value; // 条件値（ターン数、TP数、スコアなど）

  ChallengeCondition({
    required this.type,
    required this.value,
  });

  factory ChallengeCondition.fromJson(Map<String, dynamic> json) {
    return ChallengeCondition(
      type: ChallengeConditionType.values.byName(json['type'] as String),
      value: json['value'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'value': value,
      };
}

/// 日替わりチャレンジの定義
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final Scenario scenario;
  final DifficultyMode difficulty;
  final List<ChallengeCondition> conditions; // 複数の条件（AND判定）
  final int baseReward; // 報酬スコア
  final int achievementPoints; // アチーブメントポイント
  final DateTime availableFrom; // チャレンジ有効開始日時
  final DateTime availableUntil; // チャレンジ有効終了日時

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.scenario,
    required this.difficulty,
    required this.conditions,
    required this.baseReward,
    required this.achievementPoints,
    required this.availableFrom,
    required this.availableUntil,
  });

  /// チャレンジが現在有効かチェック
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(availableFrom) && now.isBefore(availableUntil);
  }

  /// チャレンジの説明テキスト生成
  String get conditionDescription {
    return conditions.map((c) {
      switch (c.type) {
        case ChallengeConditionType.victory:
          return 'シナリオをクリア';
        case ChallengeConditionType.turnLimit:
          return '${c.value}ターン以内でクリア';
        case ChallengeConditionType.noDefeats:
          return '主要ユニットを損失せずクリア';
        case ChallengeConditionType.tpTarget:
          return '${c.value}個以上のTPを達成';
        case ChallengeConditionType.scoreTarget:
          return '${c.value}ポイント以上のスコア獲得';
      }
    }).join('\n');
  }

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      scenario: Scenario.values.byName(json['scenario'] as String),
      difficulty: DifficultyMode.values.byName(json['difficulty'] as String),
      conditions: (json['conditions'] as List)
          .map((c) => ChallengeCondition.fromJson(c as Map<String, dynamic>))
          .toList(),
      baseReward: json['baseReward'] as int,
      achievementPoints: json['achievementPoints'] as int,
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableUntil: DateTime.parse(json['availableUntil'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'scenario': scenario.name,
        'difficulty': difficulty.name,
        'conditions': conditions.map((c) => c.toJson()).toList(),
        'baseReward': baseReward,
        'achievementPoints': achievementPoints,
        'availableFrom': availableFrom.toIso8601String(),
        'availableUntil': availableUntil.toIso8601String(),
      };
}

/// チャレンジ達成状態
class ChallengeProgress {
  final String challengeId;
  final DateTime completedAt; // 達成日時、nullなら未達成
  final bool claimed; // 報酬受け取り済みか

  ChallengeProgress({
    required this.challengeId,
    this.completedAt,
    this.claimed = false,
  });

  bool get isCompleted => completedAt != null;

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      challengeId: json['challengeId'] as String,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      claimed: json['claimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'challengeId': challengeId,
        'completedAt': completedAt?.toIso8601String(),
        'claimed': claimed,
      };
}

/// チャレンジ統計
class ChallengeStats {
  final int totalCompleted; // 達成したチャレンジ数
  final int totalClaimed; // 報酬受け取ったチャレンジ数
  final int totalRewardPoints; // 獲得した報酬スコア合計
  final int totalAchievementPoints; // 獲得したアチーブメントポイント合計
  final Map<Scenario, int> completionByScenario; // シナリオ別達成数
  final Map<DifficultyMode, int> completionByDifficulty; // 難易度別達成数

  ChallengeStats({
    required this.totalCompleted,
    required this.totalClaimed,
    required this.totalRewardPoints,
    required this.totalAchievementPoints,
    required this.completionByScenario,
    required this.completionByDifficulty,
  });

  factory ChallengeStats.empty() {
    return ChallengeStats(
      totalCompleted: 0,
      totalClaimed: 0,
      totalRewardPoints: 0,
      totalAchievementPoints: 0,
      completionByScenario: {},
      completionByDifficulty: {},
    );
  }
}
