import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/cosmetic.dart';
import '../../data/repositories/reward_repository.dart';
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
  List<Cosmetic> _userCosmetics = [];
  EquippedCosmetics? _equippedCosmetics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _rewardRepo = RewardRepository();
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

      setState(() {
        _userCosmetics = cosmetics;
        _equippedCosmetics = equipped;
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

    return Scaffold(
      appBar: AppBar(title: const Text('コスメティック設定')),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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

  @override
  Widget build(BuildContext context) {
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
