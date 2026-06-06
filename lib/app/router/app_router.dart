import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_launch_feedback_controller.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';
import 'package:screen_note/features/app_shell/infrastructure/app_shell_launch_query_parser.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/history_center/domain/entities/history_section.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/features/widget_bridge/presentation/pages/widget_bridge_page.dart';

part 'app_router.g.dart';

/// 路由重定向里回传壳层轻反馈的回调签名，方便在测试里复现启动直达场景。
typedef AppShellLaunchFeedbackRecorder = void Function(
  AppShellLaunchIntent intent,
);

/// 构建应用路由，供生产代码与启动直达测试共享同一套路由结构。
GoRouter buildAppRouter({
  required AppShellLaunchResolver launchResolver,
  required AppShellLaunchFeedbackRecorder recordLaunchFeedback,
  String initialLocation = RoutePaths.taskFlowHome,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.launch,
        name: 'app-shell-launch',
        redirect: (context, state) {
          final AppShellLaunchIntent launchIntent = launchResolver.resolve(
            state.uri,
          );
          recordLaunchFeedback(launchIntent);
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
                builder: (context, state) => HistoryCenterPage(
                  initialSection: HistorySection.fromQueryValue(
                    state.uri.queryParameters['section'],
                  ),
                ),
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

/// 应用路由提供器，初始化阶段只负责壳层导航与模块入口骨架。
@riverpod
GoRouter appRouter(Ref ref) {
  final AppShellLaunchResolver launchResolver = AppShellLaunchResolver(
    parser: const AppShellLaunchQueryParser(),
    logger: AppLogger.instance,
  );
  final AppShellLaunchFeedbackController feedbackController = ref.read(
    appShellLaunchFeedbackControllerProvider.notifier,
  );

  return buildAppRouter(
    launchResolver: launchResolver,
    recordLaunchFeedback: (AppShellLaunchIntent intent) {
      // redirect 发生在路由构建期；反馈写入必须延后到当前构建帧结束后，
      // 否则首次 deep link 直达会触发 “building 中修改 provider” 的运行时错误。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!ref.mounted) {
          return;
        }
        feedbackController.record(intent);
      });
    },
  );
}
