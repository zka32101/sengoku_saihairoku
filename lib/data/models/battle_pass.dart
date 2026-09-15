import 'package:cloud_firestore/cloud_firestore.dart';

/// バトルパスのトラック種別
enum BattlePassTrack {
  free,    // 無料トラック
  premium, // プレミアムトラック
}

/// 報酬の種類
enum RewardType {
  cosmetic,  // コスメティック
  currency,  // ゲーム通貨
  special,   // 特別報酬
  cosmetic_exclusive, // プレミアム限定コスメティック
}

/// バトルパスのティア定義
class BattlePassTier {
  final int tierNumber;
  final int xpRequired; // このティアに到達するために必要なXP
  final String rewardId;
  final RewardType rewardType;
  final String rewardName;
  final String? rewardDescription;
  final BattlePassTrack track; // free or premium
  final String? icon; // emoji or asset path

  const BattlePassTier({
    required this.tierNumber,
    required this.xpRequired,
    required this.rewardId,
    required this.rewardType,
    required this.rewardName,
    this.rewardDescription,
    required this.track,
    this.icon,
  });

  /// JSONからの生成
  factory BattlePassTier.fromJson(Map<String, dynamic> json) {
    return BattlePassTier(
      tierNumber: json['tierNumber'] as int,
      xpRequired: json['xpRequired'] as int,
      rewardId: json['rewardId'] as String,
      rewardType: RewardType.values.byName(json['rewardType'] as String),
      rewardName: json['rewardName'] as String,
      rewardDescription: json['rewardDescription'] as String?,
      track: BattlePassTrack.values.byName(json['track'] as String),
      icon: json['icon'] as String?,
    );
  }

  /// JSONへの変換
  Map<String, dynamic> toJson() => {
    'tierNumber': tierNumber,
    'xpRequired': xpRequired,
    'rewardId': rewardId,
    'rewardType': rewardType.name,
    'rewardName': rewardName,
    'rewardDescription': rewardDescription,
    'track': track.name,
    'icon': icon,
  };
}

/// バトルパス定義
class BattlePass {
  final String id;
  final String season;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<BattlePassTier> tiers;
  final int maxTier;

  const BattlePass({
    required this.id,
    required this.season,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.tiers,
    required this.maxTier,
  });

  /// JSONからの生成
  factory BattlePass.fromJson(Map<String, dynamic> json) {
    final tierList = (json['tiers'] as List<dynamic>)
        .map((t) => BattlePassTier.fromJson(t as Map<String, dynamic>))
        .toList();

    return BattlePass(
      id: json['id'] as String,
      season: json['season'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      tiers: tierList,
      maxTier: json['maxTier'] as int,
    );
  }

  /// JSONへの変換
  Map<String, dynamic> toJson() => {
    'id': id,
    'season': season,
    'name': name,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'tiers': tiers.map((t) => t.toJson()).toList(),
    'maxTier': maxTier,
  };
}

/// ユーザーのバトルパス進捗
class BattlePassProgress {
  final String userId;
  final String battlePassId;
  final int currentTier;
  final int currentXp; // 現在のティア内でのXP
  final int totalXp; // シーズン開始からの累積XP
  final List<String> unlockedRewards; // 獲得済みの報酬ID
  final bool hasPremium; // プレミアムトラックに加入しているか
  final DateTime createdAt;
  final DateTime updatedAt;

  const BattlePassProgress({
    required this.userId,
    required this.battlePassId,
    required this.currentTier,
    required this.currentXp,
    required this.totalXp,
    required this.unlockedRewards,
    required this.hasPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Firestoreドキュメントからの生成
  factory BattlePassProgress.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BattlePassProgress(
      userId: data['userId'] as String,
      battlePassId: data['battlePassId'] as String,
      currentTier: data['currentTier'] as int? ?? 1,
      currentXp: data['currentXp'] as int? ?? 0,
      totalXp: data['totalXp'] as int? ?? 0,
      unlockedRewards: List<String>.from(data['unlockedRewards'] as List? ?? []),
      hasPremium: data['hasPremium'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Firestoreドキュメントへの変換
  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'battlePassId': battlePassId,
    'currentTier': currentTier,
    'currentXp': currentXp,
    'totalXp': totalXp,
    'unlockedRewards': unlockedRewards,
    'hasPremium': hasPremium,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  /// 現在のティアの進捗率を計算（0.0 - 1.0）
  double getProgressPercent(BattlePassTier currentTierData) {
    if (currentTier >= 50) return 1.0; // Max tier reached
    return (currentXp / currentTierData.xpRequired).clamp(0.0, 1.0);
  }

  /// 次のティアまでに必要なXPを計算
  int getXpUntilNextTier(BattlePassTier currentTierData) {
    return (currentTierData.xpRequired - currentXp).clamp(0, currentTierData.xpRequired);
  }
}

/// バトルパス統計情報
class BattlePassStats {
  final int currentTier;
  final double progressPercent;
  final int totalRewardsEarned;
  final int premiumRewardsEarned;
  final DateTime seasonEndDate;
  final int daysRemaining;

  const BattlePassStats({
    required this.currentTier,
    required this.progressPercent,
    required this.totalRewardsEarned,
    required this.premiumRewardsEarned,
    required this.seasonEndDate,
    required this.daysRemaining,
  });
}
