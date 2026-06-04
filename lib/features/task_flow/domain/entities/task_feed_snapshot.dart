import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

part 'task_feed_snapshot.freezed.dart';

/// 首页任务流稳定快照，只暴露展示层真正需要消费的排序结果与计数。
@freezed
abstract class TaskFeedSnapshot with _$TaskFeedSnapshot {
  /// 创建首页任务流快照。
  const factory TaskFeedSnapshot({
    required List<TaskEntity> pinnedTasks,
    required List<TaskEntity> overdueTasks,
    required List<TaskEntity> todayTasks,
    required List<TaskEntity> otherTasks,
    required int activeCount,
    required int completedCount,
    required int deletedCount,
  }) = _TaskFeedSnapshot;
}
