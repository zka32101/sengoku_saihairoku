import 'dart:math';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/firebase_service.dart';
import 'core/services/locale_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/services/purchase_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/push_notification_service.dart';
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
import 'presentation/screens/warlord_collection_screen.dart';
import 'presentation/screens/chain_battle_screen.dart';
import 'presentation/screens/codex_screen.dart';
import 'data/repositories/daily_challenge_repository.dart';
import 'data/repositories/progression_repository.dart';
import 'data/repositories/reward_repository.dart';
import 'data/repositories/achievement_repository.dart';
import 'data/repositories/battle_pass_repository.dart';
import 'domain/achievement_checking/achievement_checker.dart';
import 'domain/achievement_checking/playtime_tracker.dart';
import 'domain/achievement_checking/prestige_achievement_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _SplashScreen());

  try {
    await Future(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseService().initialize();
    }).timeout(const Duration(seconds: 8));
  } catch (e) {
    // Firebase初期化に失敗・タイムアウトしても起動自体は続行する（オフライン環境や、
    // Webアプリ未登録等でappIdが暫定値の場合でも画面確認ができるように）。
    // タイムアウトを設けるのは、WebではFirebase JS SDKの動的importが
    // 失敗した際にFutureが解決も失敗もせず無期限に止まることがあるため。
    debugPrint('Firebase initialization failed or timed out: $e');
  }
  await LocaleController.instance.loadSaved();

  var needsOnboarding = false;
  try {
    // オフライン時に送信できず端末内に溜まっていたバトル結果があれば再送する
    await FirebaseService().flushPendingBattleResults();

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

    // Initialize AchievementChecker（実績判定サービス本体。これを呼び忘れると
    // 判定メソッド群が未初期化例外を投げ、呼び出し側のtry/catchで
    // サイレントに握り潰されて実績が一切解放されなくなる）
    await AchievementChecker().initialize();

    // Initialize PlaytimeTracker
    await PlaytimeTracker().initialize();

    // Initialize PrestigeAchievementHandler（これも呼び忘れると、
    // プレスティジリセット時の実績判定が未初期化例外で握り潰される）
    await PrestigeAchievementHandler().initialize();

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

    // Initialize PushNotificationService（サーバーサイドイベント通知の受信設定）
    await PushNotificationService().initialize();
    final currentUserId = FirebaseService().userId;
    if (currentUserId != null) {
      await PushNotificationService().registerToken(currentUserId);
    }

    // 初回起動オンボーディングが必要か確認
    needsOnboarding = await OnboardingRepository().needsOnboarding(
      FirebaseService().userId,
    );
  } catch (e) {
    // 各種リポジトリ・サービスの初期化が（Firebase未初期化等により）失敗しても、
    // 起動がスプラッシュ画面のまま止まらないようにする。
    debugPrint('Startup initialization failed: $e');
  }

  runApp(
    ProviderScope(
      child: SengokuSaihairokuApp(
        initialRoute: needsOnboarding ? '/onboarding' : '/home',
      ),
    ),
  );
}

/// 起動時の非同期初期化（Firebase・各種リポジトリ）が完了するまで表示する
/// スプラッシュ画面。main()から初期化完了後にrunApp()を再度呼ぶことで
/// 本体のSengokuSaihairokuAppに差し替える。
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final asset = Random().nextBool()
        ? 'assets/images/loading_1.png'
        : 'assets/images/loading_2.png';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1A0F0A),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            ),
          ],
        ),
      ),
    );
  }
}

class SengokuSaihairokuApp extends StatefulWidget {
  final String initialRoute;

  const SengokuSaihairokuApp({super.key, required this.initialRoute});

  @override
  State<SengokuSaihairokuApp> createState() => _SengokuSaihairokuAppState();
}

class _SengokuSaihairokuAppState extends State<SengokuSaihairokuApp> {
  @override
  void initState() {
    super.initState();
    LocaleController.instance.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    LocaleController.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: lookupAppLocalizations(
        LocaleController.instance.resolvedLocale,
      ).homeAppTitle,
      theme: _buildTheme(),
      locale: LocaleController.instance.value,
      supportedLocales: LocaleController.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: widget.initialRoute,
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
        '/warlords': (_) => const WarlordCollectionScreen(),
        '/chain_battle': (_) => const ChainBattleScreen(),
        '/codex': (_) => const CodexScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          return MaterialPageRoute(
            builder: (_) =>
                ResultScreen(args: settings.arguments as ResultScreenArgs),
          );
        }
        if (settings.name == '/message') {
          return MaterialPageRoute(
            builder: (_) =>
                MessageScreen(args: settings.arguments as MessageScreenArgs),
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
        // 戦闘マップの立体表現強化に合わせ、UI全体のベースも視認しやすい明るめのトーンに調整
        backgroundColor: Color(0xFF502323),
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
        color: const Color(0xFF3D260E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF8B6914), width: 1),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF2A1810),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFE8D5B0)),
        bodyLarge: TextStyle(color: Color(0xFFE8D5B0)),
        titleLarge: TextStyle(
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
