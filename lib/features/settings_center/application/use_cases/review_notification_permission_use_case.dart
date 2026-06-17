import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';

/// 通知权限复查用例，统一承接设置页对系统权限的复查或请求入口。
final class ReviewNotificationPermissionUseCase {
  /// 创建通知权限复查用例。
  const ReviewNotificationPermissionUseCase({
    required NotificationPermissionRepository repository,
  }) : _repository = repository;

  final NotificationPermissionRepository _repository;

  /// 触发权限复查。
  Future<NotificationPermissionStatus> execute() {
    return _repository.requestPermission();
  }
}
