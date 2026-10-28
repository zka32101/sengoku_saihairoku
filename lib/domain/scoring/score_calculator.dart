import 'dart:math';
import 'battle_event_log.dart';

class ScoreInput {
  final bool won;
  final double casualtyRate;
  final int battleDurationSeconds;
  final List<CommandRecord> commands;
  final int turningPointBonus;
  final bool allTurningPointsAchieved;

  ScoreInput({
    required this.won,
    required this.casualtyRate,
    required this.battleDurationSeconds,
    required this.commands,
    required this.turningPointBonus,
    required this.allTurningPointsAchieved,
  });
}

class ScoreBreakdownResult {
  final int victoryScore;
  final int efficiencyScore;
  final int commandScore;
  final int turningPointScore;
  final int historyBonus;

  int get total =>
      victoryScore + efficiencyScore + commandScore + turningPointScore + historyBonus;

  ScoreBreakdownResult({
    required this.victoryScore,
    required this.efficiencyScore,
    required this.commandScore,
    required this.turningPointScore,
    required this.historyBonus,
  });
}

class ScoreCalculator {
  /// 敗北時は勝利スコアと歴史ボーナスが0になる上に、効率・采配・転換点の各スコアも
  /// この割合まで下げる。「負けても少しは入る」が、勝った場合より大きくならないようにする。
  static const double defeatFactor = 0.25;

  ScoreBreakdownResult calculate(ScoreInput input) {
    final factor = input.won ? 1.0 : defeatFactor;
    int scaled(int v) => (v * factor).toInt();
    return ScoreBreakdownResult(
      victoryScore: _victoryScore(input.won),
      efficiencyScore:
          scaled(_efficiencyScore(input.casualtyRate, input.battleDurationSeconds)),
      commandScore: scaled(_commandScore(input.commands)),
      turningPointScore: scaled(input.turningPointBonus),
      historyBonus: _historyBonus(input.won, input.allTurningPointsAchieved),
    );
  }

  int _victoryScore(bool won) => won ? 40000 : 0;

  int _efficiencyScore(double casualtyRate, int durationSeconds) {
    final survivorScore = ((1.0 - casualtyRate) * 15000).toInt();
    final timeRatio = min(1.0, 300.0 / max(1, durationSeconds));
    final timeScore = (timeRatio * 5000).toInt();
    return survivorScore + timeScore;
  }

  int _commandScore(List<CommandRecord> commands) =>
      commandScoreForCommands(commands);

  /// コマンド履歴から采配スコアを算出する。戦闘結果画面だけでなく、
  /// 戦闘中HUDの途中経過表示（BattleGame.commandScore）とも同じ式を使うことで
  /// 表示のズレを防ぐ。
  static int commandScoreForCommands(List<CommandRecord> commands) {
    int score = 0;
    for (final cmd in commands) {
      switch (cmd.command) {
        case PlayerCommand.ambush:
          score += 150;
        case PlayerCommand.charge:
          score += 120;
        case PlayerCommand.rally:
          score += 100;
        case PlayerCommand.shield:
          score += 80;
        case PlayerCommand.formation:
          score += 80;
        case PlayerCommand.advance:
          score += 50;
        case PlayerCommand.retreat:
        case PlayerCommand.wait:
          score += 30;
      }
    }
    return min(15000, score);
  }

  int _historyBonus(bool won, bool allTurningPointsAchieved) {
    if (won && allTurningPointsAchieved) return 10000;
    if (won && !allTurningPointsAchieved) return 5000;
    return 0;
  }
}
