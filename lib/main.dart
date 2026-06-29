import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/firebase_service.dart';
import 'firebase_options.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/scenario_select_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/message_screen.dart';
import 'presentation/screens/ranking_screen.dart';
import 'presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseService().initialize();
  runApp(const ProviderScope(child: SengokuSaihairokuApp()));
}

class SengokuSaihairokuApp extends StatelessWidget {
  const SengokuSaihairokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '戦国采配録',
      theme: _buildTheme(),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/scenario_select': (_) => const ScenarioSelectScreen(),
        '/ranking': (_) => const RankingScreen(),
        '/settings': (_) => const SettingsScreen(),
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
