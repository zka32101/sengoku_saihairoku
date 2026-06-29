import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import 'battle_screen.dart';

class _ScenarioEntry {
  final Scenario scenario;
  final String name;
  final int year;
  final int difficulty;
  final String playTime;
  final String description;
  final bool isUnlocked;

  const _ScenarioEntry(this.scenario, this.name, this.year, this.difficulty,
      this.playTime, this.description, this.isUnlocked);
}

class ScenarioSelectScreen extends StatelessWidget {
  const ScenarioSelectScreen({super.key});

  static const _scenarios = [
    _ScenarioEntry(Scenario.odigahara, '桶狭間の戦', 1560, 1, '3〜5分', '2,000 vs 15,000 — 圧倒的劣勢を奇策で覆せ', true),
    _ScenarioEntry(Scenario.nagashino, '長篠の戦', 1575, 2, '4〜6分', '防衛陣形で武田騎馬隊を迎え撃て', true),
    _ScenarioEntry(Scenario.honnoJi, '本能寺の変', 1582, 3, '5〜7分', '500 vs 13,000 — 絶望的状況からの逆転', true),
    _ScenarioEntry(Scenario.sekigahara, '関ヶ原の戦', 1600, 4, '6〜8分', '天下分け目 — 複雑な戦局を制せよ', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('シナリオを選ぶ')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _scenarios.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final s = _scenarios[index];
          return _ScenarioCard(
            name: s.name,
            year: s.year,
            difficulty: s.difficulty,
            playTime: s.playTime,
            description: s.description,
            isUnlocked: s.isUnlocked,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BattleScreen(scenario: s.scenario),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final String name;
  final int year;
  final int difficulty;
  final String playTime;
  final String description;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _ScenarioCard({
    required this.name,
    required this.year,
    required this.difficulty,
    required this.playTime,
    required this.description,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                        Text(
                          '$year年',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isUnlocked)
                    const Icon(Icons.lock, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              _DifficultyStars(difficulty: difficulty),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Color(0xFFE8D5B0), fontSize: 13),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    playTime,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              if (isUnlocked) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    child: const Text('出陣'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyStars extends StatelessWidget {
  final int difficulty;

  const _DifficultyStars({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        return Icon(
          i < difficulty ? Icons.star : Icons.star_border,
          size: 16,
          color: const Color(0xFFFFD700),
        );
      }),
    );
  }
}
