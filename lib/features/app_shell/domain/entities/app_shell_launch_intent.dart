import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/app/router/route_paths.dart';

part 'app_shell_launch_intent.freezed.dart';

/// 壳层入口来源，统一描述用户是从哪个系统入口回流到应用。
enum AppShellEntrySource {
  /// 常规点击应用图标启动。
  appIcon,

  /// 从 Widget 或锁屏入口回流。
  widget,

  /// 从本地通知回流。
  notification,

  /// 从快捷入口或系统动作回流。
  shortcut,

  /// 从深链或其他外部 URL 回流。
  deepLink,

  /// 无法识别的入口来源。
  unknown,
}

/// 壳层可识别的启动目标，负责把外部入口稳定收口到当前模块路由。
enum AppShellRouteTarget {
  /// 首页任务流。
  home,

  /// 事项编辑页。
  taskEditor,

  /// 最近完成入口，当前收口到历史中心。
  historyCompleted,

  /// 最近删除入口，当前收口到历史中心。
  historyDeleted,

  /// 设置中心入口。
  settings,

  /// Widget 预览入口。
  widgetBridge,
}

/// 壳层启动意图，描述解析后的入口来源、目标以及是否发生了保守回退。
@freezed
abstract class AppShellLaunchIntent with _$AppShellLaunchIntent {
  /// 创建壳层启动意图。
  const factory AppShellLaunchIntent({
    required AppShellEntrySource source,
    required AppShellRouteTarget target,
    required bool isFallback,
    String? invalidTarget,
  }) = _AppShellLaunchIntent;
}

/// 为目标枚举提供统一路由落点，避免路由字符串散落在应用层和路由层。
extension AppShellRouteTargetX on AppShellRouteTarget {
  /// 返回当前目标对应的最终路由地址。
  String get location {
    return switch (this) {
      AppShellRouteTarget.home => RoutePaths.taskFlowHome,
      AppShellRouteTarget.taskEditor => RoutePaths.taskEditor,
      AppShellRouteTarget.historyCompleted =>
        '${RoutePaths.historyCenter}?section=completed',
      AppShellRouteTarget.historyDeleted =>
        '${RoutePaths.historyCenter}?section=deleted',
      AppShellRouteTarget.settings => RoutePaths.settingsCenter,
      AppShellRouteTarget.widgetBridge => RoutePaths.widgetBridge,
    };
  }
}
