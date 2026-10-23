import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../domain/state/battle_state.dart';
import '../../core/services/ad_service.dart';
import '../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isWatchingAd = true);
    final earned = await _adService.showRewardedAdForGold();
    if (!mounted) return;
    setState(() => _isWatchingAd = false);

    if (earned) {
      setState(() => _bonusGoldClaimed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                l10n.goldShopAdRewardEarned(_adService.rewardGoldAmount))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.goldShopAdFailure)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.chainBattleTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _difficulty == null
              ? _DifficultyPicker(
                  onSelected: (d) => setState(() => _difficulty = d),
                  l10n: l10n,
                )
              : _isFinished
                  ? _ChainSummary(
                      results: _results,
                      totalScore: _totalScore,
                      isWatchingAd: _isWatchingAd,
                      bonusGoldClaimed: _bonusGoldClaimed,
                      rewardGoldAmount: _adService.rewardGoldAmount,
                      onWatchAd: _watchAdForBonusGold,
                      l10n: l10n,
                    )
                  : _StageProgress(
                      currentIndex: _currentIndex,
                      totalStages: Scenario.values.length,
                      scenario: Scenario.values[_currentIndex],
                      fatigueMultiplier: _fatigueMultiplier,
                      results: _results,
                      onStart: _startStage,
                      l10n: l10n,
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
  final AppLocalizations l10n;

  const _DifficultyPicker({required this.onSelected, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chainBattleDifficultyIntro(Scenario.values.length),
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
  final AppLocalizations l10n;

  const _StageProgress({
    required this.currentIndex,
    required this.totalStages,
    required this.scenario,
    required this.fatigueMultiplier,
    required this.results,
    required this.onStart,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chainBattleStageLabel(currentIndex + 1, totalStages),
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
          l10n.chainBattleFatigueMultiplier(fatigueMultiplier.toStringAsFixed(2)),
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 24),
        for (final result in results)
          Text(
            l10n.chainBattleResultLine(
              result.scenario.displayNameJa,
              result.won ? l10n.chainBattleWin : l10n.chainBattleLoss,
              result.score,
            ),
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
            child: Text(l10n.commonSortie),
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
  final AppLocalizations l10n;

  const _ChainSummary({
    required this.results,
    required this.totalScore,
    required this.isWatchingAd,
    required this.bonusGoldClaimed,
    required this.rewardGoldAmount,
    required this.onWatchAd,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final wins = results.where((r) => r.won).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chainSummaryTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.chainSummaryWins(wins, results.length)),
        Text(l10n.chainSummaryTotalScore(totalScore)),
        if (!bonusGoldClaimed) ...[
          const SizedBox(height: 16),
          _ChainCompletionAdCard(
            isWatching: isWatchingAd,
            rewardGoldAmount: rewardGoldAmount,
            onWatch: onWatchAd,
            l10n: l10n,
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: results
                .map((r) => ListTile(
                      title: Text(r.scenario.displayNameJa),
                      trailing: Text(
                        l10n.chainSummaryResultLine(
                          r.won ? l10n.chainBattleWin : l10n.chainBattleLoss,
                          r.score,
                        ),
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
            child: Text(l10n.chainSummaryHomeButton),
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
  final AppLocalizations l10n;

  const _ChainCompletionAdCard({
    required this.isWatching,
    required this.rewardGoldAmount,
    required this.onWatch,
    required this.l10n,
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
              l10n.chainCompletionAdLabel(rewardGoldAmount),
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
                  : Text(l10n.goldShopWatchButton),
            ),
          ),
        ],
      ),
    );
  }
}
