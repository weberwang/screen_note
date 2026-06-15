import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';

/// 通知权限仓储接口，统一隔离平台权限读取与申请细节。
abstract interface class NotificationPermissionRepository {
  /// 读取当前通知权限状态。
  Future<NotificationPermissionStatus> readStatus();

  /// 主动触发一次权限申请或复查。
  Future<NotificationPermissionStatus> requestPermission();
}
