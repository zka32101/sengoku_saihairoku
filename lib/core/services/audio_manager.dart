import 'package:just_audio/just_audio.dart';

enum AudioType { bgm, se }

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() => _instance;

  AudioManager._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final Map<String, AudioPlayer> _sePlayers = {};

  bool _bgmEnabled = true;
  bool _seEnabled = true;

  void setBgmEnabled(bool enabled) => _bgmEnabled = enabled;
  void setSeEnabled(bool enabled) => _seEnabled = enabled;

  Future<void> playBgm(String assetPath) async {
    if (!_bgmEnabled) return;
    try {
      await _bgmPlayer.setAsset(assetPath);
      await _bgmPlayer.setLoopMode(LoopMode.one);
      await _bgmPlayer.play();
    } catch (e) {
      // BGM play failed silently
    }
  }

  Future<void> stopBgm() async => await _bgmPlayer.stop();

  Future<void> pauseBgm() async => await _bgmPlayer.pause();

  Future<void> resumeBgm() async => await _bgmPlayer.play();

  /// 効果音を再生（同時再生対応）
  Future<void> playSe(String key, String assetPath) async {
    if (!_seEnabled) return;
    try {
      final player = _sePlayers.putIfAbsent(key, () => AudioPlayer());
      await player.setAsset(assetPath);
      await player.play();
    } catch (e) {
      // SE play failed silently
    }
  }

  /// 効果音をストップ
  Future<void> stopSe(String key) async {
    _sePlayers[key]?.stop();
  }

  /// 全効果音をストップ
  Future<void> stopAllSe() async {
    for (final player in _sePlayers.values) {
      await player.stop();
    }
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    for (final player in _sePlayers.values) {
      await player.dispose();
    }
    _sePlayers.clear();
  }
}
