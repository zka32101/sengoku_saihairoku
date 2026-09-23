import 'package:cloud_firestore/cloud_firestore.dart';
import 'scenario_data.dart';
import 'difficulty_mode.dart';
import 'daily_challenge.dart';

/// 期間限定イベントチャレンジの定義
///
/// 日替わりチャレンジ（[DailyChallenge]）とは異なり、Firestoreの
/// `events`コレクションから配信される、開始・終了日時を持つ特別チャレンジ。
/// 週末限定シナリオ縛りや倍報酬キャンペーンなどに使う。
class EventChallenge {
  final String id;
  final String title;
  final String description;
  final Scenario scenario;
  final DifficultyMode difficulty;
  final List<ChallengeCondition> conditions;
  final int baseReward;
  final int achievementPoints;
  final double rewardMultiplier; // 通常チャレンジに対する報酬倍率演出用
  final DateTime startAt;
  final DateTime endAt;

  EventChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.scenario,
    required this.difficulty,
    required this.conditions,
    required this.baseReward,
    required this.achievementPoints,
    required this.rewardMultiplier,
    required this.startAt,
    required this.endAt,
  });

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }

  Duration get remaining => endAt.difference(DateTime.now());

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

  factory EventChallenge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventChallenge(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      scenario: Scenario.values.byName(data['scenario'] as String),
      difficulty: DifficultyMode.values.byName(data['difficulty'] as String),
      conditions: (data['conditions'] as List)
          .map((c) => ChallengeCondition.fromJson(c as Map<String, dynamic>))
          .toList(),
      baseReward: data['baseReward'] as int,
      achievementPoints: data['achievementPoints'] as int,
      rewardMultiplier: (data['rewardMultiplier'] as num?)?.toDouble() ?? 1.0,
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt: (data['endAt'] as Timestamp).toDate(),
    );
  }
}

/// イベントチャレンジの達成状態（ユーザーごと・Firestoreに保存）
class EventChallengeProgress {
  final String eventId;
  final DateTime completedAt;
  final bool claimed;

  EventChallengeProgress({
    required this.eventId,
    required this.completedAt,
    this.claimed = false,
  });

  factory EventChallengeProgress.fromJson(Map<String, dynamic> json) {
    return EventChallengeProgress(
      eventId: json['eventId'] as String,
      completedAt: (json['completedAt'] as Timestamp).toDate(),
      claimed: json['claimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'completedAt': Timestamp.fromDate(completedAt),
        'claimed': claimed,
      };
}
