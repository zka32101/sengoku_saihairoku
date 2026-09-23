import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/firebase_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchase_service.dart';
import 'core/services/ad_service.dart';
import 'data/repositories/turn_rank_repository.dart';
import 'firebase_options.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/scenario_select_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/message_screen.dart';
import 'presentation/screens/ranking_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/challenge_history_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/statistics_screen.dart';
import 'presentation/screens/cosmetics_equipment_screen.dart';
import 'presentation/screens/prestige_reset_screen.dart';
import 'presentation/screens/achievement_list_screen.dart';
import 'presentation/screens/battle_pass_screen.dart';
import 'presentation/screens/gold_shop_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'data/repositories/onboarding_repository.dart';
import 'presentation/screens/friends_screen.dart';
import 'data/repositories/daily_challenge_repository.dart';
import 'data/repositories/progression_repository.dart';
import 'data/repositories/reward_repository.dart';
import 'data/repositories/achievement_repository.dart';
import 'data/repositories/battle_pass_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseService().initialize();

  // ターンランクリポジトリを初期化
  final turnRankRepo = TurnRankRepository();
  await turnRankRepo.initialize();

  // Initialize DailyChallengeRepository
  final challengeRepo = DailyChallengeRepository();
  await challengeRepo.initialize();

  // Initialize ProgressionRepository
  final progressionRepo = ProgressionRepository();
  await progressionRepo.initialize();

  // Initialize RewardRepository
  final rewardRepo = RewardRepository();
  await rewardRepo.initialize();

  // Initialize AchievementRepository
  final achievementRepo = AchievementRepository();
  await achievementRepo.initialize();

  // Initialize BattlePassRepository
  final battlePassRepo = BattlePassRepository();
  await battlePassRepo.initialize();

  // Initialize PurchaseService（起動直後に購入ストリームを購読し、
  // 未完了の購入・復元を取りこぼさないようにする）
  await PurchaseService().initialize();

  // Initialize NotificationService（ローカル通知の権限リクエスト・初期化）
  await NotificationService().initialize();

  // Initialize AdService（リワード広告SDKの初期化と事前読み込み）
  await AdService().initialize();

  // 初回起動オンボーディングが必要か確認
  final needsOnboarding =
      await OnboardingRepository().needsOnboarding(FirebaseService().userId);

  runApp(ProviderScope(
    child: SengokuSaihairokuApp(
      initialRoute: needsOnboarding ? '/onboarding' : '/home',
    ),
  ));
}

class SengokuSaihairokuApp extends StatelessWidget {
  final String initialRoute;

  const SengokuSaihairokuApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '戦国采配録',
      theme: _buildTheme(),
      initialRoute: initialRoute,
      routes: {
        '/home': (_) => const HomeScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/scenario_select': (_) => const ScenarioSelectScreen(),
        '/ranking': (_) => const RankingScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/challenge_history': (_) => const ChallengeHistoryScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/statistics': (_) => const StatisticsScreen(),
        '/cosmetics_equipment': (_) => const CosmeticsEquipmentScreen(),
        '/prestige_reset': (_) => const PrestigeResetScreen(),
        '/achievements': (_) => const AchievementListScreen(),
        '/battle_pass': (_) => const BattlePassScreen(),
        '/gold_shop': (_) => const GoldShopScreen(),
        '/friends': (_) => const FriendsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          return MaterialPageRoute(
            builder: (_) => ResultScreen(args: settings.arguments as ResultScreenArgs),
          );
        }
        if (settings.name == '/message') {
          return MaterialPageRoute(
            builder: (_) => MessageScreen(args: settings.arguments as MessageScreenArgs),
          );
        }
        return null;
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B1A1A),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3B1A1A),
        foregroundColor: Color(0xFFFFD700),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B1A1A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2A1A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF8B6914), width: 1),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF1A0F0A),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFE8D5B0)),
        bodyLarge: TextStyle(color: Color(0xFFE8D5B0)),
        titleLarge: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
      ),
    );
  }
}
