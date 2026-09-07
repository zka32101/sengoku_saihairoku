import '../../data/models/warlord_data.dart';

/// 2人の武将を同じ部隊・作戦に組ませたときの「相性」倍率を計算する。
///
/// これは戦闘（DamageCalculator/Unit）にはまだ接続されていない純粋ロジックの
/// 土台。実際にプレイヤーがユニットへ武将を割り当てるUI・セーブ形式は
/// 別途設計が必要なため（PR #9で武将データベースをスコープ外にした際の
/// 検討事項と同じ）、ここでは検証・拡張しやすい独立したモジュールとして
/// 用意している。
///
/// 倍率は [minMultiplier, maxMultiplier] にクランプされ、DamageCalculator の
/// 他の乗数（士気・兵種相性など）と同じ「1.0を基準にした掛け算係数」として
/// 将来組み込めるようにしてある。
class WarlordCompatibility {
  static const double minMultiplier = 0.7;
  static const double maxMultiplier = 1.5;

  static const double _sameFactionBonus = 0.15;
  static const double _synergyIntelligenceBonus = 0.05;
  static const int _synergyIntelligenceThreshold = 170; // 両者の知略合計
  static const double _leadershipGapPenalty = 0.10;
  static const int _leadershipGapThreshold = 40; // 統率差がこれを超えると指揮系統が乱れる

  /// [a] と [b] を同じ部隊に組ませたときの相性倍率。
  /// 同一武将同士(a.id == b.id)は基準値 1.0 を返す。
  static double multiplier(Warlord a, Warlord b) {
    if (a.id == b.id) return 1.0;

    double result = 1.0;

    // 同勢力出身は連携が取りやすい
    if (a.faction == b.faction) {
      result += _sameFactionBonus;
    }

    // 両者とも知略が高いと策の噛み合わせが良くなる
    if (a.intelligence + b.intelligence >= _synergyIntelligenceThreshold) {
      result += _synergyIntelligenceBonus;
    }

    // 統率差が大きすぎると指揮系統が乱れ、連携が悪化する
    final leadershipGap = (a.leadership - b.leadership).abs();
    if (leadershipGap > _leadershipGapThreshold) {
      result -= _leadershipGapPenalty;
    }

    return result.clamp(minMultiplier, maxMultiplier);
  }

  /// 部隊（3人以上）全体の相性倍率。全ペアの相乗平均に近い挙動になるよう、
  /// 全ペアの倍率の単純平均を取る（1人だけなら1.0）。
  static double partyMultiplier(List<Warlord> members) {
    if (members.length < 2) return 1.0;

    double sum = 0;
    int pairCount = 0;
    for (var i = 0; i < members.length; i++) {
      for (var j = i + 1; j < members.length; j++) {
        sum += multiplier(members[i], members[j]);
        pairCount++;
      }
    }
    return pairCount > 0 ? sum / pairCount : 1.0;
  }
}
