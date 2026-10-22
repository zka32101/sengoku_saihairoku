import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/repositories/progression_repository.dart';
import '../../l10n/generated/app_localizations.dart';
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
      debugPrint('Error loading statistics: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.statisticsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statisticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: l10n.statisticsDetailTooltip,
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

    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statisticsXpSummaryTitle,
              style: const TextStyle(
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
                  label: l10n.statisticsXpGainedLabel,
                  value: totalXpGained.toString(),
                  color: Colors.amber,
                ),
                _StatTile(
                  label: l10n.statisticsBattleCountLabel,
                  value: battleCount.toString(),
                  color: Colors.blue,
                ),
                _StatTile(
                  label: l10n.statisticsAverageXpLabel,
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
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.5)),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statisticsXpHistoryTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 12),
            if (xpHistory.isEmpty)
              Center(
                child: Text(
                  l10n.statisticsXpHistoryEmpty,
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
                                      _getSourceLabel(l10n, source),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE8D5B0),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (timestamp != null)
                                      Text(
                                        _formatTimestamp(l10n, timestamp),
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

  String _getSourceLabel(AppLocalizations l10n, String source) {
    return switch (source) {
      'battle' => l10n.statisticsSourceBattle,
      'challenge' => l10n.statisticsSourceChallenge,
      'achievement' => l10n.statisticsSourceAchievement,
      'battle_xp_boost_ad' => l10n.statisticsSourceBattleXpBoost,
      _ => source,
    };
  }

  String _formatTimestamp(AppLocalizations l10n, String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return l10n.statisticsTimeJustNow;
      } else if (difference.inHours < 1) {
        return l10n.statisticsTimeMinutesAgo(difference.inMinutes);
      } else if (difference.inDays < 1) {
        return l10n.statisticsTimeHoursAgo(difference.inHours);
      } else if (difference.inDays < 30) {
        return l10n.statisticsTimeDaysAgo(difference.inDays);
      } else {
        return l10n.statisticsTimeMonthDay(dateTime.month, dateTime.day);
      }
    } catch (e) {
      return timestamp;
    }
  }
}
