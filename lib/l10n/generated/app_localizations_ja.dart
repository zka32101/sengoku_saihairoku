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

  @override
  String messageScreenTitle(String scenario) {
    return '歴史分析: $scenario';
  }

  @override
  String get messageScreenSubheading => 'あなたの采配が歴史だったなら';

  @override
  String get messageScreenViewpointLabel => '別の視点を見る';

  @override
  String get messageScreenHome => 'ホームへ';

  @override
  String messageScreenLoadError(String error) {
    return 'メッセージの読み込みに失敗しました: $error';
  }

  @override
  String get messageScreenNotFound => 'メッセージが見つかりませんでした';

  @override
  String get messageKeyVictoryPerfect => '完全勝利';

  @override
  String get messageKeyVictoryStandard => '勝利';

  @override
  String get messageKeyVictoryDifficult => '辛勝';

  @override
  String get messageKeyDefeat => '敗北';

  @override
  String get messageKeyTurningPointAll => '全TP達成';

  @override
  String get messageKeyTurningPointMost => 'TP多数達成';

  @override
  String get messageKeyHistoryChanged => '歴史変化';

  @override
  String get messageKeyHistoryFaithful => '史実通り';

  @override
  String get achievementListTitle => '実績';

  @override
  String get achievementCategoryCombat => '戦闘';

  @override
  String get achievementCategoryProgression => '進行度';

  @override
  String get achievementCategoryPrestige => 'プレスティジ';

  @override
  String get achievementCategoryCosmetic => 'コスメティック';

  @override
  String get achievementCategoryMilestone => 'マイルストーン';

  @override
  String get achievementCategoryEvent => 'イベント';

  @override
  String get achievementDifficultyBronze => 'ブロンズ';

  @override
  String get achievementDifficultySilver => 'シルバー';

  @override
  String get achievementDifficultyGold => 'ゴールド';

  @override
  String get achievementDifficultyDiamond => 'ダイヤモンド';

  @override
  String get achievementFilterTitle => 'フィルター';

  @override
  String get achievementFilterCategory => 'カテゴリー';

  @override
  String get achievementFilterDifficulty => '難易度';

  @override
  String get achievementFilterStatus => 'ステータス';

  @override
  String get achievementFilterSort => 'ソート';

  @override
  String get achievementFilterAll => 'すべて';

  @override
  String get achievementFilterUnlocked => 'クリア済み';

  @override
  String get achievementFilterLocked => 'ロック中';

  @override
  String get achievementSortName => '名前';

  @override
  String get achievementEmptyFiltered => 'フィルター条件に一致する実績がありません';

  @override
  String get achievementClearRate => 'クリア率';

  @override
  String get prestigeShowcaseTitle => 'プレスティジコスメティック';

  @override
  String get prestigeShowcaseEmptyTier => 'このランクのコスメティックはまだありません';

  @override
  String get prestigeShowcaseCurrentRank => '現在のプレスティジランク';

  @override
  String prestigeShowcaseNextRank(String rank) {
    return '次のランク: $rank';
  }

  @override
  String prestigeShowcaseMaxRank(String rank) {
    return '最高ランク: $rankに到達しました！';
  }

  @override
  String prestigeShowcaseResetCount(int count) {
    return 'リセット回数: $count';
  }

  @override
  String prestigeShowcaseRequiredPoints(int points) {
    return '必要ポイント: $points';
  }

  @override
  String get prestigeShowcaseUnlocked => '解放済み';

  @override
  String get prestigeShowcaseLocked => '未解放';

  @override
  String prestigeShowcaseItemType(String type) {
    return 'タイプ: $type';
  }

  @override
  String get prestigeShowcaseAcquired => '取得済み';

  @override
  String get prestigeShowcaseItemLocked => 'ロック中';

  @override
  String get advancedStatsTitle => '詳細統計';

  @override
  String get advancedStatsTabOverview => '概要';

  @override
  String get advancedStatsTabScenario => 'シナリオ';

  @override
  String get advancedStatsTabDifficulty => '難易度';

  @override
  String get advancedStatsTabRanking => 'ランキング';

  @override
  String get advancedStatsTotalBattles => '総バトル数';

  @override
  String get advancedStatsWinRate => '勝率';

  @override
  String get advancedStatsVictories => '勝利';

  @override
  String get advancedStatsDefeats => '敗北';

  @override
  String get advancedStatsHighestScore => '最高スコア';

  @override
  String get advancedStatsAverageScore => '平均スコア';

  @override
  String get advancedStatsPlayTime => 'プレイ時間';

  @override
  String get advancedStatsPerformanceTrend => 'パフォーマンストレンド';

  @override
  String advancedStatsWinRateChange(String percent) {
    return '勝率: $percent%';
  }

  @override
  String advancedStatsScoreChange(String score) {
    return 'スコア: ${score}pt';
  }

  @override
  String get advancedStatsWinRateTrendLabel => '勝率の推移';

  @override
  String get advancedStatsScoreTrendLabel => 'スコアの推移';

  @override
  String get advancedStatsScenarioClearStatus => 'シナリオ制覇状況';

  @override
  String get advancedStatsTrendImproving => '📈 上昇傾向';

  @override
  String get advancedStatsTrendDeclining => '📉 低下傾向';

  @override
  String get advancedStatsTrendStable => '→ 安定傾向';

  @override
  String get rankingTitle => 'ランキング';

  @override
  String get rankingShareTooltip => 'ランキングを共有';

  @override
  String get rankingShareText => '戦国采配録でランキングに挑戦中！あなたも采配を振るってみない？\n#戦国采配録';

  @override
  String get rankingGlobal => 'グローバル';

  @override
  String get rankingMyPlay => 'マイプレイ';

  @override
  String get rankingAllScenarios => '全シナリオ';

  @override
  String get rankingEmpty => 'ランキングデータはまだありません';

  @override
  String get rankingWon => '勝利';

  @override
  String rankingSeasonBestNone(String season) {
    return '$season: まだ記録がありません';
  }

  @override
  String rankingSeasonBestScore(String season, int score) {
    return '$season: 自己ベスト $score点';
  }

  @override
  String rankingDurationSeconds(int seconds) {
    return '$seconds秒';
  }

  @override
  String get warlordCollectionTitle => '武将図鑑';

  @override
  String warlordCollectionUnlockedCount(int unlocked, int total) {
    return '$unlocked / $total 解放済み';
  }

  @override
  String get warlordCollectionDrawing => '発掘中...';

  @override
  String warlordCollectionDrawButton(int cost) {
    return '武将を発掘する（$costゴールド）';
  }

  @override
  String get warlordCollectionAllFilter => 'すべて';

  @override
  String get warlordCollectionAllUnlocked => 'すべての武将を解放済みです';

  @override
  String get warlordCollectionGoldShortage => 'ゴールドが不足しています';

  @override
  String get warlordCollectionLocked => '???';

  @override
  String get warlordCollectionUndiscovered => '未発掘';

  @override
  String warlordCollectionTotalStat(int stat) {
    return '総合力 $stat';
  }

  @override
  String get warlordDetailLeadership => '統率';

  @override
  String get warlordDetailValor => '武勇';

  @override
  String get warlordDetailIntelligence => '知略';

  @override
  String warlordDetailAwakenedLevel(int level) {
    return '覚醒済み（Lv.$level）';
  }

  @override
  String warlordDetailLevel(int level) {
    return 'Lv.$level';
  }

  @override
  String get warlordDetailExpHint => '出陣させて勝利するとEXPを獲得します';

  @override
  String get warlordDiscoveredTitle => '武将を発見！';

  @override
  String get warlordArchetypeLeadership => '采配の名手';

  @override
  String get warlordArchetypeValor => '猛将';

  @override
  String get warlordArchetypeIntelligence => '智将';

  @override
  String warlordArchetypeLegendary(String archetype) {
    return '伝説の$archetype';
  }

  @override
  String get goldShopTitle => 'ゴールドショップ';

  @override
  String get goldShopPurchaseSuccess => 'ゴールドを獲得しました！';

  @override
  String goldShopPurchaseFailure(String error) {
    return '購入に失敗しました: $error';
  }

  @override
  String get goldShopUnknownError => '不明なエラー';

  @override
  String goldShopAdRewardEarned(int amount) {
    return '$amountゴールドを獲得しました！';
  }

  @override
  String get goldShopAdFailure => '広告を表示できませんでした。しばらくしてから再度お試しください';

  @override
  String get goldShopBalanceLabel => '所持ゴールド';

  @override
  String goldShopWatchAdTitle(int amount) {
    return '広告を見て$amountゴールド獲得';
  }

  @override
  String goldShopWatchAdRemaining(int remaining, int limit) {
    return '本日あと$remaining/$limit回';
  }

  @override
  String get goldShopWatchButton => '視聴する';

  @override
  String get goldShopWatchLimitReached => '上限到達';

  @override
  String get goldShopPacksTitle => 'ゴールドパック';

  @override
  String get goldShopStoreUnavailable => 'ストアに接続できません';

  @override
  String get goldShopNoProducts => '現在購入可能な商品がありません';

  @override
  String get goldShopBestValueBadge => 'もっともお得';

  @override
  String get goldShopPopularBadge => '人気';

  @override
  String goldShopGoldAmount(int amount) {
    return '$amount ゴールド';
  }

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileLoadError => 'ユーザーデータを読み込めませんでした';

  @override
  String get profileLevelLabel => 'レベル';

  @override
  String get profileXpLabel => '経験値';

  @override
  String profileXpSuffix(String xp) {
    return '$xp XP';
  }

  @override
  String get profileNextLevelProgress => '次のレベルまでの進捗';

  @override
  String get profileMaxLevelReached => '最大レベルに到達！プレスティジでリセットできます';

  @override
  String get profilePrestigeRank => 'プレスティジランク';

  @override
  String get profilePrestigePoints => 'プレスティジポイント';

  @override
  String profilePrestigeResetCount(int count) {
    return 'リセット回数: $count';
  }

  @override
  String get profileCosmeticsTitle => 'コスメティック';

  @override
  String profileUnitSkinsLabel(int count) {
    return 'ユニットスキン ($count)';
  }

  @override
  String profileUiThemesLabel(int count) {
    return 'UIテーマ ($count)';
  }

  @override
  String get profileCosmeticsEmpty => 'コスメティックはまだ解放されていません';

  @override
  String get profileProgressionDetailsTitle => 'プログレッション詳細';

  @override
  String get profileUserIdLabel => 'ユーザーID';

  @override
  String get profilePlayTimeLabel => 'プレイ時間';

  @override
  String profilePlayTimeFormat(int hours, int minutes) {
    return '$hours時間 $minutes分';
  }

  @override
  String get profileLastUpdatedLabel => '最終更新';

  @override
  String profileDateFormat(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get profileUnlockedCosmeticsLabel => 'アンロック済みコスメティック';

  @override
  String profileUnlockedCosmeticsCount(int count) {
    return '$count個';
  }

  @override
  String get profileActionsTitle => 'アクション';

  @override
  String get profileCosmeticsSettingsButton => 'コスメティック設定';

  @override
  String get profilePrestigeButton => 'プレスティジ';

  @override
  String profilePrestigeLockedButton(int level) {
    return 'プレスティジ (Lv.$levelで解放)';
  }

  @override
  String get profileAchievementsTitle => '実績';

  @override
  String get profileAchievementsViewAllButton => 'すべての実績を表示';

  @override
  String get homeAppTitle => '戦国采配録';

  @override
  String get homeTagline => '天下を狙え';

  @override
  String get homeTodayChallengeLabel => '本日のチャレンジ';

  @override
  String get homeWeeklyChallengeLabel => '今週のチャレンジ';

  @override
  String get homeSpotBattleTitle => 'スポット戦';

  @override
  String get homeSpotBattleSubtitle => '有名な合戦を選んで采配を振るえ';

  @override
  String get homeSpotBattlePlayTime => 'プレイ時間: 3〜8分';

  @override
  String get homeSpotBattleButton => 'シナリオを選ぶ';

  @override
  String get homeChainBattleTitle => '連戦モード';

  @override
  String get homeChainBattleSubtitle => '休憩なしで全シナリオを攻略する高難度の縛りプレイ';

  @override
  String get homeChainBattleButton => '連戦に挑む';

  @override
  String get homeReplayTitle => 'バトルリプレイ';

  @override
  String get homeReplaySubtitle => '過去のバトルを再生・分析する';

  @override
  String get homeReplayNote => 'すべてのバトルは自動で記録されます';

  @override
  String get homeReplayButton => 'リプレイを見る';

  @override
  String get homeRankingTitle => 'ランキング';

  @override
  String get homeRankingSubtitle => '他の武将の采配と競え';

  @override
  String get homeRankingButton => 'ランキングを見る';

  @override
  String get homeChallengeHistoryTitle => 'チャレンジ履歴';

  @override
  String get homeChallengeHistorySubtitle => '過去7日間のチャレンジを確認';

  @override
  String get homeChallengeHistoryButton => 'チャレンジ履歴を見る';

  @override
  String get homeFriendsTitle => 'フレンド';

  @override
  String get homeFriendsSubtitle => 'フレンドコードを交換してランキングを競おう';

  @override
  String get homeFriendsButton => 'フレンドを見る';

  @override
  String get homeWarlordCollectionTitle => '武将図鑑';

  @override
  String get homeWarlordCollectionSubtitle => 'ゴールドで武将を発掘し、図鑑をコンプリートしよう';

  @override
  String get homeWarlordCollectionButton => '図鑑を見る';

  @override
  String get homeGoldShopTitle => 'ゴールドショップ';

  @override
  String get homeGoldShopSubtitle => 'ゴールドを購入してバトルパスの進行を加速';

  @override
  String get homeGoldShopButton => 'ショップを見る';

  @override
  String get homeBattlePassTitle => 'バトルパス';

  @override
  String get homeBattlePassSubtitle => 'シーズンを通してティアをアップ';

  @override
  String homeBattlePassMissedRewards(int count) {
    return 'プレミアム報酬を$count件受け取り逃し中';
  }

  @override
  String get homeBattlePassButton => 'バトルパスを見る';

  @override
  String get resultTitle => '戦闘結果';

  @override
  String get resultVictory => '勝利！';

  @override
  String get resultDefeat => '敗北';

  @override
  String get resultVictorySubtitle => '見事な采配であった';

  @override
  String get resultDefeatSubtitle => '次は必ず雪辱を晴らせ';

  @override
  String get resultTotalScoreLabel => '総スコア';

  @override
  String resultScorePoints(String score) {
    return '$score点';
  }

  @override
  String get resultScoreVictory => '勝敗スコア';

  @override
  String get resultScoreEfficiency => '効率スコア';

  @override
  String get resultScoreCommand => '采配スコア';

  @override
  String get resultScoreTurningPoint => 'TP ボーナス';

  @override
  String get resultScoreHistory => '歴史ボーナス';

  @override
  String get resultTurningPointTitle => 'ターニングポイント';

  @override
  String resultTpFallback(int number) {
    return 'TP$number';
  }

  @override
  String get resultViewHistoryButton => '歴史分析を見る';

  @override
  String get resultViewRankingButton => 'ランキングを見る';

  @override
  String get resultShareButton => '結果をシェア';

  @override
  String get resultHomeButton => 'ホームへ戻る';

  @override
  String resultShareText(
    String scenario,
    String result,
    int score,
    int tp,
    int total,
  ) {
    return '戦国采配録『$scenario』で$result！\nスコア: $score pts / ターニングポイント $tp/$total\n#戦国采配録';
  }

  @override
  String get resultShareVictory => '勝利';

  @override
  String get resultShareDefeat => '敗北';

  @override
  String resultFriendChallengeSuccess(String friend) {
    return '$friendへの挑戦、成功！';
  }

  @override
  String resultFriendChallengeFailure(String friend) {
    return '$friendへの挑戦、届かず';
  }

  @override
  String resultFriendChallengeTarget(int score) {
    return '目標スコア: $score点';
  }

  @override
  String get resultChallengeCompletedTitle => '本日のチャレンジ達成！';

  @override
  String get resultChallengeCompletedNote => '報酬を受け取るにはホーム画面から獲得してください';

  @override
  String get resultXpGainTitle => '経験値獲得';

  @override
  String get resultXpGainedLabel => '獲得XP:';

  @override
  String get resultXpBoostLoading => '読み込み中…';

  @override
  String get resultXpBoostButton => '広告を見てXPを2倍にする';

  @override
  String get resultLevelUpTitle => 'レベルアップ！';

  @override
  String resultLevelUpSubtitle(int level) {
    return 'レベル $level に到達しました';
  }

  @override
  String get resultBattlePassTierUpTitle => 'バトルパス ティアアップ！';

  @override
  String resultBattlePassTierUpSubtitle(int tier) {
    return 'ティア $tier に到達しました';
  }

  @override
  String get resultCosmeticUnlockTitle => 'コスメティック解放！';

  @override
  String get resultTpOdigahara1 => '敵到着前に奇襲';

  @override
  String get resultTpOdigahara2 => '嵐の中での戦闘';

  @override
  String get resultTpOdigahara3 => '敵将兵力低下';

  @override
  String get resultTpOdigahara4 => '敵将討死';

  @override
  String get resultTpNagashino1 => '初期陣形を防御に設定';

  @override
  String get resultTpNagashino2 => '敵騎馬隊の突撃を耐える';

  @override
  String get resultTpNagashino3 => '一斉反撃';

  @override
  String get resultTpNagashino4 => '敵将討死';

  @override
  String get resultTpHonnoJi1 => '敵の包囲を突破';

  @override
  String get resultTpHonnoJi2 => '援軍到着まで生存';

  @override
  String get resultTpHonnoJi3 => '援軍到着後の反撃';

  @override
  String get resultTpHonnoJi4 => '敵総大将討死';

  @override
  String get resultTpSekigahara1 => '序盤は慎重に';

  @override
  String get resultTpSekigahara2 => '味方のモラル維持';

  @override
  String get resultTpSekigahara3 => '側面を奇襲';

  @override
  String get resultTpSekigahara4 => '敵将討死';

  @override
  String get resultTpSekigahara5 => '豊臣武将生存';

  @override
  String get resultTpKawanakajima1 => '夜明けの奇襲に備える';

  @override
  String get resultTpKawanakajima2 => '別働隊到着まで凌ぐ';

  @override
  String get resultTpKawanakajima3 => '挟撃を成功させる';

  @override
  String get resultTpKawanakajima4 => '敵将討死';

  @override
  String get resultTpItsukushima1 => '暴風雨に乗じた奇襲';

  @override
  String get resultTpItsukushima2 => '宮尾城を死守';

  @override
  String get resultTpItsukushima3 => '退路を断ち包囲';

  @override
  String get resultTpItsukushima4 => '敵将討死';

  @override
  String get resultTpOshijo1 => '偽情報で敵を翻弄';

  @override
  String get resultTpOshijo2 => '堤防決壊で敵陣を打撃';

  @override
  String get resultTpOshijo3 => '寄せ手の猛攻を耐え抜く';

  @override
  String get resultTpOshijo4 => '敵将討死';

  @override
  String get scenarioSelectTitle => 'シナリオを選ぶ';

  @override
  String get scenarioSelectHelpTooltip => 'ヘルプ';

  @override
  String scenarioYearSuffix(int year) {
    return '$year年';
  }

  @override
  String get scenarioSettingsTitle => 'シナリオ設定';

  @override
  String get scenarioPerspectiveTitle => '視点を選ぶ';

  @override
  String get scenarioWarlordSelectTitle => '出陣武将を選ぶ（任意・最大2名）';

  @override
  String get scenarioWarlordSelectHint =>
      '統率ステータスに応じて自軍全体の兵力が上昇します。2名選ぶと相性（同勢力・知略シナジー・統率差）に加え、1人目が先鋒隊・2人目が本隊を指揮し、各武将の武勇が担当部隊に反映されます';

  @override
  String get scenarioWarlordAwakenedTag => '覚醒';

  @override
  String scenarioWarlordChipLabel(
    String name,
    int level,
    String awakened,
    int leadership,
  ) {
    return '$name Lv.$level$awakened (統率$leadership)';
  }

  @override
  String scenarioCompatibilityLabel(String multiplier, String note) {
    return '相性倍率: ×$multiplier$note';
  }

  @override
  String get scenarioCompatibilityPositive => '（好相性）';

  @override
  String get scenarioCompatibilityNegative => '（不協和）';

  @override
  String get scenarioDifficultyTitle => '難易度を選ぶ';

  @override
  String get scenarioLoadingText => 'シナリオを読み込み中...';

  @override
  String get scenarioLoadErrorText => 'シナリオの読み込みに失敗しました';

  @override
  String get scenarioNameOdigahara => '桶狭間の戦';

  @override
  String get scenarioDescOdigahara => '3,500 vs 15,000 — 圧倒的劣勢を奇策で覆せ';

  @override
  String get scenarioPlayTimeOdigahara => '3〜5分';

  @override
  String get scenarioNameNagashino => '長篠の戦';

  @override
  String get scenarioDescNagashino => '防衛陣形で武田騎馬隊を迎え撃て';

  @override
  String get scenarioPlayTimeNagashino => '4〜6分';

  @override
  String get scenarioNameHonnoji => '本能寺の変';

  @override
  String get scenarioDescHonnoji => '500 vs 13,000 — 絶望的状況からの逆転';

  @override
  String get scenarioPlayTimeHonnoji => '5〜7分';

  @override
  String get scenarioNameSekigahara => '関ヶ原の戦';

  @override
  String get scenarioDescSekigahara => '天下分け目 — 複雑な戦局を制せよ';

  @override
  String get scenarioPlayTimeSekigahara => '6〜8分';

  @override
  String get scenarioNameKawanakajima => '川中島の戦';

  @override
  String get scenarioDescKawanakajima => '夜明けの奇襲を受けた本隊のみで、別働隊到着まで持ちこたえよ';

  @override
  String get scenarioPlayTimeKawanakajima => '4〜6分';

  @override
  String get scenarioNameItsukushima => '厳島の戦';

  @override
  String get scenarioNameOshijo => '忍城の戦い';

  @override
  String get scenarioDescItsukushima => '4,000 vs 15,000 — 暴風雨に乗じた奇襲で殲滅せよ';

  @override
  String get scenarioPlayTimeItsukushima => '4〜5分';

  @override
  String get scenarioDescOshijo => '3,000 vs 20,000 — 水攻めに耐え、寡兵で大軍を退けよ';

  @override
  String get scenarioPlayTimeOshijo => '4〜5分';

  @override
  String get tutorialTitle => '初陣：采配の基本';

  @override
  String get tutorialPaceSelectTitle => '進め方を選ぶ';

  @override
  String get tutorialPaceThoroughButton => 'じっくり学ぶ（解説つき）';

  @override
  String get tutorialPaceBriskButton => '駆け足で済ませる（解説なし）';

  @override
  String get tutorialEnemyBaseLabel => '敵本陣';

  @override
  String get tutorialVictoryTitle => '初陣、勝利！';

  @override
  String get tutorialVictoryMessage => '奇襲・盾陣・激励・突撃…\n采配次第で劣勢は覆せる。\nさあ、本当の戦場へ。';

  @override
  String get tutorialStartJourneyButton => '武将としての旅を始める';

  @override
  String get tutorialStepAmbushLabel => '奇襲';

  @override
  String get tutorialStepAmbushPrompt =>
      '兵力は敵の数分の一…正面からでは勝てない。\nまずは「奇襲」で敵の側面を突こう。';

  @override
  String get tutorialStepAmbushResult => '奇襲成功！敵陣が崩れ、大きな打撃を与えた。';

  @override
  String get tutorialStepShieldLabel => '盾陣';

  @override
  String get tutorialStepShieldPrompt => '敵の反撃が始まる。「盾陣」で守りを固め、\n被害を抑えよう。';

  @override
  String get tutorialStepShieldResult => '盾陣を展開！味方の防御力が大きく上がった。';

  @override
  String get tutorialStepRallyLabel => '激励';

  @override
  String get tutorialStepRallyPrompt => '味方の士気を「激励」で高め、\n攻撃力を引き上げよう。';

  @override
  String get tutorialStepRallyResult => '将兵の士気が上がり、攻撃力が上昇した！';

  @override
  String get tutorialStepChargeLabel => '突撃';

  @override
  String get tutorialStepChargePrompt => '敵は崩れかけている。最後は「突撃」で\n一気に畳み掛けよう！';

  @override
  String get tutorialStepChargeResult => '全軍突撃！敵将本陣を突き崩し、勝利を掴んだ！';

  @override
  String get chainBattleTitle => '連戦モード';

  @override
  String chainBattleDifficultyIntro(int count) {
    return '連戦モードは全$count戦を休憩なしで攻略します。ステージが進むほど自軍兵力が疲労で減少します。難易度を選んでください。';
  }

  @override
  String chainBattleStageLabel(int current, int total) {
    return 'ステージ $current / $total';
  }

  @override
  String chainBattleFatigueMultiplier(String multiplier) {
    return '疲労による兵力倍率: ×$multiplier';
  }

  @override
  String chainBattleResultLine(String scenario, String result, int score) {
    return '$scenario: $result（$score点）';
  }

  @override
  String get chainBattleWin => '勝利';

  @override
  String get chainBattleLoss => '敗北';

  @override
  String get chainSummaryTitle => '連戦終了';

  @override
  String chainSummaryWins(int wins, int total) {
    return '$wins / $total 勝利';
  }

  @override
  String chainSummaryTotalScore(int score) {
    return '合計スコア: $score点';
  }

  @override
  String chainSummaryResultLine(String result, int score) {
    return '$result $score点';
  }

  @override
  String get chainSummaryHomeButton => 'ホームに戻る';

  @override
  String chainCompletionAdLabel(int amount) {
    return '広告を見て連戦の労をねぎらうボーナス$amountゴールドを獲得';
  }

  @override
  String get prestigeResetTitle => 'プレスティジ';

  @override
  String get prestigeResetSuccessMessage => 'プレスティジリセットが完了しました！';

  @override
  String prestigeResetErrorMessage(String error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get prestigeResetLockedLevelReason => 'レベル100に到達してください';

  @override
  String prestigeResetLockedPointsReason(int points) {
    return 'プレスティジポイント1000以上が必要です\n現在: $points';
  }

  @override
  String get prestigeResetCurrentRankLabel => '現在のプレスティジランク';

  @override
  String prestigeResetCountSuffix(int count) {
    return 'リセット回数: $count回';
  }

  @override
  String get prestigeResetLockedTitle => 'プレスティジが利用できません';

  @override
  String get prestigeResetActionTitle => 'プレスティジリセット実行';

  @override
  String get prestigeResetActionDescription => '条件を満たしています。プレスティジリセットを実行できます。';

  @override
  String get prestigeResetProcessing => '処理中...';

  @override
  String get prestigeResetBenefitsTitle => 'プレスティジについて';

  @override
  String get prestigeResetBenefit1Title => 'レベルとXPがリセット';

  @override
  String get prestigeResetBenefit1Desc => 'レベルが1に戻り、XPが0にリセットされます';

  @override
  String get prestigeResetBenefit2Title => 'プレスティジランク上昇';

  @override
  String get prestigeResetBenefit2Desc => 'ターン効率に基づいて新しいランクが決定されます';

  @override
  String get prestigeResetBenefit3Title => '限定コスメティック解放';

  @override
  String get prestigeResetBenefit3Desc => '新しいランクに対応した限定スキンやテーマが解放されます';

  @override
  String get prestigeResetBenefit4Title => '次回リセット条件が上昇';

  @override
  String get prestigeResetBenefit4Desc => 'より多くのプレスティジポイントが必要になります';

  @override
  String get prestigeResetConfirmTitle => 'プレスティジリセット確認';

  @override
  String get prestigeResetConfirmIntro => 'プレスティジリセットを実行します。以下の内容で問題ありませんか？';

  @override
  String get prestigeResetConfirmCurrentLevel => '現在のレベル';

  @override
  String get prestigeResetConfirmRank => 'リセット後のランク';

  @override
  String get prestigeResetIrreversibleWarning => 'この操作は取り消せません';

  @override
  String get prestigeResetConfirmExecuteButton => 'リセットを実行';

  @override
  String get cosmeticsEquipTitle => 'コスメティック設定';

  @override
  String get cosmeticsEquipSuccess => 'コスメティックを装備しました';

  @override
  String get cosmeticsUnequipSuccess => 'コスメティックを外しました';

  @override
  String get cosmeticsUnitSkinTitle => 'ユニットスキン';

  @override
  String get cosmeticsUiThemeTitle => 'UIテーマ';

  @override
  String get cosmeticsEquippedLabel => '装備中:';

  @override
  String get cosmeticsUnknownName => '不明';

  @override
  String get cosmeticsUnequipButton => '外す';

  @override
  String get cosmeticsEquippedBadge => '装備中';

  @override
  String get cosmeticsEquipButton => '装備する';

  @override
  String cosmeticsNoCosmeticsTitle(String type) {
    return '$typeはまだ解放されていません';
  }

  @override
  String get cosmeticsNoCosmeticsHint => 'レベルアップやプレスティジで解放されます';

  @override
  String get cosmeticsAcquisitionLevelMilestone => 'レベル報酬';

  @override
  String get cosmeticsAcquisitionAchievement => 'アチーブメント';

  @override
  String get cosmeticsAcquisitionPrestige => 'プレスティジ報酬';

  @override
  String get cosmeticsAcquisitionBattlePass => 'バトルパス';

  @override
  String get cosmeticsAcquisitionEvent => 'イベント報酬';

  @override
  String get cosmeticsPrestigeRankLabel => 'プレスティジランク';

  @override
  String cosmeticsResetCountLabel(int count) {
    return 'リセット回数: $count';
  }

  @override
  String cosmeticsPointsLabel(int points) {
    return 'ポイント: $points';
  }

  @override
  String get cosmeticsShowcaseTitle => 'プレスティジコスメティック';

  @override
  String cosmeticsShowcaseRankLine(String rank) {
    return 'ランク: $rank';
  }

  @override
  String get cosmeticsShowcaseEquippedSkinLabel => '装備中のユニットスキン';

  @override
  String get cosmeticsShowcaseEquippedThemeLabel => '装備中のUIテーマ';

  @override
  String get cosmeticsShowcaseEmpty => 'プレスティジコスメティックがまだ装備されていません';

  @override
  String get cosmeticsPrestigeSectionEmptyHint => 'プレスティジリセットを行うと解放されます';

  @override
  String cosmeticsPrestigeCurrentRankLine(String rank) {
    return '現在のプレスティジランク: $rank';
  }

  @override
  String get cosmeticsPrestigeUnitSkinTitle => 'プレスティジユニットスキン';

  @override
  String get cosmeticsPrestigeUiThemeTitle => 'プレスティジUIテーマ';

  @override
  String get cosmeticsPrestigeTierSilver => 'シルバー';

  @override
  String get cosmeticsPrestigeTierGold => 'ゴールド';

  @override
  String get cosmeticsPrestigeTierPlatinum => 'プラチナ';

  @override
  String get cosmeticsPrestigeTierDiamond => 'ダイヤモンド';

  @override
  String get cosmeticsPrestigeTierUnknown => '不明';

  @override
  String get friendsTitle => 'フレンド';

  @override
  String get friendsAddedSuccess => 'フレンドを追加しました！';

  @override
  String get friendsAddFailed => 'コードが無効か、既にフレンド登録済みです';

  @override
  String get friendsChallengeScenarioTitle => '挑戦するシナリオを選ぶ';

  @override
  String get friendsNoRecordYet => 'このフレンドはまだこのシナリオの記録がありません';

  @override
  String friendsChallengeSetMessage(String friend, String scenario, int score) {
    return '目標設定: $friendの$scenarioスコア $score点を超えよう！シナリオ選択から出陣してください';
  }

  @override
  String friendsShareMyCodeText(String code) {
    return '戦国采配録で対戦しよう！\nフレンドコード: $code';
  }

  @override
  String get friendsCopySuccess => 'フレンドコードをコピーしました';

  @override
  String get friendsMyCodeLabel => 'あなたのフレンドコード';

  @override
  String get friendsCopyButton => 'コピー';

  @override
  String get friendsShareButton => '共有';

  @override
  String get friendsAddFriendTitle => 'フレンドを追加';

  @override
  String get friendsCodeHint => 'フレンドコードを入力';

  @override
  String get friendsAddButton => '追加';

  @override
  String get friendsRankingTitle => 'フレンドランキング（合計スコア）';

  @override
  String get friendsNoRecordsYet => 'まだ戦績がありません';

  @override
  String get friendsRecentActivityTitle => '最近の戦績';

  @override
  String friendsListTitle(int count) {
    return 'フレンド一覧 ($count)';
  }

  @override
  String get friendsNoFriendsYet => 'まだフレンドがいません';

  @override
  String get friendsYouLabel => 'あなた';

  @override
  String friendsActivityLine(String player, String scenario, String result) {
    return '$player が$scenarioで$result';
  }

  @override
  String get friendsChallengeTooltip => '挑戦する';

  @override
  String get onboardingSkipButton => 'スキップ';

  @override
  String get onboardingNextButton => '次へ';

  @override
  String get onboardingStartButton => '初陣へ';

  @override
  String get onboardingPage1Title => '戦国采配録へようこそ';

  @override
  String get onboardingPage1Description =>
      '桶狭間、本能寺、関ヶ原…\n兵力で劣る武将となり、采配一つで\n歴史に残る大逆転劇を実現せよ。';

  @override
  String get onboardingPage2Title => '圧倒的劣勢から始まる';

  @override
  String get onboardingPage2Description =>
      '多くのシナリオでは、敵の兵力が\nあなたの数倍〜十数倍に達する。\n正面からの力押しでは勝てない。';

  @override
  String get onboardingPage3Title => 'コマンドで戦況を動かす';

  @override
  String get onboardingPage3Description =>
      '奇襲・盾陣・進軍・撤退・鼓舞・突撃…\n状況に応じたコマンドの選択こそが\n勝敗を分ける采配の要。';

  @override
  String get onboardingPage4Title => 'ターニングポイントを狙え';

  @override
  String get onboardingPage4Description =>
      '各シナリオには史実に基づいた\n「ターニングポイント」が用意されている。\n条件を満たして達成し、高得点を狙おう。';

  @override
  String get onboardingPage5Title => '成長し続ける武将';

  @override
  String get onboardingPage5Description =>
      'レベル・実績・バトルパス・プレスティジ…\n戦えば戦うほど武将は成長する。\nさあ、初陣の采配を振るおう！';

  @override
  String get replayWatchSharedTooltip => '共有コードで観戦';

  @override
  String get replayDeleteConfirmTitle => '削除確認';

  @override
  String get replayDeleteConfirmBody => 'このリプレイを削除しますか？';

  @override
  String get replayDeleteButton => '削除';

  @override
  String get replayShareIssuingCode => '共有コードを発行中...';

  @override
  String get replayShareCodeTitle => '共有コード';

  @override
  String get replayShareCodeHint => 'このコードをフレンドに伝えると観戦できます';

  @override
  String get replayShareButton => '共有する';

  @override
  String get replayShareMenuItem => '共有';

  @override
  String replayShareFailure(String error) {
    return '共有に失敗しました: $error';
  }

  @override
  String replayShareText(String code) {
    return '戦国采配録のリプレイを見てください！\n共有コード: $code';
  }

  @override
  String get replayCodeEntryTitle => '共有コードで観戦';

  @override
  String get replayCodeEntryHint => '例: A3F9QZ';

  @override
  String get replayWatchButton => '観戦する';

  @override
  String get replayFetchingReplay => 'リプレイを取得中...';

  @override
  String get replayNotFound => 'リプレイが見つかりませんでした';

  @override
  String get replayFilterAll => 'すべて';

  @override
  String get replayEmptyMessage => 'リプレイがありません';

  @override
  String replayLikeCountSuffix(int count) {
    return '$count いいね';
  }

  @override
  String get replayCommentHint => 'コメントを残す';

  @override
  String get replayStatsTotalLabel => '総リプレイ数';

  @override
  String get replayStatsWinRateLabel => '勝率';

  @override
  String get replayStatsAverageScoreLabel => '平均スコア';

  @override
  String get replayStatsWinLossLabel => '勝/敗';

  @override
  String replayDifficultyScoreLine(String difficulty, int score) {
    return '$difficulty • スコア: $score';
  }

  @override
  String get battlePassTitle => 'バトルパス';

  @override
  String get battlePassPremiumUnlockedSnackbar => 'プレミアムトラックを解放しました！';

  @override
  String battlePassPurchaseFailedSnackbar(String error) {
    return '購入に失敗しました: $error';
  }

  @override
  String get battlePassUnknownError => '不明なエラー';

  @override
  String get battlePassSeasonEndLabel => 'シーズン終了';

  @override
  String battlePassSeasonEndDate(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get battlePassDaysRemainingLabel => '残り日数';

  @override
  String battlePassDaysRemainingValue(int days) {
    return '$days日';
  }

  @override
  String get battlePassStoreUnavailable => 'ストア利用不可';

  @override
  String get battlePassPremiumUnlockTitle => 'プレミアムトラックを解放';

  @override
  String get battlePassPremiumUnlockDescription =>
      '現在のティアまでのプレミアム限定報酬をすべて即座に獲得し、以降のティアアップでも継続してプレミアム報酬を受け取れます。';

  @override
  String battlePassMissedRewardWarning(int count) {
    return 'すでに$count件のプレミアム報酬を受け取り逃しています！';
  }

  @override
  String battlePassUnlockForPrice(String priceLabel) {
    return '$priceLabel で解放する';
  }

  @override
  String get battlePassRestorePurchase => '購入を復元';

  @override
  String get battlePassTierRewardsTitle => 'ティア報酬';

  @override
  String get battlePassCurrentTierLabel => '現在のティア';

  @override
  String battlePassTierOfMax(int current, int max) {
    return 'ティア $current / $max';
  }

  @override
  String get battlePassPremiumBadge => 'プレミアム';

  @override
  String get battlePassProgressLabel => '進捗';

  @override
  String battlePassXpOfTotal(int current, int total) {
    return '$current / $total';
  }

  @override
  String battlePassXpUntilNextTier(int xp) {
    return '次のティアまで $xp XP';
  }

  @override
  String get battlePassMaxTierReached => '最大ティアに達成しました！';

  @override
  String get battlePassFreeBadge => 'フリー';

  @override
  String battleScenarioLoadError(String error) {
    return 'シナリオの読み込みに失敗しました: $error';
  }

  @override
  String get battlePlayerSideLabel => '味方';

  @override
  String get battleEnemySideLabel => '敵';

  @override
  String battleTpCounter(int count, int total) {
    return 'TP: $count / $total';
  }

  @override
  String battleComboCounter(int count) {
    return 'コンボ: $count';
  }

  @override
  String battleCommandScore(int score) {
    return '采配: $score';
  }

  @override
  String get battleCommandAdvance => '進軍';

  @override
  String get battleCommandRetreat => '撤退';

  @override
  String get battleCommandWait => '待機';

  @override
  String get battleCommandAmbush => '奇襲';

  @override
  String get battleCommandCharge => '突撃';

  @override
  String get battleCommandRally => '激励';

  @override
  String get battleCommandShield => '盾陣';

  @override
  String get battleCommandFormation => '陣形';

  @override
  String get battleCommandSpecialLabel => '特殊';

  @override
  String get battleTurningPointAchievedTitle => 'ターニングポイント達成！';

  @override
  String battleTurningPointRewardLine(String name, int points) {
    return '$name  +$points点';
  }

  @override
  String get battleMomentumEnemyLabel => '敵優勢';

  @override
  String get battleMomentumPlayerLabel => '味方優勢';

  @override
  String get achievementConditionBattleWins => '戦闘勝利';

  @override
  String get achievementConditionLevelReached => 'レベル到達';

  @override
  String get achievementConditionPrestigeRank => 'プレスティジランク';

  @override
  String get achievementConditionTurnEfficiency => 'ターン効率';

  @override
  String get achievementConditionCosmeticUnlocked => 'コスメティック解放';

  @override
  String get achievementConditionTotalPlayTime => 'プレイ時間';

  @override
  String get achievementConditionScenarioCleared => 'シナリオクリア';

  @override
  String get achievementConditionPerfectBattle => 'パーフェクト戦闘';

  @override
  String get achievementConditionPrestigeResetCount => 'プレスティジリセット回数';

  @override
  String get achievementConditionEventChallengeCompleted => 'イベントチャレンジ達成';

  @override
  String get achievementConditionWarlordsCollected => '武将図鑑解放数';

  @override
  String achievementDescBattleWins(int value) {
    return '$value 回の戦闘に勝利';
  }

  @override
  String achievementDescLevelReached(int value) {
    return 'レベル $value に到達';
  }

  @override
  String achievementDescPrestigeRank(int value) {
    return 'プレスティジランク $value';
  }

  @override
  String achievementDescTurnEfficiency(int value) {
    return '$value ターン以内にクリア';
  }

  @override
  String achievementDescCosmeticUnlocked(int value) {
    return '$value 個のコスメティックを解放';
  }

  @override
  String achievementDescTotalPlayTime(int value) {
    return '総プレイ時間 $value 時間';
  }

  @override
  String get achievementDescScenarioCleared => 'シナリオをクリア';

  @override
  String get achievementDescPerfectBattle => 'ユニットロスなしでクリア';

  @override
  String achievementDescPrestigeResetCount(int value) {
    return '$value 回プレスティジリセット';
  }

  @override
  String achievementDescEventChallengeCompleted(int value) {
    return '$value 個のイベントチャレンジを達成';
  }

  @override
  String achievementDescWarlordsCollected(int value) {
    return '$value 人の武将を図鑑に登録';
  }

  @override
  String get achievementDetailUnlockedBadge => 'クリア済み';

  @override
  String get achievementDetailLockedBadge => 'ロック中';

  @override
  String get achievementDetailCategoryLabel => 'カテゴリー';

  @override
  String get achievementDetailDifficultyLabel => '難易度';

  @override
  String get achievementDetailPointsLabel => 'ポイント';

  @override
  String get achievementDetailDescriptionLabel => '説明';

  @override
  String get achievementDetailConditionLabel => '達成条件';

  @override
  String get achievementDetailRewardLabel => '報酬';

  @override
  String get statsDashboardCombatStatsTitle => '戦闘統計';

  @override
  String get statsDashboardPlayTimeTitle => 'プレイ時間';

  @override
  String get statsDashboardScoreTitle => 'スコア';

  @override
  String get statsDashboardWinRateAnalysisTitle => '勝率分析';

  @override
  String get statsDashboardTurningPointTitle => 'ターニングポイント';

  @override
  String get statsDashboardViewDetailsButton => '詳細統計を見る';

  @override
  String statsDashboardPointsSuffix(int points) {
    return '$points ポイント';
  }

  @override
  String statsDashboardAchievementsLine(int unlocked, int total) {
    return 'アチーブメント: $unlocked/$total';
  }

  @override
  String get statsDashboardTotalBattlesLabel => '総戦闘数';

  @override
  String get statsDashboardTotalWinsLabel => '勝利数';

  @override
  String get statsDashboardTotalLossesLabel => '敗北数';

  @override
  String get statsDashboardTpAchievedLabel => 'TP達成数';

  @override
  String statsDashboardDurationHoursMinutes(int hours, int minutes) {
    return '$hours時間 $minutes分';
  }

  @override
  String statsDashboardDurationMinutesSeconds(int minutes, int seconds) {
    return '$minutes分 $seconds秒';
  }

  @override
  String statsDashboardDurationSeconds(int seconds) {
    return '$seconds秒';
  }

  @override
  String get statsDashboardTotalPlayTimeLabel => '総プレイ時間';

  @override
  String get statsDashboardAveragePlayTimeLabel => '平均戦闘時間';

  @override
  String statsDashboardAverageBattleMinutes(String minutes) {
    return '$minutes分';
  }

  @override
  String statsDashboardFirstPlayLine(String date) {
    return '初プレイ: $date';
  }

  @override
  String statsDashboardLastPlayLine(String date) {
    return '最終プレイ: $date';
  }

  @override
  String get statsDashboardTotalScoreLabel => '総スコア';

  @override
  String get statsDashboardAverageScoreLabel => '平均スコア';

  @override
  String get statsDashboardWinRateLabel => '勝率';

  @override
  String get statsDashboardTotalTpLabel => '総達成数';

  @override
  String get statsDashboardAverageTpLabel => '平均達成数';

  @override
  String get advStatsWinRateLabel => '勝率';

  @override
  String get advStatsTotalBattlesLabel => '戦闘数';

  @override
  String get advStatsVictoriesLabel => '勝利';

  @override
  String get advStatsDefeatsLabel => '敗北';

  @override
  String get advStatsBestScoreLabel => '最高スコア';

  @override
  String get advStatsDifficultyAnalysisTitle => '難易度別分析';

  @override
  String advStatsVictoryDefeatBattleLine(
    int victories,
    int defeats,
    int battles,
  ) {
    return '$victories勝 $defeats敗 ($battles戦)';
  }

  @override
  String advStatsScenariosClearedLine(int cleared, int total) {
    return '$cleared/$total制覇';
  }

  @override
  String get advStatsNoData => 'データなし';

  @override
  String get advStatsScenarioRankingTitle => 'シナリオランキング (勝率)';

  @override
  String advStatsRankSuffix(int rank) {
    return '$rank位';
  }

  @override
  String advStatsVictoryDefeatLine(int victories, int defeats) {
    return '$victories勝 $defeats敗';
  }

  @override
  String advStatsAverageScoreLine(int score) {
    return '平均 ${score}pt';
  }

  @override
  String get helpModalTabTutorial => 'チュートリアル';

  @override
  String get helpModalTabCommands => 'コマンド';

  @override
  String get helpModalTabTactics => '戦術ヒント';

  @override
  String get helpModalCloseButton => '閉じる';

  @override
  String get helpModalNoHintsForDifficulty => 'この難易度のヒントはありません';

  @override
  String get helpModalEffectLabel => '効果';

  @override
  String get helpModalLimitationLabel => '制限事項';

  @override
  String get helpModalRecommendationsLabel => '推奨事項';

  @override
  String replayPlayerTurnLabel(int turn) {
    return 'ターン $turn';
  }

  @override
  String replayPlayerCommandUsedLabel(String command) {
    return 'コマンド: $command';
  }

  @override
  String get replayPlayerPlayerLabel => 'プレイヤー';

  @override
  String get replayPlayerEnemyLabel => '敵';

  @override
  String get replayPlayerEventLabel => 'イベント';

  @override
  String get replayPlayerTpAchievedBadge => '✨ ターニングポイント達成';

  @override
  String get replayPlayerTurnProgressLabel => 'ターン進行';

  @override
  String replayPlayerTurnFraction(int current, int total) {
    return '$current/$total';
  }

  @override
  String get replayPlayerSpeedLabel => '速度: ';

  @override
  String get replayPlayerHpLabel => 'HP';

  @override
  String get replayPlayerUnitsLabel => '兵力';

  @override
  String eventBannerRemainingDays(int days, int hours) {
    return 'あと$days日$hours時間';
  }

  @override
  String eventBannerRemainingHours(int hours, int minutes) {
    return 'あと$hours時間$minutes分';
  }

  @override
  String eventBannerRemainingMinutes(int minutes) {
    return 'あと$minutes分';
  }

  @override
  String get eventBannerLimitedEventLabel => '期間限定イベント';

  @override
  String eventBannerRewardMultiplier(String multiplier) {
    return '報酬$multiplier倍';
  }

  @override
  String get eventBannerClaimRewardButton => '報酬を受け取る';

  @override
  String get eventBannerClaimedLabel => '達成済み';

  @override
  String get challengeCardScenarioOdigahara => '桶狭間';

  @override
  String get challengeCardScenarioNagashino => '長篠';

  @override
  String get challengeCardScenarioHonnoji => '本能寺';

  @override
  String get challengeCardScenarioSekigahara => '関ヶ原';

  @override
  String get challengeCardScenarioKawanakajima => '川中島';

  @override
  String get challengeCardScenarioItsukushima => '厳島';

  @override
  String get challengeCardScenarioOshijo => '忍城';

  @override
  String get challengeCardRewardLabel => '報酬';

  @override
  String get challengeCardApLabel => 'AP';

  @override
  String get dailyLoginTitle => '本日のログインボーナス';

  @override
  String dailyLoginStreakLabel(int streak) {
    return '連続ログイン $streak日目';
  }

  @override
  String get dailyLoginClaimButton => '受け取る';

  @override
  String trendSparklineInsufficientData(String label) {
    return '$label: データが不足しています';
  }

  @override
  String get notifReminderChannelName => 'リマインダー';

  @override
  String get notifReminderChannelDescription => 'デイリーチャレンジ・バトルパスの通知';

  @override
  String get notifDailyChallengeTitle => '本日のデイリーチャレンジ';

  @override
  String notifDailyChallengeBodyStreak(int streak) {
    return '$streak日連続達成中！今日挑戦しないとストリークが途切れてしまいます。';
  }

  @override
  String get notifDailyChallengeBodyNoStreak => '新しいデイリーチャレンジに挑戦しましょう！';

  @override
  String get notifBattlePassExpiryTitle => 'バトルパスもうすぐ終了';

  @override
  String notifBattlePassExpiryBody(int days) {
    return 'シーズン終了まであと$days日。報酬を取り逃さないようにしましょう！';
  }

  @override
  String get notifServerEventChannelName => 'サーバーイベント通知';

  @override
  String get notifServerEventChannelDescription => 'フレンド追加やランキング更新などのお知らせ';

  @override
  String get battlePassOverlayTierUpTitle => 'バトルパス ティアアップ！';

  @override
  String get battlePassOverlayRewardTitle => '報酬獲得！';

  @override
  String get battlePassOverlayPremiumTitle => 'プレミアム アクティベート';

  @override
  String get battlePassOverlayPremiumBody => 'プレミアムトラックの全報酬がアンロックされました';

  @override
  String get achievementOverlayUnlockedLabel => '実績解放！';

  @override
  String achievementOverlayPointsSuffix(int points) {
    return '+$points ポイント';
  }

  @override
  String get achievementOverlayShareButton => 'シェアする';

  @override
  String achievementShareText(String name, String description) {
    return '戦国采配録で実績「$name」を解放した！\n$description\n#戦国采配録';
  }

  @override
  String get challengeConditionVictory => 'シナリオをクリア';

  @override
  String challengeConditionTurnLimit(int turns) {
    return '$turnsターン以内でクリア';
  }

  @override
  String get challengeConditionNoDefeats => '主要ユニットを損失せずクリア';

  @override
  String challengeConditionTpTarget(int count) {
    return '$count個以上のTPを達成';
  }

  @override
  String challengeConditionScoreTarget(int score) {
    return '$scoreポイント以上のスコア獲得';
  }
}
