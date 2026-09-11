import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/scenario_data.dart';
import '../models/scenario_education.dart';

class ScenarioEducationRepository {
  static final ScenarioEducationRepository _instance =
      ScenarioEducationRepository._internal();

  factory ScenarioEducationRepository() {
    return _instance;
  }

  ScenarioEducationRepository._internal();

  Map<String, dynamic>? _cachedData;

  Future<ScenarioEducation?> getEducation(Scenario scenario) async {
    try {
      _cachedData ??= jsonDecode(
        await rootBundle.loadString('assets/data/scenario_education.json'),
      ) as Map<String, dynamic>;

      final key = scenario.name;
      if (_cachedData!.containsKey(key)) {
        return ScenarioEducation.fromJson(
          _cachedData![key] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      print('Error loading education data: $e');
    }
    return null;
  }

  /// ターニングポイント達成時の説明を取得
  Future<TurningPointExplanation?> getTurningPointExplanation(
    Scenario scenario,
    String tpId,
  ) async {
    final education = await getEducation(scenario);
    if (education != null) {
      try {
        return education.turningPointExplanations
            .firstWhere((tp) => tp.tpId == tpId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
