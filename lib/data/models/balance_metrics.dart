import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// ゲームバランスの測定・分析用モデル
class BalanceMetrics {
  final Scenario scenario;
  final DifficultyMode difficulty;
  final double playerWinRate;
  final double avgBattleDuration;
  final double tpAchievementRate;
  final double playerDeathRatio;
  final double enemyDeathRatio;
  final int totalBattles;
  final DateTime lastUpdated;

  BalanceMetrics({
    required this.scenario,
    required this.difficulty,
    required this.playerWinRate,
    required this.avgBattleDuration,
    required this.tpAchievementRate,
    required this.playerDeathRatio,
    required this.enemyDeathRatio,
    required this.totalBattles,
    required this.lastUpdated,
  });

  /// バランスの診断結果
  BalanceDiagnosis getDiagnosis() {
    final diagnostics = <String>[];
    final recommendations = <String>[];

    // 勝率の分析
    if (playerWinRate < 0.3) {
      diagnostics.add('敵が強すぎる（勝率30%未満）');
      recommendations.add('プレイヤーユニットの兵力を+5%〜+10%増加');
      recommendations.add('敵ユニットの兵力を-5%削減');
    } else if (playerWinRate < 0.45) {
      diagnostics.add('敵がやや強い（勝率30-45%）');
      recommendations.add('プレイヤーユニットの兵力を+3%〜+5%増加');
    } else if (playerWinRate > 0.75) {
      diagnostics.add('敵が弱すぎる（勝率75%以上）');
      recommendations.add('敵ユニットの兵力を+5%〜+10%増加');
      recommendations.add('プレイヤーユニットの兵力を-3%削減');
    } else if (playerWinRate > 0.60) {
      diagnostics.add('敵がやや弱い（勝率60-75%）');
      recommendations.add('敵ユニットの兵力を+3%〜+5%増加');
    } else {
      diagnostics.add('バランス良好（勝率45-60%）');
    }

    // 戦闘時間の分析
    if (avgBattleDuration < 120) {
      // 2分以下
      diagnostics.add('戦闘が短すぎる（平均${(avgBattleDuration/60).toStringAsFixed(1)}分）');
      recommendations.add('ユニット兵力を全体的に+10%〜+15%増加');
    } else if (avgBattleDuration > 600) {
      // 10分以上
      diagnostics.add('戦闘が長すぎる（平均${(avgBattleDuration/60).toStringAsFixed(1)}分）');
      recommendations.add('ユニット兵力を全体的に-10%削減');
    } else if (avgBattleDuration > 480) {
      // 8分以上
      diagnostics.add('戦闘がやや長い（平均${(avgBattleDuration/60).toStringAsFixed(1)}分）');
      recommendations.add('ユニット兵力を-5%削減');
    } else if (avgBattleDuration < 180) {
      // 3分以下
      diagnostics.add('戦闘がやや短い（平均${(avgBattleDuration/60).toStringAsFixed(1)}分）');
      recommendations.add('ユニット兵力を+5%増加');
    }

    // TP達成率の分析
    if (tpAchievementRate < 0.3) {
      diagnostics.add('ターニングポイント達成が難しい（達成率30%未満）');
      recommendations.add('TPの達成条件を緩和する（敵兵力の閾値を+10%上げる等）');
    } else if (tpAchievementRate > 0.85) {
      diagnostics.add('ターニングポイント達成が簡単（達成率85%以上）');
      recommendations.add('TPの達成条件を厳格化する（敵兵力の閾値を-10%下げる等）');
    }

    // 兵力損耗率の分析
    if (playerDeathRatio > 0.8) {
      diagnostics.add('味方の損耗が大きい（${(playerDeathRatio*100).toStringAsFixed(0)}%）');
      recommendations.add('敵ユニットの攻撃力を-5%削減');
    }

    return BalanceDiagnosis(
      scenario: scenario,
      difficulty: difficulty,
      diagnostics: diagnostics,
      recommendations: recommendations,
      totalBattles: totalBattles,
    );
  }

