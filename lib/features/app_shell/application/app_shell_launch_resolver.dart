import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

/// 启动落点解析器只把原始路径归一到共享壳层允许的一级入口，
/// 避免平台入口把未知路径直接推入路由树。
final class AppShellLaunchResolver {
  /// 创建启动落点解析器。
  const AppShellLaunchResolver();

  /// 解析平台原始路径，并返回壳层允许的安全落点。
  AppShellLaunchIntent resolve(String rawLocation) {
    if (rawLocation == RoutePaths.home) {
      return const AppShellLaunchIntent.home();
    }

    // 只允许精确命中一级入口，或在入口后跟合法路径/查询分隔符。
    if (_matchesShellEntry(rawLocation, RoutePaths.history)) {
      return const AppShellLaunchIntent.history();
    }

    if (_matchesShellEntry(rawLocation, RoutePaths.settings)) {
      return const AppShellLaunchIntent.settings();
    }

    return const AppShellLaunchIntent.fallbackHome();
  }

  /// 判断原始路径是否命中允许的壳层一级入口，避免把相似未知路径误判为合法入口。
  bool _matchesShellEntry(String rawLocation, String shellEntry) {
    return rawLocation == shellEntry ||
        rawLocation.startsWith('$shellEntry/') ||
        rawLocation.startsWith('$shellEntry?');
  }
}
