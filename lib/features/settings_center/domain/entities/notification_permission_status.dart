/// 通知权限状态只表达设置页需要的最小能力边界，不泄露平台细节到显示层。
enum NotificationPermissionStatus {
  enabled,
  disabled,
  unknown,
}
