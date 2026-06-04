import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

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
