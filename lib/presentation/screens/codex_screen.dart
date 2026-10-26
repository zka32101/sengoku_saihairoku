import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import '../../data/repositories/replay_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import 'codex_detail_screen.dart';

/// 戦史図鑑：クリア済みシナリオの序章・転機・顛末テキストを読み返せる画面。
/// 未クリアのシナリオはロックされ、内容は隠される。
class CodexScreen extends StatefulWidget {
  const CodexScreen({super.key});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  bool _loading = true;
  Set<Scenario> _unlocked = {};

  @override
  void initState() {
    super.initState();
    _loadUnlockedScenarios();
  }

  Future<void> _loadUnlockedScenarios() async {
    final replays = await ReplayRepository().getAllReplays();
    final unlocked = replays
        .where((r) => r.isVictory)
        .map((r) => r.scenario)
        .toSet();
    if (mounted) {
      setState(() {
        _unlocked = unlocked;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.codexTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: Scenario.values.length,
              itemBuilder: (context, index) {
                final scenario = Scenario.values[index];
                final isUnlocked = _unlocked.contains(scenario);
                return Card(
                  child: ListTile(
                    leading: Icon(
                      isUnlocked ? Icons.menu_book : Icons.lock_outline,
                      color: isUnlocked
                          ? const Color(0xFFFFD700)
                          : Colors.grey,
                    ),
                    title: Text(
                      isUnlocked
                          ? scenario.displayNameJa
                          : l10n.codexLockedName,
                      style: TextStyle(
                        color: isUnlocked
                            ? const Color(0xFFE8D5B0)
                            : Colors.grey,
                      ),
                    ),
                    subtitle: isUnlocked
                        ? null
                        : Text(
                            l10n.codexLockedHint,
                            style: const TextStyle(fontSize: 11),
                          ),
                    trailing: isUnlocked
                        ? const Icon(Icons.chevron_right, color: Colors.grey)
                        : null,
                    onTap: isUnlocked
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CodexDetailScreen(scenario: scenario),
                              ),
                            )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
