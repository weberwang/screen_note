/// Widget 刷新结果。
///
/// 主链路只依赖“刷新是否需要降级”这个稳定枚举，不把底层插件异常
/// 直接暴露给事项创建、编辑、完成、删除和恢复流程。
enum WidgetRefreshResult {
  /// 当前快照已成功生成并写入。
  success,

  /// 当前快照写入失败，但已成功回退到最后有效内容或空态。
  savedFallback,

  /// 刷新失败且连兜底也没有完成，但异常已被吃掉，不阻断主链路。
  failedButNonBlocking,
}
