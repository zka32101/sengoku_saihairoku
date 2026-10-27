import 'package:firebase_core/firebase_core.dart'
    show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Web は Firebaseコンソールでwebアプリを登録後、実際のappIdへ更新すること。
  // それまではローカルでの画面確認用の暫定値（appIdが未登録のため一部のFirebase
  // 機能は動作しない）。
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDyeBCHFsksVUP4BRLQsJvsNEJegU4zxFw',
    appId: '1:970577736486:web:0000000000000000000000',
    messagingSenderId: '970577736486',
    projectId: 'sengoku-saihairoku',
    authDomain: 'sengoku-saihairoku.firebaseapp.com',
    storageBucket: 'sengoku-saihairoku.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyeBCHFsksVUP4BRLQsJvsNEJegU4zxFw',
    appId: '1:970577736486:android:1ddec83fc040d08dd2c7e7',
    messagingSenderId: '970577736486',
    projectId: 'sengoku-saihairoku',
    storageBucket: 'sengoku-saihairoku.firebasestorage.app',
  );

  // iOS は GoogleService-Info.plist を配置後に更新
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyeBCHFsksVUP4BRLQsJvsNEJegU4zxFw',
    appId: '1:970577736486:ios:000000000000000000000000',
    messagingSenderId: '970577736486',
    projectId: 'sengoku-saihairoku',
    storageBucket: 'sengoku-saihairoku.firebasestorage.app',
    iosBundleId: 'com.petitworksapps.sengokusaihairoku',
  );
}
