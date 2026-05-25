import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/history/presentation/pages/completed_history_page.dart';
import 'package:screen_note/src/history/presentation/pages/deleted_history_page.dart';
import 'package:screen_note/src/tasks/presentation/pages/home_page.dart';
import 'package:screen_note/src/tasks/presentation/pages/task_detail_page.dart';

/// 创建应用路由实例，阶段一仅注册工程入口要求的最小页面骨架。
GoRouter createAppRouter({String initialLocation = RoutePaths.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.home,
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.taskDetail,
        builder: (BuildContext context, GoRouterState state) {
          final String taskId = state.pathParameters['id'] ?? '';
          return TaskDetailPage(taskId: taskId);
        },
      ),
      GoRoute(
        path: RoutePaths.historyCompleted,
        builder: (BuildContext context, GoRouterState state) =>
            const CompletedHistoryPage(),
      ),
      GoRoute(
        path: RoutePaths.historyDeleted,
        builder: (BuildContext context, GoRouterState state) =>
            const DeletedHistoryPage(),
      ),
    ],
  );
}
