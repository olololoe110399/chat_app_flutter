import 'package:chat_app/models/enum/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    @Default('') String notificationId,
    @Default(NotificationType.unknown) NotificationType notificationType,
    @Default('') String image,
    @Default('') String title,
    @Default('') String message,
    @Default(false) bool isAndroid,
    @Default(null) Map<String, dynamic>? data,
  }) = _AppNotification;
}
