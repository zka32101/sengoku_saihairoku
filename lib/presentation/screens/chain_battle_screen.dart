import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../domain/state/battle_state.dart';
import '../../core/services/ad_service.dart';
import 'battle_screen.dart';

/// 連戦モード：全シナリオを休憩なしで連続攻略する高難度モード。
///
/// 各シナリオは独立した戦闘（ユニット編成は毎回そのシナリオ本来のもの）
/// だが、ステージが進むごとに「戦の疲労」として自軍兵力に逓減する
/// ペナルティを掛け、縛りプレイとしての緊張感を出している。
/// 通常のスポット戦と違い、各ステージの結果画面（実績・チャレンジ判定等の
/// 副作用）は経由せず、連戦専用の簡易サマリーのみを都度・最後に表示する
/// （チャレンジ等の重複判定を避けるため）。
class ChainBattleScreen extends StatefulWidget {
  const ChainBattleScreen({super.key});

  @override
  State<ChainBattleScreen> createState() => _ChainBattleScreenState();
}

class _ChainBattleScreenState extends State<ChainBattleScreen> {
  static const double _fatigueStepPenalty = 0.05;
  static const double _minFatigueMultiplier = 0.7;

  DifficultyMode? _difficulty;
  int _currentIndex = 0;
  int _totalScore = 0;
  final List<_StageResult> _results = [];
  final AdService _adService = AdService();
  bool _isWatchingAd = false;
  bool _bonusGoldClaimed = false;

  double get _fatigueMultiplier =>
      (1.0 - _currentIndex * _fatigueStepPenalty)
          .clamp(_minFatigueMultiplier, 1.0);

  void _handleStageEnd(BattleStateData data) {
    Navigator.pop(context); // BattleScreenを閉じ、連戦画面に戻る
    setState(() {
      _results.add(_StageResult(
        scenario: Scenario.values[_currentIndex],
        won: data.won,
        score: data.totalScore,
      ));
      _totalScore += data.totalScore;
      _currentIndex++;
    });
  }

  void _startStage() {
    final difficulty = _difficulty;
    if (difficulty == null) return;
    final scenario = Scenario.values[_currentIndex];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BattleScreen(
          scenario: scenario,
          difficultyMode: difficulty,
          warlordStrengthMultiplier: _fatigueMultiplier,
          onChainBattleEnd: _handleStageEnd,
        ),
      ),
    );
  }

  bool get _isFinished => _currentIndex >= Scenario.values.length;

  Future<void> _watchAdForBonusGold() async {
    setState(() => _isWatchingAd = true);
    final earned = await _adService.showRewardedAdForGold();
    if (!mounted) return;
    setState(() => _isWatchingAd = false);

    if (earned) {
      setState(() => _bonusGoldClaimed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_adService.rewardGoldAmount}ゴールドを獲得しました！')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('広告を表示できませんでした。しばらくしてから再度お試しください')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('連戦モード')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _difficulty == null
              ? _DifficultyPicker(onSelected: (d) => setState(() => _difficulty = d))
              : _isFinished
                  ? _ChainSummary(
                      results: _results,
                      totalScore: _totalScore,
                      isWatchingAd: _isWatchingAd,
                      bonusGoldClaimed: _bonusGoldClaimed,
                      rewardGoldAmount: _adService.rewardGoldAmount,
                      onWatchAd: _watchAdForBonusGold,
                    )
                  : _StageProgress(
                      currentIndex: _currentIndex,
                      totalStages: Scenario.values.length,
                      scenario: Scenario.values[_currentIndex],
                      fatigueMultiplier: _fatigueMultiplier,
                      results: _results,
                      onStart: _startStage,
                    ),
        ),
      ),
    );
  }
}

class _StageResult {
  final Scenario scenario;
  final bool won;
  final int score;

  const _StageResult({
    required this.scenario,
    required this.won,
    required this.score,
  });
}

