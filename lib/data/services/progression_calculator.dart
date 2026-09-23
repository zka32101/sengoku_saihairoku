import '../../domain/state/battle_state.dart';
import '../../data/models/daily_challenge.dart';
import '../../data/models/difficulty_mode.dart';
import '../models/user_progression.dart';

/// 戦闘結果からXP獲得を計算するサービス
class ProgressionCalculator {
  /// 戦闘結果からXP獲得を計算
  static int calculateXpGain({
    required BattleStateData battleResult,
    required DifficultyMode difficulty,
    required int currentChallengeStreak,
    required bool isFirstClearOnDifficulty,
    required int turnCount,
  }) {
    if (!battleResult.won) return 0; // 敗北時はXPなし

    // 基本XP（スコアから）
    final baseXp = (battleResult.totalScore / 10).toInt();

    // 難易度ボーナス
    final difficultyMultiplier = _getDifficultyMultiplier(difficulty);

    // パフォーマンスボーナス
    final turnEfficiency = _calculateTurnEfficiency(turnCount);
    final tpBonusXp = battleResult.tpAchievements
            .where((a) => a)
            .length *
        50; // TP達成ボーナス
    final performanceBonus = (turnEfficiency * 100).toInt() + tpBonusXp;

    // チャレンジストリークボーナス（毎5日ごとに50XP）
    final streakBonus = (currentChallengeStreak ~/ 5) * 50;

    // シナリオマスタリーボーナス（そのシナリオ・難易度ではじめてクリア）
    final masteryBonus = isFirstClearOnDifficulty ? 200 : 0;

    // 最終計算
    final totalXp =
        ((baseXp * difficultyMultiplier) + performanceBonus + streakBonus + masteryBonus)
            .toInt();

    return totalXp;
  }

  /// 難易度別のXP倍率
  static double _getDifficultyMultiplier(DifficultyMode difficulty) {
    return switch (difficulty) {
      DifficultyMode.easy => 0.7,
      DifficultyMode.normal => 1.0,
      DifficultyMode.hard => 1.5,
    };
  }

  /// ターン効率スコア（0.0-1.0）を計算
  /// ターン数が少ないほどスコアが高い
  static double _calculateTurnEfficiency(int turnCount) {
    // 想定ターン数：20ターン（基準）
    // 20ターン以下なら100%、30ターンなら50%、40ターン以上なら0%
    if (turnCount <= 20) return 1.0;
    if (turnCount >= 40) return 0.0;

    // 線形補間
    return 1.0 - ((turnCount - 20) / (40 - 20)) * 0.5;
  }

  /// チャレンジ条件を満たしたかどうかを確認
  static bool isChallengeConditionMet(
    ChallengeCondition condition,
    BattleStateData battleResult,
    int turnCount,
  ) {
    switch (condition.type) {
      case ChallengeConditionType.victory:
        return battleResult.won;

      case ChallengeConditionType.turnLimit:
        return battleResult.won && turnCount <= condition.value;

      case ChallengeConditionType.noDefeats:
        return battleResult.won && battleResult.casualtyRate < 0.01;

      case ChallengeConditionType.tpTarget:
        final tpCount =
            battleResult.tpAchievements.where((a) => a).toList().length;
        return battleResult.won && tpCount >= condition.value;

      case ChallengeConditionType.scoreTarget:
        return battleResult.won && battleResult.totalScore >= condition.value;
    }
  }

  /// ターン効率スコアの説明を取得
  static String getTurnEfficiencyDescription(int turnCount) {
    if (turnCount <= 15) return 'S - 非常に効率的！';
    if (turnCount <= 20) return 'A - 非常に良好';
    if (turnCount <= 25) return 'B - 良好';
    if (turnCount <= 30) return 'C - 標準';
    if (turnCount <= 40) return 'D - やや遅め';
    return 'E - 遅め';
  }
}

/// プレスティジランクを計算するサービス
class PrestigeCalculator {
  /// シナリオ別の平均ターン数からプレスティジランクを計算
  static PrestigeTier calculatePrestigeRank(
    Map<String, int> averageTurnsByScenario,
  ) {
    if (averageTurnsByScenario.isEmpty) return PrestigeTier.bronze;

    // 全シナリオの平均を計算
    final totalTurns =
        averageTurnsByScenario.values.fold<int>(0, (sum, turns) => sum + turns);
    final averageTurns = totalTurns ~/ averageTurnsByScenario.length;

    // ターン効率ランク計算
    if (averageTurns <= 20) return PrestigeTier.diamond;
    if (averageTurns <= 23) return PrestigeTier.platinum;
    if (averageTurns <= 26) return PrestigeTier.gold;
    if (averageTurns <= 29) return PrestigeTier.silver;
    return PrestigeTier.bronze;
  }

  /// ターン効率スコア（プレスティジポイント用）を計算
  /// 低いターン数ほどスコアが高い
  static int calculatePrestigePoints(
    Map<String, int> averageTurnsByScenario,
  ) {
    if (averageTurnsByScenario.isEmpty) return 0;

    int totalPoints = 0;

    for (final turns in averageTurnsByScenario.values) {
      if (turns <= 20) {
        totalPoints += 100; // 完璧
      } else if (turns <= 25) {
        totalPoints += 80; // 優秀
      } else if (turns <= 30) {
        totalPoints += 60; // 良好
      } else if (turns <= 35) {
        totalPoints += 40; // 標準
      } else {
        totalPoints += 20; // 平均以下
      }
    }

    return (totalPoints / averageTurnsByScenario.length).toInt();
  }
}
