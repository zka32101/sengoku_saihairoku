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
}
