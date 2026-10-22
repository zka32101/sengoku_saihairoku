import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_models.dart';
import '../models/scenario_data.dart';
import 'package:flutter/foundation.dart';

abstract class IRankingRepository {
  Future<List<RankingEntry>> fetchRanking(Scenario scenario, {int limit = 50});
  Future<void> saveRanking(RankingEntry entry);
}

class RankingRepository implements IRankingRepository {
  static final RankingRepository _instance = RankingRepository._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory RankingRepository() {
    return _instance;
  }

  RankingRepository._internal();

  /// 現在のシーズンキー（年-月単位）。シーズンごとにランキングの
  /// コレクションを分けることで、過去シーズンのデータをクエリ対象から
  /// 外し（＝実質的な月次リセット）、かつ過去データも消さずに残す。
  String get currentSeasonKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// 今シーズンの表示用ラベル（例: "2026年10月シーズン"）
  String get currentSeasonLabel {
    final now = DateTime.now();
    return '${now.year}年${now.month}月シーズン';
  }

  String _getRankingCollectionName(Scenario scenario) =>
      'rankings_${scenario.name}_$currentSeasonKey';

  @override
  Future<List<RankingEntry>> fetchRanking(Scenario scenario,
      {int limit = 50}) async {
    try {
      final collectionName = _getRankingCollectionName(scenario);
      final snapshot = await _firestore
          .collection(collectionName)
          .orderBy('bestScore', descending: true)
          .limit(limit)
          .get();

      final entries = <RankingEntry>[];
      for (int i = 0; i < snapshot.docs.length; i++) {
        final data = snapshot.docs[i].data();
        final entry = RankingEntry.fromJson(data);
        entries.add(RankingEntry(
          rank: i + 1,
          userId: entry.userId,
          displayName: entry.displayName,
          scenarioId: entry.scenarioId,
          bestScore: entry.bestScore,
          achievedAt: entry.achievedAt,
          turningPointsAchieved: entry.turningPointsAchieved,
        ));
      }

      return entries;
    } catch (e) {
      throw Exception('Failed to fetch ranking: $e');
    }
  }

  @override
  Future<void> saveRanking(RankingEntry entry) async {
    try {
      final collectionName =
          _getRankingCollectionName(entry.scenarioId);

      await _firestore
          .collection(collectionName)
          .doc('${entry.userId}_${entry.scenarioId.name}')
          .set({
        'userId': entry.userId,
        'displayName': entry.displayName,
        'scenarioId': entry.scenarioId.name,
        'bestScore': entry.bestScore,
        'achievedAt': entry.achievedAt.toIso8601String(),
        'turningPointsAchieved': entry.turningPointsAchieved,
      });
    } catch (e) {
      throw Exception('Failed to save ranking: $e');
    }
  }

  /// 今シーズンの自己ベストより高い場合のみ上書き保存する。
  /// 低いスコアで上書きされてしまわないよう、書き込み前に既存値と比較する。
  ///
  /// 戻り値にRankingEntryを公開すると、同名で別定義の
  /// `FirebaseService`側RankingEntryとの型の取り違えを呼び出し側で
  /// 起こしやすいため、呼び出し側にはプリミティブ型のみを公開する。
  Future<void> submitIfSeasonBest({
    required String userId,
    required String displayName,
    required Scenario scenario,
    required int score,
    required DateTime achievedAt,
    required int turningPointsAchieved,
  }) async {
    try {
      final currentBest = await getMySeasonBestScore(userId, scenario);
      if (currentBest != null && currentBest >= score) return;
      await saveRanking(RankingEntry(
        rank: 0,
        userId: userId,
        displayName: displayName,
        scenarioId: scenario,
        bestScore: score,
        achievedAt: achievedAt,
        turningPointsAchieved: turningPointsAchieved,
      ));
    } catch (e) {
      debugPrint('Error submitting season ranking: $e');
    }
  }

  /// 指定ユーザーの今シーズンの自己ベストスコアを取得する
  Future<int?> getMySeasonBestScore(String userId, Scenario scenario) async {
    try {
      final collectionName = _getRankingCollectionName(scenario);
      final doc = await _firestore
          .collection(collectionName)
          .doc('${userId}_${scenario.name}')
          .get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return data['bestScore'] as int?;
    } catch (e) {
      debugPrint('Error getting season best: $e');
      return null;
    }
  }
}
