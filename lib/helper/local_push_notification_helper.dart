import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:chat_app/models/app_notification.dart';
import 'package:chat_app/utilities/file_utils.dart';
import 'package:chat_app/utilities/parse_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalPushNotificationHelper {
  static const _channelId = 'vtnd.duynn.abc';
  static const _channelName = 'Hot News';
  static const _channelDescription = 'Update hot news every day';
  static const _androidDefaultIcon = '@mipmap/ic_launcher';
  static const _bitCount = 31;
  static final LocalPushNotificationHelper _singleton =
      LocalPushNotificationHelper();

  static LocalPushNotificationHelper get instance => _singleton;

  // ignore: close_sinks
  static final BehaviorSubject<String?> _selectNotificationSubject =
      BehaviorSubject<String?>();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int get _randomNotificationId =>
      Random().nextInt(pow(2, _bitCount).toInt() - 1);

  BehaviorSubject<String?> get selectNotificationSubject =>
      _selectNotificationSubject;

  Future<NotificationAppLaunchDetails?> get details =>
      _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  Future<void> init() async {
    /// Change icon at android\app\src\main\res\drawable\app_icon.png
    const androidInit = AndroidInitializationSettings(_androidDefaultIcon);

    /// don't request permission here
    /// we use firebase_messaging package to request permission instead
    const iOSInit = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const init = InitializationSettings(android: androidInit, iOS: iOSInit);

    /// init local notification
    await FlutterLocalNotificationsPlugin().initialize(
      init,
      onSelectNotification: _selectNotificationSubject.add,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ));
  }

  Future<void> notify(AppNotification notification) async {
    File? imageFile;
    if (notification.image.isNotEmpty) {
      imageFile = await FileUtils.getImageFileFromUrl(notification.image);
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      styleInformation: imageFile != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(imageFile.path),
              hideExpandedLargeIcon: true,
            )
          : null,
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (notification.isAndroid) {
      await FlutterLocalNotificationsPlugin()
          .show(
            _randomNotificationId,
            notification.title,
            notification.message,
            platformChannelSpecifics,
            payload: jsonEncode(notification.data),
          )
          .onError((error, stackTrace) =>
              print('Can not show notification cause $error'));
    }
  }

  Future<void> handleSelectNotificationMap(
    Map<String, dynamic>? data,
    Function(int id, String targetId, String title)? readChanged,
  ) async {}

  Future<void> handleSelectNotificationPayload(
    String? payload,
    Function(int id, String targetId, String title)? readChanged,
  ) async {
    final data = ParseUtils.parseStringToMap(payload);
    if (data != null) {
      handleSelectNotificationMap(data, readChanged);
    }
  }
}
