import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/warlord_data.dart';
import '../../data/repositories/warlord_repository.dart';
import '../../data/repositories/warlord_collection_repository.dart';
import '../../data/repositories/currency_repository.dart';

/// 武将図鑑（コレクション）画面
class WarlordCollectionScreen extends StatefulWidget {
  const WarlordCollectionScreen({super.key});

  @override
  State<WarlordCollectionScreen> createState() =>
      _WarlordCollectionScreenState();
}

class _WarlordCollectionScreenState extends State<WarlordCollectionScreen> {
  final _warlordRepo = WarlordRepository();
  final _collectionRepo = WarlordCollectionRepository();
  final _currencyRepo = CurrencyRepository();

  List<Warlord> _allWarlords = [];
  Set<String> _unlockedIds = {};
  int _gold = 0;
  bool _loading = true;
  bool _drawing = false;
  String? _factionFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final userId = FirebaseService().userId;
    final warlords = await _warlordRepo.getAllWarlords();
    final unlocked = userId != null
        ? await _collectionRepo.getUnlockedWarlordIds(userId)
        : <String>{};
    final wallet =
        userId != null ? await _currencyRepo.getWallet(userId) : null;

    if (!mounted) return;
    setState(() {
      _allWarlords = warlords;
      _unlockedIds = unlocked;
      _gold = wallet?.gold ?? 0;
      _loading = false;
    });
  }

  Future<void> _drawGacha() async {
    final userId = FirebaseService().userId;
    if (userId == null || _drawing) return;

    if (_unlockedIds.length >= _allWarlords.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('すべての武将を解放済みです')),
      );
      return;
    }

    setState(() => _drawing = true);

    final spent = await _currencyRepo.spendGold(
      userId,
      WarlordCollectionRepository.gachaCost,
      source: 'warlord_gacha',
    );

    if (!spent) {
      if (mounted) {
        setState(() => _drawing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ゴールドが不足しています')),
        );
      }
      return;
    }

    final drawnId = _collectionRepo.drawRandom(
      _allWarlords.map((w) => w.id).toList(),
      _unlockedIds,
    );

    if (drawnId != null) {
      await _collectionRepo.unlockWarlord(userId, drawnId);
    }

    await _load();
    if (!mounted) return;
    setState(() => _drawing = false);

    if (drawnId != null) {
      final warlord = _allWarlords.firstWhere((w) => w.id == drawnId);
      _showUnlockDialog(warlord);
    }
  }

  void _showUnlockDialog(Warlord warlord) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('武将を発見！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              warlord.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(warlord.faction),
            const SizedBox(height: 12),
            _StatRow(label: '統率', value: warlord.leadership),
            _StatRow(label: '武勇', value: warlord.valor),
            _StatRow(label: '知略', value: warlord.intelligence),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final factions =
        _allWarlords.map((w) => w.faction).toSet().toList()..sort();
    final filtered = _factionFilter == null
        ? _allWarlords
        : _allWarlords.where((w) => w.faction == _factionFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('武将図鑑'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        '${_unlockedIds.length} / ${_allWarlords.length} 解放済み',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(Icons.monetization_on,
                          color: const Color(0xFFFFD700), size: 18),
                      const SizedBox(width: 4),
                      Text('$_gold'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _drawing ? null : _drawGacha,
                      icon: const Icon(Icons.casino),
                      label: Text(
                        _drawing
                            ? '発掘中...'
                            : '武将を発掘する（${WarlordCollectionRepository.gachaCost}ゴールド）',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('すべて'),
                        selected: _factionFilter == null,
                        onSelected: (_) =>
                            setState(() => _factionFilter = null),
                      ),
                      const SizedBox(width: 8),
                      ...factions.map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: _factionFilter == f,
                              onSelected: (_) =>
                                  setState(() => _factionFilter = f),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final warlord = filtered[index];
                      final unlocked = _unlockedIds.contains(warlord.id);
                      return _WarlordCard(
                          warlord: warlord, unlocked: unlocked);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final int value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _WarlordCard extends StatelessWidget {
  final Warlord warlord;
  final bool unlocked;

  const _WarlordCard({required this.warlord, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: unlocked ? null : Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              unlocked ? Icons.person : Icons.person_outline,
              size: 36,
              color: unlocked ? const Color(0xFFFFD700) : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              unlocked ? warlord.name : '???',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: unlocked ? null : Colors.grey[600],
              ),
            ),
            Text(
              unlocked ? warlord.faction : '未発掘',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const Spacer(),
            if (unlocked)
              Text(
                '総合力 ${warlord.totalStat}',
                style: const TextStyle(fontSize: 11),
              ),
          ],
        ),
      ),
    );
  }
}
