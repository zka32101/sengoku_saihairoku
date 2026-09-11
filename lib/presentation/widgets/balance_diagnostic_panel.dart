import 'package:flutter/material.dart';
import '../../data/models/balance_metrics.dart';
import '../../data/repositories/balance_metrics_repository.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// バランス診断パネル（デバッグ/管理者向け）
class BalanceDiagnosticPanel extends StatefulWidget {
  final Scenario scenario;
  final DifficultyMode difficulty;

  const BalanceDiagnosticPanel({
    super.key,
    required this.scenario,
    required this.difficulty,
  });

  @override
  State<BalanceDiagnosticPanel> createState() => _BalanceDiagnosticPanelState();
}

class _BalanceDiagnosticPanelState extends State<BalanceDiagnosticPanel> {
  final _balanceRepo = BalanceMetricsRepository();
  late Future<BalanceMetrics?> _metricsFuture;

  @override
  void initState() {
    super.initState();
    _metricsFuture = _balanceRepo.getMetrics(widget.scenario, widget.difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BalanceMetrics?>(
      future: _metricsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('バランスデータが利用できません'),
          );
        }

        final metrics = snapshot.data!;
        final diagnosis = metrics.getDiagnosis();
        final adjustment = metrics.getAutoAdjustment();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // メトリクス概要
              _MetricsOverviewCard(metrics: metrics),
              const SizedBox(height: 16),

              // 診断結果
              _DiagnosisCard(diagnosis: diagnosis),
              const SizedBox(height: 16),

              // 自動調整提案
              _AdjustmentCard(adjustment: adjustment),
              const SizedBox(height: 16),

              // レポート生成ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showReport(context),
                  child: const Text('バランスレポートを表示'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showReport(BuildContext context) async {
    final report = await _balanceRepo.generateBalanceReport();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ゲームバランスレポート'),
        content: SingleChildScrollView(
          child: Text(report, style: const TextStyle(fontFamily: 'monospace')),
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
}

/// メトリクス概要カード
class _MetricsOverviewCard extends StatelessWidget {
  final BalanceMetrics metrics;

  const _MetricsOverviewCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'メトリクス概要',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _MetricRow(
              label: '勝率',
              value: '${(metrics.playerWinRate*100).toStringAsFixed(1)}%',
              color: _getWinRateColor(metrics.playerWinRate),
            ),
            const SizedBox(height: 8),
            _MetricRow(
              label: '平均戦闘時間',
              value: '${(metrics.avgBattleDuration/60).toStringAsFixed(1)}分',
            ),
            const SizedBox(height: 8),
            _MetricRow(
              label: 'TP達成率',
              value: '${(metrics.tpAchievementRate*100).toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 8),
            _MetricRow(
              label: '味方損耗率',
              value: '${(metrics.playerDeathRatio*100).toStringAsFixed(1)}%',
              color: _getDamageColor(metrics.playerDeathRatio),
            ),
            const SizedBox(height: 8),
            _MetricRow(
              label: '敵損耗率',
              value: '${(metrics.enemyDeathRatio*100).toStringAsFixed(1)}%',
              color: Colors.blue[300],
            ),
            const SizedBox(height: 8),
            Text(
              'サンプル: ${metrics.totalBattles}戦',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color? _getWinRateColor(double winRate) {
    if (winRate < 0.35) return Colors.red[300];
    if (winRate < 0.45) return Colors.orange[300];
    if (winRate > 0.65) return Colors.red[300];
    if (winRate > 0.55) return Colors.orange[300];
    return Colors.green[300];
  }

  Color? _getDamageColor(double ratio) {
    if (ratio > 0.75) return Colors.red[300];
    if (ratio > 0.60) return Colors.orange[300];
    return Colors.green[300];
  }
}

/// 診断結果カード
class _DiagnosisCard extends StatelessWidget {
  final BalanceDiagnosis diagnosis;

  const _DiagnosisCard({required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '診断結果',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (!diagnosis.isValid)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'サンプル数が不足しています（${diagnosis.totalBattles}/10）',
                  style: const TextStyle(color: Colors.orange),
                ),
              )
            else ...[
              for (final diag in diagnosis.diagnostics) ...[
                Row(
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(diag)),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ],
            if (diagnosis.recommendations.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                '推奨される調整',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              for (final rec in diagnosis.recommendations) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Text('→ ', style: TextStyle(color: Colors.blue)),
                      Expanded(child: Text(rec, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// 自動調整提案カード
class _AdjustmentCard extends StatelessWidget {
  final DifficultyAdjustment adjustment;

  const _AdjustmentCard({required this.adjustment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '自動調整提案',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              adjustment.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (adjustment.hasSignificantAdjustment) ...[
              const SizedBox(height: 12),
              _AdjustmentBar(
                label: '味方兵力',
                adjustment: adjustment.playerStrengthAdjustment,
              ),
              const SizedBox(height: 8),
              _AdjustmentBar(
                label: '敵兵力',
                adjustment: adjustment.enemyStrengthAdjustment,
              ),
              const SizedBox(height: 12),
              Text(
                '推奨戦闘時間: ${(adjustment.targetDuration / 60).toStringAsFixed(1)}分',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 調整バー
class _AdjustmentBar extends StatelessWidget {
  final String label;
  final double adjustment;

  const _AdjustmentBar({
    required this.label,
    required this.adjustment,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (adjustment * 100).toStringAsFixed(1);
    final color = adjustment > 0 ? Colors.red[300] : Colors.green[300];

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (adjustment + 0.15) / 0.30, // -15% ～ +15% を 0.0 ～ 1.0 にマップ
              minHeight: 20,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            adjustment > 0 ? '+$percentage%' : '$percentage%',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// メトリクスの行表示
class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _MetricRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color?.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: color ?? Colors.grey,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
