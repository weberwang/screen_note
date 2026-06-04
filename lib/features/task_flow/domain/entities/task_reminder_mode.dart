/// 提醒模式枚举，先固定最小主链路所需的两种策略。
enum TaskReminderMode {
  /// 普通提醒，仅在到点时触发。
  normal,

  /// 持续提醒，为后续高优先级事项预留。
  persistent,
}
