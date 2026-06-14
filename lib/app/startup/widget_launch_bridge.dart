import 'dart:async';

import 'package:home_widget/home_widget.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';

part 'widget_launch_bridge.g.dart';

const Duration _defaultWidgetLaunchBridgeTimeout = Duration(milliseconds: 300);

/// 启动桥接负责把系统入口解析为安全的首个落点。
///
/// 当前 bootstrap 阶段先提供无副作用默认实现，后续再接 Widget、深链或系统快捷入口。
abstract interface class WidgetLaunchBridge {
  /// 返回平台原始入口位置；壳层路由会基于它归一化到安全一级入口。
  String get rawLaunchLocation;

  /// 运行中点击 Widget 时，桥接会持续输出已经归一化过的安全落点。
  Stream<String> get launchLocations;
}

/// 默认桥接不做任何平台分发，统一安全落到首页。
final class NoopWidgetLaunchBridge implements WidgetLaunchBridge {
  /// 创建默认桥接。
  const NoopWidgetLaunchBridge();

  @override
  String get rawLaunchLocation => defaultAppShellLocation;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();
}

/// HomeWidget 桥接只负责把桌面小组件回流统一归一到壳层可接受的安全落点。
final class HomeWidgetLaunchBridge implements WidgetLaunchBridge {
  HomeWidgetLaunchBridge._({
    required this.rawLaunchLocation,
    required Stream<String> launchLocations,
  }) : _launchLocations = launchLocations;

  /// 异步读取首启 Widget 深链，并接上运行中的 Widget 点击流。
  static Future<HomeWidgetLaunchBridge> load({
    Uri? initialUri,
    Stream<Uri?>? clickStream,
  }) async {
    final Uri? rawInitialUri =
        initialUri ?? await HomeWidget.initiallyLaunchedFromHomeWidget();
    final Stream<Uri?> rawClickStream = clickStream ?? HomeWidget.widgetClicked;

    return HomeWidgetLaunchBridge._(
      rawLaunchLocation: _normalize(rawInitialUri),
      launchLocations: rawClickStream.transform(
        _safeLaunchLocationTransformer(),
      ),
    );
  }

  @override
  final String rawLaunchLocation;

  final Stream<String> _launchLocations;

  @override
  Stream<String> get launchLocations => _launchLocations;

  /// 只接受来自 Widget 的安全参数；未知或缺失参数统一回首页。
  static String _normalize(Uri? uri) {
    if (uri == null || uri.queryParameters['source'] != 'widget') {
      return defaultAppShellLocation;
    }

    final String target = (uri.queryParameters['target'] ?? '').trim();
    if (target == 'home') {
      return defaultAppShellLocation;
    }
    if (target != 'task') {
      return defaultAppShellLocation;
    }

    final String? taskId = _normalizeTaskId(uri.queryParameters['taskId']);
    if (taskId == null) {
      return defaultAppShellLocation;
    }

    return buildTaskEditorLocation(taskId);
  }

  /// taskId 只接受非空值，避免把空参数误导入编辑落点。
  static String? _normalizeTaskId(String? taskId) {
    final String normalizedTaskId = (taskId ?? '').trim();
    if (normalizedTaskId.isEmpty) {
      return null;
    }
    return normalizedTaskId;
  }
}

/// 统一安全加载 Widget 启动桥；任何异常都只能降级到首页，不能阻断应用启动。
Future<WidgetLaunchBridge> loadSafeWidgetLaunchBridge({
  Future<HomeWidgetLaunchBridge> Function()? loader,
  Duration timeout = _defaultWidgetLaunchBridgeTimeout,
}) async {
  try {
    return await (loader?.call() ?? HomeWidgetLaunchBridge.load()).timeout(
      timeout,
    );
  } catch (_) {
    return const NoopWidgetLaunchBridge();
  }
}

/// 运行时 Widget 点击流只允许输出安全落点；平台错误也要降级为首页而不是抛出未处理异常。
StreamTransformer<Uri?, String> _safeLaunchLocationTransformer() {
  return StreamTransformer<Uri?, String>.fromHandlers(
    handleData: (Uri? uri, EventSink<String> sink) {
      sink.add(HomeWidgetLaunchBridge._normalize(uri));
    },
    handleError: (Object error, StackTrace stackTrace, EventSink<String> sink) {
      sink.add(defaultAppShellLocation);
    },
  );
}

/// 根路由只依赖这个 Provider 获取安全初始落点，
/// 避免直接把平台入口逻辑揉进 `GoRouter` 构造过程。
@Riverpod(keepAlive: true)
WidgetLaunchBridge widgetLaunchBridge(Ref ref) {
  return const NoopWidgetLaunchBridge();
}
