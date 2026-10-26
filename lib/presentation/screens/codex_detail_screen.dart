import 'package:flutter/material.dart';
import '../../core/services/message_loader.dart';
import '../../data/models/scenario_data.dart';
import '../../data/repositories/scenario_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/screen_transition.dart';

/// 図鑑詳細：序章・転機・顛末テキストをまとめて読める画面。
class CodexDetailScreen extends StatefulWidget {
  final Scenario scenario;

  const CodexDetailScreen({super.key, required this.scenario});

  @override
  State<CodexDetailScreen> createState() => _CodexDetailScreenState();
}

class _CodexDetailScreenState extends State<CodexDetailScreen> {
  final _messageLoader = MessageLoader();
  bool _loading = true;
  String _prologue = '';
  List<TurningPoint> _turningPoints = [];
  List<String?> _tpFlavors = [];
  List<MapEntry<String, String>> _epilogueEntries = [];

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    await _messageLoader.initialize();
    final scenarioId = widget.scenario.name;
    final data = await ScenarioRepository().getScenario(widget.scenario);
    final all = _messageLoader.getAllMessages();
    final scenarioMessages =
        (all[scenarioId] as Map<String, dynamic>?) ?? {};

    final epilogueEntries = scenarioMessages.entries
        .where((e) => e.key != 'prologue' && e.key != 'tpFlavor')
        .map((e) => MapEntry(e.key, e.value as String))
        .toList();

    if (!mounted) return;
    setState(() {
      _prologue = scenarioMessages['prologue'] as String? ?? '';
      _turningPoints = data.turningPoints;
      _tpFlavors = List.generate(
        data.turningPoints.length,
        (i) => _messageLoader.getTpFlavor(scenarioId, i),
      );
      _epilogueEntries = epilogueEntries;
      _loading = false;
    });
  }

  String _keyToLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      'victory_perfect' => l10n.messageKeyVictoryPerfect,
      'victory_standard' => l10n.messageKeyVictoryStandard,
      'victory_difficult' => l10n.messageKeyVictoryDifficult,
      'defeat' => l10n.messageKeyDefeat,
      'turning_point_all' => l10n.messageKeyTurningPointAll,
      'turning_point_most' => l10n.messageKeyTurningPointMost,
      'history_changed' => l10n.messageKeyHistoryChanged,
      'history_faithful' => l10n.messageKeyHistoryFaithful,
      _ => key,
    };
  }

  Widget _sectionHeading(String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _textBlock(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A0A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8B6914)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFFE8D5B0), height: 1.6),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.scenario.displayNameJa)),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_prologue.isNotEmpty) ...[
                _sectionHeading(l10n.codexPrologueHeading),
                _textBlock(_prologue),
              ],
              if (_turningPoints.isNotEmpty) ...[
                _sectionHeading(l10n.codexTurningPointsHeading),
                for (int i = 0; i < _turningPoints.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _turningPoints[i].name,
                          style: const TextStyle(
                            color: Color(0xFFFFAA00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_tpFlavors[i] != null)
                          _textBlock(_tpFlavors[i]!),
                      ],
                    ),
                  ),
              ],
              if (_epilogueEntries.isNotEmpty) ...[
                _sectionHeading(l10n.codexEpilogueHeading),
                for (final entry in _epilogueEntries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _keyToLabel(l10n, entry.key),
                          style: const TextStyle(
                            color: Color(0xFFFFAA00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _textBlock(entry.value),
                      ],
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
