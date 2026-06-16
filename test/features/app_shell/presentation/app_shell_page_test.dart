import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

const _historyRootTitle = 'History root';
const _historyDetailTitle = 'History detail';

void main() {
  group('AppShellPage', () {
    testWidgets('reselecting the current tab resets that branch to root', (
      tester,
    ) async {
      await _pumpNestedHistoryShell(tester);
      final AppLocalizations localizations = _localizations(tester);

      expect(find.text(_historyDetailTitle), findsOneWidget);
      expect(find.text(_historyRootTitle), findsNothing);

      await tester.tap(find.text(localizations.historyTabLabel));
      await tester.pumpAndSettle();

      expect(find.text(_historyRootTitle), findsOneWidget);
      expect(find.text(_historyDetailTitle), findsNothing);
    });

    testWidgets('switches shell tabs through the shared navigation bar', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await _pumpAppShell(tester, runtime: runtime);
      final AppLocalizations localizations = _localizations(tester);

      expect(find.text(localizations.settingsSubtitle), findsNothing);

      await tester.tap(find.text(localizations.historyTabLabel));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryCenterPage), findsOneWidget);

      await tester.tap(find.text(localizations.settingsTabLabel));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsCenterPage), findsOneWidget);
    });

    testWidgets('does not stack quick add sheets on repeated fab trigger', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await _pumpAppShell(tester, runtime: runtime);

      expect(find.byType(AppShellQuickAddSheet), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      fab.onPressed!.call();
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);
    });

    testWidgets('quick add 主按钮会把用户带到事项编辑页', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await _pumpAppShell(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('quick add 通过蒙层关闭时只会收起 sheet', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await _pumpAppShell(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('编辑态不会继续展示全局 quick add', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await _pumpAppShell(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('运行中点击 widget 事项会推入编辑页', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        runtime.buildTask(
          id: 'task-42',
          title: '来自小组件',
          note: '待回流',
          createdAt: DateTime(2026, 6, 14, 9),
        ),
      );
      final controller = StreamController<String>.broadcast();
      addTearDown(controller.close);
      await _pumpAppShell(
        tester,
        runtime: runtime,
        launchBridge: _FakeWidgetLaunchBridge(
          rawLaunchLocation: RoutePaths.home,
          launchLocations: controller.stream,
        ),
      );

      controller.add('${RoutePaths.home}${RoutePaths.taskEditor}?taskId=task-42');
      await tester.pumpAndSettle();

      final TextField titleField = tester.widget<TextField>(
        find.byType(TextField).first,
      );

      expect(titleField.controller?.text, '来自小组件');
    });

    testWidgets('quick add 打开时收到 widget click 会先收口再进入编辑页', (
      tester,
    ) async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        runtime.buildTask(
          id: 'task-42',
          title: '来自小组件',
          note: '待回流',
          createdAt: DateTime(2026, 6, 14, 9),
        ),
      );
      final controller = StreamController<String>.broadcast();
      addTearDown(controller.close);
      final container = _createAppShellTestContainer(
        runtime: runtime,
        launchBridge: _FakeWidgetLaunchBridge(
          rawLaunchLocation: RoutePaths.home,
          launchLocations: controller.stream,
        ),
      );
      addTearDown(container.dispose);
      await _pumpAppShell(
        tester,
        runtime: runtime,
        container: container,
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      controller.add('${RoutePaths.home}${RoutePaths.taskEditor}?taskId=task-42');
      await tester.pumpAndSettle();

      final TextField titleField = tester.widget<TextField>(
        find.byType(TextField).first,
      );
      expect(titleField.controller?.text, '来自小组件');
      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(
        container.read(appShellUiStateControllerProvider).quickAddSheetOpen,
        isFalse,
      );
    });
  });
}

Future<void> _pumpAppShell(
  WidgetTester tester, {
  required _TaskFlowTestRuntime runtime,
  ProviderContainer? container,
  WidgetLaunchBridge? launchBridge,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final ProviderContainer resolvedContainer =
      container ??
      _createAppShellTestContainer(
        runtime: runtime,
        launchBridge: launchBridge,
      );
  if (container == null) {
    addTearDown(resolvedContainer.dispose);
  }

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: resolvedContainer,
      child: const ScreenNoteApp(),
    ),
  );
  await tester.pumpAndSettle();
}

