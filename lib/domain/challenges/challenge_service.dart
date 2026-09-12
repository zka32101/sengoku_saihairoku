import '../../data/models/daily_challenge.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../state/battle_state.dart';

/// チャレンジ達成判定サービス
class ChallengeService {
  /// バトル結果がチャレンジ条件を満たしているか判定
  static bool isChallengeMet(
    DailyChallenge challenge,
    BattleStateData battleResult,
    int turnCount,
  ) {
    // 全ての条件を満たす必要がある（AND判定）
    for (final condition in challenge.conditions) {
      if (!_checkCondition(condition, battleResult, turnCount)) {
        return false;
      }
    }
    return true;
  }

  /// 個別の条件をチェック
  static bool _checkCondition(
    ChallengeCondition condition,
    BattleStateData battleResult,
    int turnCount,
  ) {
    switch (condition.type) {
      case ChallengeConditionType.victory:
        // 勝利しているか
        return battleResult.won;

      case ChallengeConditionType.turnLimit:
        // 指定ターン数以内でクリアしているか
        return battleResult.won && turnCount <= condition.value;

      case ChallengeConditionType.noDefeats:
        // 敵将討死時に主要ユニットが損失していないか
        // casualtyRate == 0 なら1ユニットも損失していない
        return battleResult.won && battleResult.casualtyRate < 0.01;

      case ChallengeConditionType.tpTarget:
        // 指定数以上のターニングポイントを達成したか
        final tpCount =
            battleResult.tpAchievements.where((a) => a).toList().length;
        return battleResult.won && tpCount >= condition.value;

      case ChallengeConditionType.scoreTarget:
        // 指定スコア以上を獲得したか
        return battleResult.won && battleResult.totalScore >= condition.value;
    }
  }

  /// チャレンジ達成時の報酬を計算
  static int calculateReward(DailyChallenge challenge) {
    return challenge.baseReward;
  }

  /// チャレンジ達成時のアチーブメントポイントを計算
  static int calculateAchievementPoints(DailyChallenge challenge) {
    return challenge.achievementPoints;
  }
}
