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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCwiX7tkkrLqdjNYII68WeRvBgyzseBJ8A',
    appId: '1:388181415985:web:ce5e018574fc2193fe9d10',
    messagingSenderId: '388181415985',
    projectId: 'chat-app-f3abe',
    authDomain: 'chat-app-f3abe.firebaseapp.com',
    storageBucket: 'chat-app-f3abe.appspot.com',
    measurementId: 'G-FC16PBC4SK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9pB_Br1-Zhk5KWC6anP1yjpCk416S4Bc',
    appId: '1:388181415985:android:02636544adaf1481fe9d10',
    messagingSenderId: '388181415985',
    projectId: 'chat-app-f3abe',
    storageBucket: 'chat-app-f3abe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQuopmANtSnh67XVwhBJfk2GEOXnudJkE',
    appId: '1:388181415985:ios:66088dcb77f1bde2fe9d10',
    messagingSenderId: '388181415985',
    projectId: 'chat-app-f3abe',
    storageBucket: 'chat-app-f3abe.appspot.com',
    androidClientId: '388181415985-09t9hlp8sn8n5i2346gakvj1hk0otcbj.apps.googleusercontent.com',
    iosClientId: '388181415985-kp4o2b79lssghbdomlej09k9oconjun7.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
