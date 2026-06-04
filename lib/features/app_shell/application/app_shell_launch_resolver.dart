import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
import 'package:screen_note/features/app_shell/infrastructure/app_shell_launch_query_parser.dart';

/// 壳层启动解析用例，负责把系统入口统一收口为应用当前可支持的稳定路由。
final class AppShellLaunchResolver {
  /// 创建壳层启动解析用例。
  const AppShellLaunchResolver({
    required AppShellLaunchQueryParser parser,
    required AppLogger logger,
  }) : _parser = parser,
       _logger = logger;

  final AppShellLaunchQueryParser _parser;
  final AppLogger _logger;

  /// 解析启动 URI，并在目标异常时保守回退到首页。
  AppShellLaunchIntent resolve(Uri uri) {
    final AppShellEntrySource source = _parser.parseSource(uri);
    final AppShellRouteTarget? target = _parser.parseTarget(uri);
    if (target == null) {
      final String invalidTarget =
          uri.queryParameters['target'] ?? 'missing-target';
      // 回流参数异常时只能回退首页，避免把用户卡在无效入口。
      _logger.warning('external_entry_fallback:$invalidTarget');
      return AppShellLaunchIntent(
        source: source,
        target: AppShellRouteTarget.home,
        isFallback: true,
        invalidTarget: invalidTarget,
      );
    }

    _logger.info('app_launch_routed:${source.name}:${target.name}');
    return AppShellLaunchIntent(
      source: source,
      target: target,
      isFallback: false,
    );
  }
}
