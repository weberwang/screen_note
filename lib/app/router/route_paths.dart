/// 应用级路由常量，集中避免页面层散落硬编码路径。
abstract final class RoutePaths {
  /// 壳层首页。
  static const String taskFlowHome = '/';

  /// 历史中心页。
  static const String historyCenter = '/history';

  /// Widget 预览页。
  static const String widgetBridge = '/widget';

  /// 设置中心页。
  static const String settingsCenter = '/settings';

  /// 外部入口统一回流网关。
  static const String launch = '/launch';

  /// 事项编辑占位页。
  static const String taskEditor = '/task-editor';
}
