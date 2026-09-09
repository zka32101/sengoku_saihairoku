import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/warlord_data.dart';

abstract class IWarlordRepository {
  Future<List<Warlord>> getAllWarlords();
  Future<Warlord?> getWarlord(String id);
  Future<List<Warlord>> getWarlordsByFaction(String faction);
}

/// assets/data/warlords.json を読み込み、IDでキャッシュする。
/// ScenarioRepository と同じ読み込みパターンに揃えている。
class WarlordRepository implements IWarlordRepository {
  static final WarlordRepository _instance = WarlordRepository._internal();

  late Map<String, Warlord> _cache;
  bool _isInitialized = false;

  factory WarlordRepository() => _instance;

  WarlordRepository._internal();

  Future<void> _initializeCache() async {
    if (_isInitialized) return;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/warlords.json');
      final jsonList = jsonDecode(jsonString) as List;

      _cache = {
        for (final entry in jsonList)
          (entry as Map<String, dynamic>)['id'] as String:
              Warlord.fromJson(entry),
      };

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load warlords: $e');
    }
  }

  @override
  Future<List<Warlord>> getAllWarlords() async {
    await _initializeCache();
    return _cache.values.toList();
  }

  @override
  Future<Warlord?> getWarlord(String id) async {
    await _initializeCache();
    return _cache[id];
  }

  @override
  Future<List<Warlord>> getWarlordsByFaction(String faction) async {
    await _initializeCache();
    return _cache.values.where((w) => w.faction == faction).toList();
  }
}
