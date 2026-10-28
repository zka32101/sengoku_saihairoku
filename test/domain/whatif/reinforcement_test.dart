import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:sengoku_saihairoku/data/models/scenario_data.dart';
import 'package:sengoku_saihairoku/domain/state/battle_state.dart';
import 'package:sengoku_saihairoku/domain/whatif/persuasion.dart';

ScenarioData _odigahara() {
  final json = jsonDecode(File('assets/data/scenarios.json').readAsStringSync())
      as Map<String, dynamic>;
  return ScenarioData.fromJson(json['odigahara'] as Map<String, dynamic>);
}

ReinforceDuringBattle _reinforce({double? maxRatio}) => ReinforceDuringBattle(
      unit: UnitDataSnapshot(
        id: 'maeda',
        name: '前田利家隊',
        type: 'cavalry',
        strength: 1200,
      ),
      afterSeconds: 1.0,
      maxPlayerRatio: maxRatio,
      message: '駆けつけた',
    );

void _step(BattleState state, double seconds) {
  for (var t = 0.0; t < seconds; t += 0.1) {
    state.update(0.1);
  }
}

void main() {
  test('whatif.json の前田利家は読み込め、戦闘中の到着として解釈される', () {
    final json = jsonDecode(File('assets/data/whatif.json').readAsStringSync())
        as Map<String, dynamic>;
    final maeda = (json['odigahara']['persuasions'] as List)
        .map((p) => Persuasion.fromJson(p as Map<String, dynamic>))
        .firstWhere((p) => p.id == 'odigahara_maeda');
    final r = reinforcementsOf(maeda.effects);
    expect(r, hasLength(1));
    expect(r.single.afterSeconds, 40);
    expect(r.single.maxPlayerRatio, 0.7);
    // 開戦時の編成は変えない
    final base = _odigahara();
    final applied = applyWhatIfEffects(base, maeda.effects);
    expect(applied.playerUnits.length, base.playerUnits.length);
  });

  test('scaled は兵力だけを倍にする', () {
    final s = _reinforce().scaled(1.5);
    expect(s.unit.strength, 1800);
    expect(s.afterSeconds, 1.0);
    expect(s.message, '駆けつけた');
  });

  test('時間だけの条件なら、時間が来ると1回だけ加わる', () {
    final state = BattleState(
      scenario: _odigahara(),
      reinforcements: [_reinforce()],
    );
    var arrivals = 0;
    state.onReinforcementArrived = (r, unit) => arrivals++;
    state.start();
    final before = state.playerArmy.units.length;

    _step(state, 0.5);
    expect(state.playerArmy.units.length, before);

    _step(state, 2);
    expect(state.playerArmy.units.length, before + 1);
    expect(arrivals, 1);

    final arrived = state.playerArmy.units.last;
    expect(arrived.id, 'maeda');
    expect(arrived.isMoving, isTrue);
    expect(arrived.seeksEnemy, isTrue);

    _step(state, 5);
    expect(state.playerArmy.units.length, before + 1, reason: '2回目は来ない');
  });

  test('苦戦していなければ来ず、兵力が減ると加わる', () {
    final state = BattleState(
      scenario: _odigahara(),
      reinforcements: [_reinforce(maxRatio: 0.7)],
    );
    var arrivals = 0;
    state.onReinforcementArrived = (r, unit) => arrivals++;
    state.start();
    final before = state.playerArmy.units.length;

    _step(state, 3);
    expect(arrivals, 0, reason: '兵力が満タンのうちは来ない');

    for (final u in state.playerArmy.units) {
      u.takeDamage(u.maxStrength * 0.6); // 残り4割
    }
    _step(state, 0.2);
    expect(arrivals, 1);
    expect(state.playerArmy.units.length, before + 1);
  });

  test('協力者がいない戦闘は従来どおり', () {
    final state = BattleState(scenario: _odigahara());
    state.start();
    final before = state.playerArmy.units.length;
    _step(state, 5);
    expect(state.playerArmy.units.length, before);
  });
}
