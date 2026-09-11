import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// バトルリプレイデータモデル
class BattleReplay {
  final String id;
  final String battleName;
  final Scenario scenario;
  final DifficultyMode difficulty;
  final DateTime playedAt;
  final Duration battleDuration;
  final int finalScore;
  final bool isVictory;
  final List<String> turnEvents; // ターンごとのイベント説明
  final List<ReplayTurnState> turnStates; // ターンごとの状態スナップショット
  final List<String> achievedTPs; // 達成したTP一覧
  final Map<String, dynamic> metadata; // 拡張用メタデータ

  BattleReplay({
    required this.id,
    required this.battleName,
    required this.scenario,
    required this.difficulty,
    required this.playedAt,
    required this.battleDuration,
    required this.finalScore,
    required this.isVictory,
    required this.turnEvents,
    required this.turnStates,
    required this.achievedTPs,
    this.metadata = const {},
  });

  /// リプレイの要約テキスト
  String get summary {
    final result = isVictory ? '勝利' : '敗北';
    final duration = _formatDuration(battleDuration);
    return '$battleName - $result (${difficulty.displayName}, $duration)';
  }

  /// リプレイの詳細説明
  String get details {
    return '日時: ${playedAt.year}年${playedAt.month}月${playedAt.day}日\n'
        'スコア: $finalScore\n'
        'ターン数: ${turnStates.length}\n'
        '達成TP: ${achievedTPs.length}';
  }

  static String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }

  factory BattleReplay.fromJson(Map<String, dynamic> json) {
    return BattleReplay(
      id: json['id'] as String,
      battleName: json['battleName'] as String,
      scenario: Scenario.values.byName(json['scenario'] as String),
      difficulty: DifficultyMode.values.byName(json['difficulty'] as String),
      playedAt: DateTime.parse(json['playedAt'] as String),
      battleDuration: Duration(seconds: json['battleDurationSeconds'] as int),
      finalScore: json['finalScore'] as int,
      isVictory: json['isVictory'] as bool,
      turnEvents: List<String>.from(json['turnEvents'] as List),
      turnStates: (json['turnStates'] as List)
          .map((s) => ReplayTurnState.fromJson(s as Map<String, dynamic>))
          .toList(),
      achievedTPs: List<String>.from(json['achievedTPs'] as List),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'battleName': battleName,
        'scenario': scenario.name,
        'difficulty': difficulty.name,
        'playedAt': playedAt.toIso8601String(),
        'battleDurationSeconds': battleDuration.inSeconds,
        'finalScore': finalScore,
        'isVictory': isVictory,
        'turnEvents': turnEvents,
        'turnStates': turnStates.map((s) => s.toJson()).toList(),
        'achievedTPs': achievedTPs,
        'metadata': metadata,
      };
}

/// リプレイの各ターンの状態スナップショット
class ReplayTurnState {
  final int turnNumber;
  final int playerHp;
  final int playerUnits;
  final int enemyHp;
  final int enemyUnits;
  final String? commandUsed; // 使用したコマンド名
  final String eventDescription; // ターンのイベント説明
  final int scoreGained; // このターンで獲得したスコア
  final bool tpAchieved; // このターンでTPを達成したか

  ReplayTurnState({
    required this.turnNumber,
    required this.playerHp,
    required this.playerUnits,
    required this.enemyHp,
    required this.enemyUnits,
    this.commandUsed,
    required this.eventDescription,
    required this.scoreGained,
    required this.tpAchieved,
  });

  factory ReplayTurnState.fromJson(Map<String, dynamic> json) {
    return ReplayTurnState(
      turnNumber: json['turnNumber'] as int,
      playerHp: json['playerHp'] as int,
      playerUnits: json['playerUnits'] as int,
      enemyHp: json['enemyHp'] as int,
      enemyUnits: json['enemyUnits'] as int,
      commandUsed: json['commandUsed'] as String?,
      eventDescription: json['eventDescription'] as String,
      scoreGained: json['scoreGained'] as int,
      tpAchieved: json['tpAchieved'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'turnNumber': turnNumber,
        'playerHp': playerHp,
        'playerUnits': playerUnits,
        'enemyHp': enemyHp,
        'enemyUnits': enemyUnits,
        'commandUsed': commandUsed,
        'eventDescription': eventDescription,
        'scoreGained': scoreGained,
        'tpAchieved': tpAchieved,
      };
}
