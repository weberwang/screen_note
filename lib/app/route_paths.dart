/// 统一维护应用阶段一路由路径，避免页面直接散落字符串常量。
abstract final class RoutePaths {
  /// 首页占位路由。
  static const String home = '/home';

  /// 完整新建页路由。
  static const String taskNew = '/task/new';

  /// 快速添加兜底页路由。
  static const String quickAdd = '/quick-add';

  /// 任务详情路由模板，占位阶段只负责注册与参数透传。
  static const String taskDetail = '/task/:id';

  /// 已完成历史列表路由。
  static const String historyCompleted = '/history/completed';

  /// 已删除历史列表路由。
  static const String historyDeleted = '/history/deleted';

  /// 设置页入口路由。
  static const String settings = '/settings';

  /// Widget 预览设置页路由。
  static const String settingsWidget = '/settings/widget';

  /// 隐私设置页路由。
  static const String settingsPrivacy = '/settings/privacy';

  /// 构建事项详情实际路径。
  static String taskDetailPath(String id) => '/task/$id';
}
