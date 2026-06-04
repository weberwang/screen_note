import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
import 'package:screen_note/features/app_shell/infrastructure/app_shell_launch_query_parser.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/features/widget_bridge/presentation/pages/widget_bridge_page.dart';

part 'app_router.g.dart';

/// 应用路由提供器，初始化阶段只负责壳层导航与模块入口骨架。
@riverpod
GoRouter appRouter(Ref ref) {
  final AppShellLaunchResolver launchResolver = AppShellLaunchResolver(
    parser: const AppShellLaunchQueryParser(),
    logger: AppLogger.instance,
  );

  return GoRouter(
    initialLocation: RoutePaths.taskFlowHome,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.launch,
        name: 'app-shell-launch',
        redirect: (context, state) {
          final AppShellLaunchIntent launchIntent = launchResolver.resolve(
            state.uri,
          );
          return launchIntent.target.location;
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, StatefulNavigationShell navigationShell) {
          return AppShellPage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.taskFlowHome,
                name: 'task-flow-home',
                builder: (context, state) => const TaskFlowHomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.historyCenter,
                name: 'history-center',
                builder: (context, state) => const HistoryCenterPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.widgetBridge,
                name: 'widget-bridge',
                builder: (context, state) => const WidgetBridgePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.settingsCenter,
                name: 'settings-center',
                builder: (context, state) => const SettingsCenterPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.taskEditor,
        name: 'task-flow-editor',
        builder: (context, state) => const TaskFlowEditorPage(),
      ),
    ],
  );
}
