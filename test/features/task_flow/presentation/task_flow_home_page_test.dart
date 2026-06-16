import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/router/route_paths.dart';

import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/screen_note_screenutil_contract.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  group('TaskFlowHomePage', () {
    testWidgets('会展示主事项卡片与紧急队列', (WidgetTester tester) async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      addTearDown(database.close);

      await repository.createTask(
        _buildTask(
          id: 'priority',
          title: '完成首页真实快照接入',
          createdAt: DateTime(2026, 6, 14, 8),
          dueAt: DateTime(2026, 6, 14, 18),
          isPinned: true,
        ),
      );
      await repository.createTask(
        _buildTask(
          id: 'overdue',
          title: '补齐紧急队列展示',
          createdAt: DateTime(2026, 6, 12, 9),
          dueAt: DateTime(2026, 6, 13, 18),
        ),
      );

      await _pumpHomePage(
        tester,
        child: ProviderScope(
          overrides: [
            taskFlowDatabaseProvider.overrideWithValue(database),
            taskFlowMutationRepositoryProvider.overrideWithValue(repository),
            taskFlowRepositoryProvider.overrideWithValue(repository),
          ],
          child: const Scaffold(body: TaskFlowHomePage()),
        ),
      );

      expect(find.text('完成首页真实快照接入'), findsOneWidget);
      expect(find.text('补齐紧急队列展示'), findsOneWidget);
      expect(find.text('紧急队列'), findsOneWidget);
    });

    testWidgets('空态时会展示最小提示', (WidgetTester tester) async {
      await _pumpHomePage(
        tester,
        child: ProviderScope(
          overrides: [
            taskFlowHomeControllerProvider.overrideWith(
              _buildEmptyHomeController,
            ),
          ],
          child: const Scaffold(body: TaskFlowHomePage()),
        ),
      );

      expect(find.text('还没有待处理事项'), findsOneWidget);
    });

    testWidgets('错误时会展示最小失败提示', (WidgetTester tester) async {
      await _pumpHomePage(
        tester,
        child: ProviderScope(
          overrides: [
            taskFlowHomeControllerProvider.overrideWith(
              _buildErrorHomeController,
            ),
          ],
          child: const Scaffold(body: TaskFlowHomePage()),
        ),
      );

      await tester.pump();

      expect(find.text('首页快照加载失败'), findsOneWidget);
    });

    testWidgets('点击主事项卡片会进入事项编辑页', (WidgetTester tester) async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      addTearDown(database.close);

      await repository.createTask(
        _buildTask(
          id: 'priority',
          title: '点击主事项卡片进入编辑页',
          createdAt: DateTime(2026, 6, 14, 8),
          dueAt: DateTime(2026, 6, 14, 18),
          isPinned: true,
        ),
      );

      await _pumpHomeRouter(
        tester,
        runtime: _HomeRouterRuntime(
          database: database,
          repository: repository,
        ),
      );

      await tester.tap(find.text('点击主事项卡片进入编辑页'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('点击紧急队列行会进入事项编辑页', (WidgetTester tester) async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      addTearDown(database.close);

      await repository.createTask(
        _buildTask(
          id: 'priority',
          title: '首页主事项',
          createdAt: DateTime(2026, 6, 14, 8),
          dueAt: DateTime(2026, 6, 14, 18),
          isPinned: true,
        ),
      );
      await repository.createTask(
        _buildTask(
          id: 'overdue',
          title: '点击队列行进入编辑页',
          createdAt: DateTime(2026, 6, 12, 9),
          dueAt: DateTime(2026, 6, 13, 18),
        ),
      );

      await _pumpHomeRouter(
        tester,
        runtime: _HomeRouterRuntime(
          database: database,
          repository: repository,
        ),
      );

      await tester.tap(find.text('点击队列行进入编辑页'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
    });
  });

  testWidgets('首页会展示历史状态概览', (WidgetTester tester) async {
    await _pumpHomePage(
      tester,
      child: ProviderScope(
        overrides: [
          taskFlowHomeControllerProvider.overrideWith(
            () => _FakeTaskFlowHomeController(
              snapshot: const TaskFeedSnapshot(
                pinnedTasks: <TaskEntity>[],
                overdueTasks: <TaskEntity>[],
                todayTasks: <TaskEntity>[],
                otherTasks: <TaskEntity>[],
                activeCount: 0,
                completedCount: 3,
                deletedCount: 1,
              ),
            ),
          ),
        ],
        child: const Scaffold(body: TaskFlowHomePage()),
      ),
    );

    expect(find.text('历史状态'), findsOneWidget);
    expect(find.text('已完成 3'), findsOneWidget);
    expect(find.text('已删除 1'), findsOneWidget);
  });

  group('TaskFlowHomeController', () {
    test('createQuickTask 后会刷新首页快照', () async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowMutationRepositoryProvider.overrideWithValue(repository),
          taskFlowRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);

      final TaskFeedSnapshot initialSnapshot = await container.read(
        taskFlowHomeControllerProvider.future,
      );
      expect(initialSnapshot.activeCount, 0);

      await container.read(taskFlowHomeControllerProvider.notifier).createQuickTask(
        const CreateTaskInput(title: '新的快捷事项', note: ''),
        now: DateTime(2026, 6, 14, 9),
      );

      final TaskFeedSnapshot refreshedSnapshot = container.read(
        taskFlowHomeControllerProvider,
      ).requireValue;
      expect(refreshedSnapshot.activeCount, 1);
      expect(
        refreshedSnapshot.otherTasks.map((TaskEntity task) => task.title),
        contains('新的快捷事项'),
      );
    });

    test('refresh 有旧快照时不会立刻清空首页数据', () async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      final Completer<void> refreshGate = Completer<void>();
      final TaskRepository delayedRepository = _DelayedTaskRepository(
        delegate: repository,
        gate: refreshGate.future,
      );
      var snapshotReadCount = 0;
      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowMutationRepositoryProvider.overrideWithValue(repository),
          taskFlowRepositoryProvider.overrideWithValue(repository),
          loadTaskFeedUseCaseProvider.overrideWith(
            (ref) => LoadTaskFeedUseCase(repository: delayedRepository),
          ),
          taskFlowHomeSnapshotProvider.overrideWith((ref) async {
            snapshotReadCount += 1;
            if (snapshotReadCount == 1) {
              return LoadTaskFeedUseCase(repository: repository).execute(
                now: DateTime(2026, 6, 14, 8),
              );
            }
            await Future<void>.delayed(const Duration(seconds: 1));
            return LoadTaskFeedUseCase(repository: repository).execute(
              now: DateTime(2026, 6, 14, 8),
            );
          }),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);

      await repository.createTask(
        _buildTask(
          id: 'existing-task',
          title: '刷新前已有事项',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );
      final TaskFeedSnapshot initialSnapshot = await container.read(
        taskFlowHomeControllerProvider.future,
      );
      expect(initialSnapshot.activeCount, 1);

      final Future<void> refreshFuture = container
          .read(taskFlowHomeControllerProvider.notifier)
          .refresh();

      final AsyncValue<TaskFeedSnapshot> refreshingState = container.read(
        taskFlowHomeControllerProvider,
      );
      expect(refreshingState.hasValue, isTrue);
      expect(refreshingState.requireValue.activeCount, 1);

      refreshGate.complete();
      await refreshFuture;
    });

    test('refresh 不应依赖基础快照 provider 的二次失效重读', () async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      var snapshotReadCount = 0;
      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowMutationRepositoryProvider.overrideWithValue(repository),
          taskFlowRepositoryProvider.overrideWithValue(repository),
          taskFlowHomeSnapshotProvider.overrideWith((ref) async {
            snapshotReadCount += 1;
            if (snapshotReadCount > 1) {
              throw StateError('unexpected second snapshot read');
            }
            return ref.read(loadTaskFeedUseCaseProvider).execute();
          }),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);

      await repository.createTask(
        _buildTask(
          id: 'task-1',
          title: '避免重复读取基础快照 provider',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );

      final TaskFeedSnapshot initialSnapshot = await container.read(
        taskFlowHomeControllerProvider.future,
      );
      expect(initialSnapshot.activeCount, 1);

      await container.read(taskFlowHomeControllerProvider.notifier).refresh();

      final TaskFeedSnapshot refreshedSnapshot = container.read(
        taskFlowHomeControllerProvider,
      ).requireValue;
      expect(refreshedSnapshot.activeCount, 1);
    });

    test('refresh 不应让基础快照 provider 的外部监听者被迫重算', () async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      var snapshotReadCount = 0;
      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowMutationRepositoryProvider.overrideWithValue(repository),
          taskFlowRepositoryProvider.overrideWithValue(repository),
          taskFlowHomeSnapshotProvider.overrideWith((ref) async {
            snapshotReadCount += 1;
            return ref.read(loadTaskFeedUseCaseProvider).execute();
          }),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);

      final subscription = container.listen<AsyncValue<TaskFeedSnapshot>>(
        taskFlowHomeSnapshotProvider,
        (_, __) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await repository.createTask(
        _buildTask(
          id: 'task-2',
          title: '外部监听者不应被迫重算',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );

      await container.read(taskFlowHomeControllerProvider.future);
      expect(snapshotReadCount, 1);

      await container.read(taskFlowHomeControllerProvider.notifier).refresh();

      expect(snapshotReadCount, 1);
    });
  });
}

