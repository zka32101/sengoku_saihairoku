import 'package:flutter/material.dart';
import '../../core/services/message_loader.dart';
import '../../data/models/scenario_data.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/screen_transition.dart';

class MessageScreenArgs {
  final Scenario scenario;
  final bool won;
  final bool allTpAchieved;

  MessageScreenArgs({
    required this.scenario,
    required this.won,
    required this.allTpAchieved,
  });
}

class MessageScreen extends StatefulWidget {
  final MessageScreenArgs args;

  const MessageScreen({super.key, required this.args});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageLoader = MessageLoader();
  bool _loading = true;
  String _currentMessage = '';
  String _selectedKey = '';
  List<MapEntry<String, String>> _availableMessages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      await _messageLoader.initialize();
      final scenarioId = widget.args.scenario.name;
      final all = _messageLoader.getAllMessages();
      final scenarioMessages =
          (all[scenarioId] as Map<String, dynamic>?) ?? {};

      final entries = scenarioMessages.entries
          .map((e) => MapEntry(e.key, e.value as String))
          .toList();

      // デフォルトメッセージ選択
      final defaultKey = _selectDefaultKey();
      final defaultMessage = scenarioMessages[defaultKey] as String? ??
          (entries.isNotEmpty
              ? entries.first.value
              : (mounted ? AppLocalizations.of(context)!.messageScreenNotFound : ''));

      if (mounted) {
        setState(() {
          _availableMessages = entries;
          _selectedKey = defaultKey;
          _currentMessage = defaultMessage;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentMessage = AppLocalizations.of(context)!.messageScreenLoadError(e.toString());
          _loading = false;
        });
      }
    }
  }

  String _selectDefaultKey() {
    final args = widget.args;
    if (args.won && args.allTpAchieved) return 'victory_perfect';
    if (args.won && !args.allTpAchieved) return 'victory_standard';
    return 'defeat';
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.messageScreenTitle(widget.args.scenario.displayNameJa)),
      ),
      body: ScreenTransition(
        duration: const Duration(milliseconds: 500),
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.messageScreenSubheading,
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A0A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF8B6914)),
                    ),
                    child: Text(
                      _currentMessage,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: Color(0xFFE8D5B0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_availableMessages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedKey,
                    decoration: InputDecoration(
                      labelText: l10n.messageScreenViewpointLabel,
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF8B6914)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF8B6914)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    dropdownColor: const Color(0xFF2A1A0A),
                    items: _availableMessages
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(
                                _keyToLabel(l10n, e.key),
                                style: const TextStyle(color: Color(0xFFE8D5B0)),
                              ),
                            ))
                        .toList(),
                    onChanged: (key) {
                      if (key == null) return;
                      final msg = _availableMessages
                          .firstWhere((e) => e.key == key)
                          .value;
                      setState(() {
                        _selectedKey = key;
                        _currentMessage = msg;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.popUntil(context, ModalRoute.withName('/home')),
                      icon: const Icon(Icons.home, color: Color(0xFFFFD700)),
                      label: Text(
                        l10n.messageScreenHome,
                        style: const TextStyle(color: Color(0xFFFFD700)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFFD700)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        ),
      ),
    );
  }
}
