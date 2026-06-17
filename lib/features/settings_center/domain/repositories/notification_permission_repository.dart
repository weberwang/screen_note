import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';

/// 通知权限仓储统一屏蔽设置页对平台通知插件与权限细节的直接依赖。
abstract interface class NotificationPermissionRepository {
  /// 读取当前通知权限状态。
  Future<NotificationPermissionStatus> readStatus();

  /// 触发权限复查或请求，并返回更新后的状态。
  Future<NotificationPermissionStatus> requestPermission();
}
