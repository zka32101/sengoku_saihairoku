import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_models.dart';
import '../models/scenario_data.dart';

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

  String _getRankingCollectionName(Scenario scenario) =>
      'rankings_${scenario.name}';

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
}
