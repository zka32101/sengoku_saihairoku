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

  @override
  String get resultTitle => 'Battle Result';

  @override
  String get resultVictory => 'Victory!';

  @override
  String get resultDefeat => 'Defeat';

  @override
  String get resultVictorySubtitle => 'A masterful command';

  @override
  String get resultDefeatSubtitle => 'Avenge this defeat next time';

  @override
  String get resultTotalScoreLabel => 'Total Score';

  @override
  String resultScorePoints(String score) {
    return '$score pts';
  }

  @override
  String get resultScoreVictory => 'Victory Score';

  @override
  String get resultScoreEfficiency => 'Efficiency Score';

  @override
  String get resultScoreCommand => 'Command Score';

  @override
  String get resultScoreTurningPoint => 'TP Bonus';

  @override
  String get resultScoreHistory => 'History Bonus';

  @override
  String get resultTurningPointTitle => 'Turning Points';

  @override
  String resultTpFallback(int number) {
    return 'TP$number';
  }

  @override
  String get resultViewHistoryButton => 'View Historical Analysis';

  @override
  String get resultViewRankingButton => 'View Ranking';

  @override
  String get resultShareButton => 'Share Result';

  @override
  String get resultHomeButton => 'Back to Home';

  @override
  String resultShareText(
    String scenario,
    String result,
    int score,
    int tp,
    int total,
  ) {
    return 'I got a $result in \"$scenario\" on Sengoku Saihairoku!\nScore: $score pts / Turning Points $tp/$total\n#SengokuSaihairoku';
  }

  @override
  String get resultShareVictory => 'Victory';

  @override
  String get resultShareDefeat => 'Defeat';

  @override
  String resultFriendChallengeSuccess(String friend) {
    return 'Beat $friend\'s challenge!';
  }

  @override
  String resultFriendChallengeFailure(String friend) {
    return 'Fell short of $friend\'s challenge';
  }

  @override
  String resultFriendChallengeTarget(int score) {
    return 'Target score: $score pts';
  }

  @override
  String get resultChallengeCompletedTitle => 'Today\'s Challenge Complete!';

  @override
  String get resultChallengeCompletedNote =>
      'Claim your reward from the Home screen';

  @override
  String get resultXpGainTitle => 'XP Gained';

  @override
  String get resultXpGainedLabel => 'XP Gained:';

  @override
  String get resultXpBoostLoading => 'Loading…';

  @override
  String get resultXpBoostButton => 'Watch an ad to double XP';

  @override
  String get resultLevelUpTitle => 'Level Up!';

  @override
  String resultLevelUpSubtitle(int level) {
    return 'Reached Level $level';
  }

  @override
  String get resultBattlePassTierUpTitle => 'Battle Pass Tier Up!';

  @override
  String resultBattlePassTierUpSubtitle(int tier) {
    return 'Reached Tier $tier';
  }

  @override
  String get resultCosmeticUnlockTitle => 'Cosmetic Unlocked!';

  @override
  String get resultTpOdigahara1 => 'Surprise attack before the enemy arrives';

  @override
  String get resultTpOdigahara2 => 'Fight in the storm';

  @override
  String get resultTpOdigahara3 => 'Weaken the enemy general';

  @override
  String get resultTpOdigahara4 => 'Defeat the enemy general';

  @override
  String get resultTpNagashino1 => 'Set the initial formation to defense';

  @override
  String get resultTpNagashino2 => 'Withstand the enemy cavalry charge';

  @override
  String get resultTpNagashino3 => 'Launch a full counterattack';

  @override
  String get resultTpNagashino4 => 'Defeat the enemy general';

  @override
  String get resultTpHonnoJi1 => 'Break through the enemy encirclement';

  @override
  String get resultTpHonnoJi2 => 'Survive until reinforcements arrive';

  @override
  String get resultTpHonnoJi3 => 'Counterattack after reinforcements arrive';

  @override
  String get resultTpHonnoJi4 => 'Defeat the enemy supreme commander';

  @override
  String get resultTpSekigahara1 => 'Proceed cautiously in the early stages';

  @override
  String get resultTpSekigahara2 => 'Maintain allied morale';

  @override
  String get resultTpSekigahara3 => 'Flank the enemy';

  @override
  String get resultTpSekigahara4 => 'Defeat the enemy general';

  @override
  String get resultTpSekigahara5 => 'Keep the Toyotomi warlord alive';

  @override
  String get resultTpKawanakajima1 => 'Prepare for the dawn surprise attack';

  @override
  String get resultTpKawanakajima2 =>
      'Hold out until the detached unit arrives';

  @override
  String get resultTpKawanakajima3 => 'Succeed at the pincer attack';

  @override
  String get resultTpKawanakajima4 => 'Defeat the enemy general';

  @override
  String get resultTpItsukushima1 => 'Surprise attack amid the storm';

  @override
  String get resultTpItsukushima2 => 'Defend Miyao Castle';

  @override
  String get resultTpItsukushima3 => 'Cut off the retreat and encircle';

  @override
  String get resultTpItsukushima4 => 'Defeat the enemy general';

  @override
  String get scenarioSelectTitle => 'Choose a Scenario';

  @override
  String get scenarioSelectHelpTooltip => 'Help';

  @override
  String scenarioYearSuffix(int year) {
    return '$year';
  }

  @override
  String get scenarioSettingsTitle => 'Scenario Settings';

  @override
  String get scenarioPerspectiveTitle => 'Choose a Perspective';

  @override
  String get scenarioWarlordSelectTitle =>
      'Choose Warlords to Sortie (optional, up to 2)';

  @override
  String get scenarioWarlordSelectHint =>
      'Your army\'s overall strength rises based on Leadership. Selecting two also applies compatibility (same faction, intelligence synergy, leadership gap) — the 1st commands the vanguard and the 2nd the main force, reflecting each warlord\'s Valor in their unit.';

  @override
  String get scenarioWarlordAwakenedTag => 'Awakened';

  @override
  String scenarioWarlordChipLabel(
    String name,
    int level,
    String awakened,
    int leadership,
  ) {
    return '$name Lv.$level$awakened (LDR $leadership)';
  }

  @override
  String scenarioCompatibilityLabel(String multiplier, String note) {
    return 'Compatibility: ×$multiplier$note';
  }

  @override
  String get scenarioCompatibilityPositive => ' (Good match)';

  @override
  String get scenarioCompatibilityNegative => ' (Poor match)';

  @override
  String get scenarioDifficultyTitle => 'Choose Difficulty';

  @override
  String get scenarioLoadingText => 'Loading scenario...';

  @override
  String get scenarioLoadErrorText => 'Failed to load scenario';

  @override
  String get scenarioNameOdigahara => 'Battle of Okehazama';

  @override
  String get scenarioDescOdigahara =>
      '3,500 vs 15,000 — overturn overwhelming odds with cunning tactics';

  @override
  String get scenarioPlayTimeOdigahara => '3-5 min';

  @override
  String get scenarioNameNagashino => 'Battle of Nagashino';

  @override
  String get scenarioDescNagashino =>
      'Meet the Takeda cavalry with a defensive formation';

  @override
  String get scenarioPlayTimeNagashino => '4-6 min';

  @override
  String get scenarioNameHonnoji => 'Honno-ji Incident';

  @override
  String get scenarioDescHonnoji =>
      '500 vs 13,000 — a reversal from a hopeless situation';

  @override
  String get scenarioPlayTimeHonnoji => '5-7 min';

  @override
  String get scenarioNameSekigahara => 'Battle of Sekigahara';

  @override
  String get scenarioDescSekigahara =>
      'The fate of the realm — master a complex battlefield';

  @override
  String get scenarioPlayTimeSekigahara => '6-8 min';

  @override
  String get scenarioNameKawanakajima => 'Battle of Kawanakajima';

  @override
  String get scenarioDescKawanakajima =>
      'Hold the line alone after a dawn ambush until the detached unit arrives';

  @override
  String get scenarioPlayTimeKawanakajima => '4-6 min';

  @override
  String get scenarioNameItsukushima => 'Battle of Itsukushima';

  @override
  String get scenarioDescItsukushima =>
      '4,000 vs 15,000 — annihilate with a storm-borne surprise attack';

  @override
  String get scenarioPlayTimeItsukushima => '4-5 min';
}
