import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_challenge.dart';

/// 週替わりチャレンジ管理リポジトリ。
///
/// 日替わりチャレンジ(`DailyChallengeRepository`)と同じ`challenges.json`の
/// プールを使い回すが、ローテーション単位を「週」にし、報酬を3倍に
/// 引き上げることで「じっくり挑む高難度・高報酬の週替わり枠」として扱う。
/// モデル・進捗記録の形は日替わりと揃え、専用のSharedPreferencesキーで
/// 独立して進捗を管理する。
class WeeklyChallengeRepository {
  static final WeeklyChallengeRepository _instance =
      WeeklyChallengeRepository._internal();
  factory WeeklyChallengeRepository() => _instance;
  WeeklyChallengeRepository._internal();

  static const double rewardMultiplier = 3.0;
  static const String _progressKey = 'weekly_challenge_progress';

  /// 日替わりローテーションと重ならないようずらすオフセット
  static const int _rotationOffset = 17;

  List<DailyChallenge> _allChallenges = [];
  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> initialize(List<DailyChallenge> challengePool) async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _allChallenges = challengePool;
    _initialized = true;
  }

  int get _isoWeekNumber {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return dayOfYear ~/ 7;
  }

  /// 今週のチャレンジ（元の定義から報酬のみ3倍に引き上げたコピー）
  DailyChallenge? getThisWeekChallenge() {
    if (_allChallenges.isEmpty) return null;
    final index = (_isoWeekNumber + _rotationOffset) % _allChallenges.length;
    final base = _allChallenges[index];
    return DailyChallenge(
      id: 'weekly_${base.id}',
      title: '【週替わり】${base.title}',
      description: base.description,
      scenario: base.scenario,
      difficulty: base.difficulty,
      conditions: base.conditions,
      baseReward: (base.baseReward * rewardMultiplier).round(),
      achievementPoints: base.achievementPoints,
      availableFrom: base.availableFrom,
      availableUntil: base.availableUntil,
    );
  }

  String get _weekKey {
    final now = DateTime.now();
    return '${now.year}-w$_isoWeekNumber';
  }

  ChallengeProgress? getThisWeekProgress() {
    final progressJson = _prefs.getString(_progressKey);
    if (progressJson == null) return null;

    try {
      final progressList = (jsonDecode(progressJson) as List)
          .cast<Map<String, dynamic>>();
      final entry = progressList
          .where((p) => (p['week'] as String?) == _weekKey)
          .firstOrNull;
      if (entry != null) return ChallengeProgress.fromJson(entry);
    } catch (_) {
      // 読み込みに失敗した場合は未達成として扱う
    }
    return null;
  }

  Future<void> completeChallenge(String challengeId) async {
    final week = _weekKey;
    final progress = ChallengeProgress(
      challengeId: challengeId,
      completedAt: DateTime.now(),
      claimed: false,
    );

    final progressJson = _prefs.getString(_progressKey);
    final progressList = progressJson != null
        ? (jsonDecode(progressJson) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    progressList.removeWhere((p) => (p['week'] as String?) == week);

    final progressMap = progress.toJson();
    progressMap['week'] = week;
    progressList.add(progressMap);

    if (progressList.length > 12) {
      progressList.removeAt(0);
    }

    await _prefs.setString(_progressKey, jsonEncode(progressList));
  }

  Future<void> claimReward(String challengeId) async {
    final week = _weekKey;
    final progressJson = _prefs.getString(_progressKey);
    if (progressJson == null) return;

    try {
      final progressList =
          (jsonDecode(progressJson) as List).cast<Map<String, dynamic>>();
      final index = progressList.indexWhere((p) =>
          (p['week'] as String?) == week &&
          (p['challengeId'] as String?) == challengeId);
      if (index != -1) {
        progressList[index]['claimed'] = true;
        await _prefs.setString(_progressKey, jsonEncode(progressList));
      }
    } catch (_) {
      // 失敗時は何もしない（次回起動時に再試行される）
    }
  }
}
