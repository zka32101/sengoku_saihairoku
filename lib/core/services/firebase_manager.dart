import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/battle_result_data.dart';
import '../../data/models/scenario_data.dart';

class FirebaseManager {
  static final FirebaseManager _instance = FirebaseManager._internal();
  late FirebaseFirestore _firestore;
  bool _isInitialized = false;

  factory FirebaseManager() {
    return _instance;
  }

  FirebaseManager._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
      _firestore = FirebaseFirestore.instance;
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  Future<void> saveReplay(BattleResultData result) async {
    try {
      await _firestore
          .collection('battle_results')
          .doc(result.id)
          .set(result.toJson());
    } catch (e) {
      throw Exception('Failed to save replay: $e');
    }
  }

  Future<BattleResultData?> getReplay(String replayId) async {
    try {
      final doc =
          await _firestore.collection('battle_results').doc(replayId).get();

      if (!doc.exists) return null;

      return BattleResultData.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get replay: $e');
    }
  }

  Future<List<BattleResultData>> getUserBattleHistory(String userId,
      {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('battle_results')
          .where('userId', isEqualTo: userId)
          .orderBy('playedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => BattleResultData.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user battle history: $e');
    }
  }

  Future<void> updateUserStats(String userId, int totalWins,
      int totalPlayed, int bestScore) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'totalWins': totalWins,
        'totalPlayed': totalPlayed,
        'bestScore': bestScore,
        'lastPlayedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  Future<void> addMessageRecord(String userId, String messageId,
      Scenario scenario, int score) async {
    try {
      await _firestore.collection('message_records').add({
        'userId': userId,
        'messageId': messageId,
        'scenario': scenario.name,
        'score': score,
        'recordedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add message record: $e');
    }
  }

  Future<String?> getPlayerMessageVariant(String userId, Scenario scenario) async {
    try {
      final snapshot = await _firestore
          .collection('message_records')
          .where('userId', isEqualTo: userId)
          .where('scenario', isEqualTo: scenario.name)
          .orderBy('recordedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return snapshot.docs.first['messageId'] as String?;
    } catch (e) {
      throw Exception('Failed to get player message variant: $e');
    }
  }

  Future<Map<String, dynamic>> getAppConfig() async {
    try {
      final doc = await _firestore.collection('config').doc('app').get();

      if (!doc.exists) {
        return {};
      }

      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get app config: $e');
    }
  }
}
