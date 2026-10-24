import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// アプリ名（MaterialAppのtitle、ホーム画面等では使わない）
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール'**
  String get navProfile;

  /// No description provided for @navStatistics.
  ///
  /// In ja, this message translates to:
  /// **'統計'**
  String get navStatistics;

  /// No description provided for @navReplay.
  ///
  /// In ja, this message translates to:
  /// **'リプレイ'**
  String get navReplay;

  /// No description provided for @navRanking.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get navRanking;

  /// No description provided for @navSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get navSettings;

  /// No description provided for @commonClose.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get commonConfirm;

  /// No description provided for @commonSortie.
  ///
  /// In ja, this message translates to:
  /// **'出陣'**
  String get commonSortie;

  /// No description provided for @commonRetry.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました'**
  String get commonError;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @settingsGameSection.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム設定'**
  String get settingsGameSection;

  /// No description provided for @settingsSfx.
  ///
  /// In ja, this message translates to:
  /// **'効果音'**
  String get settingsSfx;

  /// No description provided for @settingsSfxSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'SE'**
  String get settingsSfxSubtitle;

  /// No description provided for @settingsBgm.
  ///
  /// In ja, this message translates to:
  /// **'BGM'**
  String get settingsBgm;

  /// No description provided for @settingsBgmSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'バックグラウンドミュージック'**
  String get settingsBgmSubtitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In ja, this message translates to:
  /// **'言語 / Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsDisplayLanguage.
  ///
  /// In ja, this message translates to:
  /// **'表示言語'**
  String get settingsDisplayLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In ja, this message translates to:
  /// **'端末の設定に従う'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageJa.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get settingsLanguageJa;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In ja, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsDataSection.
  ///
  /// In ja, this message translates to:
  /// **'データ管理'**
  String get settingsDataSection;

  /// No description provided for @settingsCloudSave.
  ///
  /// In ja, this message translates to:
  /// **'クラウドに保存'**
  String get settingsCloudSave;

  /// No description provided for @settingsCloudSaveSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'Firebase アカウントが必要です'**
  String get settingsCloudSaveSubtitle;

  /// No description provided for @settingsDeleteSaveData.
  ///
  /// In ja, this message translates to:
  /// **'セーブデータを削除'**
  String get settingsDeleteSaveData;

  /// No description provided for @settingsOtherSection.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get settingsOtherSection;

  /// No description provided for @settingsReplayTutorial.
  ///
  /// In ja, this message translates to:
  /// **'チュートリアルをもう一度見る'**
  String get settingsReplayTutorial;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get settingsTermsOfService;

  /// No description provided for @settingsVersion.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get settingsVersion;

  /// No description provided for @settingsComingSoon.
  ///
  /// In ja, this message translates to:
  /// **'近日公開'**
  String get settingsComingSoon;

  /// No description provided for @settingsDeleteDataTitle.
  ///
  /// In ja, this message translates to:
  /// **'データを削除しますか？'**
  String get settingsDeleteDataTitle;

  /// No description provided for @settingsDeleteDataBody.
  ///
  /// In ja, this message translates to:
  /// **'この操作は元に戻せません'**
  String get settingsDeleteDataBody;

  /// No description provided for @settingsDeleteDataConfirm.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get settingsDeleteDataConfirm;

  /// No description provided for @settingsDeleteDataSuccess.
  ///
  /// In ja, this message translates to:
  /// **'データを削除しました'**
  String get settingsDeleteDataSuccess;

  /// No description provided for @settingsDeleteDataFailure.
  ///
  /// In ja, this message translates to:
  /// **'データの削除に失敗しました'**
  String get settingsDeleteDataFailure;

  /// No description provided for @challengeHistoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴'**
  String get challengeHistoryTitle;

  /// No description provided for @challengeHistoryEmpty.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴がありません'**
  String get challengeHistoryEmpty;

  /// No description provided for @challengeHistoryBanner.
  ///
  /// In ja, this message translates to:
  /// **'これまで7日間のチャレンジ情報'**
  String get challengeHistoryBanner;

  /// No description provided for @challengeHistoryToday.
  ///
  /// In ja, this message translates to:
  /// **'本日'**
  String get challengeHistoryToday;

  /// No description provided for @challengeHistoryNoChallengeInfo.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ情報がありません'**
  String get challengeHistoryNoChallengeInfo;

  /// No description provided for @weekdaySun.
  ///
  /// In ja, this message translates to:
  /// **'日'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In ja, this message translates to:
  /// **'月'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ja, this message translates to:
  /// **'火'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ja, this message translates to:
  /// **'水'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ja, this message translates to:
  /// **'木'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ja, this message translates to:
  /// **'金'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ja, this message translates to:
  /// **'土'**
  String get weekdaySat;

  /// No description provided for @statisticsTitle.
  ///
  /// In ja, this message translates to:
  /// **'統計'**
  String get statisticsTitle;

  /// No description provided for @statisticsDetailTooltip.
  ///
  /// In ja, this message translates to:
  /// **'詳細統計（シナリオ別・トレンド）'**
  String get statisticsDetailTooltip;

  /// No description provided for @statisticsXpSummaryTitle.
  ///
  /// In ja, this message translates to:
  /// **'XP統計'**
  String get statisticsXpSummaryTitle;

  /// No description provided for @statisticsXpGainedLabel.
  ///
  /// In ja, this message translates to:
  /// **'獲得XP'**
  String get statisticsXpGainedLabel;

  /// No description provided for @statisticsBattleCountLabel.
  ///
  /// In ja, this message translates to:
  /// **'戦闘数'**
  String get statisticsBattleCountLabel;

  /// No description provided for @statisticsAverageXpLabel.
  ///
  /// In ja, this message translates to:
  /// **'平均XP'**
  String get statisticsAverageXpLabel;

  /// No description provided for @statisticsXpHistoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'XP獲得履歴'**
  String get statisticsXpHistoryTitle;

  /// No description provided for @statisticsXpHistoryEmpty.
  ///
  /// In ja, this message translates to:
  /// **'XP獲得履歴がまだありません'**
  String get statisticsXpHistoryEmpty;

  /// No description provided for @statisticsSourceBattle.
  ///
  /// In ja, this message translates to:
  /// **'戦闘'**
  String get statisticsSourceBattle;

  /// No description provided for @statisticsSourceChallenge.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ'**
  String get statisticsSourceChallenge;

  /// No description provided for @statisticsSourceAchievement.
  ///
  /// In ja, this message translates to:
  /// **'実績'**
  String get statisticsSourceAchievement;

  /// No description provided for @statisticsSourceBattleXpBoost.
  ///
  /// In ja, this message translates to:
  /// **'広告ブースト'**
  String get statisticsSourceBattleXpBoost;

  /// No description provided for @statisticsTimeJustNow.
  ///
  /// In ja, this message translates to:
  /// **'たった今'**
  String get statisticsTimeJustNow;

  /// No description provided for @statisticsTimeMinutesAgo.
  ///
  /// In ja, this message translates to:
  /// **'{minutes}分前'**
  String statisticsTimeMinutesAgo(int minutes);

  /// No description provided for @statisticsTimeHoursAgo.
  ///
  /// In ja, this message translates to:
  /// **'{hours}時間前'**
  String statisticsTimeHoursAgo(int hours);

  /// No description provided for @statisticsTimeDaysAgo.
  ///
  /// In ja, this message translates to:
  /// **'{days}日前'**
  String statisticsTimeDaysAgo(int days);

  /// No description provided for @statisticsTimeMonthDay.
  ///
  /// In ja, this message translates to:
  /// **'{month}月{day}日'**
  String statisticsTimeMonthDay(int month, int day);

  /// No description provided for @messageScreenTitle.
  ///
  /// In ja, this message translates to:
  /// **'歴史分析: {scenario}'**
  String messageScreenTitle(String scenario);

  /// No description provided for @messageScreenSubheading.
  ///
  /// In ja, this message translates to:
  /// **'あなたの采配が歴史だったなら'**
  String get messageScreenSubheading;

  /// No description provided for @messageScreenViewpointLabel.
  ///
  /// In ja, this message translates to:
  /// **'別の視点を見る'**
  String get messageScreenViewpointLabel;

  /// No description provided for @messageScreenHome.
  ///
  /// In ja, this message translates to:
  /// **'ホームへ'**
  String get messageScreenHome;

  /// No description provided for @messageScreenLoadError.
  ///
  /// In ja, this message translates to:
  /// **'メッセージの読み込みに失敗しました: {error}'**
  String messageScreenLoadError(String error);

  /// No description provided for @messageScreenNotFound.
  ///
  /// In ja, this message translates to:
  /// **'メッセージが見つかりませんでした'**
  String get messageScreenNotFound;

  /// No description provided for @messageKeyVictoryPerfect.
  ///
  /// In ja, this message translates to:
  /// **'完全勝利'**
  String get messageKeyVictoryPerfect;

  /// No description provided for @messageKeyVictoryStandard.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get messageKeyVictoryStandard;

  /// No description provided for @messageKeyVictoryDifficult.
  ///
  /// In ja, this message translates to:
  /// **'辛勝'**
  String get messageKeyVictoryDifficult;

  /// No description provided for @messageKeyDefeat.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get messageKeyDefeat;

  /// No description provided for @messageKeyTurningPointAll.
  ///
  /// In ja, this message translates to:
  /// **'全TP達成'**
  String get messageKeyTurningPointAll;

  /// No description provided for @messageKeyTurningPointMost.
  ///
  /// In ja, this message translates to:
  /// **'TP多数達成'**
  String get messageKeyTurningPointMost;

  /// No description provided for @messageKeyHistoryChanged.
  ///
  /// In ja, this message translates to:
  /// **'歴史変化'**
  String get messageKeyHistoryChanged;

  /// No description provided for @messageKeyHistoryFaithful.
  ///
  /// In ja, this message translates to:
  /// **'史実通り'**
  String get messageKeyHistoryFaithful;

  /// No description provided for @achievementListTitle.
  ///
  /// In ja, this message translates to:
  /// **'実績'**
  String get achievementListTitle;

  /// No description provided for @achievementCategoryCombat.
  ///
  /// In ja, this message translates to:
  /// **'戦闘'**
  String get achievementCategoryCombat;

  /// No description provided for @achievementCategoryProgression.
  ///
  /// In ja, this message translates to:
  /// **'進行度'**
  String get achievementCategoryProgression;

  /// No description provided for @achievementCategoryPrestige.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジ'**
  String get achievementCategoryPrestige;

  /// No description provided for @achievementCategoryCosmetic.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック'**
  String get achievementCategoryCosmetic;

  /// No description provided for @achievementCategoryMilestone.
  ///
  /// In ja, this message translates to:
  /// **'マイルストーン'**
  String get achievementCategoryMilestone;

  /// No description provided for @achievementCategoryEvent.
  ///
  /// In ja, this message translates to:
  /// **'イベント'**
  String get achievementCategoryEvent;

  /// No description provided for @achievementDifficultyBronze.
  ///
  /// In ja, this message translates to:
  /// **'ブロンズ'**
  String get achievementDifficultyBronze;

  /// No description provided for @achievementDifficultySilver.
  ///
  /// In ja, this message translates to:
  /// **'シルバー'**
  String get achievementDifficultySilver;

  /// No description provided for @achievementDifficultyGold.
  ///
  /// In ja, this message translates to:
  /// **'ゴールド'**
  String get achievementDifficultyGold;

  /// No description provided for @achievementDifficultyDiamond.
  ///
  /// In ja, this message translates to:
  /// **'ダイヤモンド'**
  String get achievementDifficultyDiamond;

  /// No description provided for @achievementFilterTitle.
  ///
  /// In ja, this message translates to:
  /// **'フィルター'**
  String get achievementFilterTitle;

  /// No description provided for @achievementFilterCategory.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー'**
  String get achievementFilterCategory;

  /// No description provided for @achievementFilterDifficulty.
  ///
  /// In ja, this message translates to:
  /// **'難易度'**
  String get achievementFilterDifficulty;

  /// No description provided for @achievementFilterStatus.
  ///
  /// In ja, this message translates to:
  /// **'ステータス'**
  String get achievementFilterStatus;

  /// No description provided for @achievementFilterSort.
  ///
  /// In ja, this message translates to:
  /// **'ソート'**
  String get achievementFilterSort;

  /// No description provided for @achievementFilterAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get achievementFilterAll;

  /// No description provided for @achievementFilterUnlocked.
  ///
  /// In ja, this message translates to:
  /// **'クリア済み'**
  String get achievementFilterUnlocked;

  /// No description provided for @achievementFilterLocked.
  ///
  /// In ja, this message translates to:
  /// **'ロック中'**
  String get achievementFilterLocked;

  /// No description provided for @achievementSortName.
  ///
  /// In ja, this message translates to:
  /// **'名前'**
  String get achievementSortName;

  /// No description provided for @achievementEmptyFiltered.
  ///
  /// In ja, this message translates to:
  /// **'フィルター条件に一致する実績がありません'**
  String get achievementEmptyFiltered;

  /// No description provided for @achievementClearRate.
  ///
  /// In ja, this message translates to:
  /// **'クリア率'**
  String get achievementClearRate;

  /// No description provided for @prestigeShowcaseTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジコスメティック'**
  String get prestigeShowcaseTitle;

  /// No description provided for @prestigeShowcaseEmptyTier.
  ///
  /// In ja, this message translates to:
  /// **'このランクのコスメティックはまだありません'**
  String get prestigeShowcaseEmptyTier;

  /// No description provided for @prestigeShowcaseCurrentRank.
  ///
  /// In ja, this message translates to:
  /// **'現在のプレスティジランク'**
  String get prestigeShowcaseCurrentRank;

  /// No description provided for @prestigeShowcaseNextRank.
  ///
  /// In ja, this message translates to:
  /// **'次のランク: {rank}'**
  String prestigeShowcaseNextRank(String rank);

  /// No description provided for @prestigeShowcaseMaxRank.
  ///
  /// In ja, this message translates to:
  /// **'最高ランク: {rank}に到達しました！'**
  String prestigeShowcaseMaxRank(String rank);

  /// No description provided for @prestigeShowcaseResetCount.
  ///
  /// In ja, this message translates to:
  /// **'リセット回数: {count}'**
  String prestigeShowcaseResetCount(int count);

  /// No description provided for @prestigeShowcaseRequiredPoints.
  ///
  /// In ja, this message translates to:
  /// **'必要ポイント: {points}'**
  String prestigeShowcaseRequiredPoints(int points);

  /// No description provided for @prestigeShowcaseUnlocked.
  ///
  /// In ja, this message translates to:
  /// **'解放済み'**
  String get prestigeShowcaseUnlocked;

  /// No description provided for @prestigeShowcaseLocked.
  ///
  /// In ja, this message translates to:
  /// **'未解放'**
  String get prestigeShowcaseLocked;

  /// No description provided for @prestigeShowcaseItemType.
  ///
  /// In ja, this message translates to:
  /// **'タイプ: {type}'**
  String prestigeShowcaseItemType(String type);

  /// No description provided for @prestigeShowcaseAcquired.
  ///
  /// In ja, this message translates to:
  /// **'取得済み'**
  String get prestigeShowcaseAcquired;

  /// No description provided for @prestigeShowcaseItemLocked.
  ///
  /// In ja, this message translates to:
  /// **'ロック中'**
  String get prestigeShowcaseItemLocked;

  /// No description provided for @advancedStatsTitle.
  ///
  /// In ja, this message translates to:
  /// **'詳細統計'**
  String get advancedStatsTitle;

  /// No description provided for @advancedStatsTabOverview.
  ///
  /// In ja, this message translates to:
  /// **'概要'**
  String get advancedStatsTabOverview;

  /// No description provided for @advancedStatsTabScenario.
  ///
  /// In ja, this message translates to:
  /// **'シナリオ'**
  String get advancedStatsTabScenario;

  /// No description provided for @advancedStatsTabDifficulty.
  ///
  /// In ja, this message translates to:
  /// **'難易度'**
  String get advancedStatsTabDifficulty;

  /// No description provided for @advancedStatsTabRanking.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get advancedStatsTabRanking;

  /// No description provided for @advancedStatsTotalBattles.
  ///
  /// In ja, this message translates to:
  /// **'総バトル数'**
  String get advancedStatsTotalBattles;

  /// No description provided for @advancedStatsWinRate.
  ///
  /// In ja, this message translates to:
  /// **'勝率'**
  String get advancedStatsWinRate;

  /// No description provided for @advancedStatsVictories.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get advancedStatsVictories;

  /// No description provided for @advancedStatsDefeats.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get advancedStatsDefeats;

  /// No description provided for @advancedStatsHighestScore.
  ///
  /// In ja, this message translates to:
  /// **'最高スコア'**
  String get advancedStatsHighestScore;

  /// No description provided for @advancedStatsAverageScore.
  ///
  /// In ja, this message translates to:
  /// **'平均スコア'**
  String get advancedStatsAverageScore;

  /// No description provided for @advancedStatsPlayTime.
  ///
  /// In ja, this message translates to:
  /// **'プレイ時間'**
  String get advancedStatsPlayTime;

  /// No description provided for @advancedStatsPerformanceTrend.
  ///
  /// In ja, this message translates to:
  /// **'パフォーマンストレンド'**
  String get advancedStatsPerformanceTrend;

  /// No description provided for @advancedStatsWinRateChange.
  ///
  /// In ja, this message translates to:
  /// **'勝率: {percent}%'**
  String advancedStatsWinRateChange(String percent);

  /// No description provided for @advancedStatsScoreChange.
  ///
  /// In ja, this message translates to:
  /// **'スコア: {score}pt'**
  String advancedStatsScoreChange(String score);

  /// No description provided for @advancedStatsWinRateTrendLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝率の推移'**
  String get advancedStatsWinRateTrendLabel;

  /// No description provided for @advancedStatsScoreTrendLabel.
  ///
  /// In ja, this message translates to:
  /// **'スコアの推移'**
  String get advancedStatsScoreTrendLabel;

  /// No description provided for @advancedStatsScenarioClearStatus.
  ///
  /// In ja, this message translates to:
  /// **'シナリオ制覇状況'**
  String get advancedStatsScenarioClearStatus;

  /// No description provided for @advancedStatsTrendImproving.
  ///
  /// In ja, this message translates to:
  /// **'📈 上昇傾向'**
  String get advancedStatsTrendImproving;

  /// No description provided for @advancedStatsTrendDeclining.
  ///
  /// In ja, this message translates to:
  /// **'📉 低下傾向'**
  String get advancedStatsTrendDeclining;

  /// No description provided for @advancedStatsTrendStable.
  ///
  /// In ja, this message translates to:
  /// **'→ 安定傾向'**
  String get advancedStatsTrendStable;

  /// No description provided for @rankingTitle.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get rankingTitle;

  /// No description provided for @rankingShareTooltip.
  ///
  /// In ja, this message translates to:
  /// **'ランキングを共有'**
  String get rankingShareTooltip;

  /// No description provided for @rankingShareText.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録でランキングに挑戦中！あなたも采配を振るってみない？\n#戦国采配録'**
  String get rankingShareText;

  /// No description provided for @rankingGlobal.
  ///
  /// In ja, this message translates to:
  /// **'グローバル'**
  String get rankingGlobal;

  /// No description provided for @rankingMyPlay.
  ///
  /// In ja, this message translates to:
  /// **'マイプレイ'**
  String get rankingMyPlay;

  /// No description provided for @rankingAllScenarios.
  ///
  /// In ja, this message translates to:
  /// **'全シナリオ'**
  String get rankingAllScenarios;

  /// No description provided for @rankingEmpty.
  ///
  /// In ja, this message translates to:
  /// **'ランキングデータはまだありません'**
  String get rankingEmpty;

  /// No description provided for @rankingWon.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get rankingWon;

  /// No description provided for @rankingSeasonBestNone.
  ///
  /// In ja, this message translates to:
  /// **'{season}: まだ記録がありません'**
  String rankingSeasonBestNone(String season);

  /// No description provided for @rankingSeasonBestScore.
  ///
  /// In ja, this message translates to:
  /// **'{season}: 自己ベスト {score}点'**
  String rankingSeasonBestScore(String season, int score);

  /// No description provided for @rankingDurationSeconds.
  ///
  /// In ja, this message translates to:
  /// **'{seconds}秒'**
  String rankingDurationSeconds(int seconds);

  /// No description provided for @warlordCollectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'武将図鑑'**
  String get warlordCollectionTitle;

  /// No description provided for @warlordCollectionUnlockedCount.
  ///
  /// In ja, this message translates to:
  /// **'{unlocked} / {total} 解放済み'**
  String warlordCollectionUnlockedCount(int unlocked, int total);

  /// No description provided for @warlordCollectionDrawing.
  ///
  /// In ja, this message translates to:
  /// **'発掘中...'**
  String get warlordCollectionDrawing;

  /// No description provided for @warlordCollectionDrawButton.
  ///
  /// In ja, this message translates to:
  /// **'武将を発掘する（{cost}ゴールド）'**
  String warlordCollectionDrawButton(int cost);

  /// No description provided for @warlordCollectionAllFilter.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get warlordCollectionAllFilter;

  /// No description provided for @warlordCollectionAllUnlocked.
  ///
  /// In ja, this message translates to:
  /// **'すべての武将を解放済みです'**
  String get warlordCollectionAllUnlocked;

  /// No description provided for @warlordCollectionGoldShortage.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドが不足しています'**
  String get warlordCollectionGoldShortage;

  /// No description provided for @warlordCollectionLocked.
  ///
  /// In ja, this message translates to:
  /// **'???'**
  String get warlordCollectionLocked;

  /// No description provided for @warlordCollectionUndiscovered.
  ///
  /// In ja, this message translates to:
  /// **'未発掘'**
  String get warlordCollectionUndiscovered;

  /// No description provided for @warlordCollectionTotalStat.
  ///
  /// In ja, this message translates to:
  /// **'総合力 {stat}'**
  String warlordCollectionTotalStat(int stat);

  /// No description provided for @warlordDetailLeadership.
  ///
  /// In ja, this message translates to:
  /// **'統率'**
  String get warlordDetailLeadership;

  /// No description provided for @warlordDetailValor.
  ///
  /// In ja, this message translates to:
  /// **'武勇'**
  String get warlordDetailValor;

  /// No description provided for @warlordDetailIntelligence.
  ///
  /// In ja, this message translates to:
  /// **'知略'**
  String get warlordDetailIntelligence;

  /// No description provided for @warlordDetailAwakenedLevel.
  ///
  /// In ja, this message translates to:
  /// **'覚醒済み（Lv.{level}）'**
  String warlordDetailAwakenedLevel(int level);

  /// No description provided for @warlordDetailLevel.
  ///
  /// In ja, this message translates to:
  /// **'Lv.{level}'**
  String warlordDetailLevel(int level);

  /// No description provided for @warlordDetailExpHint.
  ///
  /// In ja, this message translates to:
  /// **'出陣させて勝利するとEXPを獲得します'**
  String get warlordDetailExpHint;

  /// No description provided for @warlordDiscoveredTitle.
  ///
  /// In ja, this message translates to:
  /// **'武将を発見！'**
  String get warlordDiscoveredTitle;

  /// No description provided for @warlordArchetypeLeadership.
  ///
  /// In ja, this message translates to:
  /// **'采配の名手'**
  String get warlordArchetypeLeadership;

  /// No description provided for @warlordArchetypeValor.
  ///
  /// In ja, this message translates to:
  /// **'猛将'**
  String get warlordArchetypeValor;

  /// No description provided for @warlordArchetypeIntelligence.
  ///
  /// In ja, this message translates to:
  /// **'智将'**
  String get warlordArchetypeIntelligence;

  /// No description provided for @warlordArchetypeLegendary.
  ///
  /// In ja, this message translates to:
  /// **'伝説の{archetype}'**
  String warlordArchetypeLegendary(String archetype);

  /// No description provided for @goldShopTitle.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドショップ'**
  String get goldShopTitle;

  /// No description provided for @goldShopPurchaseSuccess.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドを獲得しました！'**
  String get goldShopPurchaseSuccess;

  /// No description provided for @goldShopPurchaseFailure.
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました: {error}'**
  String goldShopPurchaseFailure(String error);

  /// No description provided for @goldShopUnknownError.
  ///
  /// In ja, this message translates to:
  /// **'不明なエラー'**
  String get goldShopUnknownError;

  /// No description provided for @goldShopAdRewardEarned.
  ///
  /// In ja, this message translates to:
  /// **'{amount}ゴールドを獲得しました！'**
  String goldShopAdRewardEarned(int amount);

  /// No description provided for @goldShopAdFailure.
  ///
  /// In ja, this message translates to:
  /// **'広告を表示できませんでした。しばらくしてから再度お試しください'**
  String get goldShopAdFailure;

  /// No description provided for @goldShopBalanceLabel.
  ///
  /// In ja, this message translates to:
  /// **'所持ゴールド'**
  String get goldShopBalanceLabel;

  /// No description provided for @goldShopWatchAdTitle.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て{amount}ゴールド獲得'**
  String goldShopWatchAdTitle(int amount);

  /// No description provided for @goldShopWatchAdRemaining.
  ///
  /// In ja, this message translates to:
  /// **'本日あと{remaining}/{limit}回'**
  String goldShopWatchAdRemaining(int remaining, int limit);

  /// No description provided for @goldShopWatchButton.
  ///
  /// In ja, this message translates to:
  /// **'視聴する'**
  String get goldShopWatchButton;

  /// No description provided for @goldShopWatchLimitReached.
  ///
  /// In ja, this message translates to:
  /// **'上限到達'**
  String get goldShopWatchLimitReached;

  /// No description provided for @goldShopPacksTitle.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドパック'**
  String get goldShopPacksTitle;

  /// No description provided for @goldShopStoreUnavailable.
  ///
  /// In ja, this message translates to:
  /// **'ストアに接続できません'**
  String get goldShopStoreUnavailable;

  /// No description provided for @goldShopNoProducts.
  ///
  /// In ja, this message translates to:
  /// **'現在購入可能な商品がありません'**
  String get goldShopNoProducts;

  /// No description provided for @goldShopBestValueBadge.
  ///
  /// In ja, this message translates to:
  /// **'もっともお得'**
  String get goldShopBestValueBadge;

  /// No description provided for @goldShopPopularBadge.
  ///
  /// In ja, this message translates to:
  /// **'人気'**
  String get goldShopPopularBadge;

  /// No description provided for @goldShopGoldAmount.
  ///
  /// In ja, this message translates to:
  /// **'{amount} ゴールド'**
  String goldShopGoldAmount(int amount);

  /// No description provided for @profileTitle.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール'**
  String get profileTitle;

  /// No description provided for @profileLoadError.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーデータを読み込めませんでした'**
  String get profileLoadError;

  /// No description provided for @profileLevelLabel.
  ///
  /// In ja, this message translates to:
  /// **'レベル'**
  String get profileLevelLabel;

  /// No description provided for @profileXpLabel.
  ///
  /// In ja, this message translates to:
  /// **'経験値'**
  String get profileXpLabel;

  /// No description provided for @profileXpSuffix.
  ///
  /// In ja, this message translates to:
  /// **'{xp} XP'**
  String profileXpSuffix(String xp);

  /// No description provided for @profileNextLevelProgress.
  ///
  /// In ja, this message translates to:
  /// **'次のレベルまでの進捗'**
  String get profileNextLevelProgress;

  /// No description provided for @profileMaxLevelReached.
  ///
  /// In ja, this message translates to:
  /// **'最大レベルに到達！プレスティジでリセットできます'**
  String get profileMaxLevelReached;

  /// No description provided for @profilePrestigeRank.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジランク'**
  String get profilePrestigeRank;

  /// No description provided for @profilePrestigePoints.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジポイント'**
  String get profilePrestigePoints;

  /// No description provided for @profilePrestigeResetCount.
  ///
  /// In ja, this message translates to:
  /// **'リセット回数: {count}'**
  String profilePrestigeResetCount(int count);

  /// No description provided for @profileCosmeticsTitle.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック'**
  String get profileCosmeticsTitle;

  /// No description provided for @profileUnitSkinsLabel.
  ///
  /// In ja, this message translates to:
  /// **'ユニットスキン ({count})'**
  String profileUnitSkinsLabel(int count);

  /// No description provided for @profileUiThemesLabel.
  ///
  /// In ja, this message translates to:
  /// **'UIテーマ ({count})'**
  String profileUiThemesLabel(int count);

  /// No description provided for @profileCosmeticsEmpty.
  ///
  /// In ja, this message translates to:
  /// **'コスメティックはまだ解放されていません'**
  String get profileCosmeticsEmpty;

  /// No description provided for @profileProgressionDetailsTitle.
  ///
  /// In ja, this message translates to:
  /// **'プログレッション詳細'**
  String get profileProgressionDetailsTitle;

  /// No description provided for @profileUserIdLabel.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーID'**
  String get profileUserIdLabel;

  /// No description provided for @profilePlayTimeLabel.
  ///
  /// In ja, this message translates to:
  /// **'プレイ時間'**
  String get profilePlayTimeLabel;

  /// No description provided for @profilePlayTimeFormat.
  ///
  /// In ja, this message translates to:
  /// **'{hours}時間 {minutes}分'**
  String profilePlayTimeFormat(int hours, int minutes);

  /// No description provided for @profileLastUpdatedLabel.
  ///
  /// In ja, this message translates to:
  /// **'最終更新'**
  String get profileLastUpdatedLabel;

  /// No description provided for @profileDateFormat.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String profileDateFormat(int year, int month, int day);

  /// No description provided for @profileUnlockedCosmeticsLabel.
  ///
  /// In ja, this message translates to:
  /// **'アンロック済みコスメティック'**
  String get profileUnlockedCosmeticsLabel;

  /// No description provided for @profileUnlockedCosmeticsCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}個'**
  String profileUnlockedCosmeticsCount(int count);

  /// No description provided for @profileActionsTitle.
  ///
  /// In ja, this message translates to:
  /// **'アクション'**
  String get profileActionsTitle;

  /// No description provided for @profileCosmeticsSettingsButton.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック設定'**
  String get profileCosmeticsSettingsButton;

  /// No description provided for @profilePrestigeButton.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジ'**
  String get profilePrestigeButton;

  /// No description provided for @profilePrestigeLockedButton.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジ (Lv.{level}で解放)'**
  String profilePrestigeLockedButton(int level);

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In ja, this message translates to:
  /// **'実績'**
  String get profileAchievementsTitle;

  /// No description provided for @profileAchievementsViewAllButton.
  ///
  /// In ja, this message translates to:
  /// **'すべての実績を表示'**
  String get profileAchievementsViewAllButton;

  /// No description provided for @homeAppTitle.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録'**
  String get homeAppTitle;

  /// No description provided for @homeTagline.
  ///
  /// In ja, this message translates to:
  /// **'天下を狙え'**
  String get homeTagline;

  /// No description provided for @homeTodayChallengeLabel.
  ///
  /// In ja, this message translates to:
  /// **'本日のチャレンジ'**
  String get homeTodayChallengeLabel;

  /// No description provided for @homeWeeklyChallengeLabel.
  ///
  /// In ja, this message translates to:
  /// **'今週のチャレンジ'**
  String get homeWeeklyChallengeLabel;

  /// No description provided for @homeSpotBattleTitle.
  ///
  /// In ja, this message translates to:
  /// **'スポット戦'**
  String get homeSpotBattleTitle;

  /// No description provided for @homeSpotBattleSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'有名な合戦を選んで采配を振るえ'**
  String get homeSpotBattleSubtitle;

  /// No description provided for @homeSpotBattlePlayTime.
  ///
  /// In ja, this message translates to:
  /// **'プレイ時間: 3〜8分'**
  String get homeSpotBattlePlayTime;

  /// No description provided for @homeSpotBattleButton.
  ///
  /// In ja, this message translates to:
  /// **'シナリオを選ぶ'**
  String get homeSpotBattleButton;

  /// No description provided for @homeChainBattleTitle.
  ///
  /// In ja, this message translates to:
  /// **'連戦モード'**
  String get homeChainBattleTitle;

  /// No description provided for @homeChainBattleSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'休憩なしで全シナリオを攻略する高難度の縛りプレイ'**
  String get homeChainBattleSubtitle;

  /// No description provided for @homeChainBattleButton.
  ///
  /// In ja, this message translates to:
  /// **'連戦に挑む'**
  String get homeChainBattleButton;

  /// No description provided for @homeReplayTitle.
  ///
  /// In ja, this message translates to:
  /// **'バトルリプレイ'**
  String get homeReplayTitle;

  /// No description provided for @homeReplaySubtitle.
  ///
  /// In ja, this message translates to:
  /// **'過去のバトルを再生・分析する'**
  String get homeReplaySubtitle;

  /// No description provided for @homeReplayNote.
  ///
  /// In ja, this message translates to:
  /// **'すべてのバトルは自動で記録されます'**
  String get homeReplayNote;

  /// No description provided for @homeReplayButton.
  ///
  /// In ja, this message translates to:
  /// **'リプレイを見る'**
  String get homeReplayButton;

  /// No description provided for @homeRankingTitle.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get homeRankingTitle;

  /// No description provided for @homeRankingSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'他の武将の采配と競え'**
  String get homeRankingSubtitle;

  /// No description provided for @homeRankingButton.
  ///
  /// In ja, this message translates to:
  /// **'ランキングを見る'**
  String get homeRankingButton;

  /// No description provided for @homeChallengeHistoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴'**
  String get homeChallengeHistoryTitle;

  /// No description provided for @homeChallengeHistorySubtitle.
  ///
  /// In ja, this message translates to:
  /// **'過去7日間のチャレンジを確認'**
  String get homeChallengeHistorySubtitle;

  /// No description provided for @homeChallengeHistoryButton.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴を見る'**
  String get homeChallengeHistoryButton;

  /// No description provided for @homeFriendsTitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンド'**
  String get homeFriendsTitle;

  /// No description provided for @homeFriendsSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンドコードを交換してランキングを競おう'**
  String get homeFriendsSubtitle;

  /// No description provided for @homeFriendsButton.
  ///
  /// In ja, this message translates to:
  /// **'フレンドを見る'**
  String get homeFriendsButton;

  /// No description provided for @homeWarlordCollectionTitle.
  ///
  /// In ja, this message translates to:
  /// **'武将図鑑'**
  String get homeWarlordCollectionTitle;

  /// No description provided for @homeWarlordCollectionSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドで武将を発掘し、図鑑をコンプリートしよう'**
  String get homeWarlordCollectionSubtitle;

  /// No description provided for @homeWarlordCollectionButton.
  ///
  /// In ja, this message translates to:
  /// **'図鑑を見る'**
  String get homeWarlordCollectionButton;

  /// No description provided for @homeGoldShopTitle.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドショップ'**
  String get homeGoldShopTitle;

  /// No description provided for @homeGoldShopSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'ゴールドを購入してバトルパスの進行を加速'**
  String get homeGoldShopSubtitle;

  /// No description provided for @homeGoldShopButton.
  ///
  /// In ja, this message translates to:
  /// **'ショップを見る'**
  String get homeGoldShopButton;

  /// No description provided for @homeBattlePassTitle.
  ///
  /// In ja, this message translates to:
  /// **'バトルパス'**
  String get homeBattlePassTitle;

  /// No description provided for @homeBattlePassSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'シーズンを通してティアをアップ'**
  String get homeBattlePassSubtitle;

  /// No description provided for @homeBattlePassMissedRewards.
  ///
  /// In ja, this message translates to:
  /// **'プレミアム報酬を{count}件受け取り逃し中'**
  String homeBattlePassMissedRewards(int count);

  /// No description provided for @homeBattlePassButton.
  ///
  /// In ja, this message translates to:
  /// **'バトルパスを見る'**
  String get homeBattlePassButton;

  /// No description provided for @resultTitle.
  ///
  /// In ja, this message translates to:
  /// **'戦闘結果'**
  String get resultTitle;

  /// No description provided for @resultVictory.
  ///
  /// In ja, this message translates to:
  /// **'勝利！'**
  String get resultVictory;

  /// No description provided for @resultDefeat.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get resultDefeat;

  /// No description provided for @resultVictorySubtitle.
  ///
  /// In ja, this message translates to:
  /// **'見事な采配であった'**
  String get resultVictorySubtitle;

  /// No description provided for @resultDefeatSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'次は必ず雪辱を晴らせ'**
  String get resultDefeatSubtitle;

  /// No description provided for @resultTotalScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'総スコア'**
  String get resultTotalScoreLabel;

  /// No description provided for @resultScorePoints.
  ///
  /// In ja, this message translates to:
  /// **'{score}点'**
  String resultScorePoints(String score);

  /// No description provided for @resultScoreVictory.
  ///
  /// In ja, this message translates to:
  /// **'勝敗スコア'**
  String get resultScoreVictory;

  /// No description provided for @resultScoreEfficiency.
  ///
  /// In ja, this message translates to:
  /// **'効率スコア'**
  String get resultScoreEfficiency;

  /// No description provided for @resultScoreCommand.
  ///
  /// In ja, this message translates to:
  /// **'采配スコア'**
  String get resultScoreCommand;

  /// No description provided for @resultScoreTurningPoint.
  ///
  /// In ja, this message translates to:
  /// **'TP ボーナス'**
  String get resultScoreTurningPoint;

  /// No description provided for @resultScoreHistory.
  ///
  /// In ja, this message translates to:
  /// **'歴史ボーナス'**
  String get resultScoreHistory;

  /// No description provided for @resultTurningPointTitle.
  ///
  /// In ja, this message translates to:
  /// **'ターニングポイント'**
  String get resultTurningPointTitle;

  /// No description provided for @resultTpFallback.
  ///
  /// In ja, this message translates to:
  /// **'TP{number}'**
  String resultTpFallback(int number);

  /// No description provided for @resultViewHistoryButton.
  ///
  /// In ja, this message translates to:
  /// **'歴史分析を見る'**
  String get resultViewHistoryButton;

  /// No description provided for @resultViewRankingButton.
  ///
  /// In ja, this message translates to:
  /// **'ランキングを見る'**
  String get resultViewRankingButton;

  /// No description provided for @resultShareButton.
  ///
  /// In ja, this message translates to:
  /// **'結果をシェア'**
  String get resultShareButton;

  /// No description provided for @resultHomeButton.
  ///
  /// In ja, this message translates to:
  /// **'ホームへ戻る'**
  String get resultHomeButton;

  /// No description provided for @resultShareText.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録『{scenario}』で{result}！\nスコア: {score} pts / ターニングポイント {tp}/{total}\n#戦国采配録'**
  String resultShareText(
    String scenario,
    String result,
    int score,
    int tp,
    int total,
  );

  /// No description provided for @resultShareVictory.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get resultShareVictory;

  /// No description provided for @resultShareDefeat.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get resultShareDefeat;

  /// No description provided for @resultFriendChallengeSuccess.
  ///
  /// In ja, this message translates to:
  /// **'{friend}への挑戦、成功！'**
  String resultFriendChallengeSuccess(String friend);

  /// No description provided for @resultFriendChallengeFailure.
  ///
  /// In ja, this message translates to:
  /// **'{friend}への挑戦、届かず'**
  String resultFriendChallengeFailure(String friend);

  /// No description provided for @resultFriendChallengeTarget.
  ///
  /// In ja, this message translates to:
  /// **'目標スコア: {score}点'**
  String resultFriendChallengeTarget(int score);

  /// No description provided for @resultChallengeCompletedTitle.
  ///
  /// In ja, this message translates to:
  /// **'本日のチャレンジ達成！'**
  String get resultChallengeCompletedTitle;

  /// No description provided for @resultChallengeCompletedNote.
  ///
  /// In ja, this message translates to:
  /// **'報酬を受け取るにはホーム画面から獲得してください'**
  String get resultChallengeCompletedNote;

  /// No description provided for @resultXpGainTitle.
  ///
  /// In ja, this message translates to:
  /// **'経験値獲得'**
  String get resultXpGainTitle;

  /// No description provided for @resultXpGainedLabel.
  ///
  /// In ja, this message translates to:
  /// **'獲得XP:'**
  String get resultXpGainedLabel;

  /// No description provided for @resultXpBoostLoading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中…'**
  String get resultXpBoostLoading;

  /// No description provided for @resultXpBoostButton.
  ///
  /// In ja, this message translates to:
  /// **'広告を見てXPを2倍にする'**
  String get resultXpBoostButton;

  /// No description provided for @resultLevelUpTitle.
  ///
  /// In ja, this message translates to:
  /// **'レベルアップ！'**
  String get resultLevelUpTitle;

  /// No description provided for @resultLevelUpSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'レベル {level} に到達しました'**
  String resultLevelUpSubtitle(int level);

  /// No description provided for @resultBattlePassTierUpTitle.
  ///
  /// In ja, this message translates to:
  /// **'バトルパス ティアアップ！'**
  String get resultBattlePassTierUpTitle;

  /// No description provided for @resultBattlePassTierUpSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'ティア {tier} に到達しました'**
  String resultBattlePassTierUpSubtitle(int tier);

  /// No description provided for @resultCosmeticUnlockTitle.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック解放！'**
  String get resultCosmeticUnlockTitle;

  /// No description provided for @resultTpOdigahara1.
  ///
  /// In ja, this message translates to:
  /// **'敵到着前に奇襲'**
  String get resultTpOdigahara1;

  /// No description provided for @resultTpOdigahara2.
  ///
  /// In ja, this message translates to:
  /// **'嵐の中での戦闘'**
  String get resultTpOdigahara2;

  /// No description provided for @resultTpOdigahara3.
  ///
  /// In ja, this message translates to:
  /// **'敵将兵力低下'**
  String get resultTpOdigahara3;

  /// No description provided for @resultTpOdigahara4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpOdigahara4;

  /// No description provided for @resultTpNagashino1.
  ///
  /// In ja, this message translates to:
  /// **'初期陣形を防御に設定'**
  String get resultTpNagashino1;

  /// No description provided for @resultTpNagashino2.
  ///
  /// In ja, this message translates to:
  /// **'敵騎馬隊の突撃を耐える'**
  String get resultTpNagashino2;

  /// No description provided for @resultTpNagashino3.
  ///
  /// In ja, this message translates to:
  /// **'一斉反撃'**
  String get resultTpNagashino3;

  /// No description provided for @resultTpNagashino4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpNagashino4;

  /// No description provided for @resultTpHonnoJi1.
  ///
  /// In ja, this message translates to:
  /// **'敵の包囲を突破'**
  String get resultTpHonnoJi1;

  /// No description provided for @resultTpHonnoJi2.
  ///
  /// In ja, this message translates to:
  /// **'援軍到着まで生存'**
  String get resultTpHonnoJi2;

  /// No description provided for @resultTpHonnoJi3.
  ///
  /// In ja, this message translates to:
  /// **'援軍到着後の反撃'**
  String get resultTpHonnoJi3;

  /// No description provided for @resultTpHonnoJi4.
  ///
  /// In ja, this message translates to:
  /// **'敵総大将討死'**
  String get resultTpHonnoJi4;

  /// No description provided for @resultTpSekigahara1.
  ///
  /// In ja, this message translates to:
  /// **'序盤は慎重に'**
  String get resultTpSekigahara1;

  /// No description provided for @resultTpSekigahara2.
  ///
  /// In ja, this message translates to:
  /// **'味方のモラル維持'**
  String get resultTpSekigahara2;

  /// No description provided for @resultTpSekigahara3.
  ///
  /// In ja, this message translates to:
  /// **'側面を奇襲'**
  String get resultTpSekigahara3;

  /// No description provided for @resultTpSekigahara4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpSekigahara4;

  /// No description provided for @resultTpSekigahara5.
  ///
  /// In ja, this message translates to:
  /// **'豊臣武将生存'**
  String get resultTpSekigahara5;

  /// No description provided for @resultTpKawanakajima1.
  ///
  /// In ja, this message translates to:
  /// **'夜明けの奇襲に備える'**
  String get resultTpKawanakajima1;

  /// No description provided for @resultTpKawanakajima2.
  ///
  /// In ja, this message translates to:
  /// **'別働隊到着まで凌ぐ'**
  String get resultTpKawanakajima2;

  /// No description provided for @resultTpKawanakajima3.
  ///
  /// In ja, this message translates to:
  /// **'挟撃を成功させる'**
  String get resultTpKawanakajima3;

  /// No description provided for @resultTpKawanakajima4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpKawanakajima4;

  /// No description provided for @resultTpItsukushima1.
  ///
  /// In ja, this message translates to:
  /// **'暴風雨に乗じた奇襲'**
  String get resultTpItsukushima1;

  /// No description provided for @resultTpItsukushima2.
  ///
  /// In ja, this message translates to:
  /// **'宮尾城を死守'**
  String get resultTpItsukushima2;

  /// No description provided for @resultTpItsukushima3.
  ///
  /// In ja, this message translates to:
  /// **'退路を断ち包囲'**
  String get resultTpItsukushima3;

  /// No description provided for @resultTpItsukushima4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpItsukushima4;

  /// No description provided for @resultTpOshijo1.
  ///
  /// In ja, this message translates to:
  /// **'偽情報で敵を翻弄'**
  String get resultTpOshijo1;

  /// No description provided for @resultTpOshijo2.
  ///
  /// In ja, this message translates to:
  /// **'堤防決壊で敵陣を打撃'**
  String get resultTpOshijo2;

  /// No description provided for @resultTpOshijo3.
  ///
  /// In ja, this message translates to:
  /// **'寄せ手の猛攻を耐え抜く'**
  String get resultTpOshijo3;

  /// No description provided for @resultTpOshijo4.
  ///
  /// In ja, this message translates to:
  /// **'敵将討死'**
  String get resultTpOshijo4;

  /// No description provided for @scenarioSelectTitle.
  ///
  /// In ja, this message translates to:
  /// **'シナリオを選ぶ'**
  String get scenarioSelectTitle;

  /// No description provided for @scenarioSelectHelpTooltip.
  ///
  /// In ja, this message translates to:
  /// **'ヘルプ'**
  String get scenarioSelectHelpTooltip;

  /// No description provided for @scenarioYearSuffix.
  ///
  /// In ja, this message translates to:
  /// **'{year}年'**
  String scenarioYearSuffix(int year);

  /// No description provided for @scenarioSettingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'シナリオ設定'**
  String get scenarioSettingsTitle;

  /// No description provided for @scenarioPerspectiveTitle.
  ///
  /// In ja, this message translates to:
  /// **'視点を選ぶ'**
  String get scenarioPerspectiveTitle;

  /// No description provided for @scenarioWarlordSelectTitle.
  ///
  /// In ja, this message translates to:
  /// **'出陣武将を選ぶ（任意・最大2名）'**
  String get scenarioWarlordSelectTitle;

  /// No description provided for @scenarioWarlordSelectHint.
  ///
  /// In ja, this message translates to:
  /// **'統率ステータスに応じて自軍全体の兵力が上昇します。2名選ぶと相性（同勢力・知略シナジー・統率差）に加え、1人目が先鋒隊・2人目が本隊を指揮し、各武将の武勇が担当部隊に反映されます'**
  String get scenarioWarlordSelectHint;

  /// No description provided for @scenarioWarlordAwakenedTag.
  ///
  /// In ja, this message translates to:
  /// **'覚醒'**
  String get scenarioWarlordAwakenedTag;

  /// No description provided for @scenarioWarlordChipLabel.
  ///
  /// In ja, this message translates to:
  /// **'{name} Lv.{level}{awakened} (統率{leadership})'**
  String scenarioWarlordChipLabel(
    String name,
    int level,
    String awakened,
    int leadership,
  );

  /// No description provided for @scenarioCompatibilityLabel.
  ///
  /// In ja, this message translates to:
  /// **'相性倍率: ×{multiplier}{note}'**
  String scenarioCompatibilityLabel(String multiplier, String note);

  /// No description provided for @scenarioCompatibilityPositive.
  ///
  /// In ja, this message translates to:
  /// **'（好相性）'**
  String get scenarioCompatibilityPositive;

  /// No description provided for @scenarioCompatibilityNegative.
  ///
  /// In ja, this message translates to:
  /// **'（不協和）'**
  String get scenarioCompatibilityNegative;

  /// No description provided for @scenarioDifficultyTitle.
  ///
  /// In ja, this message translates to:
  /// **'難易度を選ぶ'**
  String get scenarioDifficultyTitle;

  /// No description provided for @scenarioLoadingText.
  ///
  /// In ja, this message translates to:
  /// **'シナリオを読み込み中...'**
  String get scenarioLoadingText;

  /// No description provided for @scenarioLoadErrorText.
  ///
  /// In ja, this message translates to:
  /// **'シナリオの読み込みに失敗しました'**
  String get scenarioLoadErrorText;

  /// No description provided for @scenarioNameOdigahara.
  ///
  /// In ja, this message translates to:
  /// **'桶狭間の戦'**
  String get scenarioNameOdigahara;

  /// No description provided for @scenarioDescOdigahara.
  ///
  /// In ja, this message translates to:
  /// **'3,500 vs 15,000 — 圧倒的劣勢を奇策で覆せ'**
  String get scenarioDescOdigahara;

  /// No description provided for @scenarioPlayTimeOdigahara.
  ///
  /// In ja, this message translates to:
  /// **'3〜5分'**
  String get scenarioPlayTimeOdigahara;

  /// No description provided for @scenarioNameNagashino.
  ///
  /// In ja, this message translates to:
  /// **'長篠の戦'**
  String get scenarioNameNagashino;

  /// No description provided for @scenarioDescNagashino.
  ///
  /// In ja, this message translates to:
  /// **'防衛陣形で武田騎馬隊を迎え撃て'**
  String get scenarioDescNagashino;

  /// No description provided for @scenarioPlayTimeNagashino.
  ///
  /// In ja, this message translates to:
  /// **'4〜6分'**
  String get scenarioPlayTimeNagashino;

  /// No description provided for @scenarioNameHonnoji.
  ///
  /// In ja, this message translates to:
  /// **'本能寺の変'**
  String get scenarioNameHonnoji;

  /// No description provided for @scenarioDescHonnoji.
  ///
  /// In ja, this message translates to:
  /// **'500 vs 13,000 — 絶望的状況からの逆転'**
  String get scenarioDescHonnoji;

  /// No description provided for @scenarioPlayTimeHonnoji.
  ///
  /// In ja, this message translates to:
  /// **'5〜7分'**
  String get scenarioPlayTimeHonnoji;

  /// No description provided for @scenarioNameSekigahara.
  ///
  /// In ja, this message translates to:
  /// **'関ヶ原の戦'**
  String get scenarioNameSekigahara;

  /// No description provided for @scenarioDescSekigahara.
  ///
  /// In ja, this message translates to:
  /// **'天下分け目 — 複雑な戦局を制せよ'**
  String get scenarioDescSekigahara;

  /// No description provided for @scenarioPlayTimeSekigahara.
  ///
  /// In ja, this message translates to:
  /// **'6〜8分'**
  String get scenarioPlayTimeSekigahara;

  /// No description provided for @scenarioNameKawanakajima.
  ///
  /// In ja, this message translates to:
  /// **'川中島の戦'**
  String get scenarioNameKawanakajima;

  /// No description provided for @scenarioDescKawanakajima.
  ///
  /// In ja, this message translates to:
  /// **'夜明けの奇襲を受けた本隊のみで、別働隊到着まで持ちこたえよ'**
  String get scenarioDescKawanakajima;

  /// No description provided for @scenarioPlayTimeKawanakajima.
  ///
  /// In ja, this message translates to:
  /// **'4〜6分'**
  String get scenarioPlayTimeKawanakajima;

  /// No description provided for @scenarioNameItsukushima.
  ///
  /// In ja, this message translates to:
  /// **'厳島の戦'**
  String get scenarioNameItsukushima;

  /// No description provided for @scenarioNameOshijo.
  ///
  /// In ja, this message translates to:
  /// **'忍城の戦い'**
  String get scenarioNameOshijo;

  /// No description provided for @scenarioDescItsukushima.
  ///
  /// In ja, this message translates to:
  /// **'4,000 vs 15,000 — 暴風雨に乗じた奇襲で殲滅せよ'**
  String get scenarioDescItsukushima;

  /// No description provided for @scenarioPlayTimeItsukushima.
  ///
  /// In ja, this message translates to:
  /// **'4〜5分'**
  String get scenarioPlayTimeItsukushima;

  /// No description provided for @scenarioDescOshijo.
  ///
  /// In ja, this message translates to:
  /// **'3,000 vs 20,000 — 水攻めに耐え、寡兵で大軍を退けよ'**
  String get scenarioDescOshijo;

  /// No description provided for @scenarioPlayTimeOshijo.
  ///
  /// In ja, this message translates to:
  /// **'4〜5分'**
  String get scenarioPlayTimeOshijo;

  /// No description provided for @tutorialTitle.
  ///
  /// In ja, this message translates to:
  /// **'初陣：采配の基本'**
  String get tutorialTitle;

  /// No description provided for @tutorialPaceSelectTitle.
  ///
  /// In ja, this message translates to:
  /// **'進め方を選ぶ'**
  String get tutorialPaceSelectTitle;

  /// No description provided for @tutorialPaceThoroughButton.
  ///
  /// In ja, this message translates to:
  /// **'じっくり学ぶ（解説つき）'**
  String get tutorialPaceThoroughButton;

  /// No description provided for @tutorialPaceBriskButton.
  ///
  /// In ja, this message translates to:
  /// **'駆け足で済ませる（解説なし）'**
  String get tutorialPaceBriskButton;

  /// No description provided for @tutorialEnemyBaseLabel.
  ///
  /// In ja, this message translates to:
  /// **'敵本陣'**
  String get tutorialEnemyBaseLabel;

  /// No description provided for @tutorialVictoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'初陣、勝利！'**
  String get tutorialVictoryTitle;

  /// No description provided for @tutorialVictoryMessage.
  ///
  /// In ja, this message translates to:
  /// **'奇襲・盾陣・激励・突撃…\n采配次第で劣勢は覆せる。\nさあ、本当の戦場へ。'**
  String get tutorialVictoryMessage;

  /// No description provided for @tutorialStartJourneyButton.
  ///
  /// In ja, this message translates to:
  /// **'武将としての旅を始める'**
  String get tutorialStartJourneyButton;

  /// No description provided for @tutorialStepAmbushLabel.
  ///
  /// In ja, this message translates to:
  /// **'奇襲'**
  String get tutorialStepAmbushLabel;

  /// No description provided for @tutorialStepAmbushPrompt.
  ///
  /// In ja, this message translates to:
  /// **'兵力は敵の数分の一…正面からでは勝てない。\nまずは「奇襲」で敵の側面を突こう。'**
  String get tutorialStepAmbushPrompt;

  /// No description provided for @tutorialStepAmbushResult.
  ///
  /// In ja, this message translates to:
  /// **'奇襲成功！敵陣が崩れ、大きな打撃を与えた。'**
  String get tutorialStepAmbushResult;

  /// No description provided for @tutorialStepShieldLabel.
  ///
  /// In ja, this message translates to:
  /// **'盾陣'**
  String get tutorialStepShieldLabel;

  /// No description provided for @tutorialStepShieldPrompt.
  ///
  /// In ja, this message translates to:
  /// **'敵の反撃が始まる。「盾陣」で守りを固め、\n被害を抑えよう。'**
  String get tutorialStepShieldPrompt;

  /// No description provided for @tutorialStepShieldResult.
  ///
  /// In ja, this message translates to:
  /// **'盾陣を展開！味方の防御力が大きく上がった。'**
  String get tutorialStepShieldResult;

  /// No description provided for @tutorialStepRallyLabel.
  ///
  /// In ja, this message translates to:
  /// **'激励'**
  String get tutorialStepRallyLabel;

  /// No description provided for @tutorialStepRallyPrompt.
  ///
  /// In ja, this message translates to:
  /// **'味方の士気を「激励」で高め、\n攻撃力を引き上げよう。'**
  String get tutorialStepRallyPrompt;

  /// No description provided for @tutorialStepRallyResult.
  ///
  /// In ja, this message translates to:
  /// **'将兵の士気が上がり、攻撃力が上昇した！'**
  String get tutorialStepRallyResult;

  /// No description provided for @tutorialStepChargeLabel.
  ///
  /// In ja, this message translates to:
  /// **'突撃'**
  String get tutorialStepChargeLabel;

  /// No description provided for @tutorialStepChargePrompt.
  ///
  /// In ja, this message translates to:
  /// **'敵は崩れかけている。最後は「突撃」で\n一気に畳み掛けよう！'**
  String get tutorialStepChargePrompt;

  /// No description provided for @tutorialStepChargeResult.
  ///
  /// In ja, this message translates to:
  /// **'全軍突撃！敵将本陣を突き崩し、勝利を掴んだ！'**
  String get tutorialStepChargeResult;

  /// No description provided for @chainBattleTitle.
  ///
  /// In ja, this message translates to:
  /// **'連戦モード'**
  String get chainBattleTitle;

  /// No description provided for @chainBattleDifficultyIntro.
  ///
  /// In ja, this message translates to:
  /// **'連戦モードは全{count}戦を休憩なしで攻略します。ステージが進むほど自軍兵力が疲労で減少します。難易度を選んでください。'**
  String chainBattleDifficultyIntro(int count);

  /// No description provided for @chainBattleStageLabel.
  ///
  /// In ja, this message translates to:
  /// **'ステージ {current} / {total}'**
  String chainBattleStageLabel(int current, int total);

  /// No description provided for @chainBattleFatigueMultiplier.
  ///
  /// In ja, this message translates to:
  /// **'疲労による兵力倍率: ×{multiplier}'**
  String chainBattleFatigueMultiplier(String multiplier);

  /// No description provided for @chainBattleResultLine.
  ///
  /// In ja, this message translates to:
  /// **'{scenario}: {result}（{score}点）'**
  String chainBattleResultLine(String scenario, String result, int score);

  /// No description provided for @chainBattleWin.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get chainBattleWin;

  /// No description provided for @chainBattleLoss.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get chainBattleLoss;

  /// No description provided for @chainSummaryTitle.
  ///
  /// In ja, this message translates to:
  /// **'連戦終了'**
  String get chainSummaryTitle;

  /// No description provided for @chainSummaryWins.
  ///
  /// In ja, this message translates to:
  /// **'{wins} / {total} 勝利'**
  String chainSummaryWins(int wins, int total);

  /// No description provided for @chainSummaryTotalScore.
  ///
  /// In ja, this message translates to:
  /// **'合計スコア: {score}点'**
  String chainSummaryTotalScore(int score);

  /// No description provided for @chainSummaryResultLine.
  ///
  /// In ja, this message translates to:
  /// **'{result} {score}点'**
  String chainSummaryResultLine(String result, int score);

  /// No description provided for @chainSummaryHomeButton.
  ///
  /// In ja, this message translates to:
  /// **'ホームに戻る'**
  String get chainSummaryHomeButton;

  /// No description provided for @chainCompletionAdLabel.
  ///
  /// In ja, this message translates to:
  /// **'広告を見て連戦の労をねぎらうボーナス{amount}ゴールドを獲得'**
  String chainCompletionAdLabel(int amount);

  /// No description provided for @prestigeResetTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジ'**
  String get prestigeResetTitle;

  /// No description provided for @prestigeResetSuccessMessage.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセットが完了しました！'**
  String get prestigeResetSuccessMessage;

  /// No description provided for @prestigeResetErrorMessage.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました: {error}'**
  String prestigeResetErrorMessage(String error);

  /// No description provided for @prestigeResetLockedLevelReason.
  ///
  /// In ja, this message translates to:
  /// **'レベル100に到達してください'**
  String get prestigeResetLockedLevelReason;

  /// No description provided for @prestigeResetLockedPointsReason.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジポイント1000以上が必要です\n現在: {points}'**
  String prestigeResetLockedPointsReason(int points);

  /// No description provided for @prestigeResetCurrentRankLabel.
  ///
  /// In ja, this message translates to:
  /// **'現在のプレスティジランク'**
  String get prestigeResetCurrentRankLabel;

  /// No description provided for @prestigeResetCountSuffix.
  ///
  /// In ja, this message translates to:
  /// **'リセット回数: {count}回'**
  String prestigeResetCountSuffix(int count);

  /// No description provided for @prestigeResetLockedTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジが利用できません'**
  String get prestigeResetLockedTitle;

  /// No description provided for @prestigeResetActionTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセット実行'**
  String get prestigeResetActionTitle;

  /// No description provided for @prestigeResetActionDescription.
  ///
  /// In ja, this message translates to:
  /// **'条件を満たしています。プレスティジリセットを実行できます。'**
  String get prestigeResetActionDescription;

  /// No description provided for @prestigeResetProcessing.
  ///
  /// In ja, this message translates to:
  /// **'処理中...'**
  String get prestigeResetProcessing;

  /// No description provided for @prestigeResetBenefitsTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジについて'**
  String get prestigeResetBenefitsTitle;

  /// No description provided for @prestigeResetBenefit1Title.
  ///
  /// In ja, this message translates to:
  /// **'レベルとXPがリセット'**
  String get prestigeResetBenefit1Title;

  /// No description provided for @prestigeResetBenefit1Desc.
  ///
  /// In ja, this message translates to:
  /// **'レベルが1に戻り、XPが0にリセットされます'**
  String get prestigeResetBenefit1Desc;

  /// No description provided for @prestigeResetBenefit2Title.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジランク上昇'**
  String get prestigeResetBenefit2Title;

  /// No description provided for @prestigeResetBenefit2Desc.
  ///
  /// In ja, this message translates to:
  /// **'ターン効率に基づいて新しいランクが決定されます'**
  String get prestigeResetBenefit2Desc;

  /// No description provided for @prestigeResetBenefit3Title.
  ///
  /// In ja, this message translates to:
  /// **'限定コスメティック解放'**
  String get prestigeResetBenefit3Title;

  /// No description provided for @prestigeResetBenefit3Desc.
  ///
  /// In ja, this message translates to:
  /// **'新しいランクに対応した限定スキンやテーマが解放されます'**
  String get prestigeResetBenefit3Desc;

  /// No description provided for @prestigeResetBenefit4Title.
  ///
  /// In ja, this message translates to:
  /// **'次回リセット条件が上昇'**
  String get prestigeResetBenefit4Title;

  /// No description provided for @prestigeResetBenefit4Desc.
  ///
  /// In ja, this message translates to:
  /// **'より多くのプレスティジポイントが必要になります'**
  String get prestigeResetBenefit4Desc;

  /// No description provided for @prestigeResetConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセット確認'**
  String get prestigeResetConfirmTitle;

  /// No description provided for @prestigeResetConfirmIntro.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセットを実行します。以下の内容で問題ありませんか？'**
  String get prestigeResetConfirmIntro;

  /// No description provided for @prestigeResetConfirmCurrentLevel.
  ///
  /// In ja, this message translates to:
  /// **'現在のレベル'**
  String get prestigeResetConfirmCurrentLevel;

  /// No description provided for @prestigeResetConfirmRank.
  ///
  /// In ja, this message translates to:
  /// **'リセット後のランク'**
  String get prestigeResetConfirmRank;

  /// No description provided for @prestigeResetIrreversibleWarning.
  ///
  /// In ja, this message translates to:
  /// **'この操作は取り消せません'**
  String get prestigeResetIrreversibleWarning;

  /// No description provided for @prestigeResetConfirmExecuteButton.
  ///
  /// In ja, this message translates to:
  /// **'リセットを実行'**
  String get prestigeResetConfirmExecuteButton;

  /// No description provided for @cosmeticsEquipTitle.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック設定'**
  String get cosmeticsEquipTitle;

  /// No description provided for @cosmeticsEquipSuccess.
  ///
  /// In ja, this message translates to:
  /// **'コスメティックを装備しました'**
  String get cosmeticsEquipSuccess;

  /// No description provided for @cosmeticsUnequipSuccess.
  ///
  /// In ja, this message translates to:
  /// **'コスメティックを外しました'**
  String get cosmeticsUnequipSuccess;

  /// No description provided for @cosmeticsUnitSkinTitle.
  ///
  /// In ja, this message translates to:
  /// **'ユニットスキン'**
  String get cosmeticsUnitSkinTitle;

  /// No description provided for @cosmeticsUiThemeTitle.
  ///
  /// In ja, this message translates to:
  /// **'UIテーマ'**
  String get cosmeticsUiThemeTitle;

  /// No description provided for @cosmeticsEquippedLabel.
  ///
  /// In ja, this message translates to:
  /// **'装備中:'**
  String get cosmeticsEquippedLabel;

  /// No description provided for @cosmeticsUnknownName.
  ///
  /// In ja, this message translates to:
  /// **'不明'**
  String get cosmeticsUnknownName;

  /// No description provided for @cosmeticsUnequipButton.
  ///
  /// In ja, this message translates to:
  /// **'外す'**
  String get cosmeticsUnequipButton;

  /// No description provided for @cosmeticsEquippedBadge.
  ///
  /// In ja, this message translates to:
  /// **'装備中'**
  String get cosmeticsEquippedBadge;

  /// No description provided for @cosmeticsEquipButton.
  ///
  /// In ja, this message translates to:
  /// **'装備する'**
  String get cosmeticsEquipButton;

  /// No description provided for @cosmeticsNoCosmeticsTitle.
  ///
  /// In ja, this message translates to:
  /// **'{type}はまだ解放されていません'**
  String cosmeticsNoCosmeticsTitle(String type);

  /// No description provided for @cosmeticsNoCosmeticsHint.
  ///
  /// In ja, this message translates to:
  /// **'レベルアップやプレスティジで解放されます'**
  String get cosmeticsNoCosmeticsHint;

  /// No description provided for @cosmeticsAcquisitionLevelMilestone.
  ///
  /// In ja, this message translates to:
  /// **'レベル報酬'**
  String get cosmeticsAcquisitionLevelMilestone;

  /// No description provided for @cosmeticsAcquisitionAchievement.
  ///
  /// In ja, this message translates to:
  /// **'アチーブメント'**
  String get cosmeticsAcquisitionAchievement;

  /// No description provided for @cosmeticsAcquisitionPrestige.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジ報酬'**
  String get cosmeticsAcquisitionPrestige;

  /// No description provided for @cosmeticsAcquisitionBattlePass.
  ///
  /// In ja, this message translates to:
  /// **'バトルパス'**
  String get cosmeticsAcquisitionBattlePass;

  /// No description provided for @cosmeticsAcquisitionEvent.
  ///
  /// In ja, this message translates to:
  /// **'イベント報酬'**
  String get cosmeticsAcquisitionEvent;

  /// No description provided for @cosmeticsPrestigeRankLabel.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジランク'**
  String get cosmeticsPrestigeRankLabel;

  /// No description provided for @cosmeticsResetCountLabel.
  ///
  /// In ja, this message translates to:
  /// **'リセット回数: {count}'**
  String cosmeticsResetCountLabel(int count);

  /// No description provided for @cosmeticsPointsLabel.
  ///
  /// In ja, this message translates to:
  /// **'ポイント: {points}'**
  String cosmeticsPointsLabel(int points);

  /// No description provided for @cosmeticsShowcaseTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジコスメティック'**
  String get cosmeticsShowcaseTitle;

  /// No description provided for @cosmeticsShowcaseRankLine.
  ///
  /// In ja, this message translates to:
  /// **'ランク: {rank}'**
  String cosmeticsShowcaseRankLine(String rank);

  /// No description provided for @cosmeticsShowcaseEquippedSkinLabel.
  ///
  /// In ja, this message translates to:
  /// **'装備中のユニットスキン'**
  String get cosmeticsShowcaseEquippedSkinLabel;

  /// No description provided for @cosmeticsShowcaseEquippedThemeLabel.
  ///
  /// In ja, this message translates to:
  /// **'装備中のUIテーマ'**
  String get cosmeticsShowcaseEquippedThemeLabel;

  /// No description provided for @cosmeticsShowcaseEmpty.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジコスメティックがまだ装備されていません'**
  String get cosmeticsShowcaseEmpty;

  /// No description provided for @cosmeticsPrestigeSectionEmptyHint.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセットを行うと解放されます'**
  String get cosmeticsPrestigeSectionEmptyHint;

  /// No description provided for @cosmeticsPrestigeCurrentRankLine.
  ///
  /// In ja, this message translates to:
  /// **'現在のプレスティジランク: {rank}'**
  String cosmeticsPrestigeCurrentRankLine(String rank);

  /// No description provided for @cosmeticsPrestigeUnitSkinTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジユニットスキン'**
  String get cosmeticsPrestigeUnitSkinTitle;

  /// No description provided for @cosmeticsPrestigeUiThemeTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジUIテーマ'**
  String get cosmeticsPrestigeUiThemeTitle;

  /// No description provided for @cosmeticsPrestigeTierSilver.
  ///
  /// In ja, this message translates to:
  /// **'シルバー'**
  String get cosmeticsPrestigeTierSilver;

  /// No description provided for @cosmeticsPrestigeTierGold.
  ///
  /// In ja, this message translates to:
  /// **'ゴールド'**
  String get cosmeticsPrestigeTierGold;

  /// No description provided for @cosmeticsPrestigeTierPlatinum.
  ///
  /// In ja, this message translates to:
  /// **'プラチナ'**
  String get cosmeticsPrestigeTierPlatinum;

  /// No description provided for @cosmeticsPrestigeTierDiamond.
  ///
  /// In ja, this message translates to:
  /// **'ダイヤモンド'**
  String get cosmeticsPrestigeTierDiamond;

  /// No description provided for @cosmeticsPrestigeTierUnknown.
  ///
  /// In ja, this message translates to:
  /// **'不明'**
  String get cosmeticsPrestigeTierUnknown;

  /// No description provided for @friendsTitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンド'**
  String get friendsTitle;

  /// No description provided for @friendsAddedSuccess.
  ///
  /// In ja, this message translates to:
  /// **'フレンドを追加しました！'**
  String get friendsAddedSuccess;

  /// No description provided for @friendsAddFailed.
  ///
  /// In ja, this message translates to:
  /// **'コードが無効か、既にフレンド登録済みです'**
  String get friendsAddFailed;

  /// No description provided for @friendsChallengeScenarioTitle.
  ///
  /// In ja, this message translates to:
  /// **'挑戦するシナリオを選ぶ'**
  String get friendsChallengeScenarioTitle;

  /// No description provided for @friendsNoRecordYet.
  ///
  /// In ja, this message translates to:
  /// **'このフレンドはまだこのシナリオの記録がありません'**
  String get friendsNoRecordYet;

  /// No description provided for @friendsChallengeSetMessage.
  ///
  /// In ja, this message translates to:
  /// **'目標設定: {friend}の{scenario}スコア {score}点を超えよう！シナリオ選択から出陣してください'**
  String friendsChallengeSetMessage(String friend, String scenario, int score);

  /// No description provided for @friendsShareMyCodeText.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録で対戦しよう！\nフレンドコード: {code}'**
  String friendsShareMyCodeText(String code);

  /// No description provided for @friendsCopySuccess.
  ///
  /// In ja, this message translates to:
  /// **'フレンドコードをコピーしました'**
  String get friendsCopySuccess;

  /// No description provided for @friendsMyCodeLabel.
  ///
  /// In ja, this message translates to:
  /// **'あなたのフレンドコード'**
  String get friendsMyCodeLabel;

  /// No description provided for @friendsCopyButton.
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get friendsCopyButton;

  /// No description provided for @friendsShareButton.
  ///
  /// In ja, this message translates to:
  /// **'共有'**
  String get friendsShareButton;

  /// No description provided for @friendsAddFriendTitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンドを追加'**
  String get friendsAddFriendTitle;

  /// No description provided for @friendsCodeHint.
  ///
  /// In ja, this message translates to:
  /// **'フレンドコードを入力'**
  String get friendsCodeHint;

  /// No description provided for @friendsAddButton.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get friendsAddButton;

  /// No description provided for @friendsRankingTitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンドランキング（合計スコア）'**
  String get friendsRankingTitle;

  /// No description provided for @friendsNoRecordsYet.
  ///
  /// In ja, this message translates to:
  /// **'まだ戦績がありません'**
  String get friendsNoRecordsYet;

  /// No description provided for @friendsRecentActivityTitle.
  ///
  /// In ja, this message translates to:
  /// **'最近の戦績'**
  String get friendsRecentActivityTitle;

  /// No description provided for @friendsListTitle.
  ///
  /// In ja, this message translates to:
  /// **'フレンド一覧 ({count})'**
  String friendsListTitle(int count);

  /// No description provided for @friendsNoFriendsYet.
  ///
  /// In ja, this message translates to:
  /// **'まだフレンドがいません'**
  String get friendsNoFriendsYet;

  /// No description provided for @friendsYouLabel.
  ///
  /// In ja, this message translates to:
  /// **'あなた'**
  String get friendsYouLabel;

  /// No description provided for @friendsActivityLine.
  ///
  /// In ja, this message translates to:
  /// **'{player} が{scenario}で{result}'**
  String friendsActivityLine(String player, String scenario, String result);

  /// No description provided for @friendsChallengeTooltip.
  ///
  /// In ja, this message translates to:
  /// **'挑戦する'**
  String get friendsChallengeTooltip;

  /// No description provided for @onboardingSkipButton.
  ///
  /// In ja, this message translates to:
  /// **'スキップ'**
  String get onboardingSkipButton;

  /// No description provided for @onboardingNextButton.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get onboardingNextButton;

  /// No description provided for @onboardingStartButton.
  ///
  /// In ja, this message translates to:
  /// **'初陣へ'**
  String get onboardingStartButton;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録へようこそ'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Description.
  ///
  /// In ja, this message translates to:
  /// **'桶狭間、本能寺、関ヶ原…\n兵力で劣る武将となり、采配一つで\n歴史に残る大逆転劇を実現せよ。'**
  String get onboardingPage1Description;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In ja, this message translates to:
  /// **'圧倒的劣勢から始まる'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Description.
  ///
  /// In ja, this message translates to:
  /// **'多くのシナリオでは、敵の兵力が\nあなたの数倍〜十数倍に達する。\n正面からの力押しでは勝てない。'**
  String get onboardingPage2Description;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In ja, this message translates to:
  /// **'コマンドで戦況を動かす'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In ja, this message translates to:
  /// **'奇襲・盾陣・進軍・撤退・鼓舞・突撃…\n状況に応じたコマンドの選択こそが\n勝敗を分ける采配の要。'**
  String get onboardingPage3Description;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In ja, this message translates to:
  /// **'ターニングポイントを狙え'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Description.
  ///
  /// In ja, this message translates to:
  /// **'各シナリオには史実に基づいた\n「ターニングポイント」が用意されている。\n条件を満たして達成し、高得点を狙おう。'**
  String get onboardingPage4Description;

  /// No description provided for @onboardingPage5Title.
  ///
  /// In ja, this message translates to:
  /// **'成長し続ける武将'**
  String get onboardingPage5Title;

  /// No description provided for @onboardingPage5Description.
  ///
  /// In ja, this message translates to:
  /// **'レベル・実績・バトルパス・プレスティジ…\n戦えば戦うほど武将は成長する。\nさあ、初陣の采配を振るおう！'**
  String get onboardingPage5Description;

  /// No description provided for @replayWatchSharedTooltip.
  ///
  /// In ja, this message translates to:
  /// **'共有コードで観戦'**
  String get replayWatchSharedTooltip;

  /// No description provided for @replayDeleteConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除確認'**
  String get replayDeleteConfirmTitle;

  /// No description provided for @replayDeleteConfirmBody.
  ///
  /// In ja, this message translates to:
  /// **'このリプレイを削除しますか？'**
  String get replayDeleteConfirmBody;

  /// No description provided for @replayDeleteButton.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get replayDeleteButton;

  /// No description provided for @replayShareIssuingCode.
  ///
  /// In ja, this message translates to:
  /// **'共有コードを発行中...'**
  String get replayShareIssuingCode;

  /// No description provided for @replayShareCodeTitle.
  ///
  /// In ja, this message translates to:
  /// **'共有コード'**
  String get replayShareCodeTitle;

  /// No description provided for @replayShareCodeHint.
  ///
  /// In ja, this message translates to:
  /// **'このコードをフレンドに伝えると観戦できます'**
  String get replayShareCodeHint;

  /// No description provided for @replayShareButton.
  ///
  /// In ja, this message translates to:
  /// **'共有する'**
  String get replayShareButton;

  /// No description provided for @replayShareMenuItem.
  ///
  /// In ja, this message translates to:
  /// **'共有'**
  String get replayShareMenuItem;

  /// No description provided for @replayShareFailure.
  ///
  /// In ja, this message translates to:
  /// **'共有に失敗しました: {error}'**
  String replayShareFailure(String error);

  /// No description provided for @replayShareText.
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録のリプレイを見てください！\n共有コード: {code}'**
  String replayShareText(String code);

  /// No description provided for @replayCodeEntryTitle.
  ///
  /// In ja, this message translates to:
  /// **'共有コードで観戦'**
  String get replayCodeEntryTitle;

  /// No description provided for @replayCodeEntryHint.
  ///
  /// In ja, this message translates to:
  /// **'例: A3F9QZ'**
  String get replayCodeEntryHint;

  /// No description provided for @replayWatchButton.
  ///
  /// In ja, this message translates to:
  /// **'観戦する'**
  String get replayWatchButton;

  /// No description provided for @replayFetchingReplay.
  ///
  /// In ja, this message translates to:
  /// **'リプレイを取得中...'**
  String get replayFetchingReplay;

  /// No description provided for @replayNotFound.
  ///
  /// In ja, this message translates to:
  /// **'リプレイが見つかりませんでした'**
  String get replayNotFound;

  /// No description provided for @replayFilterAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get replayFilterAll;

  /// No description provided for @replayEmptyMessage.
  ///
  /// In ja, this message translates to:
  /// **'リプレイがありません'**
  String get replayEmptyMessage;

  /// No description provided for @replayLikeCountSuffix.
  ///
  /// In ja, this message translates to:
  /// **'{count} いいね'**
  String replayLikeCountSuffix(int count);

  /// No description provided for @replayCommentHint.
  ///
  /// In ja, this message translates to:
  /// **'コメントを残す'**
  String get replayCommentHint;

  /// No description provided for @replayStatsTotalLabel.
  ///
  /// In ja, this message translates to:
  /// **'総リプレイ数'**
  String get replayStatsTotalLabel;

  /// No description provided for @replayStatsWinRateLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝率'**
  String get replayStatsWinRateLabel;

  /// No description provided for @replayStatsAverageScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'平均スコア'**
  String get replayStatsAverageScoreLabel;

  /// No description provided for @replayStatsWinLossLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝/敗'**
  String get replayStatsWinLossLabel;

  /// No description provided for @replayDifficultyScoreLine.
  ///
  /// In ja, this message translates to:
  /// **'{difficulty} • スコア: {score}'**
  String replayDifficultyScoreLine(String difficulty, int score);

  /// No description provided for @battlePassTitle.
  ///
  /// In ja, this message translates to:
  /// **'バトルパス'**
  String get battlePassTitle;

  /// No description provided for @battlePassPremiumUnlockedSnackbar.
  ///
  /// In ja, this message translates to:
  /// **'プレミアムトラックを解放しました！'**
  String get battlePassPremiumUnlockedSnackbar;

  /// No description provided for @battlePassPurchaseFailedSnackbar.
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました: {error}'**
  String battlePassPurchaseFailedSnackbar(String error);

  /// No description provided for @battlePassUnknownError.
  ///
  /// In ja, this message translates to:
  /// **'不明なエラー'**
  String get battlePassUnknownError;

  /// No description provided for @battlePassSeasonEndLabel.
  ///
  /// In ja, this message translates to:
  /// **'シーズン終了'**
  String get battlePassSeasonEndLabel;

  /// No description provided for @battlePassSeasonEndDate.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String battlePassSeasonEndDate(int year, int month, int day);

  /// No description provided for @battlePassDaysRemainingLabel.
  ///
  /// In ja, this message translates to:
  /// **'残り日数'**
  String get battlePassDaysRemainingLabel;

  /// No description provided for @battlePassDaysRemainingValue.
  ///
  /// In ja, this message translates to:
  /// **'{days}日'**
  String battlePassDaysRemainingValue(int days);

  /// No description provided for @battlePassStoreUnavailable.
  ///
  /// In ja, this message translates to:
  /// **'ストア利用不可'**
  String get battlePassStoreUnavailable;

  /// No description provided for @battlePassPremiumUnlockTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレミアムトラックを解放'**
  String get battlePassPremiumUnlockTitle;

  /// No description provided for @battlePassPremiumUnlockDescription.
  ///
  /// In ja, this message translates to:
  /// **'現在のティアまでのプレミアム限定報酬をすべて即座に獲得し、以降のティアアップでも継続してプレミアム報酬を受け取れます。'**
  String get battlePassPremiumUnlockDescription;

  /// No description provided for @battlePassMissedRewardWarning.
  ///
  /// In ja, this message translates to:
  /// **'すでに{count}件のプレミアム報酬を受け取り逃しています！'**
  String battlePassMissedRewardWarning(int count);

  /// No description provided for @battlePassUnlockForPrice.
  ///
  /// In ja, this message translates to:
  /// **'{priceLabel} で解放する'**
  String battlePassUnlockForPrice(String priceLabel);

  /// No description provided for @battlePassRestorePurchase.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元'**
  String get battlePassRestorePurchase;

  /// No description provided for @battlePassTierRewardsTitle.
  ///
  /// In ja, this message translates to:
  /// **'ティア報酬'**
  String get battlePassTierRewardsTitle;

  /// No description provided for @battlePassCurrentTierLabel.
  ///
  /// In ja, this message translates to:
  /// **'現在のティア'**
  String get battlePassCurrentTierLabel;

  /// No description provided for @battlePassTierOfMax.
  ///
  /// In ja, this message translates to:
  /// **'ティア {current} / {max}'**
  String battlePassTierOfMax(int current, int max);

  /// No description provided for @battlePassPremiumBadge.
  ///
  /// In ja, this message translates to:
  /// **'プレミアム'**
  String get battlePassPremiumBadge;

  /// No description provided for @battlePassProgressLabel.
  ///
  /// In ja, this message translates to:
  /// **'進捗'**
  String get battlePassProgressLabel;

  /// No description provided for @battlePassXpOfTotal.
  ///
  /// In ja, this message translates to:
  /// **'{current} / {total}'**
  String battlePassXpOfTotal(int current, int total);

  /// No description provided for @battlePassXpUntilNextTier.
  ///
  /// In ja, this message translates to:
  /// **'次のティアまで {xp} XP'**
  String battlePassXpUntilNextTier(int xp);

  /// No description provided for @battlePassMaxTierReached.
  ///
  /// In ja, this message translates to:
  /// **'最大ティアに達成しました！'**
  String get battlePassMaxTierReached;

  /// No description provided for @battlePassFreeBadge.
  ///
  /// In ja, this message translates to:
  /// **'フリー'**
  String get battlePassFreeBadge;

  /// No description provided for @battleScenarioLoadError.
  ///
  /// In ja, this message translates to:
  /// **'シナリオの読み込みに失敗しました: {error}'**
  String battleScenarioLoadError(String error);

  /// No description provided for @battlePlayerSideLabel.
  ///
  /// In ja, this message translates to:
  /// **'味方'**
  String get battlePlayerSideLabel;

  /// No description provided for @battleEnemySideLabel.
  ///
  /// In ja, this message translates to:
  /// **'敵'**
  String get battleEnemySideLabel;

  /// No description provided for @battleTpCounter.
  ///
  /// In ja, this message translates to:
  /// **'TP: {count} / {total}'**
  String battleTpCounter(int count, int total);

  /// No description provided for @battleComboCounter.
  ///
  /// In ja, this message translates to:
  /// **'コンボ: {count}'**
  String battleComboCounter(int count);

  /// No description provided for @battleCommandScore.
  ///
  /// In ja, this message translates to:
  /// **'采配: {score}'**
  String battleCommandScore(int score);

  /// No description provided for @battleCommandAdvance.
  ///
  /// In ja, this message translates to:
  /// **'進軍'**
  String get battleCommandAdvance;

  /// No description provided for @battleCommandRetreat.
  ///
  /// In ja, this message translates to:
  /// **'撤退'**
  String get battleCommandRetreat;

  /// No description provided for @battleCommandWait.
  ///
  /// In ja, this message translates to:
  /// **'待機'**
  String get battleCommandWait;

  /// No description provided for @battleCommandAmbush.
  ///
  /// In ja, this message translates to:
  /// **'奇襲'**
  String get battleCommandAmbush;

  /// No description provided for @battleCommandCharge.
  ///
  /// In ja, this message translates to:
  /// **'突撃'**
  String get battleCommandCharge;

  /// No description provided for @battleCommandRally.
  ///
  /// In ja, this message translates to:
  /// **'激励'**
  String get battleCommandRally;

  /// No description provided for @battleCommandShield.
  ///
  /// In ja, this message translates to:
  /// **'盾陣'**
  String get battleCommandShield;

  /// No description provided for @battleCommandFormation.
  ///
  /// In ja, this message translates to:
  /// **'陣形'**
  String get battleCommandFormation;

  /// No description provided for @battleCommandSpecialLabel.
  ///
  /// In ja, this message translates to:
  /// **'特殊'**
  String get battleCommandSpecialLabel;

  /// No description provided for @battleTurningPointAchievedTitle.
  ///
  /// In ja, this message translates to:
  /// **'ターニングポイント達成！'**
  String get battleTurningPointAchievedTitle;

  /// No description provided for @battleTurningPointRewardLine.
  ///
  /// In ja, this message translates to:
  /// **'{name}  +{points}点'**
  String battleTurningPointRewardLine(String name, int points);

  /// No description provided for @battleMomentumEnemyLabel.
  ///
  /// In ja, this message translates to:
  /// **'敵優勢'**
  String get battleMomentumEnemyLabel;

  /// No description provided for @battleMomentumPlayerLabel.
  ///
  /// In ja, this message translates to:
  /// **'味方優勢'**
  String get battleMomentumPlayerLabel;

  /// No description provided for @achievementConditionBattleWins.
  ///
  /// In ja, this message translates to:
  /// **'戦闘勝利'**
  String get achievementConditionBattleWins;

  /// No description provided for @achievementConditionLevelReached.
  ///
  /// In ja, this message translates to:
  /// **'レベル到達'**
  String get achievementConditionLevelReached;

  /// No description provided for @achievementConditionPrestigeRank.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジランク'**
  String get achievementConditionPrestigeRank;

  /// No description provided for @achievementConditionTurnEfficiency.
  ///
  /// In ja, this message translates to:
  /// **'ターン効率'**
  String get achievementConditionTurnEfficiency;

  /// No description provided for @achievementConditionCosmeticUnlocked.
  ///
  /// In ja, this message translates to:
  /// **'コスメティック解放'**
  String get achievementConditionCosmeticUnlocked;

  /// No description provided for @achievementConditionTotalPlayTime.
  ///
  /// In ja, this message translates to:
  /// **'プレイ時間'**
  String get achievementConditionTotalPlayTime;

  /// No description provided for @achievementConditionScenarioCleared.
  ///
  /// In ja, this message translates to:
  /// **'シナリオクリア'**
  String get achievementConditionScenarioCleared;

  /// No description provided for @achievementConditionPerfectBattle.
  ///
  /// In ja, this message translates to:
  /// **'パーフェクト戦闘'**
  String get achievementConditionPerfectBattle;

  /// No description provided for @achievementConditionPrestigeResetCount.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジリセット回数'**
  String get achievementConditionPrestigeResetCount;

  /// No description provided for @achievementConditionEventChallengeCompleted.
  ///
  /// In ja, this message translates to:
  /// **'イベントチャレンジ達成'**
  String get achievementConditionEventChallengeCompleted;

  /// No description provided for @achievementConditionWarlordsCollected.
  ///
  /// In ja, this message translates to:
  /// **'武将図鑑解放数'**
  String get achievementConditionWarlordsCollected;

  /// No description provided for @achievementDescBattleWins.
  ///
  /// In ja, this message translates to:
  /// **'{value} 回の戦闘に勝利'**
  String achievementDescBattleWins(int value);

  /// No description provided for @achievementDescLevelReached.
  ///
  /// In ja, this message translates to:
  /// **'レベル {value} に到達'**
  String achievementDescLevelReached(int value);

  /// No description provided for @achievementDescPrestigeRank.
  ///
  /// In ja, this message translates to:
  /// **'プレスティジランク {value}'**
  String achievementDescPrestigeRank(int value);

  /// No description provided for @achievementDescTurnEfficiency.
  ///
  /// In ja, this message translates to:
  /// **'{value} ターン以内にクリア'**
  String achievementDescTurnEfficiency(int value);

  /// No description provided for @achievementDescCosmeticUnlocked.
  ///
  /// In ja, this message translates to:
  /// **'{value} 個のコスメティックを解放'**
  String achievementDescCosmeticUnlocked(int value);

  /// No description provided for @achievementDescTotalPlayTime.
  ///
  /// In ja, this message translates to:
  /// **'総プレイ時間 {value} 時間'**
  String achievementDescTotalPlayTime(int value);

  /// No description provided for @achievementDescScenarioCleared.
  ///
  /// In ja, this message translates to:
  /// **'シナリオをクリア'**
  String get achievementDescScenarioCleared;

  /// No description provided for @achievementDescPerfectBattle.
  ///
  /// In ja, this message translates to:
  /// **'ユニットロスなしでクリア'**
  String get achievementDescPerfectBattle;

  /// No description provided for @achievementDescPrestigeResetCount.
  ///
  /// In ja, this message translates to:
  /// **'{value} 回プレスティジリセット'**
  String achievementDescPrestigeResetCount(int value);

  /// No description provided for @achievementDescEventChallengeCompleted.
  ///
  /// In ja, this message translates to:
  /// **'{value} 個のイベントチャレンジを達成'**
  String achievementDescEventChallengeCompleted(int value);

  /// No description provided for @achievementDescWarlordsCollected.
  ///
  /// In ja, this message translates to:
  /// **'{value} 人の武将を図鑑に登録'**
  String achievementDescWarlordsCollected(int value);

  /// No description provided for @achievementDetailUnlockedBadge.
  ///
  /// In ja, this message translates to:
  /// **'クリア済み'**
  String get achievementDetailUnlockedBadge;

  /// No description provided for @achievementDetailLockedBadge.
  ///
  /// In ja, this message translates to:
  /// **'ロック中'**
  String get achievementDetailLockedBadge;

  /// No description provided for @achievementDetailCategoryLabel.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー'**
  String get achievementDetailCategoryLabel;

  /// No description provided for @achievementDetailDifficultyLabel.
  ///
  /// In ja, this message translates to:
  /// **'難易度'**
  String get achievementDetailDifficultyLabel;

  /// No description provided for @achievementDetailPointsLabel.
  ///
  /// In ja, this message translates to:
  /// **'ポイント'**
  String get achievementDetailPointsLabel;

  /// No description provided for @achievementDetailDescriptionLabel.
  ///
  /// In ja, this message translates to:
  /// **'説明'**
  String get achievementDetailDescriptionLabel;

  /// No description provided for @achievementDetailConditionLabel.
  ///
  /// In ja, this message translates to:
  /// **'達成条件'**
  String get achievementDetailConditionLabel;

  /// No description provided for @achievementDetailRewardLabel.
  ///
  /// In ja, this message translates to:
  /// **'報酬'**
  String get achievementDetailRewardLabel;

  /// No description provided for @statsDashboardCombatStatsTitle.
  ///
  /// In ja, this message translates to:
  /// **'戦闘統計'**
  String get statsDashboardCombatStatsTitle;

  /// No description provided for @statsDashboardPlayTimeTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレイ時間'**
  String get statsDashboardPlayTimeTitle;

  /// No description provided for @statsDashboardScoreTitle.
  ///
  /// In ja, this message translates to:
  /// **'スコア'**
  String get statsDashboardScoreTitle;

  /// No description provided for @statsDashboardWinRateAnalysisTitle.
  ///
  /// In ja, this message translates to:
  /// **'勝率分析'**
  String get statsDashboardWinRateAnalysisTitle;

  /// No description provided for @statsDashboardTurningPointTitle.
  ///
  /// In ja, this message translates to:
  /// **'ターニングポイント'**
  String get statsDashboardTurningPointTitle;

  /// No description provided for @statsDashboardViewDetailsButton.
  ///
  /// In ja, this message translates to:
  /// **'詳細統計を見る'**
  String get statsDashboardViewDetailsButton;

  /// No description provided for @statsDashboardPointsSuffix.
  ///
  /// In ja, this message translates to:
  /// **'{points} ポイント'**
  String statsDashboardPointsSuffix(int points);

  /// No description provided for @statsDashboardAchievementsLine.
  ///
  /// In ja, this message translates to:
  /// **'アチーブメント: {unlocked}/{total}'**
  String statsDashboardAchievementsLine(int unlocked, int total);

  /// No description provided for @statsDashboardTotalBattlesLabel.
  ///
  /// In ja, this message translates to:
  /// **'総戦闘数'**
  String get statsDashboardTotalBattlesLabel;

  /// No description provided for @statsDashboardTotalWinsLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝利数'**
  String get statsDashboardTotalWinsLabel;

  /// No description provided for @statsDashboardTotalLossesLabel.
  ///
  /// In ja, this message translates to:
  /// **'敗北数'**
  String get statsDashboardTotalLossesLabel;

  /// No description provided for @statsDashboardTpAchievedLabel.
  ///
  /// In ja, this message translates to:
  /// **'TP達成数'**
  String get statsDashboardTpAchievedLabel;

  /// No description provided for @statsDashboardDurationHoursMinutes.
  ///
  /// In ja, this message translates to:
  /// **'{hours}時間 {minutes}分'**
  String statsDashboardDurationHoursMinutes(int hours, int minutes);

  /// No description provided for @statsDashboardDurationMinutesSeconds.
  ///
  /// In ja, this message translates to:
  /// **'{minutes}分 {seconds}秒'**
  String statsDashboardDurationMinutesSeconds(int minutes, int seconds);

  /// No description provided for @statsDashboardDurationSeconds.
  ///
  /// In ja, this message translates to:
  /// **'{seconds}秒'**
  String statsDashboardDurationSeconds(int seconds);

  /// No description provided for @statsDashboardTotalPlayTimeLabel.
  ///
  /// In ja, this message translates to:
  /// **'総プレイ時間'**
  String get statsDashboardTotalPlayTimeLabel;

  /// No description provided for @statsDashboardAveragePlayTimeLabel.
  ///
  /// In ja, this message translates to:
  /// **'平均戦闘時間'**
  String get statsDashboardAveragePlayTimeLabel;

  /// No description provided for @statsDashboardAverageBattleMinutes.
  ///
  /// In ja, this message translates to:
  /// **'{minutes}分'**
  String statsDashboardAverageBattleMinutes(String minutes);

  /// No description provided for @statsDashboardFirstPlayLine.
  ///
  /// In ja, this message translates to:
  /// **'初プレイ: {date}'**
  String statsDashboardFirstPlayLine(String date);

  /// No description provided for @statsDashboardLastPlayLine.
  ///
  /// In ja, this message translates to:
  /// **'最終プレイ: {date}'**
  String statsDashboardLastPlayLine(String date);

  /// No description provided for @statsDashboardTotalScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'総スコア'**
  String get statsDashboardTotalScoreLabel;

  /// No description provided for @statsDashboardAverageScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'平均スコア'**
  String get statsDashboardAverageScoreLabel;

  /// No description provided for @statsDashboardWinRateLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝率'**
  String get statsDashboardWinRateLabel;

  /// No description provided for @statsDashboardTotalTpLabel.
  ///
  /// In ja, this message translates to:
  /// **'総達成数'**
  String get statsDashboardTotalTpLabel;

  /// No description provided for @statsDashboardAverageTpLabel.
  ///
  /// In ja, this message translates to:
  /// **'平均達成数'**
  String get statsDashboardAverageTpLabel;

  /// No description provided for @advStatsWinRateLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝率'**
  String get advStatsWinRateLabel;

  /// No description provided for @advStatsTotalBattlesLabel.
  ///
  /// In ja, this message translates to:
  /// **'戦闘数'**
  String get advStatsTotalBattlesLabel;

  /// No description provided for @advStatsVictoriesLabel.
  ///
  /// In ja, this message translates to:
  /// **'勝利'**
  String get advStatsVictoriesLabel;

  /// No description provided for @advStatsDefeatsLabel.
  ///
  /// In ja, this message translates to:
  /// **'敗北'**
  String get advStatsDefeatsLabel;

  /// No description provided for @advStatsBestScoreLabel.
  ///
  /// In ja, this message translates to:
  /// **'最高スコア'**
  String get advStatsBestScoreLabel;

  /// No description provided for @advStatsDifficultyAnalysisTitle.
  ///
  /// In ja, this message translates to:
  /// **'難易度別分析'**
  String get advStatsDifficultyAnalysisTitle;

  /// No description provided for @advStatsVictoryDefeatBattleLine.
  ///
  /// In ja, this message translates to:
  /// **'{victories}勝 {defeats}敗 ({battles}戦)'**
  String advStatsVictoryDefeatBattleLine(
    int victories,
    int defeats,
    int battles,
  );

  /// No description provided for @advStatsScenariosClearedLine.
  ///
  /// In ja, this message translates to:
  /// **'{cleared}/{total}制覇'**
  String advStatsScenariosClearedLine(int cleared, int total);

  /// No description provided for @advStatsNoData.
  ///
  /// In ja, this message translates to:
  /// **'データなし'**
  String get advStatsNoData;

  /// No description provided for @advStatsScenarioRankingTitle.
  ///
  /// In ja, this message translates to:
  /// **'シナリオランキング (勝率)'**
  String get advStatsScenarioRankingTitle;

  /// No description provided for @advStatsRankSuffix.
  ///
  /// In ja, this message translates to:
  /// **'{rank}位'**
  String advStatsRankSuffix(int rank);

  /// No description provided for @advStatsVictoryDefeatLine.
  ///
  /// In ja, this message translates to:
  /// **'{victories}勝 {defeats}敗'**
  String advStatsVictoryDefeatLine(int victories, int defeats);

  /// No description provided for @advStatsAverageScoreLine.
  ///
  /// In ja, this message translates to:
  /// **'平均 {score}pt'**
  String advStatsAverageScoreLine(int score);

  /// No description provided for @helpModalTabTutorial.
  ///
  /// In ja, this message translates to:
  /// **'チュートリアル'**
  String get helpModalTabTutorial;

  /// No description provided for @helpModalTabCommands.
  ///
  /// In ja, this message translates to:
  /// **'コマンド'**
  String get helpModalTabCommands;

  /// No description provided for @helpModalTabTactics.
  ///
  /// In ja, this message translates to:
  /// **'戦術ヒント'**
  String get helpModalTabTactics;

  /// No description provided for @helpModalCloseButton.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get helpModalCloseButton;

  /// No description provided for @helpModalNoHintsForDifficulty.
  ///
  /// In ja, this message translates to:
  /// **'この難易度のヒントはありません'**
  String get helpModalNoHintsForDifficulty;

  /// No description provided for @helpModalEffectLabel.
  ///
  /// In ja, this message translates to:
  /// **'効果'**
  String get helpModalEffectLabel;

  /// No description provided for @helpModalLimitationLabel.
  ///
  /// In ja, this message translates to:
  /// **'制限事項'**
  String get helpModalLimitationLabel;

  /// No description provided for @helpModalRecommendationsLabel.
  ///
  /// In ja, this message translates to:
  /// **'推奨事項'**
  String get helpModalRecommendationsLabel;

  /// No description provided for @replayPlayerTurnLabel.
  ///
  /// In ja, this message translates to:
  /// **'ターン {turn}'**
  String replayPlayerTurnLabel(int turn);

  /// No description provided for @replayPlayerCommandUsedLabel.
  ///
  /// In ja, this message translates to:
  /// **'コマンド: {command}'**
  String replayPlayerCommandUsedLabel(String command);

  /// No description provided for @replayPlayerPlayerLabel.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー'**
  String get replayPlayerPlayerLabel;

  /// No description provided for @replayPlayerEnemyLabel.
  ///
  /// In ja, this message translates to:
  /// **'敵'**
  String get replayPlayerEnemyLabel;

  /// No description provided for @replayPlayerEventLabel.
  ///
  /// In ja, this message translates to:
  /// **'イベント'**
  String get replayPlayerEventLabel;

  /// No description provided for @replayPlayerTpAchievedBadge.
  ///
  /// In ja, this message translates to:
  /// **'✨ ターニングポイント達成'**
  String get replayPlayerTpAchievedBadge;

  /// No description provided for @replayPlayerTurnProgressLabel.
  ///
  /// In ja, this message translates to:
  /// **'ターン進行'**
  String get replayPlayerTurnProgressLabel;

  /// No description provided for @replayPlayerTurnFraction.
  ///
  /// In ja, this message translates to:
  /// **'{current}/{total}'**
  String replayPlayerTurnFraction(int current, int total);

  /// No description provided for @replayPlayerSpeedLabel.
  ///
  /// In ja, this message translates to:
  /// **'速度: '**
  String get replayPlayerSpeedLabel;

  /// No description provided for @replayPlayerHpLabel.
  ///
  /// In ja, this message translates to:
  /// **'HP'**
  String get replayPlayerHpLabel;

  /// No description provided for @replayPlayerUnitsLabel.
  ///
  /// In ja, this message translates to:
  /// **'兵力'**
  String get replayPlayerUnitsLabel;

  /// No description provided for @eventBannerRemainingDays.
  ///
  /// In ja, this message translates to:
  /// **'あと{days}日{hours}時間'**
  String eventBannerRemainingDays(int days, int hours);

  /// No description provided for @eventBannerRemainingHours.
  ///
  /// In ja, this message translates to:
  /// **'あと{hours}時間{minutes}分'**
  String eventBannerRemainingHours(int hours, int minutes);

  /// No description provided for @eventBannerRemainingMinutes.
  ///
  /// In ja, this message translates to:
  /// **'あと{minutes}分'**
  String eventBannerRemainingMinutes(int minutes);

  /// No description provided for @eventBannerLimitedEventLabel.
  ///
  /// In ja, this message translates to:
  /// **'期間限定イベント'**
  String get eventBannerLimitedEventLabel;

  /// No description provided for @eventBannerRewardMultiplier.
  ///
  /// In ja, this message translates to:
  /// **'報酬{multiplier}倍'**
  String eventBannerRewardMultiplier(String multiplier);

  /// No description provided for @eventBannerClaimRewardButton.
  ///
  /// In ja, this message translates to:
  /// **'報酬を受け取る'**
  String get eventBannerClaimRewardButton;

  /// No description provided for @eventBannerClaimedLabel.
  ///
  /// In ja, this message translates to:
  /// **'達成済み'**
  String get eventBannerClaimedLabel;

  /// No description provided for @challengeCardScenarioOdigahara.
  ///
  /// In ja, this message translates to:
  /// **'桶狭間'**
  String get challengeCardScenarioOdigahara;

  /// No description provided for @challengeCardScenarioNagashino.
  ///
  /// In ja, this message translates to:
  /// **'長篠'**
  String get challengeCardScenarioNagashino;

  /// No description provided for @challengeCardScenarioHonnoji.
  ///
  /// In ja, this message translates to:
  /// **'本能寺'**
  String get challengeCardScenarioHonnoji;

  /// No description provided for @challengeCardScenarioSekigahara.
  ///
  /// In ja, this message translates to:
  /// **'関ヶ原'**
  String get challengeCardScenarioSekigahara;

  /// No description provided for @challengeCardScenarioKawanakajima.
  ///
  /// In ja, this message translates to:
  /// **'川中島'**
  String get challengeCardScenarioKawanakajima;

  /// No description provided for @challengeCardScenarioItsukushima.
  ///
  /// In ja, this message translates to:
  /// **'厳島'**
  String get challengeCardScenarioItsukushima;

  /// No description provided for @challengeCardScenarioOshijo.
  ///
  /// In ja, this message translates to:
  /// **'忍城'**
  String get challengeCardScenarioOshijo;

  /// No description provided for @challengeCardRewardLabel.
  ///
  /// In ja, this message translates to:
  /// **'報酬'**
  String get challengeCardRewardLabel;

  /// No description provided for @challengeCardApLabel.
  ///
  /// In ja, this message translates to:
  /// **'AP'**
  String get challengeCardApLabel;

  /// No description provided for @dailyLoginTitle.
  ///
  /// In ja, this message translates to:
  /// **'本日のログインボーナス'**
  String get dailyLoginTitle;

  /// No description provided for @dailyLoginStreakLabel.
  ///
  /// In ja, this message translates to:
  /// **'連続ログイン {streak}日目'**
  String dailyLoginStreakLabel(int streak);

  /// No description provided for @dailyLoginClaimButton.
  ///
  /// In ja, this message translates to:
  /// **'受け取る'**
  String get dailyLoginClaimButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
