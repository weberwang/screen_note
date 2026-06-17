import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/history_center/application/providers/history_center_runtime_providers.dart';
import 'package:screen_note/features/history_center/domain/entities/history_center_snapshot.dart';
import 'package:screen_note/features/history_center/presentation/pages/history_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

void main() {
  testWidgets('历史页会展示最近完成和最近删除分区', (WidgetTester tester) async {
    final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
    addTearDown(runtime.dispose);
    await runtime.repository.createTask(
      _task(
        id: 'completed-task',
        title: '已经完成的事项',
        status: TaskStatus.completed,
        anchorAt: DateTime(2026, 6, 14, 10),
      ),
    );
    await runtime.repository.createTask(
      _task(
        id: 'deleted-task',
        title: '需要恢复的事项',
        status: TaskStatus.deleted,
        anchorAt: DateTime(2026, 6, 14, 11),
      ),
    );

    await _pumpHistoryPage(tester, runtime: runtime);

    expect(find.text('History'), findsOneWidget);
    expect(find.text('Recently completed'), findsOneWidget);
    expect(find.text('已经完成的事项'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Recently deleted'), 200);
    expect(find.text('Recently deleted'), findsOneWidget);
    expect(find.text('需要恢复的事项'), findsOneWidget);
    expect(find.text('Restore'), findsOneWidget);
  });

  testWidgets('历史页空态会展示信任恢复说明', (WidgetTester tester) async {
    final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
    addTearDown(runtime.dispose);

    await _pumpHistoryPage(tester, runtime: runtime);

    expect(find.text('No history yet'), findsOneWidget);
    expect(
      find.textContaining('appear here when you need them'),
      findsOneWidget,
    );
    expect(find.byType(ScreenNotePanel), findsNothing);
    expect(find.byKey(const Key('history-empty-add-button')), findsOneWidget);
  });

  testWidgets('历史页空态点击加号会进入事项编辑页新建态', (WidgetTester tester) async {
    final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
    addTearDown(runtime.dispose);

    await _pumpHistoryPage(tester, runtime: runtime);

    await tester.tap(find.byKey(const Key('history-empty-add-button')));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('恢复后会移除已删除事项并写入共享反馈', (WidgetTester tester) async {
    final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
    addTearDown(runtime.dispose);
    await runtime.repository.createTask(
      _task(
        id: 'deleted-task',
        title: '待恢复事项',
        status: TaskStatus.deleted,
        anchorAt: DateTime(2026, 6, 14, 11),
      ),
    );

    final ProviderContainer container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(runtime.database),
        taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
        taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenNoteScreenUtilContract(
          designSize: screenNoteDesignSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ScreenNoteTheme.light(),
              darkTheme: ScreenNoteTheme.dark(),
              home: const Scaffold(body: HistoryCenterPage()),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Restore'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('待恢复事项'), findsNothing);
    expect(
      container.read(appShellUiStateControllerProvider).feedback?.text,
      'Task restored to active.',
    );

    final TaskEntity? restoredTask = await runtime.repository.findTaskById(
      'deleted-task',
    );
    expect(restoredTask?.status, TaskStatus.active);
    expect(restoredTask?.deletedAt, isNull);
  });

  group('HistoryCenterController', () {
    test('refresh 不应依赖基础快照 provider 的二次失效重读', () async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      var snapshotReadCount = 0;

      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(runtime.database),
          taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
          taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
          historyCenterSnapshotProvider.overrideWith((ref) async {
            snapshotReadCount += 1;
            if (snapshotReadCount > 1) {
              throw StateError('unexpected second history snapshot read');
            }
            return ref.read(loadHistoryCenterSnapshotUseCaseProvider).execute();
          }),
        ],
      );
      addTearDown(container.dispose);

      await runtime.repository.createTask(
        _task(
          id: 'completed-task',
          title: '避免重复读取历史快照',
          status: TaskStatus.completed,
          anchorAt: DateTime(2026, 6, 14, 10),
        ),
      );

      final HistoryCenterSnapshot initialSnapshot = await container.read(
        historyCenterControllerProvider.future,
      );
      expect(initialSnapshot.completedTasks, hasLength(1));

      await container.read(historyCenterControllerProvider.notifier).refresh();

      final HistoryCenterSnapshot refreshedSnapshot = container.read(
        historyCenterControllerProvider,
      ).requireValue;
      expect(refreshedSnapshot.completedTasks, hasLength(1));
    });

    test('refresh 不应让基础快照 provider 的外部监听者被迫重算', () async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      var snapshotReadCount = 0;

      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(runtime.database),
          taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
          taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
          historyCenterSnapshotProvider.overrideWith((ref) async {
            snapshotReadCount += 1;
            return ref.read(loadHistoryCenterSnapshotUseCaseProvider).execute();
          }),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<HistoryCenterSnapshot>>(
        historyCenterSnapshotProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await runtime.repository.createTask(
        _task(
          id: 'completed-task-2',
          title: '外部监听者不应被迫重算',
          status: TaskStatus.completed,
          anchorAt: DateTime(2026, 6, 14, 10),
        ),
      );

      await container.read(historyCenterControllerProvider.future);
      expect(snapshotReadCount, 1);

      await container.read(historyCenterControllerProvider.notifier).refresh();

      expect(snapshotReadCount, 1);
    });

    test('restoreTask 成功后首页补偿刷新失败也不应让历史恢复链路失败', () async {
      final _TaskFlowTestRuntime runtime = _TaskFlowTestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        _task(
          id: 'deleted-task',
          title: '首页刷新失败时仍应恢复成功',
          status: TaskStatus.deleted,
          anchorAt: DateTime(2026, 6, 14, 11),
        ),
      );

      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(runtime.database),
          taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
          taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
          taskFlowHomeControllerProvider.overrideWith(
            _RefreshFailingTaskFlowHomeController.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(historyCenterControllerProvider.future);

      await container.read(historyCenterControllerProvider.notifier).restoreTask(
        taskId: 'deleted-task',
        occurredAt: DateTime(2026, 6, 14, 12),
        successMessage: 'Task restored to active.',
      );

      final AsyncValue<HistoryCenterSnapshot> restoredState = container.read(
        historyCenterControllerProvider,
      );
      expect(restoredState.hasError, isFalse);
      expect(restoredState.requireValue.isEmpty, isTrue);
      expect(
        container.read(appShellUiStateControllerProvider).feedback?.text,
        'Task restored to active.',
      );

      final TaskEntity? restoredTask = await runtime.repository.findTaskById(
        'deleted-task',
      );
      expect(restoredTask?.status, TaskStatus.active);
      expect(restoredTask?.deletedAt, isNull);
    });
  });
}

Future<void> _pumpHistoryPage(
  WidgetTester tester, {
  required _TaskFlowTestRuntime runtime,
}) async {
  final GoRouter router = GoRouter(
    initialLocation: RoutePaths.history,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.history,
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: HistoryCenterPage()),
      ),
      GoRoute(
        path: RoutePaths.taskEditor,
        builder: (BuildContext context, GoRouterState state) =>
            const TaskFlowEditorPage(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(runtime.database),
        taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
        taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
      ],
      child: ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            locale: const Locale('en'),
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

/// 历史页测试统一复用内存 task-flow 真源，避免页面装配碰到真实本地库。
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
}

/// 首页补偿刷新失败替身只用于验证恢复链路的降级语义，不干扰真实恢复写库结果。
class _RefreshFailingTaskFlowHomeController extends TaskFlowHomeController {
  @override
  Future<TaskFeedSnapshot> build() async {
    return const TaskFeedSnapshot(
      pinnedTasks: <TaskEntity>[],
      overdueTasks: <TaskEntity>[],
      todayTasks: <TaskEntity>[],
      otherTasks: <TaskEntity>[],
      activeCount: 0,
      completedCount: 0,
      deletedCount: 0,
    );
  }

  @override
  Future<void> refresh() async {
    throw StateError('refresh failed');
  }
}

/// 历史页测试事项工厂统一维护三态时间锚点，避免用例散落不同时间字段组合。
TaskEntity _task({
  required String id,
  required String title,
  required TaskStatus status,
  required DateTime anchorAt,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: null,
    reminderAt: null,
    isPinned: false,
    isPrivate: false,
    status: status,
    reminderMode: TaskReminderMode.normal,
    createdAt: anchorAt.subtract(const Duration(hours: 1)),
    updatedAt: anchorAt,
    completedAt: status == TaskStatus.completed ? anchorAt : null,
    deletedAt: status == TaskStatus.deleted ? anchorAt : null,
  );
}
