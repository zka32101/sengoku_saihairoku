import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdIuk0UifwgliMGDdU-06TwUsvkJESPc0',
    appId: '1:250444577503:android:12607324e363e4bbc1476a',
    messagingSenderId: '250444577503',
    projectId: 'petit-works-games',
    databaseURL: 'https://petit-works-games-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'petit-works-games.firebasestorage.app',
  );

  // iOS は GoogleService-Info.plist を配置後に更新
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdIuk0UifwgliMGDdU-06TwUsvkJESPc0',
    appId: '1:250444577503:ios:000000000000000000000000',
    messagingSenderId: '250444577503',
    projectId: 'petit-works-games',
    databaseURL: 'https://petit-works-games-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'petit-works-games.firebasestorage.app',
    iosBundleId: 'com.petitworksapps.sengokusaihairoku',
  );
}
