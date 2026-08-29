import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/battle_result_data.dart';
import '../../data/models/scenario_data.dart';
import '../../domain/state/battle_state.dart';
import '../../domain/scoring/score_calculator.dart';
import 'message_screen.dart';

class ResultScreenArgs {
  final Scenario scenario;
  final BattleStateData data;

  ResultScreenArgs({required this.scenario, required this.data});
}

class ResultScreen extends StatefulWidget {
  final ResultScreenArgs args;

  const ResultScreen({super.key, required this.args});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveBattleResult();
  }

  Future<void> _saveBattleResult() async {
    final data = widget.args.data;
    final resultData = BattleResultData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseService().userId ?? 'anonymous',
      scenarioId: widget.args.scenario,
      playedAt: DateTime.now(),
      duration: data.elapsedTime.toInt(),
      won: data.won,
      finalPlayerStrength: (100 * (1 - data.casualtyRate)).toInt(),
      finalEnemyStrength: 100,
      totalScore: data.totalScore,
      scoreBreakdown: ScoreBreakdown(
        victoryScore: data.scoreBreakdown.victoryScore,
        efficiencyScore: data.scoreBreakdown.efficiencyScore,
        commandScore: data.scoreBreakdown.commandScore,
        turningPointScore: data.scoreBreakdown.turningPointScore,
        historyBonus: data.scoreBreakdown.historyBonus,
      ),
      achievedTurningPoints: data.tpAchievements
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => 'tp_${e.key}')
          .toList(),
      commands: [],
      messageId: null,
    );

    await FirebaseService().saveBattleResult(resultData);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.args.data;

    return Scaffold(
      appBar: AppBar(title: const Text('戦闘結果')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ResultHeader(won: data.won),
            const SizedBox(height: 24),
            _ScoreCard(breakdown: data.scoreBreakdown),
            const SizedBox(height: 16),
            _TurningPointCard(
              achievements: data.tpAchievements,
              scenario: widget.args.scenario,
            ),
            const SizedBox(height: 24),
            _ActionButtons(args: widget.args),
          ],
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final bool won;

  const _ResultHeader({required this.won});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: won
            ? const Color(0xFF1A3A1A)
            : const Color(0xFF3A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: won ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            won ? '勝利！' : '敗北',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: won ? Colors.green : Colors.red,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            won ? '見事な采配であった' : '次は必ず雪辱を晴らせ',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final ScoreBreakdownResult breakdown;

  const _ScoreCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '総スコア',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                Text(
                  '${breakdown.total.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  )}点',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF8B6914)),
            _ScoreLine('勝敗スコア', breakdown.victoryScore, 40000),
            _ScoreLine('効率スコア', breakdown.efficiencyScore, 20000),
            _ScoreLine('采配スコア', breakdown.commandScore, 15000),
            _ScoreLine('TP ボーナス', breakdown.turningPointScore, 15000),
            _ScoreLine('歴史ボーナス', breakdown.historyBonus, 10000),
          ],
        ),
      ),
    );
  }
}

class _ScoreLine extends StatelessWidget {
  final String label;
  final int score;
  final int maxScore;

  const _ScoreLine(this.label, this.score, this.maxScore);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Text(
            '$score pt',
            style: const TextStyle(color: Color(0xFFFFD700), fontSize: 13),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value: score / maxScore,
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: AlwaysStoppedAnimation(
                score > maxScore * 0.7
                    ? Colors.green
                    : score > maxScore * 0.4
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurningPointCard extends StatelessWidget {
  final List<bool> achievements;
  final Scenario scenario;

  const _TurningPointCard({
    required this.achievements,
    required this.scenario,
  });

  static const _tpNames = {
    Scenario.odigahara: ['敵到着前に奇襲', '嵐の中での戦闘', '敵将兵力低下', '敵将討死'],
    Scenario.nagashino: ['初期陣形を防御に設定', '敵騎馬隊の突撃を耐える', '一斉反撃', '敵将討死'],
    Scenario.honnoJi: ['敵の包囲を突破', '援軍到着まで生存', '援軍到着後の反撃', '敵総大将討死'],
    Scenario.sekigahara: ['序盤は慎重に', '味方のモラル維持', '側面を奇襲', '敵将討死', '豊臣武将生存'],
    Scenario.kawanakajima: ['夜明けの奇襲に備える', '別働隊到着まで凌ぐ', '挟撃を成功させる', '敵将討死'],
  };

  @override
  Widget build(BuildContext context) {
    final names = _tpNames[scenario] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ターニングポイント',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(achievements.length, (i) {
              final achieved = achievements[i];
              final name = i < names.length ? names[i] : 'TP${i + 1}';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      achieved ? Icons.check_circle : Icons.cancel,
                      color: achieved ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: TextStyle(
                        color: achieved
                            ? const Color(0xFFE8D5B0)
                            : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ResultScreenArgs args;

  const _ActionButtons({required this.args});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(
            context,
            '/message',
            arguments: MessageScreenArgs(
              scenario: args.scenario,
              won: args.data.won,
              allTpAchieved: args.data.tpAchievements.every((a) => a),
            ),
          ),
          icon: const Icon(Icons.history_edu),
          label: const Text('歴史分析を見る'),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/ranking'),
          icon: const Icon(Icons.leaderboard),
          label: const Text('ランキングを見る'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.popUntil(
              context, ModalRoute.withName('/home')),
          icon: const Icon(Icons.home, color: Color(0xFFFFD700)),
          label: const Text(
            'ホームへ戻る',
            style: TextStyle(color: Color(0xFFFFD700)),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFFD700)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
