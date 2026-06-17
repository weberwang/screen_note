import 'package:collection/collection.dart';

import 'package:screen_note/features/history_center/domain/entities/history_center_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 历史页快照加载用例，统一收口最近完成与最近删除的分区和排序规则。
final class LoadHistoryCenterSnapshotUseCase {
  /// 创建历史页快照加载用例。
  const LoadHistoryCenterSnapshotUseCase({required TaskRepository repository})
    : _repository = repository;

  final TaskRepository _repository;

  /// 加载历史页稳定快照。
  Future<HistoryCenterSnapshot> execute() async {
    final List<TaskEntity> completedTasks = await _repository.loadTasksByStatus(
      TaskStatus.completed,
    );
    final List<TaskEntity> deletedTasks = await _repository.loadTasksByStatus(
      TaskStatus.deleted,
    );

    return HistoryCenterSnapshot(
      completedTasks: _sortByCompletedAt(completedTasks),
      deletedTasks: _sortByDeletedAt(deletedTasks),
    );
  }

  /// 最近完成分区按完成时间倒序排列，没有完成时间时回退到更新时间，避免时间线跳动。
  List<TaskEntity> _sortByCompletedAt(List<TaskEntity> tasks) {
    return tasks.sorted((TaskEntity left, TaskEntity right) {
      final DateTime leftAnchor = left.completedAt ?? left.updatedAt;
      final DateTime rightAnchor = right.completedAt ?? right.updatedAt;
      return rightAnchor.compareTo(leftAnchor);
    });
  }

  /// 最近删除分区按删除时间倒序排列，没有删除时间时回退到更新时间，保证恢复入口先暴露最新项。
  List<TaskEntity> _sortByDeletedAt(List<TaskEntity> tasks) {
    return tasks.sorted((TaskEntity left, TaskEntity right) {
      final DateTime leftAnchor = left.deletedAt ?? left.updatedAt;
      final DateTime rightAnchor = right.deletedAt ?? right.updatedAt;
      return rightAnchor.compareTo(leftAnchor);
    });
  }
}