/// 用真实 go_router 承接首页子路由，验证卡片和列表行都会进入 task-editor。
Future<void> _pumpHomeRouter(
  WidgetTester tester, {
  required _HomeRouterRuntime runtime,
}) async {
  final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.home,
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: TaskFlowHomePage()),
        routes: <RouteBase>[
          GoRoute(
            path: RoutePaths.taskEditor,
            builder: (BuildContext context, GoRouterState state) =>
                const TaskFlowEditorPage(),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1170, 2532);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

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
        builder: (BuildContext context, Widget? _) {
          return MaterialApp.router(
            locale: const Locale('zh'),
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

/// 首页路由测试运行时显式持有内存真源，保证路由断言不依赖真实本地数据库。
final class _HomeRouterRuntime {
  const _HomeRouterRuntime({
    required this.database,
    required this.repository,
  });

  final TaskFlowDatabase database;
  final TaskFlowRepositoryImpl repository;
}

/// 统一泵起首页测试外壳，确保主题、本地化与 ScreenUtil 契约和正式环境一致。
Future<void> _pumpHomePage(
  WidgetTester tester, {
  required Widget child,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1170, 2532);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenNoteScreenUtilContract(
      designSize: screenNoteDesignSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? _) {
        return MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ScreenNoteTheme.light(),
          darkTheme: ScreenNoteTheme.dark(),
          home: child,
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}

/// 构造首页测试事项，避免页面测试绕开真实实体结构。
TaskEntity _buildTask({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
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

/// 刷新延迟仓储只服务控制器测试，确保能稳定观察刷新进行中的中间态。
final class _DelayedTaskRepository implements TaskRepository {
  const _DelayedTaskRepository({
    required TaskRepository delegate,
    required Future<void> gate,
  }) : _delegate = delegate,
       _gate = gate;

  final TaskRepository _delegate;
  final Future<void> _gate;

  @override
  Future<TaskEntity?> findTaskById(String id) {
    return _delegate.findTaskById(id);
  }

  @override
  Future<void> createTask(TaskEntity task) {
    return _delegate.createTask(task);
  }

  @override
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status) async {
    await _gate;
    return _delegate.loadTasksByStatus(status);
  }

  @override
  Future<int> countTasksByStatus(TaskStatus status) async {
    await _gate;
    return _delegate.countTasksByStatus(status);
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return _delegate.updateTask(task);
  }

  @override
  Future<void> appendEvent(TaskEventEntity event) {
    return _delegate.appendEvent(event);
  }
}

/// 测试替身控制器只服务页面状态覆盖，避免页面测试被真实仓储装配分散注意力。
class _FakeTaskFlowHomeController extends TaskFlowHomeController {
  _FakeTaskFlowHomeController({
    this.snapshot,
    this.error,
  });

  final TaskFeedSnapshot? snapshot;
  final Object? error;

  @override
  Future<TaskFeedSnapshot> build() async {
    if (error != null) {
      throw error!;
    }
    return snapshot!;
  }
}

/// 构造空态控制器，保证页面测试只关注空态展示本身。
_FakeTaskFlowHomeController _buildEmptyHomeController() {
  return _FakeTaskFlowHomeController(
    snapshot: const TaskFeedSnapshot(
      pinnedTasks: <TaskEntity>[],
      overdueTasks: <TaskEntity>[],
      todayTasks: <TaskEntity>[],
      otherTasks: <TaskEntity>[],
      activeCount: 0,
      completedCount: 0,
      deletedCount: 0,
    ),
  );
}

/// 构造错误态控制器，保证页面测试只关注错误提示展示。
_FakeTaskFlowHomeController _buildErrorHomeController() {
  return _FakeTaskFlowHomeController(error: StateError('load failed'));
}
