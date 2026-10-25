import 'package:flutter/material.dart';
import '../../core/services/message_loader.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/models/scenario_data.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/screen_transition.dart';
import 'battle_screen.dart';

/// 戦闘開始前に合戦の背景を伝える序章画面。
/// [_startBattle]相当の役割を引き継ぎ、「出陣」操作でBattleScreenへ遷移する。
class PrologueScreenArgs {
  final Scenario scenario;
  final String? alternativePerspectiveId;
  final DifficultyMode difficultyMode;
  final double warlordStrengthMultiplier;
  final List<double>? perUnitStrengthMultipliers;
  final List<String> sortiedWarlordIds;

  PrologueScreenArgs({
    required this.scenario,
    this.alternativePerspectiveId,
    required this.difficultyMode,
    required this.warlordStrengthMultiplier,
    this.perUnitStrengthMultipliers,
    required this.sortiedWarlordIds,
  });
}

class PrologueScreen extends StatefulWidget {
  final PrologueScreenArgs args;

  const PrologueScreen({super.key, required this.args});

  @override
  State<PrologueScreen> createState() => _PrologueScreenState();
}

class _PrologueScreenState extends State<PrologueScreen> {
  final _messageLoader = MessageLoader();
  bool _loading = true;
  String _prologueText = '';

  @override
  void initState() {
    super.initState();
    _loadPrologue();
  }

  Future<void> _loadPrologue() async {
    await _messageLoader.initialize();
    final text = _messageLoader.getMessage(
            widget.args.scenario.name, 'prologue') ??
        '';
    if (mounted) {
      setState(() {
        _prologueText = text;
        _loading = false;
      });
    }
  }

  void _enterBattle() {
    final args = widget.args;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BattleScreen(
          scenario: args.scenario,
          alternativePerspectiveId: args.alternativePerspectiveId,
          difficultyMode: args.difficultyMode,
          warlordStrengthMultiplier: args.warlordStrengthMultiplier,
          perUnitStrengthMultipliers: args.perUnitStrengthMultipliers,
          sortiedWarlordIds: args.sortiedWarlordIds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Text(
                      widget.args.scenario.displayNameJa,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ScreenTransition(
                      child: Text(
                        _prologueText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          color: Color(0xFFE8D5B0),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _enterBattle,
                      child: Text(l10n.prologueStartButton),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
        ),
      ),
    );
  }
}
