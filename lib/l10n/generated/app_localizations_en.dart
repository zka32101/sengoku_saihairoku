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

  @override
  String get prestigeShowcaseTitle => 'Prestige Cosmetics';

  @override
  String get prestigeShowcaseEmptyTier => 'No cosmetics for this rank yet';

  @override
  String get prestigeShowcaseCurrentRank => 'Current Prestige Rank';

  @override
  String prestigeShowcaseNextRank(String rank) {
    return 'Next rank: $rank';
  }

  @override
  String prestigeShowcaseMaxRank(String rank) {
    return 'Reached the highest rank: $rank!';
  }

  @override
  String prestigeShowcaseResetCount(int count) {
    return 'Resets: $count';
  }

  @override
  String prestigeShowcaseRequiredPoints(int points) {
    return 'Required points: $points';
  }

  @override
  String get prestigeShowcaseUnlocked => 'Unlocked';

  @override
  String get prestigeShowcaseLocked => 'Locked';

  @override
  String prestigeShowcaseItemType(String type) {
    return 'Type: $type';
  }

  @override
  String get prestigeShowcaseAcquired => 'Acquired';

  @override
  String get prestigeShowcaseItemLocked => 'Locked';

  @override
  String get advancedStatsTitle => 'Detailed Stats';

  @override
  String get advancedStatsTabOverview => 'Overview';

  @override
  String get advancedStatsTabScenario => 'Scenario';

  @override
  String get advancedStatsTabDifficulty => 'Difficulty';

  @override
  String get advancedStatsTabRanking => 'Ranking';

  @override
  String get advancedStatsTotalBattles => 'Total Battles';

  @override
  String get advancedStatsWinRate => 'Win Rate';

  @override
  String get advancedStatsVictories => 'Victories';

  @override
  String get advancedStatsDefeats => 'Defeats';

  @override
  String get advancedStatsHighestScore => 'Highest Score';

  @override
  String get advancedStatsAverageScore => 'Average Score';

  @override
  String get advancedStatsPlayTime => 'Play Time';

  @override
  String get advancedStatsPerformanceTrend => 'Performance Trend';

  @override
  String advancedStatsWinRateChange(String percent) {
    return 'Win rate: $percent%';
  }

  @override
  String advancedStatsScoreChange(String score) {
    return 'Score: ${score}pt';
  }

  @override
  String get advancedStatsWinRateTrendLabel => 'Win Rate Trend';

  @override
  String get advancedStatsScoreTrendLabel => 'Score Trend';

  @override
  String get advancedStatsScenarioClearStatus => 'Scenario Completion';

  @override
  String get advancedStatsTrendImproving => '📈 Improving';

  @override
  String get advancedStatsTrendDeclining => '📉 Declining';

  @override
  String get advancedStatsTrendStable => '→ Stable';

  @override
  String get rankingTitle => 'Ranking';

  @override
  String get rankingShareTooltip => 'Share Ranking';

  @override
  String get rankingShareText =>
      'I\'m challenging the ranking in Sengoku Saihairoku! Want to try your own command?\n#SengokuSaihairoku';

  @override
  String get rankingGlobal => 'Global';

  @override
  String get rankingMyPlay => 'My Plays';

  @override
  String get rankingAllScenarios => 'All Scenarios';

  @override
  String get rankingEmpty => 'No ranking data yet';

  @override
  String get rankingWon => 'Win';

  @override
  String rankingSeasonBestNone(String season) {
    return '$season: No record yet';
  }

  @override
  String rankingSeasonBestScore(String season, int score) {
    return '$season: Best $score pts';
  }

  @override
  String rankingDurationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get warlordCollectionTitle => 'Warlord Collection';

  @override
  String warlordCollectionUnlockedCount(int unlocked, int total) {
    return '$unlocked / $total Unlocked';
  }

  @override
  String get warlordCollectionDrawing => 'Discovering...';

  @override
  String warlordCollectionDrawButton(int cost) {
    return 'Discover a Warlord ($cost Gold)';
  }

  @override
  String get warlordCollectionAllFilter => 'All';

  @override
  String get warlordCollectionAllUnlocked => 'All warlords have been unlocked';

  @override
  String get warlordCollectionGoldShortage => 'Not enough gold';

  @override
  String get warlordCollectionLocked => '???';

  @override
  String get warlordCollectionUndiscovered => 'Undiscovered';

  @override
  String warlordCollectionTotalStat(int stat) {
    return 'Total Power $stat';
  }

  @override
  String get warlordDetailLeadership => 'Leadership';

  @override
  String get warlordDetailValor => 'Valor';

  @override
  String get warlordDetailIntelligence => 'Intelligence';

  @override
  String warlordDetailAwakenedLevel(int level) {
    return 'Awakened (Lv.$level)';
  }

  @override
  String warlordDetailLevel(int level) {
    return 'Lv.$level';
  }

  @override
  String get warlordDetailExpHint => 'Sortie and win battles to gain EXP';

  @override
  String get warlordDiscoveredTitle => 'Warlord Discovered!';

  @override
  String get warlordArchetypeLeadership => 'Master Tactician';

  @override
  String get warlordArchetypeValor => 'Fierce General';

  @override
  String get warlordArchetypeIntelligence => 'Wise Strategist';

  @override
  String warlordArchetypeLegendary(String archetype) {
    return 'Legendary $archetype';
  }

  @override
  String get goldShopTitle => 'Gold Shop';

  @override
  String get goldShopPurchaseSuccess => 'Gold received!';

  @override
  String goldShopPurchaseFailure(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String get goldShopUnknownError => 'Unknown error';

  @override
  String goldShopAdRewardEarned(int amount) {
    return 'You earned $amount gold!';
  }

  @override
  String get goldShopAdFailure =>
      'Could not show the ad. Please try again later.';

  @override
  String get goldShopBalanceLabel => 'Gold Balance';

  @override
  String goldShopWatchAdTitle(int amount) {
    return 'Watch an ad for $amount gold';
  }

  @override
  String goldShopWatchAdRemaining(int remaining, int limit) {
    return '$remaining/$limit left today';
  }

  @override
  String get goldShopWatchButton => 'Watch';

  @override
  String get goldShopWatchLimitReached => 'Limit Reached';

  @override
  String get goldShopPacksTitle => 'Gold Packs';

  @override
  String get goldShopStoreUnavailable => 'Can\'t connect to the store';

  @override
  String get goldShopNoProducts => 'No products available right now';

  @override
  String get goldShopBestValueBadge => 'Best Value';

  @override
  String get goldShopPopularBadge => 'Popular';

  @override
  String goldShopGoldAmount(int amount) {
    return '$amount Gold';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLoadError => 'Could not load user data';

  @override
  String get profileLevelLabel => 'Level';

  @override
  String get profileXpLabel => 'XP';

  @override
  String profileXpSuffix(String xp) {
    return '$xp XP';
  }

  @override
  String get profileNextLevelProgress => 'Progress to Next Level';

  @override
  String get profileMaxLevelReached =>
      'Max level reached! You can reset with Prestige.';

  @override
  String get profilePrestigeRank => 'Prestige Rank';

  @override
  String get profilePrestigePoints => 'Prestige Points';

  @override
  String profilePrestigeResetCount(int count) {
    return 'Resets: $count';
  }

  @override
  String get profileCosmeticsTitle => 'Cosmetics';

  @override
  String profileUnitSkinsLabel(int count) {
    return 'Unit Skins ($count)';
  }

  @override
  String profileUiThemesLabel(int count) {
    return 'UI Themes ($count)';
  }

  @override
  String get profileCosmeticsEmpty => 'No cosmetics unlocked yet';

  @override
  String get profileProgressionDetailsTitle => 'Progression Details';

  @override
  String get profileUserIdLabel => 'User ID';

  @override
  String get profilePlayTimeLabel => 'Play Time';

  @override
  String profilePlayTimeFormat(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get profileLastUpdatedLabel => 'Last Updated';

  @override
  String profileDateFormat(int year, int month, int day) {
    return '$year/$month/$day';
  }

  @override
  String get profileUnlockedCosmeticsLabel => 'Unlocked Cosmetics';

  @override
  String profileUnlockedCosmeticsCount(int count) {
    return '$count';
  }

  @override
  String get profileActionsTitle => 'Actions';

  @override
  String get profileCosmeticsSettingsButton => 'Cosmetics Settings';

  @override
  String get profilePrestigeButton => 'Prestige';

  @override
  String profilePrestigeLockedButton(int level) {
    return 'Prestige (Unlocks at Lv.$level)';
  }

  @override
  String get profileAchievementsTitle => 'Achievements';

  @override
  String get profileAchievementsViewAllButton => 'View All Achievements';

  @override
  String get homeAppTitle => 'Sengoku Saihairoku';

  @override
  String get homeTagline => 'Conquer the Realm';

  @override
  String get homeTodayChallengeLabel => 'Today\'s Challenge';

  @override
  String get homeWeeklyChallengeLabel => 'This Week\'s Challenge';

  @override
  String get homeSpotBattleTitle => 'Spot Battle';

  @override
  String get homeSpotBattleSubtitle =>
      'Choose a famous battle and take command';

  @override
  String get homeSpotBattlePlayTime => 'Play time: 3-8 min';

  @override
  String get homeSpotBattleButton => 'Choose a Scenario';

  @override
  String get homeChainBattleTitle => 'Chain Battle';

  @override
  String get homeChainBattleSubtitle =>
      'A high-difficulty mode clearing every scenario back to back';

  @override
  String get homeChainBattleButton => 'Start Chain Battle';

  @override
  String get homeReplayTitle => 'Battle Replay';

  @override
  String get homeReplaySubtitle => 'Replay and analyze past battles';

  @override
  String get homeReplayNote => 'All battles are recorded automatically';

  @override
  String get homeReplayButton => 'View Replays';

  @override
  String get homeRankingTitle => 'Ranking';

  @override
  String get homeRankingSubtitle => 'Compete against other commanders';

  @override
  String get homeRankingButton => 'View Ranking';

  @override
  String get homeChallengeHistoryTitle => 'Challenge History';

  @override
  String get homeChallengeHistorySubtitle =>
      'Check the last 7 days of challenges';

  @override
  String get homeChallengeHistoryButton => 'View Challenge History';

  @override
  String get homeFriendsTitle => 'Friends';

  @override
  String get homeFriendsSubtitle =>
      'Exchange friend codes and compete on the ranking';

  @override
  String get homeFriendsButton => 'View Friends';

  @override
  String get homeWarlordCollectionTitle => 'Warlord Collection';

  @override
  String get homeWarlordCollectionSubtitle =>
      'Discover warlords with gold and complete your collection';

  @override
  String get homeWarlordCollectionButton => 'View Collection';

  @override
  String get homeGoldShopTitle => 'Gold Shop';

  @override
  String get homeGoldShopSubtitle =>
      'Buy gold to speed up your Battle Pass progress';

  @override
  String get homeGoldShopButton => 'View Shop';

  @override
  String get homeBattlePassTitle => 'Battle Pass';

  @override
  String get homeBattlePassSubtitle => 'Rank up your tier through the season';

  @override
  String homeBattlePassMissedRewards(int count) {
    return 'Missing $count premium reward(s)';
  }

  @override
  String get homeBattlePassButton => 'View Battle Pass';
}
