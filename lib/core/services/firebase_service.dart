import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/battle_result_data.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userId;

  FirebaseService._internal();

  factory FirebaseService() => _instance;

  String? get userId => _userId;

  Future<void> initialize() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      _userId = userCredential.user?.uid;
    } catch (e) {
      // Silently fail if already signed in
      _userId = _auth.currentUser?.uid;
    }
  }

  Future<void> saveBattleResult(BattleResultData result) async {
    if (_userId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('battles')
          .doc(result.id)
          .set(result.toJson());

      // Also add to global rankings
      await _firestore.collection('rankings').doc(result.id).set({
        'userId': _userId,
        'scenarioId': result.scenarioId.name,
        'score': result.totalScore,
        'won': result.won,
        'playedAt': result.playedAt,
        'duration': result.duration,
      });
    } catch (e) {
      // Silently fail in offline mode
    }
  }

  Future<List<RankingEntry>> getGlobalRankings({
    String? scenarioId,
    int limit = 100,
  }) async {
    try {
      Query query = _firestore.collection('rankings').orderBy('score', descending: true);

      if (scenarioId != null) {
        query = query.where('scenarioId', isEqualTo: scenarioId);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .asMap()
          .entries
          .map((e) => RankingEntry(
                rank: e.key + 1,
                userId: e.value['userId'] as String? ?? 'Anonymous',
                scenarioId: e.value['scenarioId'] as String? ?? '',
                score: e.value['score'] as int? ?? 0,
                won: e.value['won'] as bool? ?? false,
                playedAt: e.value['playedAt'] != null
                    ? (e.value['playedAt'] as Timestamp).toDate()
                    : DateTime.now(),
                duration: e.value['duration'] as int? ?? 0,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<RankingEntry>> getUserRankings() async {
    if (_userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('battles')
          .orderBy('playedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => RankingEntry(
                rank: 0,
                userId: _userId ?? 'You',
                scenarioId: doc['scenarioId'] as String? ?? '',
                score: doc['totalScore'] as int? ?? 0,
                won: doc['won'] as bool? ?? false,
                playedAt: doc['playedAt'] != null
                    ? (doc['playedAt'] as Timestamp).toDate()
                    : DateTime.now(),
                duration: doc['duration'] as int? ?? 0,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class RankingEntry {
  final int rank;
  final String userId;
  final String scenarioId;
  final int score;
  final bool won;
  final DateTime playedAt;
  final int duration;

  RankingEntry({
    required this.rank,
    required this.userId,
    required this.scenarioId,
    required this.score,
    required this.won,
    required this.playedAt,
    required this.duration,
  });
}
