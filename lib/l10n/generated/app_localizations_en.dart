// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sengoku Saihairoku';

  @override
  String get navHome => 'Home';

  @override
  String get navProfile => 'Profile';

  @override
  String get navStatistics => 'Stats';

  @override
  String get navReplay => 'Replay';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSortie => 'Sortie';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'An error occurred';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGameSection => 'Game Settings';

  @override
  String get settingsSfx => 'Sound Effects';

  @override
  String get settingsSfxSubtitle => 'SFX';

  @override
  String get settingsBgm => 'Music';

  @override
  String get settingsBgmSubtitle => 'Background music';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsDisplayLanguage => 'Display Language';

  @override
  String get settingsLanguageSystem => 'Follow system setting';

  @override
  String get settingsLanguageJa => '日本語';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDataSection => 'Data Management';

  @override
  String get settingsCloudSave => 'Cloud Save';

  @override
  String get settingsCloudSaveSubtitle => 'A Firebase account is required';

  @override
  String get settingsDeleteSaveData => 'Delete Save Data';

  @override
  String get settingsOtherSection => 'Other';

  @override
  String get settingsReplayTutorial => 'Replay Tutorial';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsComingSoon => 'Coming soon';

  @override
  String get settingsDeleteDataTitle => 'Delete your data?';

  @override
  String get settingsDeleteDataBody => 'This action cannot be undone';

  @override
  String get settingsDeleteDataConfirm => 'Delete';

  @override
  String get settingsDeleteDataSuccess => 'Your data has been deleted';

  @override
  String get settingsDeleteDataFailure => 'Failed to delete your data';

  @override
  String get challengeHistoryTitle => 'Challenge History';

  @override
  String get challengeHistoryEmpty => 'No challenge history';

  @override
  String get challengeHistoryBanner => 'Challenge history for the last 7 days';

  @override
  String get challengeHistoryToday => 'Today';

  @override
  String get challengeHistoryNoChallengeInfo => 'No challenge data';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get statisticsTitle => 'Stats';

  @override
  String get statisticsDetailTooltip => 'Detailed Stats (by Scenario / Trends)';

  @override
  String get statisticsXpSummaryTitle => 'XP Stats';

  @override
  String get statisticsXpGainedLabel => 'XP Gained';

  @override
  String get statisticsBattleCountLabel => 'Battles';

  @override
  String get statisticsAverageXpLabel => 'Avg XP';

  @override
  String get statisticsXpHistoryTitle => 'XP History';

  @override
  String get statisticsXpHistoryEmpty => 'No XP history yet';

  @override
  String get statisticsSourceBattle => 'Battle';

  @override
  String get statisticsSourceChallenge => 'Challenge';

  @override
  String get statisticsSourceAchievement => 'Achievement';

  @override
  String get statisticsSourceBattleXpBoost => 'Ad Boost';

  @override
  String get statisticsTimeJustNow => 'Just now';

  @override
  String statisticsTimeMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String statisticsTimeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String statisticsTimeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String statisticsTimeMonthDay(int month, int day) {
    return '$month/$day';
  }

  @override
  String messageScreenTitle(String scenario) {
    return 'Historical Analysis: $scenario';
  }

  @override
  String get messageScreenSubheading => 'If your command had been history';

  @override
  String get messageScreenViewpointLabel => 'View another perspective';

  @override
  String get messageScreenHome => 'Home';

  @override
  String messageScreenLoadError(String error) {
    return 'Failed to load message: $error';
  }

  @override
  String get messageScreenNotFound => 'No message found';

  @override
  String get messageKeyVictoryPerfect => 'Perfect Victory';

  @override
  String get messageKeyVictoryStandard => 'Victory';

  @override
  String get messageKeyVictoryDifficult => 'Hard-fought Victory';

  @override
  String get messageKeyDefeat => 'Defeat';

  @override
  String get messageKeyTurningPointAll => 'All Turning Points';

  @override
  String get messageKeyTurningPointMost => 'Most Turning Points';

  @override
  String get messageKeyHistoryChanged => 'History Changed';

  @override
  String get messageKeyHistoryFaithful => 'Historically Accurate';

  @override
  String get achievementListTitle => 'Achievements';

  @override
  String get achievementCategoryCombat => 'Combat';

  @override
  String get achievementCategoryProgression => 'Progression';

  @override
  String get achievementCategoryPrestige => 'Prestige';

  @override
  String get achievementCategoryCosmetic => 'Cosmetic';

  @override
  String get achievementCategoryMilestone => 'Milestone';

  @override
  String get achievementCategoryEvent => 'Event';

  @override
  String get achievementDifficultyBronze => 'Bronze';

  @override
  String get achievementDifficultySilver => 'Silver';

  @override
  String get achievementDifficultyGold => 'Gold';

  @override
  String get achievementDifficultyDiamond => 'Diamond';

  @override
  String get achievementFilterTitle => 'Filters';

  @override
  String get achievementFilterCategory => 'Category';

  @override
  String get achievementFilterDifficulty => 'Difficulty';

  @override
  String get achievementFilterStatus => 'Status';

  @override
  String get achievementFilterSort => 'Sort';

  @override
  String get achievementFilterAll => 'All';

  @override
  String get achievementFilterUnlocked => 'Unlocked';

  @override
  String get achievementFilterLocked => 'Locked';

  @override
  String get achievementSortName => 'Name';

  @override
  String get achievementEmptyFiltered =>
      'No achievements match the selected filters';

  @override
  String get achievementClearRate => 'Completion Rate';
}
