/// 通知权限状态，只保留显示层真正需要的三档结果。
enum NotificationPermissionStatus {
  /// 已允许通知。
  enabled,

  /// 已拒绝或当前不可用。
  disabled,

  /// 平台无法明确判断时的降级状态。
  unknown,
}
