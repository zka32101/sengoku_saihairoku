/// デイリーログインボーナスの7日周期報酬テーブル
class DailyLoginBonus {
  /// 1〜7日目のゴールド報酬（7日目以降はループする）
  static const List<int> goldByDay = [30, 40, 50, 60, 80, 100, 150];

  static int goldForStreak(int streakDay) {
    final index = (streakDay - 1) % goldByDay.length;
    return goldByDay[index];
  }
}

/// デイリーログインボーナスの現在の状態
class DailyLoginStatus {
  final int currentStreak; // 連続ログイン日数（今日分を含む）
  final bool claimedToday;
  final int todayReward; // 本日分（未受取なら受取可能額、受取済みなら受け取った額）

  const DailyLoginStatus({
    required this.currentStreak,
    required this.claimedToday,
    required this.todayReward,
  });
}
