import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_challenge.dart';
import '../models/difficulty_mode.dart';
import '../models/scenario_data.dart';

/// 日替わりチャレンジ管理リポジトリ
class DailyChallengeRepository {
  static final DailyChallengeRepository _instance = DailyChallengeRepository._internal();

  late SharedPreferences _prefs;
  List<DailyChallenge> _allChallenges = [];
  bool _initialized = false;

  // SharedPreferences キー
  static const String _progressKey = 'daily_challenge_progress';
  static const String _streakCountKey = 'daily_challenge_streak_count';
  static const String _streakLastDateKey = 'daily_challenge_streak_last_date';

  factory DailyChallengeRepository() {
    return _instance;
  }

  DailyChallengeRepository._internal();

  /// 初期化（チャレンジデータをJSONから読み込む）
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      // challenges.json からチャレンジ定義を読み込む
      final jsonString = await rootBundle.loadString('assets/data/challenges.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      final challenges = (json['challenges'] as List)
          .map((c) => DailyChallenge.fromJson(c as Map<String, dynamic>))
          .toList();

      _allChallenges = challenges;
      _initialized = true;
      print('✓ DailyChallengeRepository initialized with ${_allChallenges.length} challenges');
    } catch (e) {
      print('Error initializing DailyChallengeRepository: $e');
      _initialized = false;
    }
  }

  /// 本日のチャレンジを取得
  DailyChallenge? getTodayChallenge() {
    if (_allChallenges.isEmpty) return null;

    // 日付をキーにしてチャレンジをローテーション
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _allChallenges.length;

    final challenge = _allChallenges[index];

    // チャレンジの有効期限をチェック
    if (challenge.isActive) {
      return challenge;
    }

    return null;
  }

  /// 本日のチャレンジの進捗を取得
  ChallengeProgress? getTodayProgress() {
    final today = _getTodayKey();
    final progressJson = _prefs.getString(_progressKey);

    if (progressJson == null) return null;

    try {
      final progressList = jsonDecode(progressJson) as List;
      final todayProgress = progressList
          .cast<Map<String, dynamic>>()
          .where((p) => p['date'] as String == today)
          .firstOrNull;

      if (todayProgress != null) {
        return ChallengeProgress.fromJson(todayProgress);
      }
    } catch (e) {
      print('Error reading challenge progress: $e');
    }

    return null;
  }

  /// チャレンジ達成を記録
  Future<void> completeChallenge(String challengeId) async {
    final today = _getTodayKey();
    final progress = ChallengeProgress(
      challengeId: challengeId,
      completedAt: DateTime.now(),
      claimed: false,
    );

    // 既存の進捗を取得
    final progressJson = _prefs.getString(_progressKey);
    final progressList = progressJson != null
        ? (jsonDecode(progressJson) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    // 本日のエントリを更新（あれば削除して新規作成）
    progressList.removeWhere((p) => (p['date'] as String?) == today);

    final progressMap = progress.toJson();
    progressMap['date'] = today;
    progressList.add(progressMap);

    // 保存（最新30日分のみ保持）
    if (progressList.length > 30) {
      progressList.removeAt(0);
    }

    await _prefs.setString(_progressKey, jsonEncode(progressList));
    await _recordStreakCompletion(today);
    print('✓ Challenge $challengeId completed on $today');
  }

  /// 連続達成日数（ストリーク）を更新する。
  /// 前回の達成日が「昨日」ならストリークを+1、それ以外（初回/途切れ後）なら1にリセット。
  /// 同日に複数回達成が記録された場合は何もしない。
  Future<void> _recordStreakCompletion(String today) async {
    final lastDate = _prefs.getString(_streakLastDateKey);
    if (lastDate == today) return;

    final yesterday = _formatDate(DateTime.now().subtract(const Duration(days: 1)));
    final currentStreak = _prefs.getInt(_streakCountKey) ?? 0;
    final newStreak = lastDate == yesterday ? currentStreak + 1 : 1;

    await _prefs.setInt(_streakCountKey, newStreak);
    await _prefs.setString(_streakLastDateKey, today);
  }

  /// 現在のデイリーチャレンジ連続達成日数を取得する。
  /// 最後の達成日が今日でも昨日でもない場合（1日以上空いた場合）はストリークが
  /// 途切れているため0を返す。
  int getCurrentStreak() {
    final lastDate = _prefs.getString(_streakLastDateKey);
    if (lastDate == null) return 0;

    final today = _getTodayKey();
    final yesterday = _formatDate(DateTime.now().subtract(const Duration(days: 1)));
    if (lastDate != today && lastDate != yesterday) return 0;

    return _prefs.getInt(_streakCountKey) ?? 0;
  }

  /// チャレンジ報酬受け取りを記録
  Future<void> claimReward(String challengeId) async {
    final today = _getTodayKey();
    final progressJson = _prefs.getString(_progressKey);

    if (progressJson == null) return;

    try {
      final progressList = (jsonDecode(progressJson) as List).cast<Map<String, dynamic>>();

      final index = progressList
          .indexWhere((p) =>
              (p['date'] as String?) == today &&
              (p['challengeId'] as String?) == challengeId);

      if (index != -1) {
        progressList[index]['claimed'] = true;
        await _prefs.setString(_progressKey, jsonEncode(progressList));
        print('✓ Challenge $challengeId reward claimed');
      }
    } catch (e) {
      print('Error claiming reward: $e');
    }
  }

  /// チャレンジ統計を計算
  Future<ChallengeStats> getStats() async {
    final progressJson = _prefs.getString(_progressKey);
    if (progressJson == null) {
      return ChallengeStats.empty();
    }

    try {
      final progressList = (jsonDecode(progressJson) as List)
          .cast<Map<String, dynamic>>();

      final completedChallenges = <String>[];
      final claimedRewards = <String>[];
      int totalRewardPoints = 0;
      int totalAchievementPoints = 0;
      final completionByScenario = <Scenario, int>{};
      final completionByDifficulty = <DifficultyMode, int>{};

      for (final progress in progressList) {
        final challengeId = progress['challengeId'] as String;
        final claimed = progress['claimed'] as bool? ?? false;

        if (progress['completedAt'] != null) {
          completedChallenges.add(challengeId);
          if (claimed) {
            claimedRewards.add(challengeId);
          }

          // チャレンジ情報から報酬を加算
          final challenge = _allChallenges
              .firstWhere((c) => c.id == challengeId, orElse: () => null as dynamic);

          if (challenge != null) {
            totalRewardPoints += challenge.baseReward;
            totalAchievementPoints += challenge.achievementPoints;

            // シナリオ別・難易度別の達成数を集計
            final scenarioKey = challenge.scenario;
            final difficultyKey = challenge.difficulty;

            completionByScenario[scenarioKey] =
                (completionByScenario[scenarioKey] ?? 0) + 1;
            completionByDifficulty[difficultyKey] =
                (completionByDifficulty[difficultyKey] ?? 0) + 1;
          }
        }
      }

      return ChallengeStats(
        totalCompleted: completedChallenges.length,
        totalClaimed: claimedRewards.length,
        totalRewardPoints: totalRewardPoints,
        totalAchievementPoints: totalAchievementPoints,
        completionByScenario: completionByScenario,
        completionByDifficulty: completionByDifficulty,
      );
    } catch (e) {
      print('Error calculating challenge stats: $e');
      return ChallengeStats.empty();
    }
  }

  /// 全チャレンジを取得
  List<DailyChallenge> getAllChallenges() => List.unmodifiable(_allChallenges);

  /// チャレンジをIDで取得
  DailyChallenge? getChallengeById(String id) {
    try {
      return _allChallenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 直近7日間のチャレンジを取得
  List<({DateTime date, DailyChallenge? challenge, ChallengeProgress? progress})>
      getLast7Days() {
    final results = <({DateTime date, DailyChallenge? challenge, ChallengeProgress? progress})>[];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateKey = _formatDate(date);
      final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
      final challengeIndex = dayOfYear % _allChallenges.length;
      final challenge = _allChallenges[challengeIndex];

      // この日の進捗を取得（簡略版）
      results.add((
        date: date,
        challenge: challenge,
        progress: null, // 実装簡略化のため省略
      ));
    }

    return results;
  }

  /// 本日を表す日付キーを取得（YYYY-MM-DD形式）
  String _getTodayKey() {
    return _formatDate(DateTime.now());
  }

  /// 日付をフォーマット
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
