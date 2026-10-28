import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/whatif/persuasion.dart';
import '../models/scenario_data.dart';

/// 「もしも」の説得データの読み込みと、1日1回の挑戦結果の保存。
///
/// 結果は「その日のうちは同じ結果」を保つために日付つきで端末内に保存する。
/// 翌日になると新しく試せる。
class PersuasionRepository {
  PersuasionRepository._();

  static const _asset = 'assets/data/whatif.json';
  static const _keyPrefix = 'persuasion_v1_';

  static Map<String, dynamic>? _cache;

  static Future<List<Persuasion>> forScenario(
    Scenario scenario, {
    AssetBundle? bundle,
  }) async {
    _cache ??= jsonDecode(await (bundle ?? rootBundle).loadString(_asset))
        as Map<String, dynamic>;
    final entry = _cache![scenario.name] as Map<String, dynamic>?;
    if (entry == null) return const [];
    return (entry['persuasions'] as List)
        .map((p) => Persuasion.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  static String _dayKey(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';

  /// 今日の挑戦結果。未挑戦なら null、成功なら true、失敗なら false。
  static Future<bool?> todayResult(String persuasionId, DateTime now) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('$_keyPrefix$persuasionId');
    if (stored == null) return null;
    final parts = stored.split(':');
    if (parts.length != 2 || parts[0] != _dayKey(now)) return null;
    return parts[1] == '1';
  }

  static Future<void> record(
    String persuasionId,
    bool success,
    DateTime now,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_keyPrefix$persuasionId',
      '${_dayKey(now)}:${success ? 1 : 0}',
    );
  }
}
