import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

/// 首页是所有未知或不安全入口的统一回退落点。
const String defaultAppShellLocation = RoutePaths.home;

/// 事项编辑页路由统一由这里组装，避免不同入口手写 query 拼接规则。
String buildTaskEditorLocation(String taskId) {
  return Uri(
    path: RoutePaths.taskEditor,
    queryParameters: <String, String>{
      'taskId': taskId,
    },
  ).toString();
}

/// 壳层启动意图到安全路由的映射统一收口到这里，避免路由与页面各自维护一套拼接规则。
String locationForAppShellIntent(AppShellLaunchIntent intent) {
  return intent.when(
    home: () => RoutePaths.home,
    history: () => RoutePaths.history,
    settings: () => RoutePaths.settings,
    taskEditor: buildTaskEditorLocation,
    fallbackHome: () => defaultAppShellLocation,
  );
}

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

    final AppShellLaunchIntent? taskEditorIntent = _resolveTaskEditor(rawLocation);
    if (taskEditorIntent != null) {
      return taskEditorIntent;
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

  /// 事项编辑落点只接受精确编辑页路径和非空白 taskId，避免未知子路径混入安全入口。
  AppShellLaunchIntent? _resolveTaskEditor(String rawLocation) {
    final Uri uri = Uri.parse(rawLocation);
    if (uri.path != RoutePaths.taskEditor) {
      return null;
    }

    final String normalizedTaskId = (uri.queryParameters['taskId'] ?? '').trim();
    if (normalizedTaskId.isEmpty) {
      return const AppShellLaunchIntent.fallbackHome();
    }

    return AppShellLaunchIntent.taskEditor(taskId: normalizedTaskId);
  }

  /// 判断原始路径是否命中允许的壳层一级入口，避免把相似未知路径误判为合法入口。
  bool _matchesShellEntry(String rawLocation, String shellEntry) {
    return rawLocation == shellEntry ||
        rawLocation.startsWith('$shellEntry/') ||
        rawLocation.startsWith('$shellEntry?');
  }
}
