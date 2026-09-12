import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/battle_result_data.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/models/cosmetic.dart';
import '../../domain/state/battle_state.dart';
import '../../domain/scoring/score_calculator.dart';
import '../../data/repositories/daily_challenge_repository.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../../data/services/progression_calculator.dart';
import '../../domain/challenges/challenge_service.dart';
import '../widgets/screen_transition.dart';
import '../widgets/animated_score_line.dart';
import 'message_screen.dart';

class ResultScreenArgs {
  final Scenario scenario;
  final DifficultyMode difficulty;
  final BattleStateData data;

  ResultScreenArgs({
    required this.scenario,
    required this.difficulty,
    required this.data,
  });
}

class ResultScreen extends StatefulWidget {
  final ResultScreenArgs args;

  const ResultScreen({super.key, required this.args});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late DailyChallengeRepository _challengeRepo;
  late ProgressionRepository _progressionRepo;
  late RewardRepository _rewardRepo;
  bool _challengeCompleted = false;
  int _xpGained = 0;
  bool _leveledUp = false;
  int? _newLevel;
  bool _cosmeticUnlocked = false;
  Cosmetic? _unlockedCosmetic;

  @override
  void initState() {
    super.initState();
    _challengeRepo = DailyChallengeRepository();
    _progressionRepo = ProgressionRepository();
    _rewardRepo = RewardRepository();
    _saveBattleResult();
    _checkChallengeCompletion();
    _recordProgressionXp();
  }

  Future<void> _saveBattleResult() async {
    final data = widget.args.data;
    final resultData = BattleResultData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseService().userId ?? 'anonymous',
      scenarioId: widget.args.scenario,
      playedAt: DateTime.now(),
      duration: data.elapsedTime.toInt(),
      won: data.won,
      finalPlayerStrength: (100 * (1 - data.casualtyRate)).toInt(),
      finalEnemyStrength: 100,
      totalScore: data.totalScore,
      scoreBreakdown: ScoreBreakdown(
        victoryScore: data.scoreBreakdown.victoryScore,
        efficiencyScore: data.scoreBreakdown.efficiencyScore,
        commandScore: data.scoreBreakdown.commandScore,
        turningPointScore: data.scoreBreakdown.turningPointScore,
        historyBonus: data.scoreBreakdown.historyBonus,
      ),
      achievedTurningPoints: data.tpAchievements
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => 'tp_${e.key}')
          .toList(),
      commands: [],
      messageId: null,
    );

    await FirebaseService().saveBattleResult(resultData);
  }

  Future<void> _checkChallengeCompletion() async {
    final todayChallenge = _challengeRepo.getTodayChallenge();
    if (todayChallenge == null) return;

    final isMet = ChallengeService.isChallengeMet(
      todayChallenge,
      widget.args.data,
      widget.args.data.turnCount,
    );

    if (isMet) {
      await _challengeRepo.completeChallenge(todayChallenge.id);
      setState(() {
        _challengeCompleted = true;
      });
    }
  }

  Future<void> _recordProgressionXp() async {
    final userId = FirebaseService().userId;
    if (userId == null) return;

    try {
      // 現在のプログレッションを取得
      final currentProgression =
          await _progressionRepo.getUserProgression(userId);
      if (currentProgression == null) return;

      final oldLevel = currentProgression.currentLevel;

      // XP獲得を計算
      _xpGained = ProgressionCalculator.calculateXpGain(
        battleResult: widget.args.data,
        difficulty: widget.args.difficulty,
        currentChallengeStreak: 0, // TODO: チャレンジストリークを取得
        isFirstClearOnDifficulty: false, // TODO: 難易度別クリア状況を確認
        turnCount: widget.args.data.turnCount,
      );

      if (_xpGained <= 0) return;

      // XP獲得を記録
      await _progressionRepo.recordXpGain(
        userId: userId,
        xpGained: _xpGained,
        source: 'battle',
        multipliers: {
          'difficulty': ProgressionCalculator._getDifficultyMultiplier(
            widget.args.difficulty,
          ),
        },
      );

      // 新しいプログレッションを取得してレベルアップを確認
      final newProgression =
          await _progressionRepo.getUserProgression(userId);
      if (newProgression != null && newProgression.currentLevel > oldLevel) {
        setState(() {
          _leveledUp = true;
          _newLevel = newProgression.currentLevel;
        });

        // レベルマイルストーン達成時のコスメティック解放
        await _unlockMilestoneCosmeticIfEarned(userId, newProgression.currentLevel);
      }
    } catch (e) {
      print('Error recording progression XP: $e');
    }
  }

  /// レベルマイルストーンに達した場合、コスメティックを解放
  Future<void> _unlockMilestoneCosmeticIfEarned(
    String userId,
    int newLevel,
  ) async {
    try {
      final milestoneReward = _rewardRepo.getMilestoneRewardForLevel(newLevel);
      if (milestoneReward == null) return;

      // コスメティック解放
      await _rewardRepo.unlockMilestoneCosmetic(
        userId,
        newLevel,
        milestoneReward.cosmeticId,
      );

      // UIに反映
      final unlockedCosmetic = _rewardRepo.getCosmeticInfo(milestoneReward.cosmeticId);
      setState(() {
        _cosmeticUnlocked = true;
        _unlockedCosmetic = unlockedCosmetic;
      });
    } catch (e) {
      print('Error unlocking milestone cosmetic: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.args.data;

    return Scaffold(
      appBar: AppBar(title: const Text('戦闘結果')),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ResultHeader(won: data.won),
              const SizedBox(height: 24),
              if (_leveledUp && _newLevel != null)
                _LevelUpBanner(newLevel: _newLevel!)
              else
                const SizedBox.shrink(),
              if (_leveledUp) const SizedBox(height: 16),
              if (_cosmeticUnlocked && _unlockedCosmetic != null)
                _CosmeticUnlockBanner(cosmetic: _unlockedCosmetic!)
              else
                const SizedBox.shrink(),
              if (_cosmeticUnlocked) const SizedBox(height: 16),
              if (_xpGained > 0)
                _XpGainCard(xpGained: _xpGained)
              else
                const SizedBox.shrink(),
              if (_xpGained > 0) const SizedBox(height: 16),
              if (_challengeCompleted)
                _ChallengeCompletionBanner()
              else
                const SizedBox.shrink(),
              if (_challengeCompleted) const SizedBox(height: 16),
              _ScoreCard(breakdown: data.scoreBreakdown),
              const SizedBox(height: 16),
              _TurningPointCard(
                achievements: data.tpAchievements,
                scenario: widget.args.scenario,
              ),
              const SizedBox(height: 24),
              _ActionButtons(args: widget.args),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final bool won;

  const _ResultHeader({required this.won});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: won
            ? const Color(0xFF1A3A1A)
            : const Color(0xFF3A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: won ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            won ? '勝利！' : '敗北',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: won ? Colors.green : Colors.red,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            won ? '見事な采配であった' : '次は必ず雪辱を晴らせ',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final ScoreBreakdownResult breakdown;

  const _ScoreCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '総スコア',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                Text(
                  '${breakdown.total.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  )}点',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF8B6914)),
            AnimatedScoreLine('勝敗スコア', breakdown.victoryScore, 40000,
                delayMillis: 100),
            AnimatedScoreLine('効率スコア', breakdown.efficiencyScore, 20000,
                delayMillis: 200),
            AnimatedScoreLine('采配スコア', breakdown.commandScore, 15000,
                delayMillis: 300),
            AnimatedScoreLine('TP ボーナス', breakdown.turningPointScore, 15000,
                delayMillis: 400),
            AnimatedScoreLine('歴史ボーナス', breakdown.historyBonus, 10000,
                delayMillis: 500),
          ],
        ),
      ),
    );
  }
}

