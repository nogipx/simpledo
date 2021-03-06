// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAG__EK_G3Bryj7Xu32-8fr5OPJTFLBdpQ',
    appId: '1:177503110368:web:1f6ed43a0385b222157c85',
    messagingSenderId: '177503110368',
    projectId: 'simpledo-48afc',
    authDomain: 'simpledo-48afc.firebaseapp.com',
    storageBucket: 'simpledo-48afc.appspot.com',
    measurementId: 'G-HENGZ932SN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxse6W1PA0Z4n1N544Yq1O8Yzt7BZR58c',
    appId: '1:177503110368:android:29fa68415c77f9a4157c85',
    messagingSenderId: '177503110368',
    projectId: 'simpledo-48afc',
    storageBucket: 'simpledo-48afc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjpOALTmtitzK8cTgE3FKFblqbjW157V4',
    appId: '1:177503110368:ios:a7f05bb88aceea03157c85',
    messagingSenderId: '177503110368',
    projectId: 'simpledo-48afc',
    storageBucket: 'simpledo-48afc.appspot.com',
    iosClientId:
        '177503110368-umi3ottqcgvb25d5b7h35mkutfikkemq.apps.googleusercontent.com',
    iosBundleId: 'dev.nogipx.simpledo',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
