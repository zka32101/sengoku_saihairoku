import 'dart:convert';
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

  static void _showPerspectiveSelector(
    BuildContext context,
    Scenario scenario,
  ) {
    showDialog(
      context: context,
      builder: (context) => _PerspectiveSelectionDialog(scenario: scenario),
    );
  }

  static const _scenarios = [
    _ScenarioEntry(Scenario.odigahara, '桶狭間の戦', 1560, 1, '3〜5分', '3,500 vs 15,000 — 圧倒的劣勢を奇策で覆せ', true),
    _ScenarioEntry(Scenario.nagashino, '長篠の戦', 1575, 2, '4〜6分', '防衛陣形で武田騎馬隊を迎え撃て', true),
    _ScenarioEntry(Scenario.honnoJi, '本能寺の変', 1582, 3, '5〜7分', '500 vs 13,000 — 絶望的状況からの逆転', true),
    _ScenarioEntry(Scenario.sekigahara, '関ヶ原の戦', 1600, 4, '6〜8分', '天下分け目 — 複雑な戦局を制せよ', true),
    _ScenarioEntry(Scenario.kawanakajima, '川中島の戦', 1561, 3, '4〜6分', '夜明けの奇襲を受けた本隊のみで、別働隊到着まで持ちこたえよ', true),
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
            onTap: () => _showPerspectiveSelector(context, s.scenario),
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

class _PerspectiveSelectionDialog extends StatefulWidget {
  final Scenario scenario;

  const _PerspectiveSelectionDialog({required this.scenario});

  @override
  State<_PerspectiveSelectionDialog> createState() =>
      _PerspectiveSelectionDialogState();
}

class _PerspectiveSelectionDialogState
    extends State<_PerspectiveSelectionDialog> {
  ScenarioData? _scenarioData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadScenario();
  }

  Future<void> _loadScenario() async {
    try {
      final scenarioJson = await DefaultAssetBundle.of(context)
          .loadString('assets/data/scenarios.json');
      final Map<String, dynamic> scenarios =
          jsonDecode(scenarioJson) as Map<String, dynamic>;
      final scenarioKey = widget.scenario.name;
      if (scenarios.containsKey(scenarioKey)) {
        final data =
            ScenarioData.fromJson(scenarios[scenarioKey] as Map<String, dynamic>);
        if (mounted) {
          setState(() {
            _scenarioData = data;
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('シナリオを読み込み中...'),
            ],
          ),
        ),
      );
    }

    if (_scenarioData == null || _scenarioData!.alternativePerspective == null) {
      // No alternative perspective, go straight to battle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BattleScreen(scenario: widget.scenario),
          ),
        );
      });
      return const SizedBox.shrink();
    }

    final mainPerspective = _scenarioData!;
    final altPerspective = _scenarioData!.alternativePerspective!;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '視点を選ぶ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 24),
            _PerspectiveOption(
              title: mainPerspective.displayName,
              description: mainPerspective.description,
              difficulty: mainPerspective.difficulty,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BattleScreen(scenario: widget.scenario),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF8B6914)),
            const SizedBox(height: 16),
            _PerspectiveOption(
              title: altPerspective.displayName,
              description: altPerspective.description,
              difficulty: altPerspective.difficulty,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BattleScreen(
                      scenario: widget.scenario,
                      alternativePerspectiveId: altPerspective.id,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerspectiveOption extends StatelessWidget {
  final String title;
  final String description;
  final int difficulty;
  final VoidCallback onTap;

  const _PerspectiveOption({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF8B6914)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFE8D5B0),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(4, (i) {
                return Icon(
                  i < difficulty ? Icons.star : Icons.star_border,
                  size: 14,
                  color: const Color(0xFFFFD700),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
