/// 集中维护根路由路径，避免页面层散落硬编码字符串。
abstract final class RoutePaths {
  /// 首页分支路径。
  static const String home = '/';

  /// 事项编辑页绝对路径，作为独立根级路由使用。
  static const String taskEditor = '/task-editor';

  /// 历史中心分支路径。
  static const String history = '/history';

  /// 设置中心分支路径。
  static const String settings = '/settings';

  /// 小组件桥接页使用独立根路由，避免和设置分支共用状态栈后互相污染返回行为。
  static const String widgetBridge = '/widget-bridge';
}
