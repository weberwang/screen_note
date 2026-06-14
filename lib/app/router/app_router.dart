import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';

part 'app_router.g.dart';

/// 根路由提供者只负责全局公共路由宿主，
/// 不直接承载任何 feature 业务规则或数据库判断。
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final launchBridge = ref.watch(widgetLaunchBridgeProvider);
  const launchResolver = AppShellLaunchResolver();
  final AppShellLaunchIntent initialIntent = launchResolver.resolve(
    launchBridge.rawLaunchLocation,
  );
  final String initialLocation = locationForAppShellIntent(initialIntent);

  return GoRouter(
    // 根路由只消费壳层安全入口，避免把平台原始路径直接灌进共享路由树。
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellPage(
            navigationShell: navigationShell,
            currentLocation: state.uri.path,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const TaskFlowHomePage(),
                routes: [
                  GoRoute(
                    path: RoutePaths.taskEditor,
                    builder: (context, state) => TaskFlowEditorPage(
                      taskId: state.uri.queryParameters['taskId'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.history,
                builder: (context, state) => const HistoryCenterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsCenterPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
