/// 启动入口来源，仅用于归档外部入口元信息。
enum AppShellEntrySource {
  /// 应用图标。
  appIcon,

  /// 小组件入口。
  widget,

  /// 通知入口。
  notification,

  /// 快捷操作入口。
  shortcut,

  /// 深链入口。
  deepLink,

  /// 未知入口。
  unknown,
}

/// 启动目标页，仅用于解析外部 query 参数时做轻量归一。
enum AppShellRouteTarget {
  /// 首页。
  home,

  /// 事项编辑页。
  taskEditor,

  /// 历史已完成分组。
  historyCompleted,

  /// 历史已删除分组。
  historyDeleted,

  /// 设置页。
  settings,

  /// Widget 预览页。
  widgetBridge,
}

/// 启动回流查询参数解析器，只负责把外部路由参数映射为领域枚举。
final class AppShellLaunchQueryParser {
  /// 创建查询参数解析器。
  const AppShellLaunchQueryParser();

  /// 解析入口来源；来源只影响日志与后续统计，不影响主路由可达性。
  AppShellEntrySource parseSource(Uri uri) {
    return switch (uri.queryParameters['source']) {
      'app-icon' => AppShellEntrySource.appIcon,
      'widget' => AppShellEntrySource.widget,
      'notification' => AppShellEntrySource.notification,
      'shortcut' => AppShellEntrySource.shortcut,
      'deep-link' => AppShellEntrySource.deepLink,
      _ => AppShellEntrySource.unknown,
    };
  }

  /// 解析目标页；无法识别时返回 `null`，由应用层决定是否保守回退。
  AppShellRouteTarget? parseTarget(Uri uri) {
    return switch (uri.queryParameters['target']) {
      null || '' || 'home' => AppShellRouteTarget.home,
      'task-editor' => AppShellRouteTarget.taskEditor,
      'history-completed' => AppShellRouteTarget.historyCompleted,
      'history-deleted' => AppShellRouteTarget.historyDeleted,
      'settings' => AppShellRouteTarget.settings,
      'widget' => AppShellRouteTarget.widgetBridge,
      _ => null,
    };
  }
}
