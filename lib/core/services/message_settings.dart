/// 戦闘後のエピローグ・ストーリーメッセージ表示設定。
///
/// 音声設定(AudioManager)と同様、現時点ではアプリ再起動で初期値(true)に戻る
/// インメモリ設定（永続化は未実装）。
class MessageSettings {
  static final MessageSettings _instance = MessageSettings._internal();

  factory MessageSettings() => _instance;

  MessageSettings._internal();

  bool _storyMessagesEnabled = true;

  bool get storyMessagesEnabled => _storyMessagesEnabled;

  void setStoryMessagesEnabled(bool enabled) =>
      _storyMessagesEnabled = enabled;
}
