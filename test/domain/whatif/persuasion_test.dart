import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sengoku_saihairoku/data/models/scenario_data.dart';
import 'package:sengoku_saihairoku/data/models/warlord_data.dart';
import 'package:sengoku_saihairoku/data/repositories/persuasion_repository.dart';
import 'package:sengoku_saihairoku/domain/whatif/persuasion.dart';

Warlord _warlord(int intelligence) => Warlord(
      id: 'w$intelligence',
      name: 'w',
      faction: 'f',
      leadership: 50,
      valor: 50,
      intelligence: intelligence,
    );

ScenarioData _odigahara() {
  final json = jsonDecode(File('assets/data/scenarios.json').readAsStringSync())
      as Map<String, dynamic>;
  return ScenarioData.fromJson(json['odigahara'] as Map<String, dynamic>);
}

List<Persuasion> _persuasions() {
  final json = jsonDecode(File('assets/data/whatif.json').readAsStringSync())
      as Map<String, dynamic>;
  return (json['odigahara']['persuasions'] as List)
      .map((p) => Persuasion.fromJson(p as Map<String, dynamic>))
      .toList();
}

void main() {
  group('成功率', () {
    final p = _persuasions().first; // base 0.4

    test('武将なしなら基本の成功率', () {
      expect(p.successRate([]), closeTo(0.4, 1e-9));
    });

    test('知略が高いほど上がり、上限は95%', () {
      expect(p.successRate([_warlord(100)]), closeTo(0.6, 1e-9));
      expect(p.successRate([_warlord(50)]), closeTo(0.5, 1e-9));
      final sure = Persuasion(
        id: 'x',
        name: 'x',
        description: 'x',
        successText: 'x',
        failureText: 'x',
        baseSuccessRate: 0.9,
        effects: const [],
      );
      expect(sure.successRate([_warlord(100)]), 0.95);
    });
  });

  group('効果の適用', () {
    test('味方の追加で味方の初期兵力が増える', () {
      final base = _odigahara();
      final p = _persuasions().firstWhere((p) => p.id == 'odigahara_hachisuka');
      final applied = applyWhatIfEffects(base, p.effects);
      expect(applied.playerUnits.length, base.playerUnits.length + 1);
      expect(applied.playerInitialStrength, base.playerInitialStrength + 900);
      expect(applied.enemyInitialStrength, base.enemyInitialStrength);
    });

    test('敵部隊の弱体化で敵の初期兵力が減る', () {
      final base = _odigahara();
      final p = _persuasions().firstWhere((p) => p.id == 'odigahara_yanada');
      final applied = applyWhatIfEffects(base, p.effects);
      expect(applied.enemyInitialStrength, base.enemyInitialStrength - 1600);
      expect(applied.playerInitialStrength, base.playerInitialStrength);
    });

    test('敵部隊の削除と、効果なしは元のまま', () {
      final base = _odigahara();
      expect(identical(applyWhatIfEffects(base, const []), base), isTrue);
      final removed = applyWhatIfEffects(
        base,
        const [RemoveEnemyUnit('enemy_cavalry_1')],
      );
      expect(removed.enemyUnits.length, base.enemyUnits.length - 1);
    });
  });

  test('attempt は成功率に従う(乱数固定)', () {
    final p = _persuasions().first;
    final results = List.generate(
      2000,
      (i) => p.attempt([], Random(i)),
    );
    final rate = results.where((r) => r).length / results.length;
    expect(rate, closeTo(0.4, 0.05));
  });

  group('1日1回の保存', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('同じ日は結果が残り、翌日は未挑戦に戻る', () async {
      final day1 = DateTime(2026, 10, 28, 9);
      expect(await PersuasionRepository.todayResult('a', day1), isNull);

      await PersuasionRepository.record('a', true, day1);
      expect(
        await PersuasionRepository.todayResult('a', DateTime(2026, 10, 28, 23)),
        isTrue,
      );
      expect(
        await PersuasionRepository.todayResult('a', DateTime(2026, 10, 29, 0)),
        isNull,
      );
    });

    test('失敗も記録される', () async {
      final now = DateTime(2026, 10, 28);
      await PersuasionRepository.record('b', false, now);
      expect(await PersuasionRepository.todayResult('b', now), isFalse);
    });
  });
}