class _DifficultyPicker extends StatelessWidget {
  final ValueChanged<DifficultyMode> onSelected;

  const _DifficultyPicker({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '連戦モードは全${Scenario.values.length}戦を休憩なしで攻略します。'
          'ステージが進むほど自軍兵力が疲労で減少します。難易度を選んでください。',
          style: const TextStyle(fontSize: 14, color: Color(0xFFE8D5B0)),
        ),
        const SizedBox(height: 24),
        ...[DifficultyMode.easy, DifficultyMode.normal, DifficultyMode.hard]
            .map((mode) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => onSelected(mode),
                      child: Text(mode.displayName),
                    ),
                  ),
                )),
      ],
    );
  }
}

class _StageProgress extends StatelessWidget {
  final int currentIndex;
  final int totalStages;
  final Scenario scenario;
  final double fatigueMultiplier;
  final List<_StageResult> results;
  final VoidCallback onStart;

  const _StageProgress({
    required this.currentIndex,
    required this.totalStages,
    required this.scenario,
    required this.fatigueMultiplier,
    required this.results,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ステージ ${currentIndex + 1} / $totalStages',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          scenario.displayNameJa,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '疲労による兵力倍率: ×${fatigueMultiplier.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 24),
        for (final result in results)
          Text(
            '${result.scenario.displayNameJa}: '
            '${result.won ? '勝利' : '敗北'}（${result.score}点）',
            style: TextStyle(
              fontSize: 12,
              color: result.won ? Colors.lightGreenAccent : Colors.redAccent,
            ),
          ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onStart,
            child: const Text('出陣'),
          ),
        ),
      ],
    );
  }
}

class _ChainSummary extends StatelessWidget {
  final List<_StageResult> results;
  final int totalScore;
  final bool isWatchingAd;
  final bool bonusGoldClaimed;
  final int rewardGoldAmount;
  final VoidCallback onWatchAd;

  const _ChainSummary({
    required this.results,
    required this.totalScore,
    required this.isWatchingAd,
    required this.bonusGoldClaimed,
    required this.rewardGoldAmount,
    required this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    final wins = results.where((r) => r.won).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '連戦終了',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 8),
        Text('$wins / ${results.length} 勝利'),
        Text('合計スコア: $totalScore点'),
        if (!bonusGoldClaimed) ...[
          const SizedBox(height: 16),
          _ChainCompletionAdCard(
            isWatching: isWatchingAd,
            rewardGoldAmount: rewardGoldAmount,
            onWatch: onWatchAd,
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: results
                .map((r) => ListTile(
                      title: Text(r.scenario.displayNameJa),
                      trailing: Text(
                        '${r.won ? '勝利' : '敗北'} ${r.score}点',
                        style: TextStyle(
                          color: r.won ? Colors.lightGreenAccent : Colors.redAccent,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ホームに戻る'),
          ),
        ),
      ],
    );
  }
}

/// 連戦終了時に表示する、広告視聴でのボーナスゴールド獲得カード。
/// 日次上限・付与ロジックはゴールドショップと同じAdService.showRewardedAdForGold
/// を再利用するため、1日の視聴回数上限もゴールドショップと共有する。
class _ChainCompletionAdCard extends StatelessWidget {
  final bool isWatching;
  final int rewardGoldAmount;
  final VoidCallback onWatch;

  const _ChainCompletionAdCard({
    required this.isWatching,
    required this.rewardGoldAmount,
    required this.onWatch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withValues(alpha: 0.2),
            Colors.cyan.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.tealAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Colors.tealAccent, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '広告を見て連戦の労をねぎらうボーナス$rewardGoldAmountゴールドを獲得',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE8D5B0),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 88,
            child: ElevatedButton(
              onPressed: isWatching ? null : onWatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
              ),
              child: isWatching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('視聴する'),
            ),
          ),
        ],
      ),
    );
  }
}
