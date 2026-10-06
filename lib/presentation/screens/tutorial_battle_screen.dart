import 'package:flutter/material.dart';
import '../../domain/scoring/battle_event_log.dart';

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

const _steps = [
  _TutorialStep(
    command: PlayerCommand.ambush,
    label: '奇襲',
    icon: Icons.bolt,
    color: Colors.orange,
    prompt: '兵力は敵の数分の一…正面からでは勝てない。\nまずは「奇襲」で敵の側面を突こう。',
    resultMessage: '奇襲成功！敵陣が崩れ、大きな打撃を与えた。',
    enemyDamage: 30,
  ),
  _TutorialStep(
    command: PlayerCommand.shield,
    label: '盾陣',
    icon: Icons.shield,
    color: Color(0xFF44AAFF),
    prompt: '敵の反撃が始まる。「盾陣」で守りを固め、\n被害を抑えよう。',
    resultMessage: '盾陣を展開！味方の防御力が大きく上がった。',
  ),
  _TutorialStep(
    command: PlayerCommand.rally,
    label: '激励',
    icon: Icons.local_fire_department,
    color: Color(0xFFFFAA00),
    prompt: '味方の士気を「激励」で高め、\n攻撃力を引き上げよう。',
    resultMessage: '将兵の士気が上がり、攻撃力が上昇した！',
  ),
  _TutorialStep(
    command: PlayerCommand.charge,
    label: '突撃',
    icon: Icons.double_arrow,
    color: Color(0xFFFF4444),
    prompt: '敵は崩れかけている。最後は「突撃」で\n一気に畳み掛けよう！',
    resultMessage: '全軍突撃！敵将本陣を突き崩し、勝利を掴んだ！',
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

class _TutorialBattleScreenState extends State<TutorialBattleScreen> {
  int _stepIndex = 0;
  int _enemyHp = 100;
  String? _lastResultMessage;
  bool get _isVictory => _stepIndex >= _steps.length;

  void _executeCurrentStep() {
    if (_isVictory) return;
    final step = _steps[_stepIndex];
    setState(() {
      _enemyHp = (_enemyHp - step.enemyDamage).clamp(0, 100);
      _lastResultMessage = step.resultMessage;
      _stepIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0A),
      appBar: AppBar(
        title: const Text('初陣：采配の基本'),
        backgroundColor: const Color(0xFF3B1A1A),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _EnemyHpBar(enemyHp: _enemyHp),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: _isVictory
                      ? _VictoryPanel(onFinished: widget.onFinished)
                      : _StepPanel(
                          step: _steps[_stepIndex],
                          lastResultMessage: _lastResultMessage,
                          onExecute: _executeCurrentStep,
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

class _EnemyHpBar extends StatelessWidget {
  final int enemyHp;

  const _EnemyHpBar({required this.enemyHp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '敵本陣',
          style: TextStyle(color: Color(0xFFB0A090), fontSize: 12),
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
  final VoidCallback onExecute;

  const _StepPanel({
    required this.step,
    required this.lastResultMessage,
    required this.onExecute,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lastResultMessage != null) ...[
          Text(
            lastResultMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
          ),
          const SizedBox(height: 16),
        ],
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

  const _VictoryPanel({required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, size: 72, color: Color(0xFFFFD700)),
        const SizedBox(height: 16),
        const Text(
          '初陣、勝利！',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '奇襲・盾陣・激励・突撃…\n采配次第で劣勢は覆せる。\nさあ、本当の戦場へ。',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFE8D5B0), fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onFinished,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: const Text('武将としての旅を始める'),
        ),
      ],
    );
  }
}
