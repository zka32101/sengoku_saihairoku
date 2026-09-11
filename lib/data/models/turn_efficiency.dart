import 'scenario_data.dart';

/// ターン数効率関連のモデル

/// ターンランク（金・銀・銅）
enum TurnRank {
  gold('🥇', 'Gold', 1.0),      // 基本報酬 × 100%
  silver('🥈', 'Silver', 0.8),   // 基本報酬 × 80%
  bronze('🥉', 'Bronze', 0.5);   // 基本報酬 × 50%

  final String icon;
  final String displayName;
  final double rewardMultiplier;

  const TurnRank(this.icon, this.displayName, this.rewardMultiplier);
}

/// ターン数ランク判定の基準
class TurnRankingCriteria {
  final int goldThreshold;   // このターン以下で Gold
  final int silverThreshold; // このターン以下で Silver（超過）
  final int bronzeThreshold; // このターン以下で Bronze（超過）

  TurnRankingCriteria({
    required this.goldThreshold,
    required this.silverThreshold,
    required this.bronzeThreshold,
  });

  /// ターン数からランクを判定
  TurnRank getRankByTurnCount(int turnCount) {
    if (turnCount <= goldThreshold) {
      return TurnRank.gold;
    } else if (turnCount <= silverThreshold) {
      return TurnRank.silver;
    } else if (turnCount <= bronzeThreshold) {
      return TurnRank.bronze;
    }
    // 推奨ターン数を超過した場合は Bronze
    return TurnRank.bronze;
  }

  /// ターン達成度を計算（0.0 ～ 1.0）
  double getEfficiencyScore(int turnCount) {
    if (turnCount <= goldThreshold) {
      // Gold 範囲内なら efficiency = 1.0
      return 1.0;
    } else if (turnCount <= silverThreshold) {
      // Silver 範囲内での相対的な効率を計算
      final range = silverThreshold - goldThreshold;
      final excess = turnCount - goldThreshold;
      return 1.0 - (excess / range) * 0.2; // 1.0 ～ 0.8
    } else if (turnCount <= bronzeThreshold) {
      // Bronze 範囲内での相対的な効率を計算
      final range = bronzeThreshold - silverThreshold;
      final excess = turnCount - silverThreshold;
      return 0.8 - (excess / range) * 0.3; // 0.8 ～ 0.5
    }
    // 超過した場合は 0.5
    return 0.5;
  }

  factory TurnRankingCriteria.fromJson(Map<String, dynamic> json) {
    return TurnRankingCriteria(
      goldThreshold: json['gold'] as int,
      silverThreshold: json['silver'] as int,
      bronzeThreshold: json['bronze'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'gold': goldThreshold,
        'silver': silverThreshold,
        'bronze': bronzeThreshold,
      };
}

/// ターン数の評価結果
class TurnRankResult {
  final int turnCount;
  final TurnRank rank;
  final double efficiencyScore; // 0.0 ～ 1.0
  final int rewardBonus; // ランク別の報酬加算額

  TurnRankResult({
    required this.turnCount,
    required this.rank,
    required this.efficiencyScore,
    required this.rewardBonus,
  });

  /// 表示用テキスト（例: "🥇 Gold (15ターン)"）
  String get displayText => '${rank.icon} ${rank.displayName} ($turnCount ターン)';

  /// 報酬表示用テキスト（例: "報酬: スコア × 100%"）
  String get rewardText => '報酬: スコア × ${(rank.rewardMultiplier * 100).toInt()}%';

  factory TurnRankResult.fromJson(Map<String, dynamic> json) {
    return TurnRankResult(
      turnCount: json['turnCount'] as int,
      rank: TurnRank.values.byName(json['rank'] as String),
      efficiencyScore: json['efficiencyScore'] as double,
      rewardBonus: json['rewardBonus'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'turnCount': turnCount,
        'rank': rank.name,
        'efficiencyScore': efficiencyScore,
        'rewardBonus': rewardBonus,
      };
}

/// ターン効率の統計
class TurnEfficiencyStats {
  final Scenario scenario;
  final List<TurnRankResult> results; // 全バトルの結果

  TurnEfficiencyStats({
    required this.scenario,
    required this.results,
  });

  /// 平均ターン数
  double get averageTurnCount =>
      results.isEmpty ? 0 : results.fold(0, (sum, r) => sum + r.turnCount) / results.length;

  /// 最小ターン数
  int get minTurnCount => results.isEmpty ? 0 : results.map((r) => r.turnCount).reduce((a, b) => a < b ? a : b);

  /// 最大ターン数
  int get maxTurnCount => results.isEmpty ? 0 : results.map((r) => r.turnCount).reduce((a, b) => a > b ? a : b);

  /// Gold ランク達成数
  int get goldRankCount => results.where((r) => r.rank == TurnRank.gold).length;

  /// Silver ランク達成数
  int get silverRankCount => results.where((r) => r.rank == TurnRank.silver).length;

  /// Bronze ランク達成数
  int get bronzeRankCount => results.where((r) => r.rank == TurnRank.bronze).length;

  /// 平均効率スコア
  double get averageEfficiency =>
      results.isEmpty ? 0 : results.fold(0.0, (sum, r) => sum + r.efficiencyScore) / results.length;
}
