import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/warlord_data.dart';
import '../../data/repositories/warlord_repository.dart';
import '../../data/repositories/warlord_collection_repository.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/warlord_progress_repository.dart';
import '../../domain/achievement_checking/achievement_checker.dart';
import '../../domain/achievement_checking/achievement_notification_service.dart';

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
  final _achievementChecker = AchievementChecker();
  final _achievementNotificationService = AchievementNotificationService();

  List<Warlord> _allWarlords = [];
  Set<String> _unlockedIds = {};
  Map<String, int> _warlordExp = {};
  int _gold = 0;
  bool _loading = true;
  bool _drawing = false;
  String? _factionFilter;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _achievementNotificationService.initialize(context);
    });
  }

  Future<void> _load() async {
    final userId = FirebaseService().userId;
    final warlords = await _warlordRepo.getAllWarlords();
    final unlocked = userId != null
        ? await _collectionRepo.getUnlockedWarlordIds(userId)
        : <String>{};
    final wallet =
        userId != null ? await _currencyRepo.getWallet(userId) : null;
    final exp = userId != null
        ? await WarlordProgressRepository().getAllExp(userId)
        : <String, int>{};

    if (!mounted) return;
    setState(() {
      _allWarlords = warlords;
      _unlockedIds = unlocked;
      _gold = wallet?.gold ?? 0;
      _warlordExp = exp;
      _loading = false;
    });
  }

  /// ステータスの傾向から武将の「型」を簡易的に表すフレーバーラベルを生成する。
  /// 個別の史実テキストは持たせず、統率・武勇・知略の相対的な高さから
  /// 動的に導くことで、102名全員分を手作業で書かずに図鑑を拡充する。
  String _archetypeFor(Warlord warlord) {
    final stats = {
      '采配の名手': warlord.leadership,
      '猛将': warlord.valor,
      '智将': warlord.intelligence,
    };
    final maxEntry =
        stats.entries.reduce((a, b) => a.value >= b.value ? a : b);
    if (warlord.totalStat >= 260) return '伝説の$maxEntry.key';
    return maxEntry.key;
  }

  void _showDetailDialog(Warlord warlord) {
    final exp = _warlordExp[warlord.id] ?? 0;
    final progressRepo = WarlordProgressRepository();
    final level = progressRepo.levelForExp(exp);
    final awakened = progressRepo.isAwakened(level);
    final expInLevel = exp % WarlordProgressRepository.expPerLevel;
    final expProgress = awakened
        ? 1.0
        : expInLevel / WarlordProgressRepository.expPerLevel;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(warlord.name)),
            if (awakened)
              const Icon(Icons.auto_awesome, color: Color(0xFFFFD700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                warlord.portraitAsset,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(warlord.faction),
            const SizedBox(height: 4),
            Text(
              _archetypeFor(warlord),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 12),
            _StatRow(label: '統率', value: warlord.leadership),
            _StatRow(label: '武勇', value: warlord.valor),
            _StatRow(label: '知略', value: warlord.intelligence),
            const SizedBox(height: 12),
            Text(awakened ? '覚醒済み（Lv.${WarlordProgressRepository.maxLevel}）' : 'Lv.$level'),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: expProgress,
                minHeight: 8,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '出陣させて勝利するとEXPを獲得します',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
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
      await _checkCollectionAchievements(userId);
    }
  }

  Future<void> _checkCollectionAchievements(String userId) async {
    try {
      final unlockedAchievements =
          await _achievementChecker.checkWarlordCollectionAchievements(
        userId: userId,
        totalWarlordsUnlocked: _unlockedIds.length,
      );

      if (unlockedAchievements.isNotEmpty && mounted) {
        for (final achievement in unlockedAchievements) {
          await _achievementNotificationService
              .showAchievementUnlockNotification(achievement);
        }
      }
    } catch (e) {
      print('Error checking warlord collection achievements: $e');
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
                        warlord: warlord,
                        unlocked: unlocked,
                        onTap: unlocked
                            ? () => _showDetailDialog(warlord)
                            : null,
                      );
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
  final VoidCallback? onTap;

  const _WarlordCard({
    required this.warlord,
    required this.unlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: unlocked ? null : Colors.grey[850],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: unlocked
              ? null
              : const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/warlord_locked.png'),
                    fit: BoxFit.cover,
                    opacity: 0.35,
                  ),
                ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              unlocked
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        warlord.portraitAsset,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person_outline,
                      size: 36,
                      color: Colors.grey[600],
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
        ),
      ),
    );
  }
}
