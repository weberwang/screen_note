/// 同步状态在当前阶段只需要表达本地真源与未来同步入口的边界。
enum SettingsSyncStatus {
  localOnly,
  synced,
}
