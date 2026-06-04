import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_flow_bootstrap_snapshot.freezed.dart';
part 'task_flow_bootstrap_snapshot.g.dart';

/// 事项主流程初始化快照，只描述骨架就绪度，不承载真实业务数据。
@freezed
abstract class TaskFlowBootstrapSnapshot with _$TaskFlowBootstrapSnapshot {
  /// 创建事项主流程初始化快照。
  const factory TaskFlowBootstrapSnapshot({
    required int activePreviewCount,
    required int completedPreviewCount,
    required int deletedPreviewCount,
    required bool widgetProjectionReady,
    required bool privacySafeByDefault,
  }) = _TaskFlowBootstrapSnapshot;

  /// 从 JSON 反序列化初始化快照，验证 `freezed + json_serializable` 生成链可用。
  factory TaskFlowBootstrapSnapshot.fromJson(Map<String, dynamic> json) =>
      _$TaskFlowBootstrapSnapshotFromJson(json);
}
