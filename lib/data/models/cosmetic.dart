/// ゲーム内コスメティック（スキン・テーマ）システム

/// コスメティックの種類
enum CosmeticType {
  unitSkin('ユニットスキン'),
  uiTheme('UIテーマ');

  final String displayName;
  const CosmeticType(this.displayName);
}

/// コスメティックの入手方法
enum AcquisitionMethod {
  levelMilestone('レベルマイルストーン'),
  prestigeReward('プレスティジ報酬'),
  eventReward('イベント報酬'),
  battlePass('バトルパス'),
  achievement('実績報酬');

  final String displayName;
  const AcquisitionMethod(this.displayName);
}

/// コスメティックのアイテム定義
class Cosmetic {
  final String id;
  final String name;
  final String description;
  final CosmeticType type;
  final AcquisitionMethod acquisitionMethod;
  final int? requiredLevel; // レベルマイルストーン用
  final String? imageAsset; // プレビュー画像パス
  final DateTime unlockedAt; // アンロック日時
  final bool isEquipped; // 装備中か

  Cosmetic({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.acquisitionMethod,
    this.requiredLevel,
    this.imageAsset,
    DateTime? unlockedAt,
    this.isEquipped = false,
  }) : unlockedAt = unlockedAt ?? DateTime.now();

  factory Cosmetic.fromJson(Map<String, dynamic> json) {
    return Cosmetic(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: CosmeticType.values.byName(json['type'] as String),
      acquisitionMethod:
          AcquisitionMethod.values.byName(json['acquisitionMethod'] as String),
      requiredLevel: json['requiredLevel'] as int?,
      imageAsset: json['imageAsset'] as String?,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      isEquipped: json['isEquipped'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.name,
        'acquisitionMethod': acquisitionMethod.name,
        'requiredLevel': requiredLevel,
        'imageAsset': imageAsset,
        'unlockedAt': unlockedAt.toIso8601String(),
        'isEquipped': isEquipped,
      };

  Cosmetic copyWith({
    String? id,
    String? name,
    String? description,
    CosmeticType? type,
    AcquisitionMethod? acquisitionMethod,
    int? requiredLevel,
    String? imageAsset,
    DateTime? unlockedAt,
    bool? isEquipped,
  }) {
    return Cosmetic(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      acquisitionMethod: acquisitionMethod ?? this.acquisitionMethod,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      imageAsset: imageAsset ?? this.imageAsset,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }
}

/// レベルマイルストーンごとの報酬情報
class MilestoneReward {
  final int level;
  final String cosmeticId;
  final String cosmeticName;
  final CosmeticType cosmeticType;
  final String description;
  final DateTime? unlockedAt;

  MilestoneReward({
    required this.level,
    required this.cosmeticId,
    required this.cosmeticName,
    required this.cosmeticType,
    required this.description,
    this.unlockedAt,
  });

  factory MilestoneReward.fromJson(Map<String, dynamic> json) {
    return MilestoneReward(
      level: json['level'] as int,
      cosmeticId: json['cosmeticId'] as String,
      cosmeticName: json['cosmeticName'] as String,
      cosmeticType: CosmeticType.values.byName(json['cosmeticType'] as String),
      description: json['description'] as String,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'cosmeticId': cosmeticId,
        'cosmeticName': cosmeticName,
        'cosmeticType': cosmeticType.name,
        'description': description,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };
}

/// ユーザーが装備中のコスメティック設定
class EquippedCosmetics {
  final String? unitSkinId;
  final String? uiThemeId;
  final DateTime lastUpdated;

  EquippedCosmetics({
    this.unitSkinId,
    this.uiThemeId,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory EquippedCosmetics.fromJson(Map<String, dynamic> json) {
    return EquippedCosmetics(
      unitSkinId: json['unitSkinId'] as String?,
      uiThemeId: json['uiThemeId'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'unitSkinId': unitSkinId,
        'uiThemeId': uiThemeId,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  EquippedCosmetics copyWith({
    String? unitSkinId,
    String? uiThemeId,
  }) {
    return EquippedCosmetics(
      unitSkinId: unitSkinId ?? this.unitSkinId,
      uiThemeId: uiThemeId ?? this.uiThemeId,
    );
  }
}
