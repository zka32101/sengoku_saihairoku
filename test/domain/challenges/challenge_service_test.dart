import 'package:flutter_test/flutter_test.dart';
import 'package:sengoku_saihairoku/data/models/daily_challenge.dart';
import 'package:sengoku_saihairoku/domain/challenges/challenge_service.dart';
import 'package:sengoku_saihairoku/domain/scoring/score_calculator.dart';
import 'package:sengoku_saihairoku/domain/state/battle_state.dart';

BattleStateData _battleResult({
  bool won = true,
  double casualtyRate = 0.0,
  List<bool> tpAchievements = const [true, true],
  int totalScore = 50000,
}) {
  return BattleStateData(
    won: won,
    result: won ? BattleResult.victory : BattleResult.defeat,
    elapsedTime: 200,
    casualtyRate: casualtyRate,
    tpAchievements: tpAchievements,
    commands: const [],
    totalScore: totalScore,
    scoreBreakdown: ScoreBreakdownResult(
      victoryScore: 0,
      efficiencyScore: 0,
      commandScore: 0,
      turningPointScore: 0,
      historyBonus: 0,
    ),
    turnCount: 10,
  );
}

void main() {
  group('ChallengeService.areConditionsMet', () {
    test('条件が空ならAND判定は常に真', () {
      expect(
        ChallengeService.areConditionsMet([], _battleResult(won: false), 10),
        isTrue,
      );
    });

    test('victory条件は敗北だと満たさない', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.victory, value: 0),
      ];
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: false), 10),
        isFalse,
      );
    });

    test('turnLimit条件はターン数がちょうど上限でも満たす', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.turnLimit, value: 10),
      ];
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: true), 10),
        isTrue,
      );
    });

    test('turnLimit条件はターン数が上限を超えると満たさない', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.turnLimit, value: 10),
      ];
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: true), 11),
        isFalse,
      );
    });

    test('noDefeats条件は損失率0%のみ満たす', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.noDefeats, value: 0),
      ];
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: true, casualtyRate: 0.0), 10),
        isTrue,
      );
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: true, casualtyRate: 0.05), 10),
        isFalse,
      );
    });

    test('tpTarget条件は達成TP数がしきい値以上か判定する', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.tpTarget, value: 2),
      ];
      expect(
        ChallengeService.areConditionsMet(
          conditions,
          _battleResult(won: true, tpAchievements: [true, true, false]),
          10,
        ),
        isTrue,
      );
      expect(
        ChallengeService.areConditionsMet(
          conditions,
          _battleResult(won: true, tpAchievements: [true, false, false]),
          10,
        ),
        isFalse,
      );
    });

    test('scoreTarget条件はスコアがしきい値以上か判定する', () {
      final conditions = [
        ChallengeCondition(
            type: ChallengeConditionType.scoreTarget, value: 40000),
      ];
      expect(
        ChallengeService.areConditionsMet(
          conditions,
          _battleResult(won: true, totalScore: 40000),
          10,
        ),
        isTrue,
      );
      expect(
        ChallengeService.areConditionsMet(
          conditions,
          _battleResult(won: true, totalScore: 39999),
          10,
        ),
        isFalse,
      );
    });

    test('複数条件はすべて満たさないとfalse（AND判定）', () {
      final conditions = [
        ChallengeCondition(type: ChallengeConditionType.victory, value: 0),
        ChallengeCondition(type: ChallengeConditionType.turnLimit, value: 5),
      ];
      // 勝利はしているがターン数超過
      expect(
        ChallengeService.areConditionsMet(
            conditions, _battleResult(won: true), 10),
        isFalse,
      );
    });
  });

  group('ChallengeService.calculateReward / calculateAchievementPoints', () {
    test('チャレンジのbaseReward/achievementPointsをそのまま返す', () {
      final challenge = DailyChallenge(
        id: 'test',
        title: 'テスト',
        description: 'テスト用',
        scenario: Scenario.odigahara,
        difficulty: DifficultyMode.normal,
        conditions: const [],
        baseReward: 100,
        achievementPoints: 20,
        availableFrom: DateTime(2020, 1, 1),
        availableUntil: DateTime(2099, 1, 1),
      );

      expect(ChallengeService.calculateReward(challenge), 100);
      expect(ChallengeService.calculateAchievementPoints(challenge), 20);
    });
  });
}
