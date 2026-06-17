/// 事项持久状态只允许三态落库，`expired` 只能由展示层按时间派生。
enum TaskStatus {
  /// 仍在进行中的事项。
  active,

  /// 已完成的事项。
  completed,

  /// 已软删除的事项。
  deleted,
}
