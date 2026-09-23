import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/repositories/progression_repository.dart';
import '../widgets/screen_transition.dart';
import 'advanced_statistics_screen.dart';

/// ユーザーの統計情報画面
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late ProgressionRepository _progressionRepo;
  List<Map<String, dynamic>> _xpHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _progressionRepo = ProgressionRepository();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final xpHistory = await _progressionRepo.getXpHistory(userId, limit: 30);

      setState(() {
        _xpHistory = xpHistory.map((record) => record.toJson()).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading statistics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('統計')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('統計'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: '詳細統計（シナリオ別・トレンド）',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdvancedStatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _XpStatsSummaryCard(xpHistory: _xpHistory),
              const SizedBox(height: 16),
              _XpHistoryCard(xpHistory: _xpHistory),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _XpStatsSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> xpHistory;

  const _XpStatsSummaryCard({required this.xpHistory});

  @override
  Widget build(BuildContext context) {
    int totalXpGained = 0;
    int battleCount = 0;
    int averageXpPerBattle = 0;

    for (final record in xpHistory) {
      totalXpGained += (record['xpGained'] as int?) ?? 0;
      if ((record['source'] as String?) == 'battle') {
        battleCount++;
      }
    }

    if (battleCount > 0) {
      averageXpPerBattle = totalXpGained ~/ battleCount;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'XP統計',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatTile(
                  label: '獲得XP',
                  value: totalXpGained.toString(),
                  color: Colors.amber,
                ),
                _StatTile(
                  label: '戦闘数',
                  value: battleCount.toString(),
                  color: Colors.blue,
                ),
                _StatTile(
                  label: '平均XP',
                  value: averageXpPerBattle.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XpHistoryCard extends StatelessWidget {
  final List<Map<String, dynamic>> xpHistory;

  const _XpHistoryCard({required this.xpHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'XP獲得履歴',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            if (xpHistory.isEmpty)
              Center(
                child: Text(
                  'XP獲得履歴がまだありません',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              Column(
                children: List.generate(
                  xpHistory.length,
                  (index) {
                    final record = xpHistory[index];
                    final xpGained = record['xpGained'] as int? ?? 0;
                    final source = record['source'] as String? ?? 'unknown';
                    final timestamp = record['timestamp'] as String?;

                    return Column(
                      children: [
                        if (index > 0) const Divider(color: Color(0xFF8B6914)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getSourceLabel(source),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE8D5B0),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (timestamp != null)
                                      Text(
                                        _formatTimestamp(timestamp),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '+$xpGained',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getSourceLabel(String source) {
    return switch (source) {
      'battle' => '戦闘',
      'challenge' => 'チャレンジ',
      'achievement' => '実績',
      _ => source,
    };
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'たった今';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}分前';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}時間前';
      } else if (difference.inDays < 30) {
        return '${difference.inDays}日前';
      } else {
        return '${dateTime.month}月${dateTime.day}日';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
