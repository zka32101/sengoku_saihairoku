import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progression.dart';

/// ユーザープログレッション管理リポジトリ
class ProgressionRepository {
  static final ProgressionRepository _instance =
      ProgressionRepository._internal();

  late FirebaseFirestore _firestore;
  static const String _collection = 'progressions';

  factory ProgressionRepository() {
    return _instance;
  }

  ProgressionRepository._internal();

  /// 初期化（Firestoreのセットアップ）
  Future<void> initialize() async {
    _firestore = FirebaseFirestore.instance;
    print('✓ ProgressionRepository initialized');
  }

  /// ユーザープログレッションを取得
  Future<UserProgression?> getUserProgression(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();

      if (!doc.exists) {
        // 新規ユーザーの場合はデフォルトプログレッションを作成
        return _createDefaultProgression(userId);
      }

      return UserProgression.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user progression: $e');
      return null;
    }
  }

  /// XP獲得を保存
  Future<void> recordXpGain({
    required String userId,
    required int xpGained,
    required String source, // "battle", "challenge", "achievement"
    required Map<String, double> multipliers,
  }) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(userId).get();
      final currentData = doc.data() as Map<String, dynamic>? ?? {};

      final currentXp = currentData['experiencePoints'] as int? ?? 0;
      final currentLevel = currentData['currentLevel'] as int? ?? 1;
      final newTotalXp = currentXp + xpGained;

      // 新しいレベルを計算
      final newLevel = LevelingSystem.getLevelFromXp(newTotalXp);
      final leveledUp = newLevel > currentLevel;

      // XP獲得履歴を記録
      final xpRecord = XpGainRecord(
        xpGained: xpGained,
        source: source,
        multipliers: multipliers,
      );

      // Firestoreに保存
      await _firestore.collection(_collection).doc(userId).update({
        'experiencePoints': newTotalXp,
        'currentLevel': newLevel,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // XP獲得履歴を別コレクションに記録
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('xpHistory')
          .add(xpRecord.toJson());

      if (leveledUp) {
        await _applyLevelMilestones(userId, newLevel);
        print('✓ Level up! User $userId reached level $newLevel');
      }

      print('✓ XP gain recorded: $xpGained XP for user $userId');
    } catch (e) {
      print('Error recording XP gain: $e');
    }
  }

  /// レベルマイルストーンの報酬を適用
  Future<void> _applyLevelMilestones(String userId, int newLevel) async {
    try {
      if (!LevelingSystem.isMilestoneLevel(newLevel)) {
        return;
      }

      // マイルストーンレベルに基づいてコスメティックをアンロック
      final reward = LevelingSystem.getMilestoneReward(newLevel);
      if (reward != null) {
        // コスメティックアンロック情報をデータベースに記録
        await _firestore
            .collection(_collection)
            .doc(userId)
            .collection('milestones')
            .add({
          'level': newLevel,
          'reward': reward,
          'unlockedAt': FieldValue.serverTimestamp(),
        });

        print('✓ Milestone unlocked for user $userId: $reward');
      }
    } catch (e) {
      print('Error applying level milestones: $e');
    }
  }

  /// プレスティジリセットを実行
  Future<void> performPrestige(String userId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(userId).get();
      final currentData = doc.data() as Map<String, dynamic>? ?? {};

      final currentResetCount = currentData['prestigeResetCount'] as int? ?? 0;

      // レベルをリセット、プレスティジカウント+1、プレスティジポイントはゼロリセット
      await _firestore.collection(_collection).doc(userId).update({
        'currentLevel': 1,
        'experiencePoints': 0,
        'prestigeResetCount': currentResetCount + 1,
        'prestigePoints': 0,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // プレスティジ履歴を記録
      await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('prestigeHistory')
          .add({
        'resetNumber': currentResetCount + 1,
        'prestigedAt': FieldValue.serverTimestamp(),
      });

      print(
          '✓ Prestige performed for user $userId (Reset #${currentResetCount + 1})');
    } catch (e) {
      print('Error performing prestige: $e');
    }
  }

  /// コスメティックをアンロック
  Future<void> unlockCosmetic(String userId, String cosmeticId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'unlockedCosmetics': FieldValue.arrayUnion([cosmeticId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      print('✓ Cosmetic unlocked for user $userId: $cosmeticId');
    } catch (e) {
      print('Error unlocking cosmetic: $e');
    }
  }

  /// コスメティックを装備
  Future<void> equipCosmetic({
    required String userId,
    required String? unitSkin,
    required String? uiTheme,
  }) async {
    try {
      final update = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (unitSkin != null) {
        update['equippedUnitSkin'] = unitSkin;
      }
      if (uiTheme != null) {
        update['equippedUiTheme'] = uiTheme;
      }

      await _firestore.collection(_collection).doc(userId).update(update);

      print('✓ Cosmetic equipped for user $userId');
    } catch (e) {
      print('Error equipping cosmetic: $e');
    }
  }

  /// XP獲得履歴を取得（ページング対応）
  Future<List<XpGainRecord>> getXpHistory(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final docs = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('xpHistory')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .map((doc) =>
              XpGainRecord.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting XP history: $e');
      return [];
    }
  }

  /// プレスティジ履歴を取得
  Future<List<Map<String, dynamic>>> getPrestigeHistory(
    String userId,
  ) async {
    try {
      final docs = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('prestigeHistory')
          .orderBy('prestigedAt', descending: true)
          .get();

      return docs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting prestige history: $e');
      return [];
    }
  }

  /// マイルストーン報酬を取得
  Future<List<Map<String, dynamic>>> getMilestoneRewards(
    String userId,
  ) async {
    try {
      final docs = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('milestones')
          .orderBy('level', descending: true)
          .get();

      return docs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting milestone rewards: $e');
      return [];
    }
  }

  /// デフォルトプログレッションを作成
  UserProgression _createDefaultProgression(String userId) {
    final progression = UserProgression(
      userId: userId,
      experiencePoints: 0,
      currentLevel: 1,
      prestigeRank: PrestigeTier.bronze,
      prestigePoints: 0,
      totalPlayTime: 0,
    );

    // 新規ユーザーをFirestoreに保存
    _firestore
        .collection(_collection)
        .doc(userId)
        .set(progression.toJson())
        .catchError((e) => print('Error creating default progression: $e'));

    return progression;
  }

  /// 全プログレッションデータを削除（テスト用）
  Future<void> deleteAllData(String userId) async {
    try {
      // メインドキュメント削除
      await _firestore.collection(_collection).doc(userId).delete();

      // サブコレクション削除
      await _deleteCollection(
          _firestore.collection(_collection).doc(userId).collection('xpHistory'));
      await _deleteCollection(
          _firestore.collection(_collection).doc(userId).collection('prestigeHistory'));
      await _deleteCollection(
          _firestore.collection(_collection).doc(userId).collection('milestones'));

      print('✓ All progression data deleted for user $userId');
    } catch (e) {
      print('Error deleting progression data: $e');
    }
  }

  /// コレクション内の全ドキュメント削除（ヘルパー）
  Future<void> _deleteCollection(CollectionReference<Map<String, dynamic>> collection) async {
    final docs = await collection.get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }
  }
}
