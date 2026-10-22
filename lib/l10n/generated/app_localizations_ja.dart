// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '戦国采配録';

  @override
  String get navHome => 'ホーム';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get navStatistics => '統計';

  @override
  String get navReplay => 'リプレイ';

  @override
  String get navRanking => 'ランキング';

  @override
  String get navSettings => '設定';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonConfirm => '確認';

  @override
  String get commonSortie => '出陣';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonError => 'エラーが発生しました';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGameSection => 'ゲーム設定';

  @override
  String get settingsSfx => '効果音';

  @override
  String get settingsSfxSubtitle => 'SE';

  @override
  String get settingsBgm => 'BGM';

  @override
  String get settingsBgmSubtitle => 'バックグラウンドミュージック';

  @override
  String get settingsLanguageSection => '言語 / Language';

  @override
  String get settingsDisplayLanguage => '表示言語';

  @override
  String get settingsLanguageSystem => '端末の設定に従う';

  @override
  String get settingsLanguageJa => '日本語';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDataSection => 'データ管理';

  @override
  String get settingsCloudSave => 'クラウドに保存';

  @override
  String get settingsCloudSaveSubtitle => 'Firebase アカウントが必要です';

  @override
  String get settingsDeleteSaveData => 'セーブデータを削除';

  @override
  String get settingsOtherSection => 'その他';

  @override
  String get settingsReplayTutorial => 'チュートリアルをもう一度見る';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTermsOfService => '利用規約';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsComingSoon => '近日公開';

  @override
  String get settingsDeleteDataTitle => 'データを削除しますか？';

  @override
  String get settingsDeleteDataBody => 'この操作は元に戻せません';

  @override
  String get settingsDeleteDataConfirm => '削除';

  @override
  String get settingsDeleteDataSuccess => 'データを削除しました';

  @override
  String get settingsDeleteDataFailure => 'データの削除に失敗しました';

  @override
  String get challengeHistoryTitle => 'チャレンジ履歴';

  @override
  String get challengeHistoryEmpty => 'チャレンジ履歴がありません';

  @override
  String get challengeHistoryBanner => 'これまで7日間のチャレンジ情報';

  @override
  String get challengeHistoryToday => '本日';

  @override
  String get challengeHistoryNoChallengeInfo => 'チャレンジ情報がありません';

  @override
  String get weekdaySun => '日';

  @override
  String get weekdayMon => '月';

  @override
  String get weekdayTue => '火';

  @override
  String get weekdayWed => '水';

  @override
  String get weekdayThu => '木';

  @override
  String get weekdayFri => '金';

  @override
  String get weekdaySat => '土';

  @override
  String get statisticsTitle => '統計';

  @override
  String get statisticsDetailTooltip => '詳細統計（シナリオ別・トレンド）';

  @override
  String get statisticsXpSummaryTitle => 'XP統計';

  @override
  String get statisticsXpGainedLabel => '獲得XP';

  @override
  String get statisticsBattleCountLabel => '戦闘数';

  @override
  String get statisticsAverageXpLabel => '平均XP';

  @override
  String get statisticsXpHistoryTitle => 'XP獲得履歴';

  @override
  String get statisticsXpHistoryEmpty => 'XP獲得履歴がまだありません';

  @override
  String get statisticsSourceBattle => '戦闘';

  @override
  String get statisticsSourceChallenge => 'チャレンジ';

  @override
  String get statisticsSourceAchievement => '実績';

  @override
  String get statisticsSourceBattleXpBoost => '広告ブースト';

  @override
  String get statisticsTimeJustNow => 'たった今';

  @override
  String statisticsTimeMinutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String statisticsTimeHoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String statisticsTimeDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String statisticsTimeMonthDay(int month, int day) {
    return '$month月$day日';
  }
}
