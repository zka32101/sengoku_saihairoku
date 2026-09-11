import '../../data/models/turn_efficiency.dart';
import '../../data/models/battle_replay.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// ターン数ランク計算エンジン
class TurnRankCalculator {
  /// ターン数からランク結果を計算
  static TurnRankResult calculateTurnRank(
    int turnCount,
    TurnRankingCriteria criteria,
    int baseScore,
  ) {
    final rank = criteria.getRankByTurnCount(turnCount);
    final efficiencyScore = criteria.getEfficiencyScore(turnCount);
    final rewardBonus = (baseScore * (rank.rewardMultiplier - 1.0)).toInt();

    return TurnRankResult(
      turnCount: turnCount,
      rank: rank,
      efficiencyScore: efficiencyScore,
      rewardBonus: rewardBonus,
    );
  }

  /// バトルリプレイからターン数を取得
  static int getTurnCountFromReplay(BattleReplay replay) {
    return replay.turnStates.length;
  }

  /// 複数のバトルリプレイからターン効率統計を計算
  static TurnEfficiencyStats calculateEfficiencyStats(
    Scenario scenario,
    List<BattleReplay> replays,
    Map<Difficulty, TurnRankingCriteria> criteriaMap,
  ) {
    final results = <TurnRankResult>[];

    for (final replay in replays) {
      if (replay.scenario != scenario) continue;

      final criteria = criteriaMap[replay.difficulty];
      if (criteria == null) continue;

      final turnCount = getTurnCountFromReplay(replay);
      final result = calculateTurnRank(turnCount, criteria, replay.finalScore);
      results.add(result);
    }

    return TurnEfficiencyStats(
      scenario: scenario,
      results: results,
    );
  }

  /// ターン数に応じた最終スコアを計算（ランク報酬を適用）
  static int calculateFinalScore(int baseScore, TurnRank rank) {
    return (baseScore * rank.rewardMultiplier).toInt();
  }

  /// ターン数に応じたアチーブメント条件を確認
  static bool checkTurnCondition(
    int turnCount,
    String conditionType,
    int conditionValue,
  ) {
    switch (conditionType) {
      case 'turns_under':
        // 指定ターン数以下でクリア
        return turnCount <= conditionValue;
      case 'turns_over':
        // 指定ターン数以上でクリア
        return turnCount >= conditionValue;
      case 'gold_rank':
        // Gold ランク達成（最良のターン数）
        // これは criteria との比較が必要なため、外部で判定
        return false;
      default:
        return false;
    }
  }
}
