import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ全体の表示言語を管理するコントローラ。
///
/// 現時点でのローカライズ対象は`lib/l10n/*.arb`で定義した一部の共通文言
/// （ナビゲーション・共通ボタン等）のみで、画面全体の多言語化は未着手。
/// 国別の追加コンテンツパック（将来構想）は、この基盤の上に
/// 言語ごとのアセット/データを切り替える形で乗せる想定。
///
/// `null`を「端末の言語設定に従う」として扱い、設定画面での明示的な
/// 選択のみSharedPreferencesに保存する。
class LocaleController extends ValueNotifier<Locale?> {
  static final LocaleController instance = LocaleController._internal();
  LocaleController._internal() : super(null);

  static const String _prefsKey = 'app_locale';

  static const List<Locale> supportedLocales = [
    Locale('ja'),
    Locale('en'),
  ];

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code != null) {
      value = Locale(code);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    value = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, locale.languageCode);
    }
  }
}