class _TurningPointCard extends StatelessWidget {
  final List<bool> achievements;
  final Scenario scenario;

  const _TurningPointCard({
    required this.achievements,
    required this.scenario,
  });

  static const _tpNames = {
    Scenario.odigahara: ['敵到着前に奇襲', '嵐の中での戦闘', '敵将兵力低下', '敵将討死'],
    Scenario.nagashino: ['初期陣形を防御に設定', '敵騎馬隊の突撃を耐える', '一斉反撃', '敵将討死'],
    Scenario.honnoJi: ['敵の包囲を突破', '援軍到着まで生存', '援軍到着後の反撃', '敵総大将討死'],
    Scenario.sekigahara: ['序盤は慎重に', '味方のモラル維持', '側面を奇襲', '敵将討死', '豊臣武将生存'],
    Scenario.kawanakajima: ['夜明けの奇襲に備える', '別働隊到着まで凌ぐ', '挟撃を成功させる', '敵将討死'],
  };

  @override
  Widget build(BuildContext context) {
    final names = _tpNames[scenario] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ターニングポイント',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(achievements.length, (i) {
              final achieved = achievements[i];
              final name = i < names.length ? names[i] : 'TP${i + 1}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      achieved ? Icons.check_circle : Icons.cancel,
                      color: achieved ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: TextStyle(
                        color: achieved
                            ? const Color(0xFFE8D5B0)
                            : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ResultScreenArgs args;

  const _ActionButtons({required this.args});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            '/message',
            arguments: MessageScreenArgs(
              scenario: args.scenario,
              won: args.data.won,
              allTpAchieved: args.data.tpAchievements.every((a) => a),
            ),
          ),
          icon: const Icon(Icons.history_edu),
          label: const Text('歴史分析を見る'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/ranking'),
          icon: const Icon(Icons.leaderboard),
          label: const Text('ランキングを見る'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.popUntil(
              context, ModalRoute.withName('/home')),
          icon: const Icon(Icons.home, color: Color(0xFFFFD700)),
          label: const Text(
            'ホームへ戻る',
            style: TextStyle(color: Color(0xFFFFD700)),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFFD700)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _ChallengeCompletionBanner extends StatelessWidget {
  const _ChallengeCompletionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本日のチャレンジ達成！',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '報酬を受け取るにはホーム画面から獲得してください',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _XpGainCard extends StatelessWidget {
  final int xpGained;

  const _XpGainCard({required this.xpGained});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A2A1A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '経験値獲得',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '獲得XP:',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '+$xpGained',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelUpBanner extends StatelessWidget {
  final int newLevel;

  const _LevelUpBanner({required this.newLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.orange.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'レベルアップ！',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'レベル $newLevel に到達しました',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

class _CosmeticUnlockBanner extends StatelessWidget {
  final Cosmetic cosmetic;

  const _CosmeticUnlockBanner({required this.cosmetic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.2),
            Colors.pink.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'コスメティック解放！',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cosmetic.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cosmetic.description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
