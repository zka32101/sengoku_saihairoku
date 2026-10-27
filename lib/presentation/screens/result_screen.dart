import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/message_settings.dart';
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
import '../../data/repositories/battle_stats_repository.dart';
import '../../data/services/progression_calculator.dart';
import '../../domain/challenges/challenge_service.dart';
import '../../domain/achievement_checking/achievement_checker.dart';
import '../../domain/achievement_checking/achievement_notification_service.dart';
import '../../domain/achievement_checking/playtime_tracker.dart';
import '../../data/repositories/battle_pass_repository.dart';
import '../../domain/battle_pass/battle_pass_notification_service.dart';
import '../../l10n/generated/app_localizations.dart';
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
  late PlaytimeTracker _playtimeTracker;
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
  bool _xpBoosted = false;
  bool _xpBoosting = false;
  bool _isFirstClearOnDifficulty = false;

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
    _playtimeTracker = PlaytimeTracker();
    _notificationService = AchievementNotificationService();
    _battlePassRepo = BattlePassRepository();
    _battlePassNotificationService = BattlePassNotificationService();

    // Initialize notification services with context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.initialize(context);
      _battlePassNotificationService.initialize(context);
    });

    final battleResultSaved = _saveBattleResult();
    _checkEventChallengeCompletion();
    _checkWeeklyChallengeCompletion();
    _checkFriendChallengeResult();
    // XP計算でストリークボーナスと初回クリア判定を正しく反映するため、
    // チャレンジ達成判定（ストリーク更新を含む）と戦闘結果保存
    // （初回クリア判定を含む）の両方の完了を待ってから実行する
    Future.wait([
      battleResultSaved,
      _checkChallengeCompletion(),
    ]).then((_) => _recordProgressionXp());
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

    if (data.won) {
      _isFirstClearOnDifficulty = await BattleStatsRepository().recordVictory(
        widget.args.scenario,
        widget.args.difficulty,
      );
    }

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
        await WarlordProgressRepository().addExpToWarlords(
          userId,
          widget.args.sortiedWarlordIds,
        );
      }
    }

    // Check battle achievements
    if (userId != null) {
      await _checkBattleAchievements(data);
      await _checkPlaytimeAchievements(userId, data);
    }
  }

  Future<void> _checkPlaytimeAchievements(
    String userId,
    BattleStateData data,
  ) async {
    try {
      final unlockedAchievements = await _playtimeTracker.recordBattlePlaytime(
        userId,
        data.elapsedTime.toInt(),
      );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(
              achievement,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking playtime achievements: $e');
    }
  }

  Future<void> _checkBattleAchievements(BattleStateData data) async {
    try {
      final userId = FirebaseService().userId;
      if (userId == null) return;

      final unlockedAchievements = await _achievementChecker
          .checkBattleAchievements(
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
            await _notificationService.showAchievementUnlockNotification(
              achievement,
            );
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

    final existingProgress = await _eventChallengeRepo.getProgress(
      userId,
      event.id,
    );
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
      final totalCompleted = await _eventChallengeRepo.getCompletedEventCount(
        userId,
      );

      final unlockedAchievements = await _achievementChecker
          .checkEventChallengeAchievements(
            userId: userId,
            totalEventChallengesCompleted: totalCompleted,
          );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(
              achievement,
            );
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
      final currentProgression = await _progressionRepo.getUserProgression(
        userId,
      );
      if (currentProgression == null) return;

      final oldLevel = currentProgression.currentLevel;

      // XP獲得を計算
      _xpGained = ProgressionCalculator.calculateXpGain(
        battleResult: widget.args.data,
        difficulty: widget.args.difficulty,
        currentChallengeStreak: _challengeRepo.getCurrentStreak(),
        isFirstClearOnDifficulty: _isFirstClearOnDifficulty,
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
      final newProgression = await _progressionRepo.getUserProgression(userId);
      if (newProgression != null && newProgression.currentLevel > oldLevel) {
        setState(() {
          _leveledUp = true;
          _newLevel = newProgression.currentLevel;
        });

        // レベルマイルストーン達成時のコスメティック解放
        await _unlockMilestoneCosmeticIfEarned(
          userId,
          newProgression.currentLevel,
        );

        // レベルアップ時に関連実績をチェック
        await _checkLevelAchievements(userId, newProgression.currentLevel);
      }

      // バトルパスXPを記録
      await _recordBattlePassXp();
    } catch (e) {
      debugPrint('Error recording progression XP: $e');
    }
  }

  /// 広告視聴で今回の戦闘XPをもう1回分（＝実質2倍）付与する。
  /// 日次上限はゴールドショップの広告とは別枠（AdService.showRewardedAd）
  /// で、1戦闘につき1回までは本メソッド自身のガード（_xpBoosted）で制限する。
  Future<void> _boostXpWithAd() async {
    if (_xpBoosted || _xpBoosting || _xpGained <= 0) return;
    final userId = FirebaseService().userId;
    if (userId == null) return;

    setState(() => _xpBoosting = true);
    try {
      final earned = await AdService().showRewardedAd();
      if (!earned) return;

      int oldLevel;
      if (_newLevel != null) {
        oldLevel = _newLevel!;
      } else {
        final progression = await _progressionRepo.getUserProgression(userId);
        oldLevel = progression?.currentLevel ?? 1;
      }

      await _progressionRepo.recordXpGain(
        userId: userId,
        xpGained: _xpGained,
        source: 'battle_xp_boost_ad',
        multipliers: const {},
      );

      final boostedXp = _xpGained;
      final newProgression = await _progressionRepo.getUserProgression(userId);
      final leveledUpFromBoost =
          newProgression != null && newProgression.currentLevel > oldLevel;

      if (!mounted) return;
      setState(() {
        _xpGained += boostedXp;
        _xpBoosted = true;
        if (leveledUpFromBoost) {
          _leveledUp = true;
          _newLevel = newProgression.currentLevel;
        }
      });

      if (leveledUpFromBoost) {
        // 通常のXP獲得と同じく、レベルマイルストーン解放・実績チェックを行う
        await _unlockMilestoneCosmeticIfEarned(
          userId,
          newProgression.currentLevel,
        );
        await _checkLevelAchievements(userId, newProgression.currentLevel);
      }
    } catch (e) {
      debugPrint('Error boosting XP with ad: $e');
    } finally {
      if (mounted) setState(() => _xpBoosting = false);
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
      final unlockedCosmetic = _rewardRepo.getCosmeticInfo(
        milestoneReward.cosmeticId,
      );
      setState(() {
        _cosmeticUnlocked = true;
        _unlockedCosmetic = unlockedCosmetic;
      });

      // コスメティック解放時に関連実績をチェック
      await _checkCosmeticAchievements(userId, milestoneReward.cosmeticId);
    } catch (e) {
      debugPrint('Error unlocking milestone cosmetic: $e');
    }
  }

  Future<void> _checkCosmeticAchievements(
    String userId,
    String unlockedCosmeticId,
  ) async {
    try {
      final progression = await _progressionRepo.getUserProgression(userId);
      final totalUnlockedCount = progression?.unlockedCosmetics.length ?? 0;

      final unlockedAchievements = await _achievementChecker
          .checkCosmeticAchievements(
            userId: userId,
            unlockedCosmeticId: unlockedCosmeticId,
            totalUnlockedCount: totalUnlockedCount,
          );

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(
              achievement,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking cosmetic achievements: $e');
    }
  }

  Future<void> _checkLevelAchievements(String userId, int newLevel) async {
    try {
      final unlockedAchievements = await _achievementChecker
          .checkLevelAchievements(userId: userId, newLevel: newLevel);

      if (unlockedAchievements.isNotEmpty) {
        setState(() {
          _unlockedAchievements.addAll(unlockedAchievements);
        });

        // Show notifications for each unlocked achievement
        if (mounted) {
          for (final achievement in unlockedAchievements) {
            await _notificationService.showAchievementUnlockNotification(
              achievement,
            );
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
      final currentProgress = await _battlePassRepo.getUserBattlePassProgress(
        userId,
      );
      final oldTier = currentProgress?.currentTier ?? 1;

      // バトルパスXPを獲得
      final newProgress = await _battlePassRepo.gainXp(
        userId,
        _battlePassXpGained,
      );

      if (newProgress != null && newProgress.currentTier > oldTier) {
        setState(() {
          _battlePassTierUp = true;
          _newBattlePassTier = newProgress.currentTier;
        });

        // ティアアップ通知を表示
        if (mounted) {
          final tierData = _battlePassRepo.getTierData(newProgress.currentTier);
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
    final l10n = AppLocalizations.of(context)!;
    final data = widget.args.data;

    // ターンランクを計算
    final criteria = _turnRankRepo.getCriteria(
      widget.args.scenario,
      widget.args.difficulty,
    );

    // ターン数ランクは勝利時のみ表示する(負けても早く終われば Gold・効率100% と出てしまうため)
    final turnRankResult = (criteria != null && data.won)
        ? TurnRankCalculator.calculateTurnRank(
            data.turnCount,
            criteria,
            data.totalScore,
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resultTitle)),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ResultHeader(won: data.won, l10n: l10n),
              const SizedBox(height: 24),
              if (turnRankResult != null) ...[
                TurnRankPanel(rankResult: turnRankResult),
                const SizedBox(height: 16),
              ],
              if (_leveledUp && _newLevel != null)
                _LevelUpBanner(newLevel: _newLevel!, l10n: l10n)
              else
                const SizedBox.shrink(),
              if (_leveledUp) const SizedBox(height: 16),
              if (_battlePassTierUp && _newBattlePassTier != null)
                _BattlePassTierUpBanner(
                  newTier: _newBattlePassTier!,
                  l10n: l10n,
                )
              else
                const SizedBox.shrink(),
              if (_battlePassTierUp) const SizedBox(height: 16),
              if (_cosmeticUnlocked && _unlockedCosmetic != null)
                _CosmeticUnlockBanner(cosmetic: _unlockedCosmetic!, l10n: l10n)
              else
                const SizedBox.shrink(),
              if (_cosmeticUnlocked) const SizedBox(height: 16),
              if (_xpGained > 0)
                _XpGainCard(
                  xpGained: _xpGained,
                  boosted: _xpBoosted,
                  boosting: _xpBoosting,
                  onBoost: _boostXpWithAd,
                  l10n: l10n,
                )
              else
                const SizedBox.shrink(),
              if (_xpGained > 0) const SizedBox(height: 16),
              if (_challengeCompleted)
                _ChallengeCompletionBanner(l10n: l10n)
              else
                const SizedBox.shrink(),
              if (_challengeCompleted) const SizedBox(height: 16),
              if (_friendChallengeResult != null)
                _FriendChallengeResultBanner(
                  friendLabel: _friendChallengeResult!.friendLabel,
                  targetScore: _friendChallengeResult!.targetScore,
                  beaten: _friendChallengeBeaten,
                  l10n: l10n,
                )
              else
                const SizedBox.shrink(),
              if (_friendChallengeResult != null) const SizedBox(height: 16),
              _ScoreCard(breakdown: data.scoreBreakdown, l10n: l10n),
              const SizedBox(height: 16),
              _TurningPointCard(
                achievements: data.tpAchievements,
                scenario: widget.args.scenario,
                l10n: l10n,
              ),
              const SizedBox(height: 24),
              _ActionButtons(args: widget.args, l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultHeader extends StatefulWidget {
  final bool won;
  final AppLocalizations l10n;

  const _ResultHeader({required this.won, required this.l10n});

  @override
  State<_ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<_ResultHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final won = widget.won;
    final l10n = widget.l10n;

    final card = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: won ? const Color(0xFF1A3A1A) : const Color(0xFF3A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: won ? Colors.green : Colors.red, width: 2),
      ),
      child: Column(
        children: [
          Text(
            won ? l10n.resultVictory : l10n.resultDefeat,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: won ? Colors.green : Colors.red,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            won ? l10n.resultVictorySubtitle : l10n.resultDefeatSubtitle,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (won)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _VictorySparklePainter(progress: _controller.value),
              size: const Size(double.infinity, 160),
            ),
          ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.elasticOut.transform(_controller.value);
            return Opacity(
              opacity: _controller.value.clamp(0.0, 1.0),
              child: Transform.scale(scale: t, child: child),
            );
          },
          child: card,
        ),
      ],
    );
  }
}

/// 勝利時のみ表示する、出現と同時に外側へ飛び散る金色の光の粒。
class _VictorySparklePainter extends CustomPainter {
  final double progress;

  _VictorySparklePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    const sparkleCount = 12;
    final alpha = (1.0 - progress).clamp(0.0, 1.0);
    for (int i = 0; i < sparkleCount; i++) {
      final angle = i * 2 * math.pi / sparkleCount;
      final distance = progress * 120 * (i.isEven ? 1.0 : 0.7);
      final offset = center + Offset.fromDirection(angle, distance);
      canvas.drawCircle(
        offset,
        i.isEven ? 3.5 : 2.0,
        Paint()..color = const Color(0xFFFFD700).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VictorySparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ScoreCard extends StatelessWidget {
  final ScoreBreakdownResult breakdown;
  final AppLocalizations l10n;

  const _ScoreCard({required this.breakdown, required this.l10n});

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
                Text(
                  l10n.resultTotalScoreLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                Text(
                  l10n.resultScorePoints(
                    breakdown.total.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},',
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF8B6914)),
            AnimatedScoreLine(
              l10n.resultScoreVictory,
              breakdown.victoryScore,
              40000,
              delayMillis: 100,
            ),
            AnimatedScoreLine(
              l10n.resultScoreEfficiency,
              breakdown.efficiencyScore,
              20000,
              delayMillis: 200,
            ),
            AnimatedScoreLine(
              l10n.resultScoreCommand,
              breakdown.commandScore,
              15000,
              delayMillis: 300,
            ),
            AnimatedScoreLine(
              l10n.resultScoreTurningPoint,
              breakdown.turningPointScore,
              15000,
              delayMillis: 400,
            ),
            AnimatedScoreLine(
              l10n.resultScoreHistory,
              breakdown.historyBonus,
              10000,
              delayMillis: 500,
            ),
          ],
        ),
      ),
    );
  }
}

class _TurningPointCard extends StatelessWidget {
  final List<bool> achievements;
  final Scenario scenario;
  final AppLocalizations l10n;

  const _TurningPointCard({
    required this.achievements,
    required this.scenario,
    required this.l10n,
  });

  List<String> _tpNamesFor(Scenario scenario) {
    switch (scenario) {
      case Scenario.odigahara:
        return [
          l10n.resultTpOdigahara1,
          l10n.resultTpOdigahara2,
          l10n.resultTpOdigahara3,
          l10n.resultTpOdigahara4,
        ];
      case Scenario.nagashino:
        return [
          l10n.resultTpNagashino1,
          l10n.resultTpNagashino2,
          l10n.resultTpNagashino3,
          l10n.resultTpNagashino4,
        ];
      case Scenario.honnoJi:
        return [
          l10n.resultTpHonnoJi1,
          l10n.resultTpHonnoJi2,
          l10n.resultTpHonnoJi3,
          l10n.resultTpHonnoJi4,
        ];
      case Scenario.sekigahara:
        return [
          l10n.resultTpSekigahara1,
          l10n.resultTpSekigahara2,
          l10n.resultTpSekigahara3,
          l10n.resultTpSekigahara4,
          l10n.resultTpSekigahara5,
        ];
      case Scenario.kawanakajima:
        return [
          l10n.resultTpKawanakajima1,
          l10n.resultTpKawanakajima2,
          l10n.resultTpKawanakajima3,
          l10n.resultTpKawanakajima4,
        ];
      case Scenario.itsukushima:
        return [
          l10n.resultTpItsukushima1,
          l10n.resultTpItsukushima2,
          l10n.resultTpItsukushima3,
          l10n.resultTpItsukushima4,
        ];
      case Scenario.oshiJo:
        return [
          l10n.resultTpOshijo1,
          l10n.resultTpOshijo2,
          l10n.resultTpOshijo3,
          l10n.resultTpOshijo4,
        ];
      case Scenario.mikatagahara:
        return [
          l10n.resultTpMikatagahara1,
          l10n.resultTpMikatagahara2,
          l10n.resultTpMikatagahara3,
          l10n.resultTpMikatagahara4,
        ];
      case Scenario.anegawa:
        return [
          l10n.resultTpAnegawa1,
          l10n.resultTpAnegawa2,
          l10n.resultTpAnegawa3,
          l10n.resultTpAnegawa4,
        ];
      case Scenario.shizugatake:
        return [
          l10n.resultTpShizugatake1,
          l10n.resultTpShizugatake2,
          l10n.resultTpShizugatake3,
          l10n.resultTpShizugatake4,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final names = _tpNamesFor(scenario);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.resultTurningPointTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(achievements.length, (i) {
              final achieved = achievements[i];
              final name = i < names.length
                  ? names[i]
                  : l10n.resultTpFallback(i + 1);
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
  final AppLocalizations l10n;

  const _ActionButtons({required this.args, required this.l10n});

  void _shareResult(BuildContext context) {
    final data = args.data;
    final resultText = data.won
        ? l10n.resultShareVictory
        : l10n.resultShareDefeat;
    final tpCount = data.tpAchievements.where((a) => a).length;
    SharePlus.instance.share(
      ShareParams(
        text: l10n.resultShareText(
          args.scenario.displayNameJa,
          resultText,
          data.totalScore,
          tpCount,
          data.tpAchievements.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (MessageSettings().storyMessagesEnabled) ...[
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
            label: Text(l10n.resultViewHistoryButton),
          ),
          const SizedBox(height: 8),
        ],
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/ranking'),
          icon: const Icon(Icons.leaderboard),
          label: Text(l10n.resultViewRankingButton),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _shareResult(context),
          icon: const Icon(Icons.share, color: Colors.cyan),
          label: Text(
            l10n.resultShareButton,
            style: const TextStyle(color: Colors.cyan),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.cyan),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName('/home')),
          icon: const Icon(Icons.home, color: Color(0xFFFFD700)),
          label: Text(
            l10n.resultHomeButton,
            style: const TextStyle(color: Color(0xFFFFD700)),
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
  final AppLocalizations l10n;

  const _FriendChallengeResultBanner({
    required this.friendLabel,
    required this.targetScore,
    required this.beaten,
    required this.l10n,
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
                      ? l10n.resultFriendChallengeSuccess(friendLabel)
                      : l10n.resultFriendChallengeFailure(friendLabel),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.resultFriendChallengeTarget(targetScore),
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
  final AppLocalizations l10n;

  const _ChallengeCompletionBanner({required this.l10n});

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
                Text(
                  l10n.resultChallengeCompletedTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.resultChallengeCompletedNote,
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

class _XpGainCard extends StatelessWidget {
  final int xpGained;
  final bool boosted;
  final bool boosting;
  final VoidCallback onBoost;
  final AppLocalizations l10n;

  const _XpGainCard({
    required this.xpGained,
    required this.boosted,
    required this.boosting,
    required this.onBoost,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A2A1A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.resultXpGainTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.resultXpGainedLabel,
                  style: const TextStyle(color: Colors.grey),
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
            if (!boosted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: boosting ? null : onBoost,
                  icon: boosting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_circle_outline, size: 18),
                  label: Text(
                    boosting
                        ? l10n.resultXpBoostLoading
                        : l10n.resultXpBoostButton,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber,
                    side: const BorderSide(color: Colors.amber),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelUpBanner extends StatelessWidget {
  final int newLevel;
  final AppLocalizations l10n;

  const _LevelUpBanner({required this.newLevel, required this.l10n});

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
          Text(
            l10n.resultLevelUpTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.resultLevelUpSubtitle(newLevel),
            style: const TextStyle(fontSize: 16, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}

class _BattlePassTierUpBanner extends StatelessWidget {
  final int newTier;
  final AppLocalizations l10n;

  const _BattlePassTierUpBanner({required this.newTier, required this.l10n});

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
          Text(
            l10n.resultBattlePassTierUpTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.resultBattlePassTierUpSubtitle(newTier),
            style: const TextStyle(fontSize: 16, color: Colors.cyan),
          ),
        ],
      ),
    );
  }
}

class _CosmeticUnlockBanner extends StatelessWidget {
  final Cosmetic cosmetic;
  final AppLocalizations l10n;

  const _CosmeticUnlockBanner({required this.cosmetic, required this.l10n});

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
          Text(
            l10n.resultCosmeticUnlockTitle,
            style: const TextStyle(
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
