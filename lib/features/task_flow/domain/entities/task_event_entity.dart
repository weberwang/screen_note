import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_event_entity.freezed.dart';

/// 事项事件类型，保证关键状态流转都有稳定日志。
enum TaskEventType {
  /// 创建事项。
  created,

  /// 更新事项主体字段。
  updated,

  /// 完成事项。
  completed,

  /// 软删除事项。
  deleted,

  /// 恢复事项。
  restored,
}

/// 事项事件日志实体，用于追踪状态变更和后续恢复链路。
@freezed
abstract class TaskEventEntity with _$TaskEventEntity {
  /// 创建事项事件。
  const factory TaskEventEntity({
    required String id,
    required String taskId,
    required TaskEventType type,
    required DateTime occurredAt,
  }) = _TaskEventEntity;
}
