import 'package:flutter_test/flutter_test.dart';
import 'package:sengoku_saihairoku/data/models/daily_login_bonus.dart';

void main() {
  group('DailyLoginBonus.goldForStreak', () {
    test('1〜7日目はテーブルの値をそのまま返す', () {
      for (var day = 1; day <= 7; day++) {
        expect(
          DailyLoginBonus.goldForStreak(day),
          DailyLoginBonus.goldByDay[day - 1],
        );
      }
    });

    test('8日目は1日目の報酬にループする', () {
      expect(
        DailyLoginBonus.goldForStreak(8),
        DailyLoginBonus.goldForStreak(1),
      );
    });

    test('14日目は7日目の報酬にループする', () {
      expect(
        DailyLoginBonus.goldForStreak(14),
        DailyLoginBonus.goldForStreak(7),
      );
    });

    test('15日目は8サイクル目の1日目と同じ', () {
      expect(
        DailyLoginBonus.goldForStreak(15),
        DailyLoginBonus.goldForStreak(1),
      );
    });
  });
}
