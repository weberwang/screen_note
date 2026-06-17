import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';

/// 通知权限降级来源只把首页真正关心的能力风险映射成内部提示枚举。
final class TaskFlowNotificationPermissionDegradationHintSource
    implements TaskFlowDegradationHintSource {
  /// 创建通知权限降级来源。
  const TaskFlowNotificationPermissionDegradationHintSource({
    required NotificationPermissionRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  final NotificationPermissionRepository _notificationRepository;

  @override
  Future<List<TaskFlowDegradationHint>> loadHints() async {
    try {
      final NotificationPermissionStatus status = await _notificationRepository
          .readStatus();
      if (status != NotificationPermissionStatus.disabled) {
        return const <TaskFlowDegradationHint>[];
      }
      return const <TaskFlowDegradationHint>[
        TaskFlowDegradationHint.notificationPermissionDenied,
      ];
    } catch (_) {
      return const <TaskFlowDegradationHint>[];
    }
  }
}
