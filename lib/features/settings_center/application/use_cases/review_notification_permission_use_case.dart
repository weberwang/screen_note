import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';

/// 通知权限复查用例，统一把设置页动作收口到权限仓储。
final class ReviewNotificationPermissionUseCase {
  /// 创建通知权限复查用例。
  const ReviewNotificationPermissionUseCase({
    required NotificationPermissionRepository repository,
  }) : _repository = repository;

  final NotificationPermissionRepository _repository;

  /// 发起一次权限复查，并返回最新状态。
  Future<NotificationPermissionStatus> execute() {
    return _repository.requestPermission();
  }
}
