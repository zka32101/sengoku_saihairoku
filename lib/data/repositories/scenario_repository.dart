import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/scenario_data.dart';

abstract class IScenarioRepository {
  Future<ScenarioData> getScenario(Scenario scenario);
  Future<List<ScenarioData>> getAllScenarios();
}

class ScenarioRepository implements IScenarioRepository {
  static final ScenarioRepository _instance = ScenarioRepository._internal();

  late Map<Scenario, ScenarioData> _scenarioCache;
  bool _isInitialized = false;

  factory ScenarioRepository() {
    return _instance;
  }

  ScenarioRepository._internal();

  Future<void> _initializeCache() async {
    if (_isInitialized) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/scenarios.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      _scenarioCache = {};
      for (final scenario in Scenario.values) {
        final scenarioKey = scenario.name;
        if (jsonData.containsKey(scenarioKey)) {
          _scenarioCache[scenario] = ScenarioData.fromJson(
              jsonData[scenarioKey] as Map<String, dynamic>);
        }
      }

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load scenarios: $e');
    }
  }

  @override
  Future<ScenarioData> getScenario(Scenario scenario) async {
    await _initializeCache();
    final data = _scenarioCache[scenario];
    if (data == null) {
      throw Exception('Scenario not found: $scenario');
    }
    return data;
  }

  @override
  Future<List<ScenarioData>> getAllScenarios() async {
    await _initializeCache();
    return _scenarioCache.values.toList();
  }
}