  /// ジャンル（勝率に基づく難易度自動調整）
  DifficultyAdjustment getAutoAdjustment() {
    final targetWinRate = 0.50; // 理想的な勝率50%
    final deviation = playerWinRate - targetWinRate;

    // 勝率の偏差に基づいて調整係数を計算
    // 勝率が10%高いなら敵兵力+5%
    final enemyStrengthAdjustment = (deviation * 0.5).clamp(-0.15, 0.15);
    final playerStrengthAdjustment = (-deviation * 0.5).clamp(-0.15, 0.15);

    return DifficultyAdjustment(
      scenario: scenario,
      difficulty: difficulty,
      playerStrengthAdjustment: playerStrengthAdjustment,
      enemyStrengthAdjustment: enemyStrengthAdjustment,
      targetDuration: _getTargetDuration(),
    );
  }

  /// 推奨される戦闘時間を取得
  int _getTargetDuration() {
    return switch (difficulty) {
      DifficultyMode.easy => 240, // 4分
      DifficultyMode.normal => 300, // 5分
      DifficultyMode.hard => 360, // 6分
    };
  }

  factory BalanceMetrics.fromJson(Map<String, dynamic> json) {
    return BalanceMetrics(
      scenario: Scenario.values.byName(json['scenario'] as String),
      difficulty: DifficultyMode.values.byName(json['difficulty'] as String),
      playerWinRate: (json['playerWinRate'] as num).toDouble(),
      avgBattleDuration: (json['avgBattleDuration'] as num).toDouble(),
      tpAchievementRate: (json['tpAchievementRate'] as num).toDouble(),
      playerDeathRatio: (json['playerDeathRatio'] as num).toDouble(),
      enemyDeathRatio: (json['enemyDeathRatio'] as num).toDouble(),
      totalBattles: json['totalBattles'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'scenario': scenario.name,
        'difficulty': difficulty.name,
        'playerWinRate': playerWinRate,
        'avgBattleDuration': avgBattleDuration,
        'tpAchievementRate': tpAchievementRate,
        'playerDeathRatio': playerDeathRatio,
        'enemyDeathRatio': enemyDeathRatio,
        'totalBattles': totalBattles,
        'lastUpdated': lastUpdated.toIso8601String(),
      };
}

/// バランス診断の結果
class BalanceDiagnosis {
  final Scenario scenario;
  final DifficultyMode difficulty;
  final List<String> diagnostics;
  final List<String> recommendations;
  final int totalBattles;

  BalanceDiagnosis({
    required this.scenario,
    required this.difficulty,
    required this.diagnostics,
    required this.recommendations,
    required this.totalBattles,
  });

  /// 診断が有効かどうか（充分なサンプルサイズがあるか）
  bool get isValid => totalBattles >= 10;

  String get summary {
    if (!isValid) {
      return 'サンプル数が不足しています（最低10回の戦闘が必要）';
    }
    return diagnostics.join('、');
  }
}

/// 難易度調整の提案
class DifficultyAdjustment {
  final Scenario scenario;
  final DifficultyMode difficulty;
  final double playerStrengthAdjustment; // -0.15 ～ +0.15（-15% ～ +15%）
  final double enemyStrengthAdjustment;
  final int targetDuration; // 秒単位

  DifficultyAdjustment({
    required this.scenario,
    required this.difficulty,
    required this.playerStrengthAdjustment,
    required this.enemyStrengthAdjustment,
    required this.targetDuration,
  });

  /// 調整がある程度の大きさか
  bool get hasSignificantAdjustment =>
      (playerStrengthAdjustment.abs() > 0.03) ||
      (enemyStrengthAdjustment.abs() > 0.03);

  String get description {
    if (!hasSignificantAdjustment) {
      return 'バランスは適切です。調整不要です。';
    }

    final playerAdj =
        playerStrengthAdjustment > 0 ? '+${(playerStrengthAdjustment*100).toStringAsFixed(0)}%' : '${(playerStrengthAdjustment*100).toStringAsFixed(0)}%';
    final enemyAdj =
        enemyStrengthAdjustment > 0 ? '+${(enemyStrengthAdjustment*100).toStringAsFixed(0)}%' : '${(enemyStrengthAdjustment*100).toStringAsFixed(0)}%';

    return '推奨: 味方兵力$playerAdj、敵兵力$enemyAdj に調整';
  }
}
