import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/cosmetic.dart';

/// ゲーム内報酬・コスメティック管理リポジトリ
class RewardRepository {
  static final RewardRepository _instance = RewardRepository._internal();

  late FirebaseFirestore _firestore;
  static const String _collection = 'rewards';
  static const String _cosmeticsCollection = 'cosmetics';
  late Map<String, dynamic> _cosmeticDatabase;

  factory RewardRepository() {
    return _instance;
  }

  RewardRepository._internal();

  /// 初期化（Firestoreのセットアップ＆コスメティックデータ読み込み）
  Future<void> initialize() async {
    _firestore = FirebaseFirestore.instance;
    await _loadCosmeticDatabase();
    print('✓ RewardRepository initialized');
  }

  /// コスメティックデータベース（JSON）を読み込み
  Future<void> _loadCosmeticDatabase() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/cosmetics.json');
      _cosmeticDatabase = jsonDecode(jsonString) as Map<String, dynamic>;
      print(
          '✓ Cosmetic database loaded: ${_cosmeticDatabase.length} cosmetics');
    } catch (e) {
      print('Error loading cosmetic database: $e');
      _cosmeticDatabase = {};
    }
  }

  /// ユーザーがアンロック済みコスメティックを取得
  Future<List<Cosmetic>> getUserCosmetics(String userId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(userId).get();

      if (!doc.exists) {
        return [];
      }

      final data = doc.data() as Map<String, dynamic>;
      final unlockedIds =
          List<String>.from(data['unlockedCosmetics'] as List? ?? []);

      // コスメティックデータベースからアンロック済みのみを取得
      final cosmetics = <Cosmetic>[];
      for (final id in unlockedIds) {
        final cosmeticData =
            _cosmeticDatabase[id] as Map<String, dynamic>?;
        if (cosmeticData != null) {
          final cosmetic = Cosmetic.fromJson({
            ...cosmeticData,
            'unlockedAt': data['unlockedAt_$id'],
            'isEquipped': _isEquipped(data, id),
          } as Map<String, dynamic>);
          cosmetics.add(cosmetic);
        }
      }

      return cosmetics;
    } catch (e) {
      print('Error getting user cosmetics: $e');
      return [];
    }
  }

  /// コスメティックがアンロック状態か確認
  Future<bool> isCosmeticUnlocked(String userId, String cosmeticId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(userId).get();

      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      final unlockedIds =
          List<String>.from(data['unlockedCosmetics'] as List? ?? []);

      return unlockedIds.contains(cosmeticId);
    } catch (e) {
      print('Error checking cosmetic unlock: $e');
      return false;
    }
  }

  /// レベルマイルストーンに基づいてコスメティックをアンロック
  Future<void> unlockMilestoneCosmetic(
    String userId,
    int level,
    String cosmeticId,
  ) async {
    try {
      final isUnlocked = await isCosmeticUnlocked(userId, cosmeticId);

      if (isUnlocked) {
        print('✓ Cosmetic already unlocked: $cosmeticId');
        return;
      }

      // Firestoreに保存
      await _firestore.collection(_collection).doc(userId).set(
        {
          'unlockedCosmetics': FieldValue.arrayUnion([cosmeticId]),
          'unlockedAt_$cosmeticId': FieldValue.serverTimestamp(),
          'milestoneLevel_$cosmeticId': level,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      print('✓ Milestone cosmetic unlocked for user $userId: $cosmeticId');
    } catch (e) {
      print('Error unlocking milestone cosmetic: $e');
    }
  }

  /// プレスティジ報酬としてコスメティックをアンロック
  Future<void> unlockPrestigeCosmetic(
    String userId,
    int prestigeLevel,
    String cosmeticId,
  ) async {
    try {
      final isUnlocked = await isCosmeticUnlocked(userId, cosmeticId);

      if (isUnlocked) {
        print('✓ Prestige cosmetic already unlocked: $cosmeticId');
        return;
      }

      // Firestoreに保存
      await _firestore.collection(_collection).doc(userId).set(
        {
          'unlockedCosmetics': FieldValue.arrayUnion([cosmeticId]),
          'unlockedAt_$cosmeticId': FieldValue.serverTimestamp(),
          'prestigeLevel_$cosmeticId': prestigeLevel,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      print('✓ Prestige cosmetic unlocked for user $userId: $cosmeticId');
    } catch (e) {
      print('Error unlocking prestige cosmetic: $e');
    }
  }

  /// コスメティックを装備
  Future<void> equipCosmetic(
    String userId,
    String cosmeticId,
    CosmeticType type,
  ) async {
    try {
      final isUnlocked = await isCosmeticUnlocked(userId, cosmeticId);

      if (!isUnlocked) {
        print('Error: Cosmetic not unlocked: $cosmeticId');
        return;
      }

      final updateMap = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // タイプに応じて装備欄を更新
      if (type == CosmeticType.unitSkin) {
        updateMap['equippedUnitSkin'] = cosmeticId;
      } else if (type == CosmeticType.uiTheme) {
        updateMap['equippedUiTheme'] = cosmeticId;
      }

      await _firestore.collection(_collection).doc(userId).set(
        updateMap,
        SetOptions(merge: true),
      );

      print('✓ Cosmetic equipped for user $userId: $cosmeticId');
    } catch (e) {
      print('Error equipping cosmetic: $e');
    }
  }

  /// コスメティックを装備解除
  Future<void> unequipCosmetic(
    String userId,
    CosmeticType type,
  ) async {
    try {
      final updateMap = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // タイプに応じて装備欄をクリア
      if (type == CosmeticType.unitSkin) {
        updateMap['equippedUnitSkin'] = FieldValue.delete();
      } else if (type == CosmeticType.uiTheme) {
        updateMap['equippedUiTheme'] = FieldValue.delete();
      }

      await _firestore.collection(_collection).doc(userId).set(
        updateMap,
        SetOptions(merge: true),
      );

      print('✓ Cosmetic unequipped for user $userId');
    } catch (e) {
      print('Error unequipping cosmetic: $e');
    }
  }

  /// ユーザーの装備中コスメティックを取得
  Future<EquippedCosmetics> getEquippedCosmetics(String userId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(userId).get();

      if (!doc.exists) {
        return EquippedCosmetics();
      }

      final data = doc.data() as Map<String, dynamic>;

      return EquippedCosmetics(
        unitSkinId: data['equippedUnitSkin'] as String?,
        uiThemeId: data['equippedUiTheme'] as String?,
        lastUpdated: data['lastUpdated'] != null
            ? (data['lastUpdated'] as Timestamp).toDate()
            : null,
      );
    } catch (e) {
      print('Error getting equipped cosmetics: $e');
      return EquippedCosmetics();
    }
  }

  /// 利用可能なレベルマイルストーン報酬を取得
  List<MilestoneReward> getAvailableMilestoneRewards() {
    return [
      MilestoneReward(
        level: 10,
        cosmeticId: 'unit_skin_bronze',
        cosmeticName: '青年期ユニットスキン',
        cosmeticType: CosmeticType.unitSkin,
        description: '若き日の兵士たち',
      ),
      MilestoneReward(
        level: 25,
        cosmeticId: 'ui_theme_autumn',
        cosmeticName: '紅葉UIテーマ',
        cosmeticType: CosmeticType.uiTheme,
        description: '秋の京都',
      ),
      MilestoneReward(
        level: 50,
        cosmeticId: 'ui_theme_night',
        cosmeticName: '夜間UIテーマ',
        cosmeticType: CosmeticType.uiTheme,
        description: '夜間作戦モード',
      ),
      MilestoneReward(
        level: 75,
        cosmeticId: 'unit_skin_elite',
        cosmeticName: 'エリートユニットスキン',
        cosmeticType: CosmeticType.unitSkin,
        description: '精鋭部隊',
      ),
      MilestoneReward(
        level: 100,
        cosmeticId: 'ui_theme_legendary',
        cosmeticName: '伝説的UIテーマ',
        cosmeticType: CosmeticType.uiTheme,
        description: 'プレスティジシステム解放',
      ),
    ];
  }

  /// 指定レベルのマイルストーン報酬を取得
  MilestoneReward? getMilestoneRewardForLevel(int level) {
    final rewards = getAvailableMilestoneRewards();
    try {
      return rewards.firstWhere((r) => r.level == level);
    } catch (e) {
      return null;
    }
  }

  /// コスメティック情報をデータベースから取得
  Cosmetic? getCosmeticInfo(String cosmeticId) {
    try {
      final cosmeticData =
          _cosmeticDatabase[cosmeticId] as Map<String, dynamic>?;
      if (cosmeticData != null) {
        return Cosmetic.fromJson(cosmeticData as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting cosmetic info: $e');
    }
    return null;
  }

  /// ユーザーの報酬履歴を取得
  Future<List<Map<String, dynamic>>> getRewardHistory(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final docs = await _firestore
          .collection(_collection)
          .doc(userId)
          .collection('rewardHistory')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return docs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting reward history: $e');
      return [];
    }
  }

  /// コスメティックが装備中か確認（ヘルパー）
  bool _isEquipped(Map<String, dynamic> userData, String cosmeticId) {
    return userData['equippedUnitSkin'] == cosmeticId ||
        userData['equippedUiTheme'] == cosmeticId;
  }

  /// テスト用：全報酬データを削除
  Future<void> deleteAllData(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
      await _deleteCollection(
          _firestore.collection(_collection).doc(userId).collection('rewardHistory'));

      print('✓ All reward data deleted for user $userId');
    } catch (e) {
      print('Error deleting reward data: $e');
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
