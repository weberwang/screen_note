/// 提醒模式先只保留最小业务语义，避免在真源层提前发明复杂提醒协议。
enum TaskReminderMode {
  /// 按默认提醒策略处理。
  normal,

  /// 明确静默，不触发提醒副作用。
  silent,
}