ProviderContainer _createAppShellTestContainer({
  required _TaskFlowTestRuntime runtime,
  WidgetLaunchBridge? launchBridge,
}) {
  return ProviderContainer(
    overrides: [
      widgetLaunchBridgeProvider.overrideWithValue(
        launchBridge ??
            const _FakeWidgetLaunchBridge(rawLaunchLocation: RoutePaths.home),
      ),
      taskFlowDatabaseProvider.overrideWithValue(runtime.database),
      taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
      taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
      settingsPreferencesRepositoryProvider.overrideWithValue(
        _InMemorySettingsPreferencesRepository(
          initial: const SettingsCenterPreferences(
            privacyModeEnabled: true,
            widgetDisplayMode: WidgetDisplayMode.previewOnly,
          ),
        ),
      ),
      notificationPermissionRepositoryProvider.overrideWithValue(
        _FakeNotificationPermissionRepository(
          initialStatus: NotificationPermissionStatus.disabled,
        ),
      ),
    ],
  );
}

/// 壳层测试统一复用内存 task-flow 真源，避免首页真实 Provider 读取本地数据库导致超时。
final class _TaskFlowTestRuntime {
  _TaskFlowTestRuntime({
    required this.database,
    required this.repository,
  });

  final TaskFlowDatabase database;
  final TaskFlowRepositoryImpl repository;

  static _TaskFlowTestRuntime create() {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    return _TaskFlowTestRuntime(
      database: database,
      repository: TaskFlowRepositoryImpl(database: database),
    );
  }

  Future<void> dispose() => database.close();

  /// 构造测试事项时统一复用真实实体结构，避免页面回流测试绕开正式模型。
  TaskEntity buildTask({
    required String id,
    required String title,
    required String note,
    required DateTime createdAt,
    bool isPinned = false,
  }) {
    return TaskEntity(
      id: id,
      title: title,
      note: note,
      dueAt: null,
      reminderAt: null,
      isPinned: isPinned,
      isPrivate: false,
      status: TaskStatus.active,
      reminderMode: TaskReminderMode.normal,
      createdAt: createdAt,
      updatedAt: createdAt,
      completedAt: null,
      deletedAt: null,
    );
  }
}

/// 设置偏好假仓储只服务壳层测试，避免切到 Settings 分支时触发真实 shared_preferences。
final class _InMemorySettingsPreferencesRepository
    implements SettingsPreferencesRepository {
  _InMemorySettingsPreferencesRepository({
    required SettingsCenterPreferences initial,
  }) : _current = initial;

  SettingsCenterPreferences _current;

  @override
  Future<SettingsCenterPreferences> loadPreferences() async => _current;

  @override
  Future<void> savePreferences(SettingsCenterPreferences preferences) async {
    _current = preferences;
  }
}

/// 设置通知权限假仓储只服务壳层测试，避免分支切换命中真实平台插件。
final class _FakeNotificationPermissionRepository
    implements NotificationPermissionRepository {
  _FakeNotificationPermissionRepository({
    required NotificationPermissionStatus initialStatus,
  }) : _current = initialStatus;

  final NotificationPermissionStatus _current;

  @override
  Future<NotificationPermissionStatus> readStatus() async => _current;

  @override
  Future<NotificationPermissionStatus> requestPermission() async => _current;
}

Future<void> _pumpNestedHistoryShell(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/history/detail',
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
                builder: (context, state) => const _TestShellLeaf('Home root'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.history,
                builder: (context, state) =>
                    const _TestShellLeaf(_historyRootTitle),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) =>
                        const _TestShellLeaf(_historyDetailTitle),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) =>
                    const _TestShellLeaf('Settings root'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      child: ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ScreenNoteTheme.light(),
            darkTheme: ScreenNoteTheme.dark(),
            routerConfig: router,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppLocalizations _localizations(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(NavigationBar)));
}

final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({
    required this.rawLaunchLocation,
    this.launchLocations = const Stream<String>.empty(),
  });

  @override
  final String rawLaunchLocation;

  @override
  final Stream<String> launchLocations;

  @override
  Future<Uri?> initiallyLaunchedUri() async => Uri.tryParse(rawLaunchLocation);

  @override
  Stream<Uri?> get widgetClicked => launchLocations.map(Uri.tryParse);
}

final class _TestShellLeaf extends StatelessWidget {
  const _TestShellLeaf(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
