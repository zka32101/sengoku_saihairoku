import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// アプリ名（MaterialAppのtitle、ホーム画面等では使わない）
  ///
  /// In ja, this message translates to:
  /// **'戦国采配録'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get navHome;

  /// No description provided for @navProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール'**
  String get navProfile;

  /// No description provided for @navStatistics.
  ///
  /// In ja, this message translates to:
  /// **'統計'**
  String get navStatistics;

  /// No description provided for @navReplay.
  ///
  /// In ja, this message translates to:
  /// **'リプレイ'**
  String get navReplay;

  /// No description provided for @navRanking.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get navRanking;

  /// No description provided for @navSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get navSettings;

  /// No description provided for @commonClose.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ja, this message translates to:
  /// **'確認'**
  String get commonConfirm;

  /// No description provided for @commonSortie.
  ///
  /// In ja, this message translates to:
  /// **'出陣'**
  String get commonSortie;

  /// No description provided for @commonRetry.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました'**
  String get commonError;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @settingsGameSection.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム設定'**
  String get settingsGameSection;

  /// No description provided for @settingsSfx.
  ///
  /// In ja, this message translates to:
  /// **'効果音'**
  String get settingsSfx;

  /// No description provided for @settingsSfxSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'SE'**
  String get settingsSfxSubtitle;

  /// No description provided for @settingsBgm.
  ///
  /// In ja, this message translates to:
  /// **'BGM'**
  String get settingsBgm;

  /// No description provided for @settingsBgmSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'バックグラウンドミュージック'**
  String get settingsBgmSubtitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In ja, this message translates to:
  /// **'言語 / Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsDisplayLanguage.
  ///
  /// In ja, this message translates to:
  /// **'表示言語'**
  String get settingsDisplayLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In ja, this message translates to:
  /// **'端末の設定に従う'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageJa.
  ///
  /// In ja, this message translates to:
  /// **'日本語'**
  String get settingsLanguageJa;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In ja, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsDataSection.
  ///
  /// In ja, this message translates to:
  /// **'データ管理'**
  String get settingsDataSection;

  /// No description provided for @settingsCloudSave.
  ///
  /// In ja, this message translates to:
  /// **'クラウドに保存'**
  String get settingsCloudSave;

  /// No description provided for @settingsCloudSaveSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'Firebase アカウントが必要です'**
  String get settingsCloudSaveSubtitle;

  /// No description provided for @settingsDeleteSaveData.
  ///
  /// In ja, this message translates to:
  /// **'セーブデータを削除'**
  String get settingsDeleteSaveData;

  /// No description provided for @settingsOtherSection.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get settingsOtherSection;

  /// No description provided for @settingsReplayTutorial.
  ///
  /// In ja, this message translates to:
  /// **'チュートリアルをもう一度見る'**
  String get settingsReplayTutorial;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get settingsTermsOfService;

  /// No description provided for @settingsVersion.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get settingsVersion;

  /// No description provided for @settingsComingSoon.
  ///
  /// In ja, this message translates to:
  /// **'近日公開'**
  String get settingsComingSoon;

  /// No description provided for @settingsDeleteDataTitle.
  ///
  /// In ja, this message translates to:
  /// **'データを削除しますか？'**
  String get settingsDeleteDataTitle;

  /// No description provided for @settingsDeleteDataBody.
  ///
  /// In ja, this message translates to:
  /// **'この操作は元に戻せません'**
  String get settingsDeleteDataBody;

  /// No description provided for @settingsDeleteDataConfirm.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get settingsDeleteDataConfirm;

  /// No description provided for @settingsDeleteDataSuccess.
  ///
  /// In ja, this message translates to:
  /// **'データを削除しました'**
  String get settingsDeleteDataSuccess;

  /// No description provided for @settingsDeleteDataFailure.
  ///
  /// In ja, this message translates to:
  /// **'データの削除に失敗しました'**
  String get settingsDeleteDataFailure;

  /// No description provided for @challengeHistoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴'**
  String get challengeHistoryTitle;

  /// No description provided for @challengeHistoryEmpty.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ履歴がありません'**
  String get challengeHistoryEmpty;

  /// No description provided for @challengeHistoryBanner.
  ///
  /// In ja, this message translates to:
  /// **'これまで7日間のチャレンジ情報'**
  String get challengeHistoryBanner;

  /// No description provided for @challengeHistoryToday.
  ///
  /// In ja, this message translates to:
  /// **'本日'**
  String get challengeHistoryToday;

  /// No description provided for @challengeHistoryNoChallengeInfo.
  ///
  /// In ja, this message translates to:
  /// **'チャレンジ情報がありません'**
  String get challengeHistoryNoChallengeInfo;

  /// No description provided for @weekdaySun.
  ///
  /// In ja, this message translates to:
  /// **'日'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In ja, this message translates to:
  /// **'月'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In ja, this message translates to:
  /// **'火'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In ja, this message translates to:
  /// **'水'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In ja, this message translates to:
  /// **'木'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In ja, this message translates to:
  /// **'金'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In ja, this message translates to:
  /// **'土'**
  String get weekdaySat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
