/// ゲームの難易度モード
enum DifficultyMode {
  easy,
  normal,
  hard,
}

extension DifficultyModeExtension on DifficultyMode {
  /// 難易度の表示名
  String get displayName => switch (this) {
        DifficultyMode.easy => 'イージー',
        DifficultyMode.normal => 'ノーマル',
        DifficultyMode.hard => 'ハード',
      };

  /// 難易度の説明
  String get description => switch (this) {
        DifficultyMode.easy => '初心者向け - 敵の兵力が30%減少',
        DifficultyMode.normal => '標準難易度 - 史実に基づいた設定',
        DifficultyMode.hard => '上級者向け - 敵の兵力が30%増加',
      };

  /// 難易度の推奨対象
  String get recommendedFor => switch (this) {
        DifficultyMode.easy => 'ゲーム初心者向け',
        DifficultyMode.normal => '標準プレイ',
        DifficultyMode.hard => '高難易度挑戦者向け',
      };

  /// ユニット兵力の調整係数
  double get unitStrengthMultiplier => switch (this) {
        DifficultyMode.easy => 1.3, // プレイヤー兵力 30% 増加
        DifficultyMode.normal => 1.0,
        DifficultyMode.hard => 0.7, // プレイヤー兵力 30% 減少 (敵が30%増加)
      };

  /// 敵ユニット兵力の調整係数
  double get enemyUnitStrengthMultiplier => switch (this) {
        DifficultyMode.easy => 0.7, // 敵兵力 30% 減少
        DifficultyMode.normal => 1.0,
        DifficultyMode.hard => 1.3, // 敵兵力 30% 増加
      };

  /// スコア倍率（難易度が高いほどスコア倍率も高い）
  double get scoreMultiplier => switch (this) {
        DifficultyMode.easy => 0.7,
        DifficultyMode.normal => 1.0,
        DifficultyMode.hard => 1.5,
      };

  /// 難易度のアイコン表示用星数
  int get stars => switch (this) {
        DifficultyMode.easy => 1,
        DifficultyMode.normal => 2,
        DifficultyMode.hard => 4,
      };
}
