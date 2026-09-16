import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/cosmetic.dart';
import '../../data/models/user_progression.dart';
import '../../data/repositories/reward_repository.dart';
import '../../data/repositories/progression_repository.dart';
import '../widgets/screen_transition.dart';

/// コスメティック装備・変更画面
class CosmeticsEquipmentScreen extends StatefulWidget {
  const CosmeticsEquipmentScreen({super.key});

  @override
  State<CosmeticsEquipmentScreen> createState() =>
      _CosmeticsEquipmentScreenState();
}

class _CosmeticsEquipmentScreenState extends State<CosmeticsEquipmentScreen> {
  late RewardRepository _rewardRepo;
  late ProgressionRepository _progressionRepo;
  List<Cosmetic> _userCosmetics = [];
  EquippedCosmetics? _equippedCosmetics;
  UserProgression? _userProgression;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _rewardRepo = RewardRepository();
    _progressionRepo = ProgressionRepository();
    _loadCosmeticsData();
  }

  Future<void> _loadCosmeticsData() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final cosmetics = await _rewardRepo.getUserCosmetics(userId);
      final equipped = await _rewardRepo.getEquippedCosmetics(userId);
      final progression = await _progressionRepo.getUserProgression(userId);

      setState(() {
        _userCosmetics = cosmetics;
        _equippedCosmetics = equipped;
        _userProgression = progression;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading cosmetics: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _equipCosmetic(String cosmeticId, CosmeticType type) async {
    final userId = FirebaseService().userId;
    if (userId == null) return;

    try {
      await _rewardRepo.equipCosmetic(userId, cosmeticId, type);

      // UIを更新
      await _loadCosmeticsData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('コスメティックを装備しました')),
        );
      }
    } catch (e) {
      print('Error equipping cosmetic: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

  Future<void> _unequipCosmetic(CosmeticType type) async {
    final userId = FirebaseService().userId;
    if (userId == null) return;

    try {
      await _rewardRepo.unequipCosmetic(userId, type);

      // UIを更新
      await _loadCosmeticsData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('コスメティックを外しました')),
        );
      }
    } catch (e) {
      print('Error unequipping cosmetic: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('コスメティック設定')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final unitSkins =
        _userCosmetics.where((c) => c.type == CosmeticType.unitSkin).toList();
    final uiThemes =
        _userCosmetics.where((c) => c.type == CosmeticType.uiTheme).toList();
    final prestigeSkins = _userCosmetics
        .where((c) =>
            c.type == CosmeticType.unitSkin &&
            c.acquisitionMethod == AcquisitionMethod.prestigeReward)
        .toList();
    final prestigeThemes = _userCosmetics
        .where((c) =>
            c.type == CosmeticType.uiTheme &&
            c.acquisitionMethod == AcquisitionMethod.prestigeReward)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('コスメティック設定')),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (prestigeSkins.isNotEmpty || prestigeThemes.isNotEmpty)
                _CosmeticsShowcaseSection(
                  progression: _userProgression!,
                  prestigeSkins: prestigeSkins,
                  prestigeThemes: prestigeThemes,
                  equippedUnitSkinId: _equippedCosmetics?.unitSkinId,
                  equippedUiThemeId: _equippedCosmetics?.uiThemeId,
                  onEquipUnitSkin: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.unitSkin),
                  onEquipUiTheme: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.uiTheme),
                ),
              const SizedBox(height: 24),
              if (unitSkins.isNotEmpty)
                _CosmeticCategorySection(
                  title: 'ユニットスキン',
                  cosmetics: unitSkins,
                  equippedId: _equippedCosmetics?.unitSkinId,
                  onEquip: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.unitSkin),
                  onUnequip: () =>
                      _unequipCosmetic(CosmeticType.unitSkin),
                )
              else
                const _NoCosmeticsCard(type: 'ユニットスキン'),
              const SizedBox(height: 24),
              if (uiThemes.isNotEmpty)
                _CosmeticCategorySection(
                  title: 'UIテーマ',
                  cosmetics: uiThemes,
                  equippedId: _equippedCosmetics?.uiThemeId,
                  onEquip: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.uiTheme),
                  onUnequip: () => _unequipCosmetic(CosmeticType.uiTheme),
                )
              else
                const _NoCosmeticsCard(type: 'UIテーマ'),
              const SizedBox(height: 24),
              if (_userProgression != null)
                _PrestigeCosmeticsSection(
                  progression: _userProgression!,
                  title: 'プレスティジユニットスキン',
                  prestigeCosmetics: prestigeSkins,
                  equippedId: _equippedCosmetics?.unitSkinId,
                  cosmeticType: CosmeticType.unitSkin,
                  onEquip: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.unitSkin),
                ),
              const SizedBox(height: 24),
              if (_userProgression != null)
                _PrestigeCosmeticsSection(
                  progression: _userProgression!,
                  title: 'プレスティジUIテーマ',
                  prestigeCosmetics: prestigeThemes,
                  equippedId: _equippedCosmetics?.uiThemeId,
                  cosmeticType: CosmeticType.uiTheme,
                  onEquip: (cosmeticId) =>
                      _equipCosmetic(cosmeticId, CosmeticType.uiTheme),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CosmeticCategorySection extends StatelessWidget {
  final String title;
  final List<Cosmetic> cosmetics;
  final String? equippedId;
  final Function(String) onEquip;
  final VoidCallback onUnequip;

  const _CosmeticCategorySection({
    required this.title,
    required this.cosmetics,
    required this.equippedId,
    required this.onEquip,
    required this.onUnequip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 12),
        if (equippedId != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B1A1A).withOpacity(0.2),
                border: Border.all(color: const Color(0xFFFFD700), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '装備中:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cosmetics
                                  .firstWhere(
                                    (c) => c.id == equippedId,
                                    orElse: () => Cosmetic(
                                      id: '',
                                      name: '不明',
                                      description: '',
                                      type: CosmeticType.unitSkin,
                                      acquisitionMethod:
                                          AcquisitionMethod.levelMilestone,
                                    ),
                                  )
                                  .name ??
                              'デフォルト',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: onUnequip,
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('外す'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Colors.red[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cosmetics.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final cosmetic = cosmetics[index];
            final isEquipped = equippedId == cosmetic.id;

            return _CosmeticEquipmentCard(
              cosmetic: cosmetic,
              isEquipped: isEquipped,
              onEquip: () => onEquip(cosmetic.id),
            );
          },
        ),
      ],
    );
  }
}

