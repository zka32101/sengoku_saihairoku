import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// バックグラウンド/終了時にFCMメッセージを受信した際のハンドラ。
/// トップレベル関数である必要がある（Flutterの制約）。
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // バックグラウンドではOSが通知を自動表示するため、ここでは特別な処理は不要。
  // 将来的にデータメッセージ受信時のローカル状態更新などが必要になれば追加する。
}

/// サーバーサイド（Cloud Functions）から送信されるプッシュ通知を扱うサービス
///
/// これまでの通知（[NotificationService]）は端末内スケジュールのみで、
/// フレンド追加やランキング更新のようなサーバー側イベントをリアルタイムに
/// 知らせる手段がなかった。`functions/`のCloud Functionsと対になる。
class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const int _serverEventChannelId = 2001;

  /// 初期化：通知権限リクエスト、フォアグラウンド受信時の表示設定
  Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'server_events',
      'サーバーイベント通知',
      channelDescription: 'フレンド追加やランキング更新などのお知らせ',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      _serverEventChannelId,
      notification.title,
      notification.body,
      details,
    );
  }

  /// FCMトークンを取得し、Firestoreの`users/{uid}.fcmToken`に保存する
  Future<void> registerToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'fcmToken': token}, SetOptions(merge: true));

      // トークンがローテーションされた場合も追従する
      _messaging.onTokenRefresh.listen((newToken) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'fcmToken': newToken}, SetOptions(merge: true));
      });
    } catch (e) {
      print('Error registering FCM token: $e');
    }
  }
}
