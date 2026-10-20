import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scenario_data.dart';

/// フレンドのスコアに挑む「非同期対戦」の目標を1件だけローカルに保持する
/// 軽量リポジトリ。同時に挑戦できる相手は1人まで（新しく設定すると上書き）。
class FriendChallengeTarget {
  final String friendUserId;
  final String friendLabel;
  final Scenario scenario;
  final int targetScore;

  const FriendChallengeTarget({
    required this.friendUserId,
    required this.friendLabel,
    required this.scenario,
    required this.targetScore,
  });

  Map<String, dynamic> toJson() => {
        'friendUserId': friendUserId,
        'friendLabel': friendLabel,
        'scenario': scenario.name,
        'targetScore': targetScore,
      };

  factory FriendChallengeTarget.fromJson(Map<String, dynamic> json) {
    return FriendChallengeTarget(
      friendUserId: json['friendUserId'] as String,
      friendLabel: json['friendLabel'] as String,
      scenario: Scenario.values.byName(json['scenario'] as String),
      targetScore: json['targetScore'] as int,
    );
  }
}

class FriendChallengeRepository {
  static final FriendChallengeRepository _instance =
      FriendChallengeRepository._internal();
  factory FriendChallengeRepository() => _instance;
  FriendChallengeRepository._internal();

  static const String _key = 'active_friend_challenge';

  Future<void> setChallenge(FriendChallengeTarget target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(target.toJson()));
  }

  Future<FriendChallengeTarget?> getChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return null;
    try {
      return FriendChallengeTarget.fromJson(
          jsonDecode(stored) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
