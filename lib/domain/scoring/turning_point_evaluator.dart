import 'dart:math';
import '../../data/models/scenario_data.dart';
import 'battle_event_log.dart';

class TurningPointEvaluator {
  final List<TurningPoint> turningPoints;
  final List<bool> achievements;
  final BattleEventLog eventLog;
  int _totalRewardEarned = 0;

  TurningPointEvaluator({required this.turningPoints, required this.eventLog})
      : achievements = List.filled(turningPoints.length, false);

  void evaluate({
    required double elapsedTime,
    required double playerStrengthRatio,
    required double playerMorale,
    required bool enemyCommanderKilled,
    required bool isFirstCommand,
  }) {
    for (int i = 0; i < turningPoints.length; i++) {
      if (achievements[i]) continue;

      final tp = turningPoints[i];
      bool achieved = _checkCondition(
        tp: tp,
        elapsedTime: elapsedTime,
        playerStrengthRatio: playerStrengthRatio,
        playerMorale: playerMorale,
        enemyCommanderKilled: enemyCommanderKilled,
        isFirstCommand: isFirstCommand,
      );

      if (achieved) {
        achievements[i] = true;
        _totalRewardEarned += tp.rewardPoints;
        onAchieved?.call(tp, i);
      }
    }
  }

  bool _checkCondition({
    required TurningPoint tp,
    required double elapsedTime,
    required double playerStrengthRatio,
    required double playerMorale,
    required bool enemyCommanderKilled,
    required bool isFirstCommand,
  }) {
    switch (tp.id) {
      case 'tp1' when turningPoints.first.id == 'tp1':
        // 最初のコマンドが奇襲
        return eventLog.hasCommandBefore(PlayerCommand.ambush, 30.0);
      case 'tp2':
        // 嵐の中での戦闘（2-3分）
        return eventLog.hasCommandInWindow(
            PlayerCommand.advance, 120.0, 180.0);
      case 'tp3':
        // 敵将兵力50%以下 → 条件は呼び出し元が判定
        return playerStrengthRatio <= 0.5;
      case 'tp4':
        // 敵将討死
        return enemyCommanderKilled;
      case 'tp5':
        // 味方武将生存（関ヶ原用）
        return playerStrengthRatio > 0.0;
      default:
        return false;
    }
  }

  int get achievedCount => achievements.where((a) => a).length;
  int get totalPoints => _totalRewardEarned;
  double get achievementRate =>
      turningPoints.isEmpty ? 0 : achievedCount / turningPoints.length;

  int get maxPossibleReward =>
      turningPoints.fold(0, (sum, tp) => sum + tp.rewardPoints);

  int calculateBonusScore() {
    final maxBonus = min(15000, maxPossibleReward);
    return (achievementRate * maxBonus).toInt();
  }

  Function(TurningPoint, int)? onAchieved;
}
