import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/turn_efficiency.dart';
import '../models/scenario_data.dart';
import '../models/difficulty_mode.dart';

/// ターンランク管理リポジトリ
class TurnRankRepository {
  static final TurnRankRepository _instance = TurnRankRepository._internal();
  Map<Scenario, Map<DifficultyMode, TurnRankingCriteria>> _criteria = {};
  bool _initialized = false;

  factory TurnRankRepository() {
    return _instance;
  }

  TurnRankRepository._internal();

  /// 初期化（シナリオデータから基準を読み込む）
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/scenarios.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      for (final scenario in Scenario.values) {
        final scenarioData = json[scenario.name] as Map<String, dynamic>?;
        if (scenarioData == null) continue;

        final turnCriteria = scenarioData['turnCriteria'] as Map<String, dynamic>?;
        if (turnCriteria == null) continue;

        _criteria[scenario] = {};

        for (final difficulty in DifficultyMode.values) {
          final difficultyKey = difficulty.name.toLowerCase();
          final criteria = turnCriteria[difficultyKey] as Map<String, dynamic>?;
          if (criteria != null) {
            _criteria[scenario]![difficulty] = TurnRankingCriteria.fromJson(criteria);
          }
        }
      }

      _initialized = true;
      print('✓ TurnRankRepository initialized with ${_criteria.length} scenarios');
    } catch (e) {
      print('Error initializing TurnRankRepository: $e');
      _initialized = false;
    }
  }

  /// シナリオ・難易度に対応する基準を取得
  TurnRankingCriteria? getCriteria(Scenario scenario, DifficultyMode difficulty) {
    return _criteria[scenario]?[difficulty];
  }

  /// すべてのシナリオの基準を取得
  Map<Scenario, Map<DifficultyMode, TurnRankingCriteria>> getAllCriteria() {
    return _criteria;
  }

  /// シナリオの全難易度基準を取得
  Map<DifficultyMode, TurnRankingCriteria>? getCriteriaForScenario(Scenario scenario) {
    return _criteria[scenario];
  }
}
