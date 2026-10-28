import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sengoku_saihairoku/data/models/scenario_data.dart';
import 'package:sengoku_saihairoku/data/repositories/scenario_unlock_repository.dart';

void main() {
  const order = [Scenario.odigahara, Scenario.anegawa, Scenario.nagashino];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ScenarioUnlockRepository.cleared.value = <String>{};
  });

  test('先頭は常に解放、2つ目以降は前をクリアするまで未解放', () {
    expect(ScenarioUnlockRepository.isUnlockedAt(0, order, {}), isTrue);
    expect(ScenarioUnlockRepository.isUnlockedAt(1, order, {}), isFalse);
    expect(ScenarioUnlockRepository.isUnlockedAt(2, order, {}), isFalse);
    expect(
        ScenarioUnlockRepository.isUnlockedAt(1, order, {'odigahara'}), isTrue);
    expect(
        ScenarioUnlockRepository.isUnlockedAt(2, order, {'odigahara'}), isFalse);
    expect(
        ScenarioUnlockRepository.isUnlockedAt(2, order, {'anegawa'}), isTrue);
  });

  test('クリアを記録すると保存され、読み直しても残る', () async {
    await ScenarioUnlockRepository.markCleared(Scenario.odigahara);
    expect(ScenarioUnlockRepository.cleared.value, {'odigahara'});

    ScenarioUnlockRepository.cleared.value = <String>{};
    await ScenarioUnlockRepository.load();
    expect(ScenarioUnlockRepository.cleared.value, {'odigahara'});
  });

  test('同じシナリオを2回記録しても重複しない', () async {
    await ScenarioUnlockRepository.markCleared(Scenario.anegawa);
    await ScenarioUnlockRepository.markCleared(Scenario.anegawa);
    expect(ScenarioUnlockRepository.cleared.value, {'anegawa'});
  });
}
