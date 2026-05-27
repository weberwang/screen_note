import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/features/history/presentation/pages/completed_history_page.dart';
import 'package:screen_note/features/history/presentation/pages/deleted_history_page.dart';
import 'package:screen_note/features/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/features/quick_add/presentation/pages/quick_add_page.dart';
import 'package:screen_note/features/settings/presentation/pages/privacy_settings_page.dart';
import 'package:screen_note/features/settings/presentation/pages/settings_page.dart';
import 'package:screen_note/features/settings/presentation/pages/widget_settings_page.dart';
import 'package:screen_note/features/tasks/presentation/pages/home_page.dart';
import 'package:screen_note/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:screen_note/features/tasks/presentation/pages/task_editor_page.dart';

/// 创建应用路由实例，统一装配阶段二首页、编辑、历史和设置入口。
GoRouter createAppRouter({String initialLocation = RoutePaths.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.home,
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.taskNew,
        builder: (BuildContext context, GoRouterState state) =>
            const TaskEditorPage(),
      ),
      GoRoute(
        path: RoutePaths.quickAdd,
        builder: (BuildContext context, GoRouterState state) {
          final QuickAddDraft? initialDraft =
              state.extra is QuickAddDraft ? state.extra as QuickAddDraft : null;
          return QuickAddPage(initialDraft: initialDraft);
        },
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
      GoRoute(
        path: RoutePaths.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
      GoRoute(
        path: RoutePaths.settingsWidget,
        builder: (BuildContext context, GoRouterState state) =>
            const WidgetSettingsPage(),
      ),
      GoRoute(
        path: RoutePaths.settingsPrivacy,
        builder: (BuildContext context, GoRouterState state) =>
            const PrivacySettingsPage(),
      ),
    ],
  );
}
