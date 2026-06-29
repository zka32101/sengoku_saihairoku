import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_models.dart';
import '../models/scenario_data.dart';

abstract class IUserRepository {
  Future<FirebaseUser> getOrCreateUser(String userId, String displayName);
  Future<void> updateUserProgress(String userId, ScenarioProgress progress);
  Future<FirebaseUser> getUser(String userId);
  Future<void> updateLastPlayedTime(String userId);
}

class UserRepository implements IUserRepository {
  static final UserRepository _instance = UserRepository._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  @override
  Future<FirebaseUser> getOrCreateUser(
      String userId, String displayName) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(userId).get();

      if (doc.exists) {
        return FirebaseUser.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        final newUser = FirebaseUser(
          uid: userId,
          displayName: displayName,
          createdAt: DateTime.now(),
          lastPlayedAt: DateTime.now(),
          totalPlayed: 0,
          totalWins: 0,
          bestScore: 0,
          scenarioProgress: Scenario.values
              .map((s) => ScenarioProgress(
                    scenarioId: s,
                    timesPlayed: 0,
                    timesWon: 0,
                    bestScore: 0,
                    achievedTurningPoints: [],
                    isUnlocked: s == Scenario.odigahara,
                  ))
              .toList(),
        );

        await _firestore
            .collection(_collectionName)
            .doc(userId)
            .set(newUser.toJson());

        return newUser;
      }
    } catch (e) {
      throw Exception('Failed to get or create user: $e');
    }
  }

  @override
  Future<void> updateUserProgress(
      String userId, ScenarioProgress progress) async {
    try {
      final userDoc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found: $userId');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final progressList = userData['scenarioProgress'] as List;

      final updatedList = progressList.map((p) {
        final currentProgress = ScenarioProgress.fromJson(p as Map<String, dynamic>);
        if (currentProgress.scenarioId == progress.scenarioId) {
          return progress.toJson();
        }
        return p;
      }).toList();

      await _firestore.collection(_collectionName).doc(userId).update({
        'scenarioProgress': updatedList,
        'totalPlayed': FieldValue.increment(1),
        if (progress.timesWon > 0)
          'totalWins': FieldValue.increment(1)
        else
          'totalWins': 0,
        if (progress.bestScore > (userData['bestScore'] as int? ?? 0))
          'bestScore': progress.bestScore
        else
          'bestScore': userData['bestScore'],
      });
    } catch (e) {
      throw Exception('Failed to update user progress: $e');
    }
  }

  @override
  Future<FirebaseUser> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(userId).get();

      if (!doc.exists) {
        throw Exception('User not found: $userId');
      }

      return FirebaseUser.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<void> updateLastPlayedTime(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'lastPlayedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update last played time: $e');
    }
  }
}
