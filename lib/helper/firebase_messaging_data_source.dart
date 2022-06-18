import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingHelper {
  final _messaging = FirebaseMessaging.instance;

  static final FirebaseMessagingHelper _singleton = FirebaseMessagingHelper();

  static FirebaseMessagingHelper get instance => _singleton;

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
  Future<String?> get deviceToken => _messaging.getToken();
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  Future<RemoteMessage?> get getInitialMessage =>
      _messaging.getInitialMessage();
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  Future<void> init() async {
    /// Set the background messaging handler early on
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // ignore: unawaited_futures
      FirebaseMessaging.instance.getToken().then((value) {
        print(
          '[FirebaseMessagingHelper] deviceToken $value',
        );
      }).catchError(
        (error) {
          print('[FirebaseMessagingHelper] deviceToken error $error');
        },
      );
    }
  }

  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
        // User granted permission
        case AuthorizationStatus.provisional:
          // User granted provisional permission
          return true;
        default:
          // User declined or has not accepted permission
          return false;
      }
    }

    return true;
  }
}

Future _handleBackgroundMessage(RemoteMessage remoteMessage) async {
  /// If you're going to use other Firebase services in the background, such as Firestore,
  /// make sure you call `Firebase.initializeApp()` before using other Firebase services.
  print(
      '[FirebaseMessagingHelper] onBackgroundMessage ${remoteMessage.notification?.title}');
}
