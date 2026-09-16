import '../../data/models/user_progression.dart';
import '../../data/repositories/progression_repository.dart';
import '../../data/repositories/reward_repository.dart';
import '../achievement_checking/prestige_achievement_handler.dart';

/// プレスティジシステム管理
class PrestigeManager {
  final ProgressionRepository _progressionRepo;
  final RewardRepository _rewardRepo;
  final PrestigeAchievementHandler _achievementHandler;

  PrestigeManager({
    required ProgressionRepository progressionRepository,
    required RewardRepository rewardRepository,
    PrestigeAchievementHandler? achievementHandler,
  })  : _progressionRepo = progressionRepository,
        _rewardRepo = rewardRepository,
        _achievementHandler = achievementHandler ?? PrestigeAchievementHandler();

  /// プレスティジ可能か確認
  Future<bool> canPrestige(String userId) async {
    final progression = await _progressionRepo.getUserProgression(userId);
    if (progression == null) return false;

    return progression.currentLevel >= 100 &&
        progression.prestigePoints >= 1000;
  }

  /// プレスティジシステムが解放されているか確認
  bool isPrestigeSystemUnlocked(int currentLevel) {
    return currentLevel >= 100;
  }

  /// プレスティジに必要なポイント
  int getRequiredPrestigePoints(int prestigeResetCount) {
    // リセット回数が増えるにつれ必要ポイントが増加
    return 1000 + (prestigeResetCount * 500);
  }

  /// 次のプレスティジランクを計算（平均ターン数から）
  PrestigeTier calculatePrestigeRank(Map<String, int> averageTurnsByScenario) {
    if (averageTurnsByScenario.isEmpty) return PrestigeTier.bronze;

    final totalTurns =
        averageTurnsByScenario.values.fold<int>(0, (sum, turns) => sum + turns);
    final averageTurns = totalTurns ~/ averageTurnsByScenario.length;

    if (averageTurns <= 20) return PrestigeTier.diamond;
    if (averageTurns <= 23) return PrestigeTier.platinum;
    if (averageTurns <= 26) return PrestigeTier.gold;
    if (averageTurns <= 29) return PrestigeTier.silver;
    return PrestigeTier.bronze;
  }

  /// プレスティジランクに対応するコスメティックを取得
  String? getCosmeticForPrestigeTier(PrestigeTier tier) {
    return switch (tier) {
      PrestigeTier.bronze => null,
      PrestigeTier.silver => 'unit_skin_prestige_silver',
      PrestigeTier.gold => 'unit_skin_prestige_gold',
      PrestigeTier.platinum => 'unit_skin_prestige_platinum',
      PrestigeTier.diamond => 'unit_skin_prestige_diamond',
    };
  }

  /// プレスティジリセットを実行
  Future<void> performPrestige(String userId) async {
    try {
      // 現在のプログレッション取得
      final currentProgression =
          await _progressionRepo.getUserProgression(userId);
      if (currentProgression == null) {
        throw Exception('User progression not found');
      }

      // プレスティジ条件を確認
      if (!await canPrestige(userId)) {
        throw Exception('Cannot prestige: conditions not met');
      }

      // リセット時のランク計算用データ取得（TODO: 実装時に戦闘履歴から計算）
      final newPrestigeRank = PrestigeTier.bronze; // 初回リセット

      // プレスティジリセット実行
      await _progressionRepo.performPrestige(userId);

      final newResetCount = currentProgression.prestigeResetCount + 1;

      // 新しいランク用コスメティック解放
      final cosmeticId = getCosmeticForPrestigeTier(newPrestigeRank);
      if (cosmeticId != null) {
        await _rewardRepo.unlockPrestigeCosmetic(
          userId,
          newResetCount,
          cosmeticId,
        );
      }

      // プレスティジリセット実績を確認・解放
      final unlockedAchievements =
          await _achievementHandler.checkPrestigeResetAchievements(
        userId,
        newResetCount,
      );
      if (unlockedAchievements.isNotEmpty) {
        print(
            '✓ Achievements unlocked: ${unlockedAchievements.map((a) => a.name).join(", ")}');
      }

      print('✓ Prestige performed: $userId reset #$newResetCount');
    } catch (e) {
      print('Error performing prestige: $e');
      rethrow;
    }
  }

  /// プレスティジ達成に必要な情報を表示用に生成
  String getPrestigeDescription(int currentLevel, int prestigePoints) {
    if (currentLevel < 100) {
      return 'レベル100に到達してプレスティジシステムを解放しましょう';
    }

    final requiredPoints = 1000;
    final progress = (prestigePoints / requiredPoints * 100).toInt();

    return 'プレスティジポイント: $prestigePoints / $requiredPoints ($progress%)';
  }

  /// プレスティジのメリットを説明
  String getPrestigeRewardsDescription() {
    return '''プレスティジすると：
• レベルが1にリセット
• 経験値がリセット
• プレスティジランクが上昇
• 限定コスメティック解放
• 次回リセットに必要なポイント増加''';
  }
}
