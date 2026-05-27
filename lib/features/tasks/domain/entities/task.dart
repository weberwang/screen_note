import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// 事项持久状态。
///
/// 这里只允许落库 `active`、`completed`、`deleted` 三种值。
/// `expired` 只作为显示层基于时间条件派生出的状态，不能变成第四种持久状态。
@JsonEnum(alwaysCreate: true)
enum TaskStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('deleted')
  deleted,
}

/// 提醒模式。
@JsonEnum(alwaysCreate: true)
enum TaskReminderMode {
  @JsonValue('normal')
  normal,
  @JsonValue('persistent')
  persistent,
}

/// 事项领域实体。
@freezed
abstract class Task with _$Task {
  /// 创建不可变事项模型。
  const factory Task({
    required String id,
    required String title,
    String? note,
    required TaskStatus status,
    DateTime? dueAt,
    @Default(false) bool isPinned,
    @Default(false) bool isPrivate,
    @Default(TaskReminderMode.normal) TaskReminderMode reminderMode,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
    DateTime? deletedAt,
  }) = _Task;

  /// 从 JSON 还原事项实体。
  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
