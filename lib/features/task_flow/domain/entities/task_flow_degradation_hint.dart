/// 首页降级提示枚举只表达非阻断能力状态，避免把展示文案和平台细节带进领域层。
enum TaskFlowDegradationHint {
  /// 通知权限不可用时，只做轻量提醒，不阻断事项主链路。
  notificationPermissionDenied,

  /// 快照刷新失败但已有旧数据时，提醒当前首页展示的是保留快照。
  refreshFailed,
}
