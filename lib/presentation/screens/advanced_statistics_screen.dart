import 'package:flutter/material.dart';
import '../../data/models/advanced_statistics.dart';
import '../../data/services/statistics_service.dart';
import '../widgets/advanced_statistics_display.dart';

/// 高度な統計分析画面
class AdvancedStatisticsScreen extends StatefulWidget {
  const AdvancedStatisticsScreen({super.key});

  @override
  State<AdvancedStatisticsScreen> createState() =>
      _AdvancedStatisticsScreenState();
}

class _AdvancedStatisticsScreenState extends State<AdvancedStatisticsScreen> {
  final _statisticsService = StatisticsService();
  late Future<AdvancedStatisticsSummary> _statistics;
  int _selectedTab = 0; // 0=概要, 1=シナリオ, 2=難易度, 3=ランキング

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  void _loadStatistics() {
    _statistics = _statisticsService.calculateAdvancedStatistics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('詳細統計'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
          ),
        ],
      ),
      body: FutureBuilder<AdvancedStatisticsSummary>(
        future: _statistics,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // タブナビゲーション
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _TabButton(
                        label: '概要',
                        selected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      _TabButton(
                        label: 'シナリオ',
                        selected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      _TabButton(
                        label: '難易度',
                        selected: _selectedTab == 2,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                      _TabButton(
                        label: 'ランキング',
                        selected: _selectedTab == 3,
                        onTap: () => setState(() => _selectedTab = 3),
                      ),
                    ],
                  ),
                ),
              ),

              // コンテンツ
              if (_selectedTab == 0)
                SliverToBoxAdapter(
                  child: _buildOverviewTab(summary),
                )
              else if (_selectedTab == 1)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final scenario = summary.scenarioRanking[index];
                      return ScenarioPerformanceCard(
                        performance: scenario,
                      );
                    },
                    childCount: summary.scenarioRanking.length,
                  ),
                )
              else if (_selectedTab == 2)
                SliverToBoxAdapter(
                  child: DifficultyComparisonCard(
                    difficultyStats: summary.difficultyStats,
                  ),
                )
              else if (_selectedTab == 3)
                SliverToBoxAdapter(
                  child: ScenarioRankingCard(
                    ranking: summary.scenarioRanking,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(AdvancedStatisticsSummary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 全体統計カード
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${summary.totalBattles}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '総バトル数',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _OverviewStatTile(
                        label: '勝率',
                        value:
                            '${(summary.overallWinRate * 100).toStringAsFixed(1)}%',
                        color: Colors.blue,
                      ),
                      _OverviewStatTile(
                        label: '勝利',
                        value: '${summary.totalVictories}',
                        color: Colors.green,
                      ),
                      _OverviewStatTile(
                        label: '敗北',
                        value: '${summary.totalDefeats}',
                        color: Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _OverviewStatTile(
                        label: '最高スコア',
                        value: '${summary.highestScore}',
                        color: Colors.amber,
                      ),
                      _OverviewStatTile(
                        label: '平均スコア',
                        value: '${summary.averageScore}',
                        color: Colors.amber,
                      ),
                      _OverviewStatTile(
                        label: 'プレイ時間',
                        value: summary.playTimeFormatted,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // トレンド情報
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'パフォーマンストレンド',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getTrendColor(summary.performanceTrend.trend)[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTrendLabel(summary.performanceTrend.trend),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    _getTrendColor(summary.performanceTrend.trend),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '勝率: ${(summary.performanceTrend.winRateChange * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'スコア: ${summary.performanceTrend.scoreChange.toStringAsFixed(0)}pt',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        _getTrendIcon(summary.performanceTrend.trend),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 難易度制覇状況
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'シナリオ制覇状況',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final entry in summary.difficultyStats.stats.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.value.difficulty.displayName),
                          Text(
                            '${entry.value.scenariosCleared}/5',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTrendLabel(String trend) {
    switch (trend) {
      case 'improving':
        return '📈 上昇傾向';
      case 'declining':
        return '📉 低下傾向';
      default:
        return '→ 安定傾向';
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving':
        return Colors.green;
      case 'declining':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving':
        return const Icon(
          Icons.trending_up,
          color: Colors.green,
          size: 32,
        );
      case 'declining':
        return const Icon(
          Icons.trending_down,
          color: Colors.red,
          size: 32,
        );
      default:
        return const Icon(
          Icons.trending_flat,
          color: Colors.blue,
          size: 32,
        );
    }
  }
}

/// タブボタン
class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 概要統計タイル
class _OverviewStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _OverviewStatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
