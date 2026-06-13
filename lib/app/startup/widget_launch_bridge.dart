import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_note/app/router/route_paths.dart';

part 'widget_launch_bridge.g.dart';

/// 启动桥接负责把系统入口解析为安全的首个落点。
///
/// 当前 bootstrap 阶段先提供无副作用默认实现，后续再接 Widget、深链或系统快捷入口。
abstract interface class WidgetLaunchBridge {
  /// 返回平台原始入口位置；壳层路由会基于它归一化到安全一级入口。
  String get rawLaunchLocation;
}

/// 默认桥接不做任何平台分发，统一安全落到首页。
final class NoopWidgetLaunchBridge implements WidgetLaunchBridge {
  /// 创建默认桥接。
  const NoopWidgetLaunchBridge();

  @override
  String get rawLaunchLocation => RoutePaths.home;
}

/// 根路由只依赖这个 Provider 获取安全初始落点，
/// 避免直接把平台入口逻辑揉进 `GoRouter` 构造过程。
@Riverpod(keepAlive: true)
WidgetLaunchBridge widgetLaunchBridge(Ref ref) {
  return const NoopWidgetLaunchBridge();
}
