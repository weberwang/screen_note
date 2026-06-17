import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';

part 'history_center_snapshot.freezed.dart';

/// 历史页稳定快照，统一承载最近完成与最近删除两个分区的数据边界。
@freezed
abstract class HistoryCenterSnapshot with _$HistoryCenterSnapshot {
  /// 允许为 `freezed` 实体补充只读派生属性。
  const HistoryCenterSnapshot._();

  /// 创建历史页快照。
  const factory HistoryCenterSnapshot({
    required List<TaskEntity> completedTasks,
    required List<TaskEntity> deletedTasks,
  }) = _HistoryCenterSnapshot;

  /// 历史页是否处于完全空态。
  bool get isEmpty => completedTasks.isEmpty && deletedTasks.isEmpty;
}
