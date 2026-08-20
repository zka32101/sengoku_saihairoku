import 'dart:math';
import '../../data/models/scenario_data.dart';
import 'battle_event_log.dart';

class TurningPointEvaluator {
  final Scenario scenarioId;
  final List<TurningPoint> turningPoints;
  final List<bool> achievements;
  final BattleEventLog eventLog;
  int _totalRewardEarned = 0;

  TurningPointEvaluator({
    required this.scenarioId,
    required this.turningPoints,
    required this.eventLog,
  }) : achievements = List.filled(turningPoints.length, false);

  void evaluate({
    required double elapsedTime,
    required double playerStrengthRatio,
    required double enemyStrengthRatio,
    required double playerMorale,
    required bool enemyCommanderKilled,
    required bool inCombat,
  }) {
    for (int i = 0; i < turningPoints.length; i++) {
      if (achievements[i]) continue;

      final tp = turningPoints[i];
      bool achieved = _checkCondition(
        tp: tp,
        elapsedTime: elapsedTime,
        playerStrengthRatio: playerStrengthRatio,
        enemyStrengthRatio: enemyStrengthRatio,
        playerMorale: playerMorale,
        enemyCommanderKilled: enemyCommanderKilled,
        inCombat: inCombat,
      );

      if (achieved) {
        achievements[i] = true;
        _totalRewardEarned += tp.rewardPoints;
        onAchieved?.call(tp, i);
      }
    }
  }

  // 各シナリオのturningPointsはtp1～tp5のidを使い回すが、
  // assets/data/scenarios.json 上で意味がシナリオごとに異なるため、
  // シナリオIDとtp.idの組み合わせで判定条件を切り替える。
  bool _checkCondition({
    required TurningPoint tp,
    required double elapsedTime,
    required double playerStrengthRatio,
    required double enemyStrengthRatio,
    required double playerMorale,
    required bool enemyCommanderKilled,
    required bool inCombat,
  }) {
    switch (scenarioId) {
      case Scenario.odigahara:
        switch (tp.id) {
          case 'tp1':
            // 敵が到着する前に奇襲コマンドを実行する
            return eventLog.hasCommandBefore(PlayerCommand.ambush, 30.0);
          case 'tp2':
            // 2分目～3分目に敵と接触する
            return elapsedTime >= 120.0 && elapsedTime <= 180.0 && inCombat;
          case 'tp3':
            // 敵将の兵力を50%以下に低下させる
            return enemyStrengthRatio <= 0.5;
          case 'tp4':
            // 敵将を討ち取る
            return enemyCommanderKilled;
        }
        break;
      case Scenario.nagashino:
        switch (tp.id) {
          case 'tp1':
            // 最初のコマンドを待機で開始する
            return eventLog.firstCommand == PlayerCommand.wait;
          case 'tp2':
            // 敵騎馬隊の突撃を待機コマンドで耐える
            return eventLog.lastCommand == PlayerCommand.wait && inCombat;
          case 'tp3':
            // 敵が近づいたら進軍で一斉反撃
            return eventLog.lastCommand == PlayerCommand.advance && inCombat;
          case 'tp4':
            // 敵将武田勝頼を討ち取る
            return enemyCommanderKilled;
        }
        break;
      case Scenario.honnoJi:
        switch (tp.id) {
          case 'tp1':
            // 敵の包囲を撤退コマンドで突破する
            return eventLog.countCommand(PlayerCommand.retreat) > 0;
          case 'tp2':
            // 5分以上敵をかわし続ける（生存している間だけ呼ばれる）
            return elapsedTime >= 300.0;
          case 'tp3':
            // 援軍到着（5分経過）後に進軍で敵陣に突撃
            return eventLog.hasCommandAfter(PlayerCommand.advance, 300.0);
          case 'tp4':
            // 明智光秀を討ち取る
            return enemyCommanderKilled;
        }
        break;
      case Scenario.sekigahara:
        switch (tp.id) {
          case 'tp1':
            // 序盤(30秒以内)は待機コマンドで敵の出方を見る
            return eventLog.hasCommandBefore(PlayerCommand.wait, 30.0);
          case 'tp2':
            // 小早川秀秋(味方)のモラルを50%以上維持
            return playerMorale >= 50.0;
          case 'tp3':
            // 敵の側面を奇襲コマンドで突く
            return eventLog.countCommand(PlayerCommand.ambush) > 0;
          case 'tp4':
            // 石田三成を討ち取る
            return enemyCommanderKilled;
          case 'tp5':
            // 豊臣家の武将を1体以上生存させる
            return playerStrengthRatio > 0.0;
        }
    }
    return false;
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
