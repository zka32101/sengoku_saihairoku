import 'package:flutter/material.dart';
import '../../data/repositories/tutorial_repository.dart';
import '../../data/models/tutorial_content.dart';
import '../../data/models/difficulty_mode.dart';

/// チュートリアル・ヘルプモーダルダイアログ
class HelpModal extends StatefulWidget {
  final String initialTab; // 'tutorial', 'commands', 'tactics'
  final String? difficultyMode;

  const HelpModal({
    super.key,
    this.initialTab = 'tutorial',
    this.difficultyMode,
  });

  @override
  State<HelpModal> createState() => _HelpModalState();
}

class _HelpModalState extends State<HelpModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tutorialRepo = TutorialRepository();

  @override
  void initState() {
    super.initState();
    final tabs = ['tutorial', 'commands', 'tactics'];
    final initialIndex = tabs.indexOf(widget.initialTab);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A0A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'チュートリアル'),
              Tab(text: 'コマンド'),
              Tab(text: '戦術ヒント'),
            ],
            labelColor: const Color(0xFFFFD700),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFFFD700),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTutorialTab(),
                _buildCommandsTab(),
                _buildTacticsTab(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFD700)),
                ),
                child: const Text(
                  '閉じる',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialTab() {
    return FutureBuilder<Map<String, TutorialContent>>(
      future: _tutorialRepo.getAllTutorial(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tutorials = snapshot.data!.values.toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            final tutorial = tutorials[index];
            return _TutorialCard(tutorial: tutorial);
          },
        );
      },
    );
  }

  Widget _buildCommandsTab() {
    return FutureBuilder<List<CommandHelp>>(
      future: _tutorialRepo.getCommandHelp(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final commands = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: commands.length,
          itemBuilder: (context, index) {
            final command = commands[index];
            return _CommandCard(command: command);
          },
        );
      },
    );
  }

  Widget _buildTacticsTab() {
    return FutureBuilder<List<TacticalHint>>(
      future: _tutorialRepo.getTacticalHints(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final hints = snapshot.data!;
        final filteredHints = widget.difficultyMode != null
            ? hints
                .where((h) =>
                    h.difficultyLevel == widget.difficultyMode?.toLowerCase())
                .toList()
            : hints;

        if (filteredHints.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'この難易度のヒントはありません',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredHints.length,
          itemBuilder: (context, index) {
            final hint = filteredHints[index];
            return _TacticalHintCard(hint: hint);
          },
        );
      },
    );
  }
}

/// チュートリアルカード
class _TutorialCard extends StatefulWidget {
  final TutorialContent tutorial;

  const _TutorialCard({required this.tutorial});

  @override
  State<_TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<_TutorialCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A1A0A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          widget.tutorial.title,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.tutorial.description,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        initiallyExpanded: _expanded,
        onExpansionChanged: (expanded) {
          setState(() => _expanded = expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final tip in widget.tutorial.tips) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tip.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(tip.icon!, style: const TextStyle(fontSize: 20)),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip.title,
                              style: const TextStyle(
                                color: Color(0xFFE8D5B0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tip.content,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (tip != widget.tutorial.tips.last)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFF8B6914)),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// コマンドカード
class _CommandCard extends StatelessWidget {
  final CommandHelp command;

  const _CommandCard({required this.command});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A1A0A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          command.displayName,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          command.description,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '効果',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  command.effect,
                  style: const TextStyle(color: Color(0xFFE8D5B0)),
                ),
                const SizedBox(height: 12),
                Text(
                  '制限事項',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  command.limitation,
                  style: const TextStyle(color: Color(0xFFE8D5B0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 戦術ヒントカード
class _TacticalHintCard extends StatelessWidget {
  final TacticalHint hint;

  const _TacticalHintCard({required this.hint});

  String _getDifficultyLabel() {
    return switch (hint.difficultyLevel) {
      'easy' => 'Easy',
      'normal' => 'Normal',
      'hard' => 'Hard',
      _ => hint.difficultyLevel,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2A1A0A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          hint.title,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _getDifficultyLabel(),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hint.content,
                  style: const TextStyle(color: Color(0xFFE8D5B0)),
                ),
                const SizedBox(height: 12),
                Text(
                  '推奨事項',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                for (final rec in hint.recommendations) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Color(0xFFFFD700))),
                        Expanded(
                          child: Text(
                            rec,
                            style: const TextStyle(color: Color(0xFFE8D5B0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
