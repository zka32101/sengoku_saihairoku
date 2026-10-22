import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sengoku_saihairoku/data/repositories/achievement_repository.dart';
import 'package:sengoku_saihairoku/data/repositories/battle_pass_repository.dart';
import 'package:sengoku_saihairoku/data/repositories/daily_challenge_repository.dart';
import 'package:sengoku_saihairoku/data/repositories/progression_repository.dart';
import 'package:sengoku_saihairoku/data/repositories/reward_repository.dart';
import 'package:sengoku_saihairoku/data/repositories/turn_rank_repository.dart';
import 'package:sengoku_saihairoku/main.dart';

/// ウィジェットテストは main() を経由せず SengokuSaihairokuApp を直接
/// pumpWidget するため、main.dart の Firebase.initializeApp() が走らない。
/// HomeScreen が FirebaseService() 経由で FirebaseAuth.instance に触れると
/// 「デフォルトのFirebase Appが存在しない」例外で落ちるため、実際の
/// プラットフォームチャンネル通信を経由せず、firebase_core_platform_interface
/// の @visibleForTesting な内部状態に直接ダミーのAppを登録しておく。
void _registerFakeDefaultFirebaseApp() {
  const options = FirebaseOptions(
    apiKey: 'test-api-key',
    appId: 'test-app-id',
    messagingSenderId: 'test-sender-id',
    projectId: 'test-project-id',
  );
  MethodChannelFirebase.appInstances[defaultFirebaseAppName] =
      MethodChannelFirebaseApp(defaultFirebaseAppName, options);
  MethodChannelFirebase.isCoreInitialized = true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  _registerFakeDefaultFirebaseApp();
  SharedPreferences.setMockInitialValues({});

  testWidgets('App launches', (WidgetTester tester) async {
    // HomeScreen.initState はこれらのリポジトリが main() 同様に
    // 既に初期化済みであることを前提に同期的に読み出すため、
    // pumpWidget の前に main.dart と同じ初期化を済ませておく。
    await TurnRankRepository().initialize();
    await DailyChallengeRepository().initialize();
    await ProgressionRepository().initialize();
    await RewardRepository().initialize();
    await AchievementRepository().initialize();
    await BattlePassRepository().initialize();

    await tester.pumpWidget(
      const SengokuSaihairokuApp(initialRoute: '/home'),
    );
    expect(find.text('戦国采配録'), findsWidgets);
  });
}