class _CosmeticEquipmentCard extends StatelessWidget {
  final Cosmetic cosmetic;
  final bool isEquipped;
  final VoidCallback onEquip;

  const _CosmeticEquipmentCard({
    required this.cosmetic,
    required this.isEquipped,
    required this.onEquip,
  });

  String _getAcquisitionMethodLabel(AcquisitionMethod method) {
    return switch (method) {
      AcquisitionMethod.levelMilestone => 'レベル報酬',
      AcquisitionMethod.achievement => 'アチーブメント',
      AcquisitionMethod.prestigeReward => 'プレスティジ報酬',
      AcquisitionMethod.battlePass => 'バトルパス',
      AcquisitionMethod.other => 'その他',
    };
  }

  Color _getAcquisitionMethodColor(AcquisitionMethod method) {
    return switch (method) {
      AcquisitionMethod.levelMilestone => Colors.cyan,
      AcquisitionMethod.achievement => Colors.purple,
      AcquisitionMethod.prestigeReward => Colors.amber,
      AcquisitionMethod.battlePass => Colors.blue,
      AcquisitionMethod.other => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final acquisitionLabel = _getAcquisitionMethodLabel(cosmetic.acquisitionMethod);
    final acquisitionColor = _getAcquisitionMethodColor(cosmetic.acquisitionMethod);

    return Card(
      color: isEquipped
          ? const Color(0xFF8B1A1A).withOpacity(0.3)
          : const Color(0xFF2A1A0A),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cosmetic.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isEquipped
                                    ? const Color(0xFFFFD700)
                                    : const Color(0xFFE8D5B0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: acquisitionColor.withOpacity(0.2),
                              border: Border.all(
                                color: acquisitionColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              acquisitionLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: acquisitionColor,
                              ),
                            ),
                          ),
                          if (isEquipped)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700)
                                    .withOpacity(0.2),
                                border: Border.all(
                                  color: const Color(0xFFFFD700),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '装備中',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cosmetic.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isEquipped ? null : onEquip,
                icon: Icon(isEquipped ? Icons.check : Icons.add),
                label: Text(isEquipped ? '装備中' : '装備する'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEquipped
                      ? Colors.grey[700]
                      : const Color(0xFF8B1A1A),
                  foregroundColor: isEquipped ? Colors.grey : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCosmeticsCard extends StatelessWidget {
  final String type;

  const _NoCosmeticsCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.lock,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(
              '$typeはまだ解放されていません',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE8D5B0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'レベルアップやプレスティジで解放されます',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CosmeticsShowcaseSection extends StatelessWidget {
  final UserProgression progression;
  final List<Cosmetic> prestigeSkins;
  final List<Cosmetic> prestigeThemes;
  final String? equippedUnitSkinId;
  final String? equippedUiThemeId;
  final Function(String) onEquipUnitSkin;
  final Function(String) onEquipUiTheme;

  const _CosmeticsShowcaseSection({
    required this.progression,
    required this.prestigeSkins,
    required this.prestigeThemes,
    required this.equippedUnitSkinId,
    required this.equippedUiThemeId,
    required this.onEquipUnitSkin,
    required this.onEquipUiTheme,
  });

  @override
  Widget build(BuildContext context) {
    Cosmetic? findEquipped(List<Cosmetic> cosmetics, String? equippedId) {
      if (equippedId == null) return null;
      try {
        return cosmetics.firstWhere((c) => c.id == equippedId);
      } catch (e) {
        return null;
      }
    }

    final equippedSkin = findEquipped(prestigeSkins, equippedUnitSkinId);
    final equippedTheme = findEquipped(prestigeThemes, equippedUiThemeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber.withOpacity(0.15),
                Colors.orange.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.amber.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'プレスティジコスメティック',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ランク: ${progression.prestigeRank.displayName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(progression.prestigeRank.color),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (equippedSkin != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ShowcaseItem(
                    label: '装備中のユニットスキン',
                    cosmetic: equippedSkin,
                    isEquipped: true,
                  ),
                ),
              if (equippedTheme != null)
                _ShowcaseItem(
                  label: '装備中のUIテーマ',
                  cosmetic: equippedTheme,
                  isEquipped: true,
                ),
              if (equippedSkin == null && equippedTheme == null)
                Center(
                  child: Text(
                    'プレスティジコスメティックがまだ装備されていません',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowcaseItem extends StatelessWidget {
  final String label;
  final Cosmetic cosmetic;
  final bool isEquipped;

  const _ShowcaseItem({
    required this.label,
    required this.cosmetic,
    required this.isEquipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(
          color: Colors.amber.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cosmetic.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cosmetic.description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PrestigeCosmeticsSection extends StatelessWidget {
  final UserProgression progression;
  final String title;
  final List<Cosmetic> prestigeCosmetics;
  final String? equippedId;
  final CosmeticType cosmeticType;
  final Function(String) onEquip;

  const _PrestigeCosmeticsSection({
    required this.progression,
    required this.title,
    required this.prestigeCosmetics,
    required this.equippedId,
    required this.cosmeticType,
    required this.onEquip,
  });

  String _getPrestigeTierName(String cosmeticId) {
    if (cosmeticId.contains('silver')) return 'シルバー';
    if (cosmeticId.contains('gold')) return 'ゴールド';
    if (cosmeticId.contains('platinum')) return 'プラチナ';
    if (cosmeticId.contains('diamond')) return 'ダイヤモンド';
    return '不明';
  }

  @override
  Widget build(BuildContext context) {
    if (prestigeCosmetics.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.star_outline,
                size: 48,
                color: Colors.amber[600],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE8D5B0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'プレスティジリセットを行うと解放されます',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '現在のプレスティジランク: ${progression.prestigeRank.displayName}',
            style: TextStyle(
              fontSize: 12,
              color: Color(progression.prestigeRank.color),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prestigeCosmetics.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final cosmetic = prestigeCosmetics[index];
            final isEquipped = equippedId == cosmetic.id;
            final tierName = _getPrestigeTierName(cosmetic.id);

            return _PrestigeCosmeticCard(
              cosmetic: cosmetic,
              tierName: tierName,
              isEquipped: isEquipped,
              onEquip: () => onEquip(cosmetic.id),
            );
          },
        ),
      ],
    );
  }
}

class _PrestigeCosmeticCard extends StatelessWidget {
  final Cosmetic cosmetic;
  final String tierName;
  final bool isEquipped;
  final VoidCallback onEquip;

  const _PrestigeCosmeticCard({
    required this.cosmetic,
    required this.tierName,
    required this.isEquipped,
    required this.onEquip,
  });

  Color _getTierColor(String tierName) {
    return switch (tierName) {
      'シルバー' => const Color(0xFFC0C0C0),
      'ゴールド' => const Color(0xFFFFD700),
      'プラチナ' => const Color(0xFFE5E4E2),
      'ダイヤモンド' => const Color(0xFF00D9FF),
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = _getTierColor(tierName);

    return Card(
      color: isEquipped
          ? const Color(0xFF8B1A1A).withOpacity(0.3)
          : const Color(0xFF2A1A0A),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cosmetic.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isEquipped
                                    ? const Color(0xFFFFD700)
                                    : tierColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tierColor.withOpacity(0.2),
                              border: Border.all(
                                color: tierColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tierName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: tierColor,
                              ),
                            ),
                          ),
                          if (isEquipped)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700)
                                    .withOpacity(0.2),
                                border: Border.all(
                                  color: const Color(0xFFFFD700),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '装備中',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cosmetic.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isEquipped ? null : onEquip,
                icon: Icon(isEquipped ? Icons.check : Icons.add),
                label: Text(isEquipped ? '装備中' : '装備する'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEquipped
                      ? Colors.grey[700]
                      : const Color(0xFF8B1A1A),
                  foregroundColor: isEquipped ? Colors.grey : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
