import 'package:flutter/material.dart';
import '../../domain/scoring/battle_event_log.dart';
import '../../l10n/generated/app_localizations.dart';

class _TutorialStep {
  final PlayerCommand command;
  final String label;
  final IconData icon;
  final Color color;
  final String prompt;
  final String resultMessage;
  final int enemyDamage;

  const _TutorialStep({
    required this.command,
    required this.label,
    required this.icon,
    required this.color,
    required this.prompt,
    required this.resultMessage,
    this.enemyDamage = 0,
  });
}

List<_TutorialStep> _stepsFor(AppLocalizations l10n) => [
  _TutorialStep(
    command: PlayerCommand.ambush,
    label: l10n.tutorialStepAmbushLabel,
    icon: Icons.bolt,
    color: Colors.orange,
    prompt: l10n.tutorialStepAmbushPrompt,
    resultMessage: l10n.tutorialStepAmbushResult,
    enemyDamage: 30,
  ),
  _TutorialStep(
    command: PlayerCommand.shield,
    label: l10n.tutorialStepShieldLabel,
    icon: Icons.shield,
    color: const Color(0xFF44AAFF),
    prompt: l10n.tutorialStepShieldPrompt,
    resultMessage: l10n.tutorialStepShieldResult,
  ),
  _TutorialStep(
    command: PlayerCommand.rally,
    label: l10n.tutorialStepRallyLabel,
    icon: Icons.local_fire_department,
    color: const Color(0xFFFFAA00),
    prompt: l10n.tutorialStepRallyPrompt,
    resultMessage: l10n.tutorialStepRallyResult,
  ),
  _TutorialStep(
    command: PlayerCommand.charge,
    label: l10n.tutorialStepChargeLabel,
    icon: Icons.double_arrow,
    color: const Color(0xFFFF4444),
    prompt: l10n.tutorialStepChargePrompt,
    resultMessage: l10n.tutorialStepChargeResult,
    enemyDamage: 70,
  ),
];

/// オンボーディング後に表示する、実際のコマンド操作を1つずつ体験できる
/// 簡易チュートリアル戦闘。本編のFlame戦闘エンジンとは独立した、
/// 台本通りに進む固定シナリオ（コマンドの意味を覚えてもらうためのもので、
/// 戦略的な判断を試すものではない）。
class TutorialBattleScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const TutorialBattleScreen({super.key, required this.onFinished});

  @override
  State<TutorialBattleScreen> createState() => _TutorialBattleScreenState();
}

/// チュートリアルの進め方。「じっくり」は各コマンドの解説文を表示し、
/// 「駆け足」は解説を省いてコマンドボタンだけを並べ、テンポよく進める。
/// どちらも同じ4コマンド・同じ結果に到達する（戦術的な難易度差ではなく、
/// 既にゲームに慣れたプレイヤー向けのテンポ差）。
enum _TutorialPace { thorough, brisk }

class _TutorialBattleScreenState extends State<TutorialBattleScreen> {
  _TutorialPace? _pace;
  int _stepIndex = 0;
  int _enemyHp = 100;
  String? _lastResultMessage;

  bool _isVictory(List<_TutorialStep> steps) => _stepIndex >= steps.length;

  void _executeCurrentStep(List<_TutorialStep> steps) {
    if (_isVictory(steps)) return;
    final step = steps[_stepIndex];
    setState(() {
      _enemyHp = (_enemyHp - step.enemyDamage).clamp(0, 100);
      _lastResultMessage = step.resultMessage;
      _stepIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _stepsFor(l10n);
    final isVictory = _isVictory(steps);
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0A),
      appBar: AppBar(
        title: Text(l10n.tutorialTitle),
        backgroundColor: const Color(0xFF3B1A1A),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _pace == null
              ? _PaceSelector(
                  onSelected: (pace) => setState(() => _pace = pace),
                  l10n: l10n,
                )
              : Column(
                  children: [
                    _EnemyHpBar(enemyHp: _enemyHp, l10n: l10n),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: isVictory
                            ? _VictoryPanel(onFinished: widget.onFinished, l10n: l10n)
                            : _StepPanel(
                                step: steps[_stepIndex],
                                lastResultMessage: _lastResultMessage,
                                showPrompt: _pace == _TutorialPace.thorough,
                                onExecute: () => _executeCurrentStep(steps),
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PaceSelector extends StatelessWidget {
  final ValueChanged<_TutorialPace> onSelected;
  final AppLocalizations l10n;

  const _PaceSelector({required this.onSelected, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.tutorialPaceSelectTitle,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => onSelected(_TutorialPace.thorough),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(l10n.tutorialPaceThoroughButton),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => onSelected(_TutorialPace.brisk),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(l10n.tutorialPaceBriskButton),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnemyHpBar extends StatelessWidget {
  final int enemyHp;
  final AppLocalizations l10n;

  const _EnemyHpBar({required this.enemyHp, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tutorialEnemyBaseLabel,
          style: const TextStyle(color: Color(0xFFB0A090), fontSize: 12),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: enemyHp / 100,
            minHeight: 16,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF8B1A1A)),
          ),
        ),
      ],
    );
  }
}

class _StepPanel extends StatelessWidget {
  final _TutorialStep step;
  final String? lastResultMessage;
  final bool showPrompt;
  final VoidCallback onExecute;

  const _StepPanel({
    required this.step,
    required this.lastResultMessage,
    required this.onExecute,
    this.showPrompt = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showPrompt && lastResultMessage != null) ...[
          Text(
            lastResultMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
          ),
          const SizedBox(height: 16),
        ],
        if (showPrompt)
          Text(
            step.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE8D5B0),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: onExecute,
          icon: Icon(step.icon),
          label: Text(step.label, style: const TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: step.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _VictoryPanel extends StatelessWidget {
  final VoidCallback onFinished;
  final AppLocalizations l10n;

  const _VictoryPanel({required this.onFinished, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 72, color: Color(0xFFFFD700)),
        const SizedBox(height: 16),
        Text(
          l10n.tutorialVictoryTitle,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.tutorialVictoryMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFFE8D5B0), fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onFinished,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: Text(l10n.tutorialStartJourneyButton),
        ),
      ],
    );
  }
}
