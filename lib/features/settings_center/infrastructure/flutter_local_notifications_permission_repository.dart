import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';

/// 通知权限仓储实现，优先复用现有本地通知插件，失败时按降级返回未知状态。
final class FlutterLocalNotificationsPermissionRepository
    implements NotificationPermissionRepository {
  /// 创建通知权限仓储实现。
  const FlutterLocalNotificationsPermissionRepository({
    required FlutterLocalNotificationsPlugin plugin,
  }) : _plugin = plugin;

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<NotificationPermissionStatus> readStatus() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final bool? enabled = await androidPlugin.areNotificationsEnabled();
      return _mapEnabledFlag(enabled);
    }

    final IOSFlutterLocalNotificationsPlugin? platformPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (platformPlugin != null) {
      final NotificationsEnabledOptions? options =
          await platformPlugin.checkPermissions();
      return _mapDarwinStatus(options);
    }

    final MacOSFlutterLocalNotificationsPlugin? macOsPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macOsPlugin != null) {
      final NotificationsEnabledOptions? options =
          await macOsPlugin.checkPermissions();
      return _mapDarwinStatus(options);
    }

    return NotificationPermissionStatus.unknown;
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      return readStatus();
    }

    final IOSFlutterLocalNotificationsPlugin? platformPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (platformPlugin != null) {
      await platformPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return readStatus();
    }

    final MacOSFlutterLocalNotificationsPlugin? macOsPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macOsPlugin != null) {
      await macOsPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return readStatus();
    }

    return NotificationPermissionStatus.unknown;
  }

  /// Darwin 平台权限状态统一只收敛为可用、不可用、未知三档，避免把平台细节泄露到显示层。
  NotificationPermissionStatus _mapDarwinStatus(
    NotificationsEnabledOptions? options,
  ) {
    if (options == null) {
      return NotificationPermissionStatus.unknown;
    }

    return options.isEnabled
        ? NotificationPermissionStatus.enabled
        : NotificationPermissionStatus.disabled;
  }

  /// Android 平台只关心系统是否允许发通知，空值时统一按未知降级。
  NotificationPermissionStatus _mapEnabledFlag(bool? enabled) {
    if (enabled == null) {
      return NotificationPermissionStatus.unknown;
    }

    return enabled
        ? NotificationPermissionStatus.enabled
        : NotificationPermissionStatus.disabled;
  }
}
