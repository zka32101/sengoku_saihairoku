import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/battle_result_data.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../domain/state/battle_state.dart';
import '../../domain/scoring/score_calculator.dart';
import '../../domain/ranking/turn_rank_calculator.dart';
import '../../data/repositories/turn_rank_repository.dart';
import '../../data/models/cosmetic.dart';
import '../../data/repositories/daily_challenge_repository.dart';
import '../../data/repositories/weekly_challenge_repository.dart';
import '../../data/repositories/friend_challenge_repository.dart';
import '../../data/repositories/friend_repository.dart';
import '../../data/repositories/ranking_repository.dart';
import '../../data/repositories/warlord_progress_repository.dart';
import '../../data/repositories/event_challenge_repository.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../../data/services/progression_calculator.dart';
import '../../domain/challenges/challenge_service.dart';
import '../../domain/achievement_checking/achievement_checker.dart';
import '../../domain/achievement_checking/achievement_notification_service.dart';
import '../../data/repositories/battle_pass_repository.dart';
import '../../domain/battle_pass/battle_pass_notification_service.dart';
import '../widgets/screen_transition.dart';
import '../widgets/animated_score_line.dart';
import '../widgets/turn_rank_badge.dart';
import 'message_screen.dart';

class ResultScreenArgs {
  final Scenario scenario;
  final DifficultyMode difficulty;
  final BattleStateData data;
  final List<String> sortiedWarlordIds;

  ResultScreenArgs({
    required this.scenario,
    required this.difficulty,
    required this.data,
    this.sortiedWarlordIds = const [],
  });
}

class ResultScreen extends StatefulWidget {
  final ResultScreenArgs args;

  const ResultScreen({super.key, required this.args});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final TurnRankRepository _turnRankRepo;
  late DailyChallengeRepository _challengeRepo;
  late WeeklyChallengeRepository _weeklyChallengeRepo;
  late EventChallengeRepository _eventChallengeRepo;
  late ProgressionRepository _progressionRepo;
  late RewardRepository _rewardRepo;
  late AchievementChecker _achievementChecker;
  late AchievementNotificationService _notificationService;
  late BattlePassRepository _battlePassRepo;
  late BattlePassNotificationService _battlePassNotificationService;
  bool _challengeCompleted = false;
  int _xpGained = 0;
  bool _leveledUp = false;
  int? _newLevel;
  bool _cosmeticUnlocked = false;
  Cosmetic? _unlockedCosmetic;
  final List<dynamic> _unlockedAchievements = [];
  int _battlePassXpGained = 0;
  bool _battlePassTierUp = false;
  int? _newBattlePassTier;
  FriendChallengeTarget? _friendChallengeResult;
  bool _friendChallengeBeaten = false;

