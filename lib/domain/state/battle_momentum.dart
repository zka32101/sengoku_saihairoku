import 'dart:math';

/// 戦闘の勢いを追跡・計算するクラス。
///
/// プレイヤーと敵の相対的な優位性を0.0〜1.0の値で表現する。
/// 0.5がイーブン、0.0に近いほど敵が優勢、1.0に近いほどプレイヤーが優勢。
class BattleMomentum {
  double _playerMomentum = 0.5; // 初期値：イーブン
  static const double _decayRate = 0.05; // 毎フレーム減衰（基準値への回帰）

  /// 現在のプレイヤー勢い（0.0 = 敵優勢, 0.5 = イーブン, 1.0 = プレイヤー優勢）
  double get playerMomentum => _playerMomentum;

  /// 敵の勢い（1 - playerMomentum）
  double get enemyMomentum => 1.0 - _playerMomentum;

  /// 勢い差分（負の値＝敵優勢、正の値＝プレイヤー優勢）
  double get momentumDelta => (_playerMomentum - 0.5) * 2;

  /// プレイヤーが有利かどうか
  bool get playerLeading => _playerMomentum > 0.5;

  /// 更新：毎フレーム呼び出す
  void update(double dt, double playerStrengthRatio, double enemyStrengthRatio) {
    // 兵力差に基づいて勢いを更新
    final totalStrength = playerStrengthRatio + enemyStrengthRatio;
    if (totalStrength > 0) {
      final playerRatio = playerStrengthRatio / totalStrength;

      // 目標値（兵力比に応じた理想的な勢い）
      final targetMomentum = playerRatio.clamp(0.2, 0.8);

      // 徐々に目標値へ移動
      _playerMomentum +=
          (targetMomentum - _playerMomentum) * _decayRate * dt * 60;
      _playerMomentum = _playerMomentum.clamp(0.0, 1.0);
    }
  }

  /// ボーナス/ペナルティを追加（コマンド実行時など）
  void applyBonus(double delta) {
    _playerMomentum = (_playerMomentum + delta).clamp(0.0, 1.0);
  }

  /// リセット
  void reset() {
    _playerMomentum = 0.5;
  }
}
