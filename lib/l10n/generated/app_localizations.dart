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
