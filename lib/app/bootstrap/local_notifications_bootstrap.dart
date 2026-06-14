import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 应用启动阶段统一初始化本地通知插件，但不在此时主动弹出权限请求。
///
/// 权限申请必须留给设置页或后续明确的业务入口触发，避免首次启动打断主链路。
Future<void> initializeScreenNoteLocalNotifications() async {
  await FlutterLocalNotificationsPlugin().initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
      windows: WindowsInitializationSettings(
        appName: 'screen_note',
        appUserModelId: 'com.example.screen_note.app',
        guid: '9f6c5b91-4d50-4ab2-93f7-548a6d66b001',
      ),
    ),
  );
}
