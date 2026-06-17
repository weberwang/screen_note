import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

part 'task_entity.freezed.dart';

/// 事项聚合根，统一承载标题、提醒、隐私与三态持久事实。
@freezed
abstract class TaskEntity with _$TaskEntity {
  /// 创建事项实体。
  const factory TaskEntity({
    required String id,
    required String title,
    required String note,
    required DateTime? dueAt,
    required DateTime? reminderAt,
    required bool isPinned,
    required bool isPrivate,
    required TaskStatus status,
    required TaskReminderMode reminderMode,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? completedAt,
    required DateTime? deletedAt,
  }) = _TaskEntity;
}
