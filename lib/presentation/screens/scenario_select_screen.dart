import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../widgets/help_modal.dart';
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

  static void _showScenarioSettings(
    BuildContext context,
    Scenario scenario,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ScenarioSettingsDialog(scenario: scenario),
    );
  }

  static const _scenarios = [
    _ScenarioEntry(Scenario.odigahara, '桶狭間の戦', 1560, 1, '3〜5分', '3,500 vs 15,000 — 圧倒的劣勢を奇策で覆せ', true),
    _ScenarioEntry(Scenario.nagashino, '長篠の戦', 1575, 2, '4〜6分', '防衛陣形で武田騎馬隊を迎え撃て', true),
    _ScenarioEntry(Scenario.honnoJi, '本能寺の変', 1582, 3, '5〜7分', '500 vs 13,000 — 絶望的状況からの逆転', true),
    _ScenarioEntry(Scenario.sekigahara, '関ヶ原の戦', 1600, 4, '6〜8分', '天下分け目 — 複雑な戦局を制せよ', true),
    _ScenarioEntry(Scenario.kawanakajima, '川中島の戦', 1561, 3, '4〜6分', '夜明けの奇襲を受けた本隊のみで、別働隊到着まで持ちこたえよ', true),
    _ScenarioEntry(Scenario.itsukushima, '厳島の戦', 1555, 3, '4〜5分', '4,000 vs 15,000 — 暴風雨に乗じた奇襲で殲滅せよ', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('シナリオを選ぶ'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const HelpModal(
                  initialTab: 'tutorial',
                ),
              );
            },
            icon: const Icon(Icons.help_outline),
            tooltip: 'ヘルプ',
          ),
        ],
      ),
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
            onTap: () => _showScenarioSettings(context, s.scenario),
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

class _ScenarioSettingsDialog extends StatefulWidget {
  final Scenario scenario;

  const _ScenarioSettingsDialog({required this.scenario});

  @override
  State<_ScenarioSettingsDialog> createState() =>
      _ScenarioSettingsDialogState();
}

class _ScenarioSettingsDialogState extends State<_ScenarioSettingsDialog> {
  ScenarioData? _scenarioData;
  String? _selectedPerspectiveId;
  DifficultyMode _selectedDifficulty = DifficultyMode.normal;
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
            _selectedPerspectiveId = null; // Main perspective
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

  void _startBattle() {
    final perspective = _selectedPerspectiveId;
    final difficulty = _selectedDifficulty;

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BattleScreen(
          scenario: widget.scenario,
          alternativePerspectiveId: perspective,
          difficultyMode: difficulty,
        ),
      ),
    );
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

    if (_scenarioData == null) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('シナリオの読み込みに失敗しました'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('閉じる'),
              ),
            ],
          ),
        ),
      );
    }

    final mainPerspective = _scenarioData!;
    final hasPerspectiveChoice = _scenarioData!.alternativePerspective != null;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'シナリオ設定',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 24),
              // Perspective Selection
              if (hasPerspectiveChoice) ...[
                const Text(
                  '視点を選ぶ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 12),
                _PerspectiveOption(
                  title: mainPerspective.displayName,
                  description: mainPerspective.description,
                  difficulty: mainPerspective.difficulty,
                  isSelected: _selectedPerspectiveId == null,
                  onTap: () {
                    setState(() => _selectedPerspectiveId = null);
                  },
                ),
                const SizedBox(height: 8),
                _PerspectiveOption(
                  title: mainPerspective.alternativePerspective!.displayName,
                  description:
                      mainPerspective.alternativePerspective!.description,
                  difficulty: mainPerspective.alternativePerspective!.difficulty,
                  isSelected: _selectedPerspectiveId != null,
                  onTap: () {
                    setState(() => _selectedPerspectiveId =
                        mainPerspective.alternativePerspective!.id);
                  },
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFF8B6914)),
                const SizedBox(height: 24),
              ],
              // Difficulty Selection
              const Text(
                '難易度を選ぶ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 12),
              ...[DifficultyMode.easy, DifficultyMode.normal, DifficultyMode.hard]
                  .map((mode) => _DifficultyOption(
                        mode: mode,
                        isSelected: _selectedDifficulty == mode,
                        onTap: () {
                          setState(() => _selectedDifficulty = mode);
                        },
                      ))
                  .toList(),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('キャンセル'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _startBattle,
                      child: const Text('出陣'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
  final bool isSelected;

  const _PerspectiveOption({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : const Color(0xFF8B6914),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFF1A1A0A) : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Color(0xFFFFD700)),
              ],
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

class _DifficultyOption extends StatelessWidget {
  final DifficultyMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : const Color(0xFF8B6914),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFF1A1A0A) : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.displayName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mode.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE8D5B0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: List.generate(4, (i) {
                return Icon(
                  i < mode.stars ? Icons.star : Icons.star_border,
                  size: 14,
                  color: const Color(0xFFFFD700),
                );
              }),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, color: Color(0xFFFFD700)),
            ],
          ],
        ),
      ),
    );
  }
}
