import 'package:flutter_test/flutter_test.dart';
import 'package:sengoku_saihairoku/domain/scoring/battle_event_log.dart';
import 'package:sengoku_saihairoku/domain/scoring/score_calculator.dart';

void main() {
  group('ScoreCalculator.calculate', () {
    final calculator = ScoreCalculator();

    test('敗北時は勝利スコア・歴史ボーナスが0になる', () {
      final result = calculator.calculate(ScoreInput(
        won: false,
        casualtyRate: 0.5,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      expect(result.victoryScore, 0);
      expect(result.historyBonus, 0);
    });

    test('勝利時は40000点の勝利スコアが付与される', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      expect(result.victoryScore, 40000);
    });

    test('全ターニングポイント達成の勝利は歴史ボーナス10000点', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: true,
      ));

      expect(result.historyBonus, 10000);
    });

    test('一部のみ達成の勝利は歴史ボーナス5000点', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      expect(result.historyBonus, 5000);
    });

    test('損失率0%は効率スコアの生存分が満点(15000)になる', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      // 生存15000 + 時間スコア(300/300=1.0倍 → 5000) = 20000
      expect(result.efficiencyScore, 20000);
    });

    test('損失率100%は生存分が0点になる', () {
      final result = calculator.calculate(ScoreInput(
        won: false,
        casualtyRate: 1.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      expect(result.efficiencyScore, 5000); // 生存0 + 時間スコア5000
    });

    test('300秒より長い戦闘は時間スコアが頭打ちにならず減少する', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 600,
        commands: const [],
        turningPointBonus: 0,
        allTurningPointsAchieved: false,
      ));

      // timeRatio = min(1.0, 300/600) = 0.5 → timeScore = 2500
      expect(result.efficiencyScore, 15000 + 2500);
    });

    test('ターニングポイントスコアは入力値をそのまま反映する', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 1234,
        allTurningPointsAchieved: false,
      ));

      expect(result.turningPointScore, 1234);
    });

    test('total は各スコアの合計になる', () {
      final result = calculator.calculate(ScoreInput(
        won: true,
        casualtyRate: 0.0,
        battleDurationSeconds: 300,
        commands: const [],
        turningPointBonus: 100,
        allTurningPointsAchieved: true,
      ));

      expect(
        result.total,
        result.victoryScore +
            result.efficiencyScore +
            result.commandScore +
            result.turningPointScore +
            result.historyBonus,
      );
    });
  });

  group('ScoreCalculator.commandScoreForCommands', () {
    CommandRecord cmd(PlayerCommand c) => CommandRecord(command: c, timestamp: 0);

    test('コマンドが無ければ0点', () {
      expect(ScoreCalculator.commandScoreForCommands([]), 0);
    });

    test('各コマンドの点数を積算する', () {
      final commands = [
        cmd(PlayerCommand.ambush), // 150
        cmd(PlayerCommand.charge), // 120
        cmd(PlayerCommand.rally), // 100
      ];
      expect(ScoreCalculator.commandScoreForCommands(commands), 370);
    });

    test('15000点で頭打ちになる', () {
      final commands = List.generate(200, (_) => cmd(PlayerCommand.ambush));
      expect(ScoreCalculator.commandScoreForCommands(commands), 15000);
    });
  });
}
