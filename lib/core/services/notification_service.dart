import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import '../../l10n/generated/app_localizations.dart';
import 'locale_controller.dart';

/// リテンション向けのローカル通知（プッシュ通知の簡易版）を管理するサービス。
///
/// サーバーからのリモートプッシュではなく、端末上でスケジュールする
/// ローカル通知のため、バックエンド（Cloud Functions等）を必要とせず
/// 完結する。デイリーチャレンジ未達成時の翌日リマインダーと、
/// バトルパス終了間近のリマインダーの2種類を扱う。
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int _dailyChallengeNotificationId = 1001;
  static const int _battlePassExpiryNotificationId = 1002;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  AppLocalizations get _l10n =>
      lookupAppLocalizations(LocaleController.instance.resolvedLocale);

  NotificationDetails get _reminderDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          _l10n.notifReminderChannelName,
          channelDescription: _l10n.notifReminderChannelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      );

  /// 本日のデイリーチャレンジが未達成の場合、翌日の朝にリマインダーを予約する。
  /// 既に予約済みなら上書き、達成済みなら [cancelDailyChallengeReminder] で解除すること。
  ///
  /// [currentStreak] が1以上の場合（連続達成中）は、ストリークが途切れる旨を
  /// 通知文に含めて継続を促す。
  Future<void> scheduleDailyChallengeReminder({int currentStreak = 0}) async {
    if (!_initialized) return;

    final tomorrow = _nextInstanceOfHour(10, daysFromNow: 1);
    final body = currentStreak > 0
        ? _l10n.notifDailyChallengeBodyStreak(currentStreak)
        : _l10n.notifDailyChallengeBodyNoStreak;
    await _plugin.zonedSchedule(
      _dailyChallengeNotificationId,
      _l10n.notifDailyChallengeTitle,
      body,
      tomorrow,
      _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelDailyChallengeReminder() async {
    if (!_initialized) return;
    await _plugin.cancel(_dailyChallengeNotificationId);
  }

  /// バトルパスのシーズン終了が近い場合にリマインダーを予約する。
  /// [daysRemaining] が0以下、または十分に日数がある場合は何もしない
  /// （呼び出し側が cancelBattlePassExpiryReminder を使うこと）。
  Future<void> scheduleBattlePassExpiryReminder(int daysRemaining) async {
    if (!_initialized) return;
    if (daysRemaining <= 0) return;

    final reminderTime = _nextInstanceOfHour(10, daysFromNow: 1);
    await _plugin.zonedSchedule(
      _battlePassExpiryNotificationId,
      _l10n.notifBattlePassExpiryTitle,
      _l10n.notifBattlePassExpiryBody(daysRemaining),
      reminderTime,
      _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelBattlePassExpiryReminder() async {
    if (!_initialized) return;
    await _plugin.cancel(_battlePassExpiryNotificationId);
  }

  tz.TZDateTime _nextInstanceOfHour(int hour, {int daysFromNow = 1}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    ).add(Duration(days: daysFromNow));
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
