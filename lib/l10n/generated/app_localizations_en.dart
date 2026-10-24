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
  String get resultTpOshijo1 => 'Confuse the enemy with misinformation';

  @override
  String get resultTpOshijo2 => 'Strike the camp by breaching the dike';

  @override
  String get resultTpOshijo3 => 'Withstand the assault';

  @override
  String get resultTpOshijo4 => 'Defeat the enemy general';

  @override
  String get resultTpMikatagahara1 => 'Hold back from a reckless sortie';

  @override
  String get resultTpMikatagahara2 =>
      'Endure the melee on the Mikatagahara plateau';

  @override
  String get resultTpMikatagahara3 =>
      'Counterattack with the woodpecker tactic';

  @override
  String get resultTpMikatagahara4 => 'Defeat the enemy general';

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
  String get scenarioNameOshijo => 'Siege of Oshi Castle';

  @override
  String get scenarioNameMikatagahara => 'Battle of Mikatagahara';

  @override
  String get scenarioDescItsukushima =>
      '4,000 vs 15,000 — annihilate with a storm-borne surprise attack';

  @override
  String get scenarioPlayTimeItsukushima => '4-5 min';

  @override
  String get scenarioDescOshijo =>
      '3,000 vs 20,000 — withstand the flood and repel the great army';

  @override
  String get scenarioPlayTimeOshijo => '4-5 min';

  @override
  String get scenarioDescMikatagahara =>
      '8,000 vs 25,000 — turn a reckless sortie into a victory unknown to history';

  @override
  String get scenarioPlayTimeMikatagahara => '4-5 min';

  @override
  String get tutorialTitle => 'First Battle: Command Basics';

  @override
  String get tutorialPaceSelectTitle => 'Choose Your Pace';

  @override
  String get tutorialPaceThoroughButton =>
      'Learn Thoroughly (with explanations)';

  @override
  String get tutorialPaceBriskButton => 'Breeze Through (no explanations)';

  @override
  String get tutorialEnemyBaseLabel => 'Enemy Main Camp';

  @override
  String get tutorialVictoryTitle => 'First Battle Won!';

  @override
  String get tutorialVictoryMessage =>
      'Surprise Attack, Shield Formation, Rally, Charge…\nEven the odds can be overcome with the right command.\nNow, to the real battlefield.';

  @override
  String get tutorialStartJourneyButton => 'Begin Your Journey as a Warlord';

  @override
  String get tutorialStepAmbushLabel => 'Surprise Attack';

  @override
  String get tutorialStepAmbushPrompt =>
      'Your forces are a fraction of the enemy\'s… you can\'t win head-on.\nFirst, strike their flank with a \"Surprise Attack\".';

  @override
  String get tutorialStepAmbushResult =>
      'Surprise attack succeeded! The enemy ranks broke, dealing a heavy blow.';

  @override
  String get tutorialStepShieldLabel => 'Shield Formation';

  @override
  String get tutorialStepShieldPrompt =>
      'The enemy counterattacks. Use \"Shield Formation\" to harden your defenses\nand reduce losses.';

  @override
  String get tutorialStepShieldResult =>
      'Shield formation deployed! Your army\'s defense rose sharply.';

  @override
  String get tutorialStepRallyLabel => 'Rally';

  @override
  String get tutorialStepRallyPrompt =>
      'Raise your troops\' morale with \"Rally\"\nto boost their attack power.';

  @override
  String get tutorialStepRallyResult =>
      'Troop morale rose, boosting attack power!';

  @override
  String get tutorialStepChargeLabel => 'Charge';

  @override
  String get tutorialStepChargePrompt =>
      'The enemy is faltering. Finish them with a \"Charge\"\nand press the advantage!';

  @override
  String get tutorialStepChargeResult =>
      'Full charge! You broke through the enemy\'s main camp and claimed victory!';

  @override
  String get chainBattleTitle => 'Chain Battle';

  @override
  String chainBattleDifficultyIntro(int count) {
    return 'Chain Battle clears all $count battles back to back with no rest. Your army\'s strength drops from fatigue as stages progress. Choose a difficulty.';
  }

  @override
  String chainBattleStageLabel(int current, int total) {
    return 'Stage $current / $total';
  }

  @override
  String chainBattleFatigueMultiplier(String multiplier) {
    return 'Fatigue strength multiplier: ×$multiplier';
  }

  @override
  String chainBattleResultLine(String scenario, String result, int score) {
    return '$scenario: $result ($score pts)';
  }

  @override
  String get chainBattleWin => 'Victory';

  @override
  String get chainBattleLoss => 'Defeat';

  @override
  String get chainSummaryTitle => 'Chain Battle Complete';

  @override
  String chainSummaryWins(int wins, int total) {
    return '$wins / $total Wins';
  }

  @override
  String chainSummaryTotalScore(int score) {
    return 'Total Score: $score pts';
  }

  @override
  String chainSummaryResultLine(String result, int score) {
    return '$result $score pts';
  }

  @override
  String get chainSummaryHomeButton => 'Back to Home';

  @override
  String chainCompletionAdLabel(int amount) {
    return 'Watch an ad to earn a $amount gold bonus for your hard work';
  }

  @override
  String get prestigeResetTitle => 'Prestige';

  @override
  String get prestigeResetSuccessMessage => 'Prestige reset complete!';

  @override
  String prestigeResetErrorMessage(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get prestigeResetLockedLevelReason => 'Reach Level 100 first';

  @override
  String prestigeResetLockedPointsReason(int points) {
    return 'You need 1000 or more Prestige Points\nCurrent: $points';
  }

  @override
  String get prestigeResetCurrentRankLabel => 'Current Prestige Rank';

  @override
  String prestigeResetCountSuffix(int count) {
    return 'Resets: $count';
  }

  @override
  String get prestigeResetLockedTitle => 'Prestige Unavailable';

  @override
  String get prestigeResetActionTitle => 'Perform Prestige Reset';

  @override
  String get prestigeResetActionDescription =>
      'You meet the requirements. You can perform a Prestige reset.';

  @override
  String get prestigeResetProcessing => 'Processing...';

  @override
  String get prestigeResetBenefitsTitle => 'About Prestige';

  @override
  String get prestigeResetBenefit1Title => 'Level and XP Reset';

  @override
  String get prestigeResetBenefit1Desc =>
      'Your level returns to 1 and your XP resets to 0';

  @override
  String get prestigeResetBenefit2Title => 'Prestige Rank Rises';

  @override
  String get prestigeResetBenefit2Desc =>
      'Your new rank is determined based on turn efficiency';

  @override
  String get prestigeResetBenefit3Title => 'Exclusive Cosmetics Unlocked';

  @override
  String get prestigeResetBenefit3Desc =>
      'Exclusive skins and themes matching your new rank are unlocked';

  @override
  String get prestigeResetBenefit4Title => 'Next Reset Requirement Rises';

  @override
  String get prestigeResetBenefit4Desc =>
      'You will need more Prestige Points next time';

  @override
  String get prestigeResetConfirmTitle => 'Confirm Prestige Reset';

  @override
  String get prestigeResetConfirmIntro =>
      'This will perform a Prestige reset. Is the following OK?';

  @override
  String get prestigeResetConfirmCurrentLevel => 'Current Level';

  @override
  String get prestigeResetConfirmRank => 'Rank After Reset';

  @override
  String get prestigeResetIrreversibleWarning => 'This action cannot be undone';

  @override
  String get prestigeResetConfirmExecuteButton => 'Perform Reset';

  @override
  String get cosmeticsEquipTitle => 'Cosmetics Settings';

  @override
  String get cosmeticsEquipSuccess => 'Cosmetic equipped';

  @override
  String get cosmeticsUnequipSuccess => 'Cosmetic unequipped';

  @override
  String get cosmeticsUnitSkinTitle => 'Unit Skins';

  @override
  String get cosmeticsUiThemeTitle => 'UI Themes';

  @override
  String get cosmeticsEquippedLabel => 'Equipped:';

  @override
  String get cosmeticsUnknownName => 'Unknown';

  @override
  String get cosmeticsUnequipButton => 'Unequip';

  @override
  String get cosmeticsEquippedBadge => 'Equipped';

  @override
  String get cosmeticsEquipButton => 'Equip';

  @override
  String cosmeticsNoCosmeticsTitle(String type) {
    return 'No $type unlocked yet';
  }

  @override
  String get cosmeticsNoCosmeticsHint =>
      'Unlocked by leveling up or through Prestige';

  @override
  String get cosmeticsAcquisitionLevelMilestone => 'Level Reward';

  @override
  String get cosmeticsAcquisitionAchievement => 'Achievement';

  @override
  String get cosmeticsAcquisitionPrestige => 'Prestige Reward';

  @override
  String get cosmeticsAcquisitionBattlePass => 'Battle Pass';

  @override
  String get cosmeticsAcquisitionEvent => 'Event Reward';

  @override
  String get cosmeticsPrestigeRankLabel => 'Prestige Rank';

  @override
  String cosmeticsResetCountLabel(int count) {
    return 'Resets: $count';
  }

  @override
  String cosmeticsPointsLabel(int points) {
    return 'Points: $points';
  }

  @override
  String get cosmeticsShowcaseTitle => 'Prestige Cosmetics';

  @override
  String cosmeticsShowcaseRankLine(String rank) {
    return 'Rank: $rank';
  }

  @override
  String get cosmeticsShowcaseEquippedSkinLabel => 'Equipped Unit Skin';

  @override
  String get cosmeticsShowcaseEquippedThemeLabel => 'Equipped UI Theme';

  @override
  String get cosmeticsShowcaseEmpty => 'No Prestige cosmetics equipped yet';

  @override
  String get cosmeticsPrestigeSectionEmptyHint =>
      'Unlocked by performing a Prestige reset';

  @override
  String cosmeticsPrestigeCurrentRankLine(String rank) {
    return 'Current Prestige Rank: $rank';
  }

  @override
  String get cosmeticsPrestigeUnitSkinTitle => 'Prestige Unit Skins';

  @override
  String get cosmeticsPrestigeUiThemeTitle => 'Prestige UI Themes';

  @override
  String get cosmeticsPrestigeTierSilver => 'Silver';

  @override
  String get cosmeticsPrestigeTierGold => 'Gold';

  @override
  String get cosmeticsPrestigeTierPlatinum => 'Platinum';

  @override
  String get cosmeticsPrestigeTierDiamond => 'Diamond';

  @override
  String get cosmeticsPrestigeTierUnknown => 'Unknown';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsAddedSuccess => 'Friend added!';

  @override
  String get friendsAddFailed =>
      'The code is invalid or you\'re already friends';

  @override
  String get friendsChallengeScenarioTitle => 'Choose a scenario to challenge';

  @override
  String get friendsNoRecordYet =>
      'This friend has no record for this scenario yet';

  @override
  String friendsChallengeSetMessage(String friend, String scenario, int score) {
    return 'Goal set: beat $friend\'s $scenario score of $score! Sortie from the scenario select screen';
  }

  @override
  String friendsShareMyCodeText(String code) {
    return 'Let\'s battle in Sengoku Saihairoku!\nFriend code: $code';
  }

  @override
  String get friendsCopySuccess => 'Friend code copied';

  @override
  String get friendsMyCodeLabel => 'Your Friend Code';

  @override
  String get friendsCopyButton => 'Copy';

  @override
  String get friendsShareButton => 'Share';

  @override
  String get friendsAddFriendTitle => 'Add a Friend';

  @override
  String get friendsCodeHint => 'Enter a friend code';

  @override
  String get friendsAddButton => 'Add';

  @override
  String get friendsRankingTitle => 'Friend Ranking (Total Score)';

  @override
  String get friendsNoRecordsYet => 'No records yet';

  @override
  String get friendsRecentActivityTitle => 'Recent Activity';

  @override
  String friendsListTitle(int count) {
    return 'Friends ($count)';
  }

  @override
  String get friendsNoFriendsYet => 'No friends yet';

  @override
  String get friendsYouLabel => 'You';

  @override
  String friendsActivityLine(String player, String scenario, String result) {
    return '$player got a $result in $scenario';
  }

  @override
  String get friendsChallengeTooltip => 'Challenge';

  @override
  String get onboardingSkipButton => 'Skip';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get onboardingStartButton => 'Start';

  @override
  String get onboardingPage1Title => 'Welcome to Sengoku Saihairoku';

  @override
  String get onboardingPage1Description =>
      'Okehazama, Honno-ji, Sekigahara…\nBecome an outnumbered warlord and use your commands\nto pull off a legendary comeback.';

  @override
  String get onboardingPage2Title => 'You Start at a Severe Disadvantage';

  @override
  String get onboardingPage2Description =>
      'In many scenarios, the enemy\'s forces\nare several to over ten times your own.\nYou can\'t win by brute force alone.';

  @override
  String get onboardingPage3Title => 'Commands Shape the Battle';

  @override
  String get onboardingPage3Description =>
      'Surprise Attack, Shield Formation, Advance, Retreat, Rally, Charge…\nChoosing the right command for the situation\nis the key to victory.';

  @override
  String get onboardingPage4Title => 'Aim for the Turning Points';

  @override
  String get onboardingPage4Description =>
      'Each scenario has historically-based\n\"Turning Points\" to discover.\nMeet their conditions for a high score.';

  @override
  String get onboardingPage5Title => 'A Warlord Who Keeps Growing';

  @override
  String get onboardingPage5Description =>
      'Level, achievements, Battle Pass, Prestige…\nThe more you fight, the more your warlord grows.\nNow, take command of your first battle!';

  @override
  String get replayWatchSharedTooltip => 'Watch with a share code';

  @override
  String get replayDeleteConfirmTitle => 'Confirm Deletion';

  @override
  String get replayDeleteConfirmBody => 'Delete this replay?';

  @override
  String get replayDeleteButton => 'Delete';

  @override
  String get replayShareIssuingCode => 'Issuing share code...';

  @override
  String get replayShareCodeTitle => 'Share Code';

  @override
  String get replayShareCodeHint =>
      'Share this code with a friend so they can watch';

  @override
  String get replayShareButton => 'Share';

  @override
  String get replayShareMenuItem => 'Share';

  @override
  String replayShareFailure(String error) {
    return 'Failed to share: $error';
  }

  @override
  String replayShareText(String code) {
    return 'Check out my replay on Sengoku Saihairoku!\nShare code: $code';
  }

  @override
  String get replayCodeEntryTitle => 'Watch with a Share Code';

  @override
  String get replayCodeEntryHint => 'e.g. A3F9QZ';

  @override
  String get replayWatchButton => 'Watch';

  @override
  String get replayFetchingReplay => 'Fetching replay...';

  @override
  String get replayNotFound => 'Replay not found';

  @override
  String get replayFilterAll => 'All';

  @override
  String get replayEmptyMessage => 'No replays';

  @override
  String replayLikeCountSuffix(int count) {
    return '$count likes';
  }

  @override
  String get replayCommentHint => 'Leave a comment';

  @override
  String get replayStatsTotalLabel => 'Total Replays';

  @override
  String get replayStatsWinRateLabel => 'Win Rate';

  @override
  String get replayStatsAverageScoreLabel => 'Average Score';

  @override
  String get replayStatsWinLossLabel => 'W/L';

  @override
  String replayDifficultyScoreLine(String difficulty, int score) {
    return '$difficulty • Score: $score';
  }

  @override
  String get battlePassTitle => 'Battle Pass';

  @override
  String get battlePassPremiumUnlockedSnackbar => 'Premium track unlocked!';

  @override
  String battlePassPurchaseFailedSnackbar(String error) {
    return 'Purchase failed: $error';
  }

  @override
  String get battlePassUnknownError => 'Unknown error';

  @override
  String get battlePassSeasonEndLabel => 'Season Ends';

  @override
  String battlePassSeasonEndDate(int year, int month, int day) {
    return '$year/$month/$day';
  }

  @override
  String get battlePassDaysRemainingLabel => 'Days Remaining';

  @override
  String battlePassDaysRemainingValue(int days) {
    return '${days}d';
  }

  @override
  String get battlePassStoreUnavailable => 'Store unavailable';

  @override
  String get battlePassPremiumUnlockTitle => 'Unlock Premium Track';

  @override
  String get battlePassPremiumUnlockDescription =>
      'Instantly claim all premium rewards up to your current tier, and keep receiving premium rewards as you tier up.';

  @override
  String battlePassMissedRewardWarning(int count) {
    return 'You\'ve already missed $count premium rewards!';
  }

  @override
  String battlePassUnlockForPrice(String priceLabel) {
    return 'Unlock for $priceLabel';
  }

  @override
  String get battlePassRestorePurchase => 'Restore Purchase';

  @override
  String get battlePassTierRewardsTitle => 'Tier Rewards';

  @override
  String get battlePassCurrentTierLabel => 'Current Tier';

  @override
  String battlePassTierOfMax(int current, int max) {
    return 'Tier $current / $max';
  }

  @override
  String get battlePassPremiumBadge => 'Premium';

  @override
  String get battlePassProgressLabel => 'Progress';

  @override
  String battlePassXpOfTotal(int current, int total) {
    return '$current / $total';
  }

  @override
  String battlePassXpUntilNextTier(int xp) {
    return '$xp XP until next tier';
  }

  @override
  String get battlePassMaxTierReached => 'Max tier reached!';

  @override
  String get battlePassFreeBadge => 'Free';

  @override
  String battleScenarioLoadError(String error) {
    return 'Failed to load scenario: $error';
  }

  @override
  String get battlePlayerSideLabel => 'Allies';

  @override
  String get battleEnemySideLabel => 'Enemy';

  @override
  String battleTpCounter(int count, int total) {
    return 'TP: $count / $total';
  }

  @override
  String battleComboCounter(int count) {
    return 'Combo: $count';
  }

  @override
  String battleCommandScore(int score) {
    return 'Score: $score';
  }

  @override
  String get battleCommandAdvance => 'Advance';

  @override
  String get battleCommandRetreat => 'Retreat';

  @override
  String get battleCommandWait => 'Wait';

  @override
  String get battleCommandAmbush => 'Ambush';

  @override
  String get battleCommandCharge => 'Charge';

  @override
  String get battleCommandRally => 'Rally';

  @override
  String get battleCommandShield => 'Shield';

  @override
  String get battleCommandFormation => 'Formation';

  @override
  String get battleCommandSpecialLabel => 'Special';

  @override
  String get battleTurningPointAchievedTitle => 'Turning Point Achieved!';

  @override
  String battleTurningPointRewardLine(String name, int points) {
    return '$name  +$points pts';
  }

  @override
  String get battleMomentumEnemyLabel => 'Enemy Advantage';

  @override
  String get battleMomentumPlayerLabel => 'Ally Advantage';

  @override
  String get achievementConditionBattleWins => 'Battle Wins';

  @override
  String get achievementConditionLevelReached => 'Level Reached';

  @override
  String get achievementConditionPrestigeRank => 'Prestige Rank';

  @override
  String get achievementConditionTurnEfficiency => 'Turn Efficiency';

  @override
  String get achievementConditionCosmeticUnlocked => 'Cosmetic Unlocked';

  @override
  String get achievementConditionTotalPlayTime => 'Total Play Time';

  @override
  String get achievementConditionScenarioCleared => 'Scenario Cleared';

  @override
  String get achievementConditionPerfectBattle => 'Perfect Battle';

  @override
  String get achievementConditionPrestigeResetCount => 'Prestige Reset Count';

  @override
  String get achievementConditionEventChallengeCompleted =>
      'Event Challenge Completed';

  @override
  String get achievementConditionWarlordsCollected => 'Warlords Collected';

  @override
  String achievementDescBattleWins(int value) {
    return 'Win $value battles';
  }

  @override
  String achievementDescLevelReached(int value) {
    return 'Reach level $value';
  }

  @override
  String achievementDescPrestigeRank(int value) {
    return 'Prestige rank $value';
  }

  @override
  String achievementDescTurnEfficiency(int value) {
    return 'Clear within $value turns';
  }

  @override
  String achievementDescCosmeticUnlocked(int value) {
    return 'Unlock $value cosmetics';
  }

  @override
  String achievementDescTotalPlayTime(int value) {
    return 'Total play time $value hours';
  }

  @override
  String get achievementDescScenarioCleared => 'Clear the scenario';

  @override
  String get achievementDescPerfectBattle => 'Clear without losing a unit';

  @override
  String achievementDescPrestigeResetCount(int value) {
    return 'Prestige reset $value times';
  }

  @override
  String achievementDescEventChallengeCompleted(int value) {
    return 'Complete $value event challenges';
  }

  @override
  String achievementDescWarlordsCollected(int value) {
    return 'Register $value warlords in the compendium';
  }

  @override
  String get achievementDetailUnlockedBadge => 'Unlocked';

  @override
  String get achievementDetailLockedBadge => 'Locked';

  @override
  String get achievementDetailCategoryLabel => 'Category';

  @override
  String get achievementDetailDifficultyLabel => 'Difficulty';

  @override
  String get achievementDetailPointsLabel => 'Points';

  @override
  String get achievementDetailDescriptionLabel => 'Description';

  @override
  String get achievementDetailConditionLabel => 'Condition';

  @override
  String get achievementDetailRewardLabel => 'Reward';

  @override
  String get statsDashboardCombatStatsTitle => 'Combat Stats';

  @override
  String get statsDashboardPlayTimeTitle => 'Play Time';

  @override
  String get statsDashboardScoreTitle => 'Score';

  @override
  String get statsDashboardWinRateAnalysisTitle => 'Win Rate Analysis';

  @override
  String get statsDashboardTurningPointTitle => 'Turning Points';

  @override
  String get statsDashboardViewDetailsButton => 'View Detailed Stats';

  @override
  String statsDashboardPointsSuffix(int points) {
    return '$points pts';
  }

  @override
  String statsDashboardAchievementsLine(int unlocked, int total) {
    return 'Achievements: $unlocked/$total';
  }

  @override
  String get statsDashboardTotalBattlesLabel => 'Total Battles';

  @override
  String get statsDashboardTotalWinsLabel => 'Wins';

  @override
  String get statsDashboardTotalLossesLabel => 'Losses';

  @override
  String get statsDashboardTpAchievedLabel => 'TPs Achieved';

  @override
  String statsDashboardDurationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String statsDashboardDurationMinutesSeconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String statsDashboardDurationSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get statsDashboardTotalPlayTimeLabel => 'Total Play Time';

  @override
  String get statsDashboardAveragePlayTimeLabel => 'Avg. Battle Time';

  @override
  String statsDashboardAverageBattleMinutes(String minutes) {
    return '${minutes}m';
  }

  @override
  String statsDashboardFirstPlayLine(String date) {
    return 'First played: $date';
  }

  @override
  String statsDashboardLastPlayLine(String date) {
    return 'Last played: $date';
  }

  @override
  String get statsDashboardTotalScoreLabel => 'Total Score';

  @override
  String get statsDashboardAverageScoreLabel => 'Average Score';

  @override
  String get statsDashboardWinRateLabel => 'Win Rate';

  @override
  String get statsDashboardTotalTpLabel => 'Total TPs';

  @override
  String get statsDashboardAverageTpLabel => 'Avg. TPs';

  @override
  String get advStatsWinRateLabel => 'Win Rate';

  @override
  String get advStatsTotalBattlesLabel => 'Battles';

  @override
  String get advStatsVictoriesLabel => 'Wins';

  @override
  String get advStatsDefeatsLabel => 'Losses';

  @override
  String get advStatsBestScoreLabel => 'Best Score';

  @override
  String get advStatsDifficultyAnalysisTitle => 'Difficulty Analysis';

  @override
  String advStatsVictoryDefeatBattleLine(
    int victories,
    int defeats,
    int battles,
  ) {
    return '${victories}W ${defeats}L ($battles battles)';
  }

  @override
  String advStatsScenariosClearedLine(int cleared, int total) {
    return '$cleared/$total cleared';
  }

  @override
  String get advStatsNoData => 'No data';

  @override
  String get advStatsScenarioRankingTitle => 'Scenario Ranking (Win Rate)';

  @override
  String advStatsRankSuffix(int rank) {
    return '#$rank';
  }

  @override
  String advStatsVictoryDefeatLine(int victories, int defeats) {
    return '${victories}W ${defeats}L';
  }

  @override
  String advStatsAverageScoreLine(int score) {
    return 'Avg ${score}pt';
  }

  @override
  String get helpModalTabTutorial => 'Tutorial';

  @override
  String get helpModalTabCommands => 'Commands';

  @override
  String get helpModalTabTactics => 'Tactics';

  @override
  String get helpModalCloseButton => 'Close';

  @override
  String get helpModalNoHintsForDifficulty => 'No hints for this difficulty';

  @override
  String get helpModalEffectLabel => 'Effect';

  @override
  String get helpModalLimitationLabel => 'Limitations';

  @override
  String get helpModalRecommendationsLabel => 'Recommendations';

  @override
  String replayPlayerTurnLabel(int turn) {
    return 'Turn $turn';
  }

  @override
  String replayPlayerCommandUsedLabel(String command) {
    return 'Command: $command';
  }

  @override
  String get replayPlayerPlayerLabel => 'Player';

  @override
  String get replayPlayerEnemyLabel => 'Enemy';

  @override
  String get replayPlayerEventLabel => 'Event';

  @override
  String get replayPlayerTpAchievedBadge => '✨ Turning Point Achieved';

  @override
  String get replayPlayerTurnProgressLabel => 'Turn Progress';

  @override
  String replayPlayerTurnFraction(int current, int total) {
    return '$current/$total';
  }

  @override
  String get replayPlayerSpeedLabel => 'Speed: ';

  @override
  String get replayPlayerHpLabel => 'HP';

  @override
  String get replayPlayerUnitsLabel => 'Troops';

  @override
  String eventBannerRemainingDays(int days, int hours) {
    return '${days}d ${hours}h left';
  }

  @override
  String eventBannerRemainingHours(int hours, int minutes) {
    return '${hours}h ${minutes}m left';
  }

  @override
  String eventBannerRemainingMinutes(int minutes) {
    return '${minutes}m left';
  }

  @override
  String get eventBannerLimitedEventLabel => 'Limited-Time Event';

  @override
  String eventBannerRewardMultiplier(String multiplier) {
    return '${multiplier}x Rewards';
  }

  @override
  String get eventBannerClaimRewardButton => 'Claim Reward';

  @override
  String get eventBannerClaimedLabel => 'Claimed';

  @override
  String get challengeCardScenarioOdigahara => 'Okehazama';

  @override
  String get challengeCardScenarioNagashino => 'Nagashino';

  @override
  String get challengeCardScenarioHonnoji => 'Honno-ji';

  @override
  String get challengeCardScenarioSekigahara => 'Sekigahara';

  @override
  String get challengeCardScenarioKawanakajima => 'Kawanakajima';

  @override
  String get challengeCardScenarioItsukushima => 'Itsukushima';

  @override
  String get challengeCardScenarioOshijo => 'Oshi Castle';

  @override
  String get challengeCardScenarioMikatagahara => 'Mikatagahara';

  @override
  String get challengeCardRewardLabel => 'Reward';

  @override
  String get challengeCardApLabel => 'AP';

  @override
  String get dailyLoginTitle => 'Daily Login Bonus';

  @override
  String dailyLoginStreakLabel(int streak) {
    return 'Day $streak streak';
  }

  @override
  String get dailyLoginClaimButton => 'Claim';

  @override
  String trendSparklineInsufficientData(String label) {
    return '$label: Not enough data';
  }

  @override
  String get notifReminderChannelName => 'Reminders';

  @override
  String get notifReminderChannelDescription =>
      'Daily challenge and battle pass notifications';

  @override
  String get notifDailyChallengeTitle => 'Today\'s Daily Challenge';

  @override
  String notifDailyChallengeBodyStreak(int streak) {
    return '$streak-day streak! Play today or your streak will break.';
  }

  @override
  String get notifDailyChallengeBodyNoStreak =>
      'Take on a new daily challenge!';

  @override
  String get notifBattlePassExpiryTitle => 'Battle Pass Ending Soon';

  @override
  String notifBattlePassExpiryBody(int days) {
    return '$days days left this season. Don\'t miss out on your rewards!';
  }

  @override
  String get notifServerEventChannelName => 'Server Event Notifications';

  @override
  String get notifServerEventChannelDescription =>
      'Alerts for friend requests, ranking updates, and more';

  @override
  String get battlePassOverlayTierUpTitle => 'Battle Pass Tier Up!';

  @override
  String get battlePassOverlayRewardTitle => 'Reward Earned!';

  @override
  String get battlePassOverlayPremiumTitle => 'Premium Activated';

  @override
  String get battlePassOverlayPremiumBody =>
      'All premium track rewards have been unlocked';

  @override
  String get achievementOverlayUnlockedLabel => 'Achievement Unlocked!';

  @override
  String achievementOverlayPointsSuffix(int points) {
    return '+$points pts';
  }

  @override
  String get achievementOverlayShareButton => 'Share';

  @override
  String achievementShareText(String name, String description) {
    return 'I unlocked the achievement \"$name\" in Sengoku Saihairoku!\n$description\n#SengokuSaihairoku';
  }

  @override
  String get challengeConditionVictory => 'Clear the scenario';

  @override
  String challengeConditionTurnLimit(int turns) {
    return 'Clear within $turns turns';
  }

  @override
  String get challengeConditionNoDefeats => 'Clear without losing key units';

  @override
  String challengeConditionTpTarget(int count) {
    return 'Achieve $count or more TPs';
  }

  @override
  String challengeConditionScoreTarget(int score) {
    return 'Earn a score of $score or more';
  }

  @override
  String get effectCriticalLabel => 'Critical';
}
