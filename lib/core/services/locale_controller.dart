import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// アプリ全体の表示言語を管理するコントローラ。
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

  /// BuildContextを持たないバックグラウンド処理（ローカル通知等）が
  /// `AppLocalizations`を取得する際に使う、現在の実効ロケール。
  /// 明示的な選択（[value]）があればそれを、無ければ端末の言語設定を
  /// サポート対象から探し、どちらも無ければ`ja`にフォールバックする。
  Locale get resolvedLocale {
    final explicit = value;
    if (explicit != null) return explicit;
    final deviceLocale = PlatformDispatcher.instance.locale;
    for (final locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode) return locale;
    }
    return const Locale('ja');
  }

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
