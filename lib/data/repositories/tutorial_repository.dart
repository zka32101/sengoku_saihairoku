import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tutorial_content.dart';

class TutorialRepository {
  static final TutorialRepository _instance = TutorialRepository._internal();

  factory TutorialRepository() {
    return _instance;
  }

  TutorialRepository._internal();

  Map<String, dynamic>? _cachedData;

  Future<TutorialContent?> getTutorialContent(String id) async {
    try {
      _cachedData ??= jsonDecode(
        await rootBundle.loadString('assets/data/tutorial.json'),
      ) as Map<String, dynamic>;

      if (_cachedData!.containsKey(id)) {
        return TutorialContent.fromJson(
          _cachedData![id] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      print('Error loading tutorial data: $e');
    }
    return null;
  }

  /// 全てのチュートリアルコンテンツを取得
  Future<Map<String, TutorialContent>> getAllTutorial() async {
    try {
      _cachedData ??= jsonDecode(
        await rootBundle.loadString('assets/data/tutorial.json'),
      ) as Map<String, dynamic>;

      final result = <String, TutorialContent>{};
      for (final entry in _cachedData!.entries) {
        result[entry.key] = TutorialContent.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return result;
    } catch (e) {
      print('Error loading all tutorial data: $e');
      return {};
    }
  }

  /// カテゴリ別のヒントを取得
  Future<List<TutorialTip>> getTipsByCategory(String category) async {
    try {
      final allTutorial = await getAllTutorial();
      final tips = <TutorialTip>[];
      for (final content in allTutorial.values) {
        tips.addAll(
          content.tips.where((tip) => tip.category == category),
        );
      }
      return tips;
    } catch (e) {
      print('Error loading tips by category: $e');
      return [];
    }
  }

  /// 難易度別のヒントを取得
  Future<List<TutorialTip>> getTipsByDifficulty(String? difficulty) async {
    try {
      final allTutorial = await getAllTutorial();
      final tips = <TutorialTip>[];
      for (final content in allTutorial.values) {
        tips.addAll(
          content.tips.where(
            (tip) => tip.difficulty == null || tip.difficulty == difficulty,
          ),
        );
      }
      return tips;
    } catch (e) {
      print('Error loading tips by difficulty: $e');
      return [];
    }
  }

  /// コマンドヘルプを取得
  Future<List<CommandHelp>> getCommandHelp() async {
    try {
      _cachedData ??= jsonDecode(
        await rootBundle.loadString('assets/data/tutorial.json'),
      ) as Map<String, dynamic>;

      if (_cachedData!.containsKey('commands')) {
        final commands = _cachedData!['commands'] as List;
        return commands
            .map((cmd) => CommandHelp.fromJson(cmd as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error loading command help: $e');
    }
    return [];
  }

  /// 特定のコマンドのヘルプを取得
  Future<CommandHelp?> getCommandHelpByName(String commandName) async {
    try {
      final commands = await getCommandHelp();
      return commands.firstWhere(
        (cmd) => cmd.commandName == commandName,
      );
    } catch (e) {
      return null;
    }
  }

  /// 難易度別の戦術ヒントを取得
  Future<List<TacticalHint>> getTacticalHints() async {
    try {
      _cachedData ??= jsonDecode(
        await rootBundle.loadString('assets/data/tutorial.json'),
      ) as Map<String, dynamic>;

      if (_cachedData!.containsKey('tacticalHints')) {
        final hints = _cachedData!['tacticalHints'] as List;
        return hints
            .map((hint) => TacticalHint.fromJson(hint as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error loading tactical hints: $e');
    }
    return [];
  }

  /// 難易度別の戦術ヒントを取得
  Future<TacticalHint?> getTacticalHintByDifficulty(
    String difficulty,
  ) async {
    try {
      final hints = await getTacticalHints();
      return hints.firstWhere(
        (hint) => hint.difficultyLevel == difficulty,
      );
    } catch (e) {
      return null;
    }
  }
}