  @override
  void initState() {
    super.initState();
    _turnRankRepo = TurnRankRepository();
    _challengeRepo = DailyChallengeRepository();
    _weeklyChallengeRepo = WeeklyChallengeRepository();
    _eventChallengeRepo = EventChallengeRepository();
    _progressionRepo = ProgressionRepository();
    _rewardRepo = RewardRepository();
    _achievementChecker = AchievementChecker();
    _notificationService = AchievementNotificationService();
    _battlePassRepo = BattlePassRepository();
    _battlePassNotificationService = BattlePassNotificationService();

    // Initialize notification services with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.initialize(context);
      _battlePassNotificationService.initialize(context);
    });

    _saveBattleResult();
    _checkEventChallengeCompletion();
    _checkWeeklyChallengeCompletion();
    _checkFriendChallengeResult();
    // XP計算でストリークボーナスを正しく反映するため、
    // チャレンジ達成判定（ストリーク更新を含む）の完了を待ってから実行する
    _checkChallengeCompletion().then((_) => _recordProgressionXp());
  }

  Future<void> _saveBattleResult() async {
    final data = widget.args.data;
    final userId = FirebaseService().userId;

    final resultData = BattleResultData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId ?? 'anonymous',
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

    if (userId != null && data.won) {
      await RankingRepository().submitIfSeasonBest(
        userId: userId,
        displayName: FriendRepository().codeForUserId(userId),
        scenario: widget.args.scenario,
        score: data.totalScore,
        achievedAt: DateTime.now(),
        turningPointsAchieved: data.tpAchievements.where((a) => a).length,
      );

      if (widget.args.sortiedWarlordIds.isNotEmpty) {
        await WarlordProgressRepository()
            .addExpToWarlords(userId, widget.args.sortiedWarlordIds);
      }
    }

    // Check battle achievements
    if (userId != null) {
      await _checkBattleAchievements(data);
    }
  }

  Future<void> _checkBattleAchievements(BattleStateData data) async {
    try {
      final userId = FirebaseService().userId;
      if (userId == null) return;

      final unlockedAchievements = await _achievementChecker.checkBattleAchievements(
        userId: userId,
        scenarioId: widget.args.scenario,
        won: data.won,
        casualtyRate: data.casualtyRate,
        turnCount: data.turnCount,
        totalScore: data.totalScore,
        battleDuration: data.elapsedTime.toInt(),
      );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        // Show notifications for each unlocked achievement
        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(achievement);
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking battle achievements: $e');
    }
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

  Future<void> _checkWeeklyChallengeCompletion() async {
    await _weeklyChallengeRepo.initialize(_challengeRepo.getAllChallenges());

    final weekly = _weeklyChallengeRepo.getThisWeekChallenge();
    if (weekly == null) return;
    if (weekly.scenario != widget.args.scenario) return;

    final alreadyCompleted = _weeklyChallengeRepo.getThisWeekProgress() != null;
    if (alreadyCompleted) return;

    final isMet = ChallengeService.isChallengeMet(
      weekly,
      widget.args.data,
      widget.args.data.turnCount,
    );

    if (isMet) {
      await _weeklyChallengeRepo.completeChallenge(weekly.id);
    }
  }

  Future<void> _checkFriendChallengeResult() async {
    final challenge = await FriendChallengeRepository().getChallenge();
    if (challenge == null) return;
    if (challenge.scenario != widget.args.scenario) return;

    final beaten = widget.args.data.totalScore > challenge.targetScore;
    await FriendChallengeRepository().clearChallenge();

    if (!mounted) return;
    setState(() {
      _friendChallengeResult = challenge;
      _friendChallengeBeaten = beaten;
    });
  }

  Future<void> _checkEventChallengeCompletion() async {
    final userId = FirebaseService().userId;
    if (userId == null) return;

    final event = await _eventChallengeRepo.getActiveEvent();
    if (event == null) return;
    if (event.scenario != widget.args.scenario) return;
    if (event.difficulty != widget.args.difficulty) return;

    final existingProgress =
        await _eventChallengeRepo.getProgress(userId, event.id);
    if (existingProgress != null) return; // 既に達成済み

    final isMet = ChallengeService.areConditionsMet(
      event.conditions,
      widget.args.data,
      widget.args.data.turnCount,
    );

    if (isMet) {
      await _eventChallengeRepo.completeEvent(userId, event.id);
      await _checkEventChallengeAchievements(userId);
    }
  }

  Future<void> _checkEventChallengeAchievements(String userId) async {
    try {
      final totalCompleted =
          await _eventChallengeRepo.getCompletedEventCount(userId);

      final unlockedAchievements =
          await _achievementChecker.checkEventChallengeAchievements(
        userId: userId,
        totalEventChallengesCompleted: totalCompleted,
      );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(achievement);
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking event challenge achievements: $e');
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
        currentChallengeStreak: _challengeRepo.getCurrentStreak(),
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
          'difficulty': ProgressionCalculator.getDifficultyMultiplier(
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

        // レベルアップ時に関連実績をチェック
        await _checkLevelAchievements(userId, newProgression.currentLevel);
      }

      // バトルパスXPを記録
      await _recordBattlePassXp();
    } catch (e) {
      debugPrint('Error recording progression XP: $e');
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

      // コスメティック解放時に関連実績をチェック
      // TODO: 総解放数を取得して checkCosmeticAchievements を呼び出す
    } catch (e) {
      debugPrint('Error unlocking milestone cosmetic: $e');
    }
  }

  Future<void> _checkLevelAchievements(String userId, int newLevel) async {
    try {
      final unlockedAchievements = await _achievementChecker.checkLevelAchievements(
        userId: userId,
        newLevel: newLevel,
      );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        // Show notifications for each unlocked achievement
        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(achievement);
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking level achievements: $e');
    }
  }

  /// バトルパスXPを獲得して進捗を更新
  Future<void> _recordBattlePassXp() async {
    final userId = FirebaseService().userId;
    if (userId == null) return;

    try {
      // バトルパスXPを計算（プログレッションXPの約30-40%）
      _battlePassXpGained = (_xpGained * 0.35).toInt();

      if (_battlePassXpGained <= 0) return;

      // 現在のバトルパス進捗を取得
      final currentProgress = await _battlePassRepo.getUserBattlePassProgress(userId);
      final oldTier = currentProgress?.currentTier ?? 1;

      // バトルパスXPを獲得
      final newProgress = await _battlePassRepo.gainXp(userId, _battlePassXpGained);

      if (newProgress != null && newProgress.currentTier > oldTier) {
        setState(() {
          _battlePassTierUp = true;
          _newBattlePassTier = newProgress.currentTier;
        });

        // ティアアップ通知を表示
        if (mounted) {
          final tierData =
              _battlePassRepo.getTierData(newProgress.currentTier);
          if (tierData != null) {
            await _battlePassNotificationService.showTierUpNotification(
              newProgress.currentTier,
              tierData,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error recording battle pass XP: $e');
    }
  }

  @override
  void dispose() {
    // Clean up notification services
    _notificationService.clear();
    _battlePassNotificationService.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.args.data;

    // ターンランクを計算
    final criteria = _turnRankRepo.getCriteria(
      widget.args.scenario,
      widget.args.difficulty,
    );

    final turnRankResult = criteria != null
        ? TurnRankCalculator.calculateTurnRank(
            data.turnCount,
            criteria,
            data.totalScore,
          )
        : null;

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
              if (turnRankResult != null) ...[
                TurnRankPanel(rankResult: turnRankResult),
                const SizedBox(height: 16),
              ],
              if (_leveledUp && _newLevel != null)
                _LevelUpBanner(newLevel: _newLevel!)
              else
                const SizedBox.shrink(),
              if (_leveledUp) const SizedBox(height: 16),
              if (_battlePassTierUp && _newBattlePassTier != null)
                _BattlePassTierUpBanner(newTier: _newBattlePassTier!)
              else
                const SizedBox.shrink(),
              if (_battlePassTierUp) const SizedBox(height: 16),
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
              if (_friendChallengeResult != null)
                _FriendChallengeResultBanner(
                  friendLabel: _friendChallengeResult!.friendLabel,
                  targetScore: _friendChallengeResult!.targetScore,
                  beaten: _friendChallengeBeaten,
                )
              else
                const SizedBox.shrink(),
              if (_friendChallengeResult != null) const SizedBox(height: 16),
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
    Scenario.itsukushima: ['暴風雨に乗じた奇襲', '宮尾城を死守', '退路を断ち包囲', '敵将討死'],
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

  void _shareResult(BuildContext context) {
    final data = args.data;
    final resultText = data.won ? '勝利' : '敗北';
    final tpCount = data.tpAchievements.where((a) => a).length;
    SharePlus.instance.share(
      ShareParams(
        text: '戦国采配録『${args.scenario.displayNameJa}』で$resultText！\n'
            'スコア: ${data.totalScore} pts / ターニングポイント $tpCount/${data.tpAchievements.length}\n'
            '#戦国采配録',
      ),
    );
  }

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
          onPressed: () => _shareResult(context),
          icon: const Icon(Icons.share, color: Colors.cyan),
          label: const Text(
            '結果をシェア',
            style: TextStyle(color: Colors.cyan),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.cyan),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
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

class _FriendChallengeResultBanner extends StatelessWidget {
  final String friendLabel;
  final int targetScore;
  final bool beaten;

  const _FriendChallengeResultBanner({
    required this.friendLabel,
    required this.targetScore,
    required this.beaten,
  });

  @override
  Widget build(BuildContext context) {
    final color = beaten ? Colors.amber : Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            beaten ? Icons.emoji_events : Icons.sports_kabaddi,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beaten
                      ? '$friendLabelへの挑戦、成功！'
                      : '$friendLabelへの挑戦、届かず',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '目標スコア: $targetScore点',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
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
        color: Colors.green.withValues(alpha: 0.15),
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
            Colors.amber.withValues(alpha: 0.2),
            Colors.orange.withValues(alpha: 0.2),
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

class _BattlePassTierUpBanner extends StatelessWidget {
  final int newTier;

  const _BattlePassTierUpBanner({required this.newTier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withValues(alpha: 0.2),
            Colors.blue.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.cyan, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'バトルパス ティアアップ！',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ティア $newTier に到達しました',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.cyan,
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
            Colors.purple.withValues(alpha: 0.2),
            Colors.pink.withValues(alpha: 0.2),
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
