import 'package:collection/collection.dart';

import 'package:screen_note/features/history_center/domain/entities/history_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 历史快照读取用例，负责把最近完成与最近删除按业务时间倒序整理出来。
final class LoadHistorySnapshotUseCase {
  /// 创建历史快照读取用例。
  const LoadHistorySnapshotUseCase({required TaskRepository repository})
    : _repository = repository;

  final TaskRepository _repository;

  /// 读取历史快照，并按完成/删除时间稳定倒序返回。
  Future<HistorySnapshot> execute() async {
    final List<TaskEntity> completedTasks = await _repository.loadTasksByStatus(
      TaskStatus.completed,
    );
    final List<TaskEntity> deletedTasks = await _repository.loadTasksByStatus(
      TaskStatus.deleted,
    );

    return HistorySnapshot(
      completedTasks: completedTasks.sorted(_compareCompletedTasks),
      deletedTasks: deletedTasks.sorted(_compareDeletedTasks),
    );
  }

  /// 优先按完成时间倒序；缺失完成时间时退回更新时间，保证旧数据也有稳定顺序。
  int _compareCompletedTasks(TaskEntity left, TaskEntity right) {
    final DateTime leftTimestamp = left.completedAt ?? left.updatedAt;
    final DateTime rightTimestamp = right.completedAt ?? right.updatedAt;
    return rightTimestamp.compareTo(leftTimestamp);
  }

  /// 优先按删除时间倒序；缺失删除时间时退回更新时间，避免异常数据打乱列表。
  int _compareDeletedTasks(TaskEntity left, TaskEntity right) {
    final DateTime leftTimestamp = left.deletedAt ?? left.updatedAt;
    final DateTime rightTimestamp = right.deletedAt ?? right.updatedAt;
    return rightTimestamp.compareTo(leftTimestamp);
  }
}
