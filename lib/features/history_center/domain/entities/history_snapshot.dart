import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

part 'history_snapshot.freezed.dart';

/// 历史中心快照，统一承接最近完成与最近删除两组稳定排序结果。
@freezed
abstract class HistorySnapshot with _$HistorySnapshot {
  /// 创建历史中心快照。
  const factory HistorySnapshot({
    required List<TaskEntity> completedTasks,
    required List<TaskEntity> deletedTasks,
  }) = _HistorySnapshot;
}
