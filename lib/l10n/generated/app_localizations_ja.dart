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
}
