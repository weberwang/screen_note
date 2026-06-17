import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

part 'task_event_entity.freezed.dart';

/// 事项事件实体，记录关键状态变化，供历史与后续同步链路消费。
@freezed
abstract class TaskEventEntity with _$TaskEventEntity {
  /// 创建事项事件。
  const factory TaskEventEntity({
    required String id,
    required String taskId,
    required String type,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required DateTime occurredAt,
  }) = _TaskEventEntity;
}
