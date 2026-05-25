import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_event.freezed.dart';
part 'task_event.g.dart';

/// 事项操作日志类型。
///
/// `expire` 只用于记录事项进入“过期显示”的事实，不代表持久状态发生迁移。
@JsonEnum(alwaysCreate: true)
enum TaskEventAction {
  @JsonValue('create')
  create,
  @JsonValue('update')
  update,
  @JsonValue('complete')
  complete,
  @JsonValue('delete')
  delete,
  @JsonValue('restore')
  restore,
  @JsonValue('expire')
  expire,
}

/// 事项操作日志实体。
@freezed
abstract class TaskEvent with _$TaskEvent {
  /// 创建不可变事项日志模型。
  const factory TaskEvent({
    required String id,
    required String taskId,
    required TaskEventAction action,
    required DateTime createdAt,
    @Default(<String, Object?>{}) Map<String, Object?> metadata,
  }) = _TaskEvent;

  /// 从 JSON 还原事项日志实体。
  factory TaskEvent.fromJson(Map<String, Object?> json) =>
      _$TaskEventFromJson(json);
}
