import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sengoku_saihairoku/data/models/difficulty_mode.dart';
import 'package:sengoku_saihairoku/data/models/scenario_data.dart';
import 'package:sengoku_saihairoku/data/repositories/battle_stats_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('BattleStatsRepository', () {
    test('初期状態では勝利数は0でクリア済みでもない', () async {
      final repo = BattleStatsRepository();
      expect(await repo.getTotalWins(), 0);
      expect(
        await repo.isCleared(Scenario.odigahara, DifficultyMode.normal),
        isFalse,
      );
    });

    test('recordVictoryで勝利数が加算され、初回クリアはtrueを返す', () async {
      final repo = BattleStatsRepository();

      final isFirstClear = await repo.recordVictory(
        Scenario.odigahara,
        DifficultyMode.normal,
      );

      expect(isFirstClear, isTrue);
      expect(await repo.getTotalWins(), 1);
      expect(
        await repo.isCleared(Scenario.odigahara, DifficultyMode.normal),
        isTrue,
      );
    });

    test('同じシナリオ・難易度の2回目のクリアはfalseを返すが勝利数は加算され続ける', () async {
      final repo = BattleStatsRepository();

      await repo.recordVictory(Scenario.odigahara, DifficultyMode.normal);
      final secondIsFirstClear = await repo.recordVictory(
        Scenario.odigahara,
        DifficultyMode.normal,
      );

      expect(secondIsFirstClear, isFalse);
      expect(await repo.getTotalWins(), 2);
    });

    test('異なる難易度は別クリア扱いになる', () async {
      final repo = BattleStatsRepository();

      await repo.recordVictory(Scenario.odigahara, DifficultyMode.normal);
      final hardIsFirstClear = await repo.recordVictory(
        Scenario.odigahara,
        DifficultyMode.hard,
      );

      expect(hardIsFirstClear, isTrue);
      expect(await repo.getTotalWins(), 2);
    });

    test('異なるシナリオは別クリア扱いになる', () async {
      final repo = BattleStatsRepository();

      await repo.recordVictory(Scenario.odigahara, DifficultyMode.normal);
      final otherScenarioIsFirstClear = await repo.recordVictory(
        Scenario.nagashino,
        DifficultyMode.normal,
      );

      expect(otherScenarioIsFirstClear, isTrue);
      expect(await repo.getTotalWins(), 2);
    });
  });
}
