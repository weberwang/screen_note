import 'package:drift/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/app/startup/widget_launch_bridge.dart';
import 'package:screen_note/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_editor_page.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';

void main() {
  group('TaskFlowEditorPage', () {
    testWidgets('全局 quick add 会进入事项编辑页新建态', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);

      await _pumpApp(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(AppShellQuickAddSheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppShellQuickAddSheet), findsNothing);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('保存后会创建事项并返回首页刷新主链路', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);

      await _pumpApp(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AppShellQuickAddSheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '补齐编辑页保存链路');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final List<TaskEntity> tasks = await runtime.repository.loadTasksByStatus(
        TaskStatus.active,
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.text('补齐编辑页保存链路'), findsOneWidget);
      expect(tasks.map((TaskEntity task) => task.title), contains('补齐编辑页保存链路'));
    });

    testWidgets('标题为空时会显示 iOS 风格居中轻提示', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);

      await _pumpApp(tester, runtime: runtime);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AppShellQuickAddSheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      final AppLocalizations localizations = AppLocalizations.of(
        tester.element(find.byType(TaskFlowEditorPage)),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(CupertinoPopupSurface), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text(localizations.taskTitleRequired), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.byType(CupertinoPopupSurface), findsNothing);
    });

    testWidgets('已有事项进入 editor 时会预填原始内容', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        _buildTask(
          id: 'task-1',
          title: '原始标题',
          note: '原始备注',
          createdAt: DateTime(2026, 6, 14, 8),
          isPinned: true,
        ),
      );

      await _pumpApp(tester, runtime: runtime);
      await tester.tap(find.text('原始标题'));
      await tester.pumpAndSettle();

      final TextField titleField = tester.widget<TextField>(
        find.byType(TextField).first,
      );
      final TextField noteField = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );

      expect(titleField.controller?.text, '原始标题');
      expect(noteField.controller?.text, '原始备注');
      expect(find.byType(SwitchListTile), findsNWidgets(2));
    });

    testWidgets('保存既有事项不会新增第二条事项', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        _buildTask(
          id: 'task-1',
          title: '旧标题',
          note: '旧备注',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );

      await _pumpApp(tester, runtime: runtime);
      await tester.tap(find.text('旧标题'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, '新标题');
      await tester.enterText(find.byType(TextField).at(1), '新备注');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final List<TaskEntity> tasks = await runtime.repository.loadTasksByStatus(
        TaskStatus.active,
      );

      expect(tasks, hasLength(1));
      expect(tasks.single.id, 'task-1');
      expect(tasks.single.title, '新标题');
      expect(tasks.single.note, '新备注');
      expect(find.text('新标题'), findsOneWidget);
    });

    testWidgets('深链进入 editor 后保存会自动回到首页并刷新任务列表', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);
      await runtime.repository.createTask(
        _buildTask(
          id: 'task-1',
          title: '深链原始标题',
          note: '深链原始备注',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );

      await _pumpApp(
        tester,
        runtime: runtime,
        rawLaunchLocation: '/${RoutePaths.taskEditor}?taskId=task-1',
      );

      await tester.enterText(find.byType(TextField).first, '深链保存后回到首页');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final List<TaskEntity> tasks = await runtime.repository.loadTasksByStatus(
        TaskStatus.active,
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.byType(TaskFlowHomePage), findsOneWidget);
      expect(find.text('深链保存后回到首页'), findsOneWidget);
      expect(tasks, hasLength(1));
      expect(tasks.single.id, 'task-1');
      expect(tasks.single.title, '深链保存后回到首页');
    });

    testWidgets('refresh 失败不会误报保存失败或重复创建事项', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);

      await _pumpApp(
        tester,
        runtime: runtime,
        failRefresh: true,
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AppShellQuickAddSheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'refresh 失败也保存成功');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final List<TaskEntity> tasks = await runtime.repository.loadTasksByStatus(
        TaskStatus.active,
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.text('保存失败，请稍后重试'), findsNothing);
      expect(tasks, hasLength(1));
      expect(tasks.single.title, 'refresh 失败也保存成功');
    });
  });
}

/// 测试运行时统一复用内存数据库，避免页面测试落到真实本地存储。
final class _TestRuntime {
  _TestRuntime({
    required this.database,
    required this.repository,
  });

  final TaskFlowDatabase database;
  final TaskFlowRepositoryImpl repository;

  /// 创建只服务于 task-flow 页面测试的内存运行时。
  static _TestRuntime create() {
    final TaskFlowDatabase database = TaskFlowDatabase.test(
      NativeDatabase.memory(),
    );
    return _TestRuntime(
      database: database,
      repository: TaskFlowRepositoryImpl(database: database),
    );
  }

  Future<void> dispose() => database.close();
}

/// 统一拉起真实应用壳层，并允许按需注入启动落点，保证测试走正式路由装配。
Future<void> _pumpApp(
  WidgetTester tester, {
  required _TestRuntime runtime,
  bool failRefresh = false,
  String rawLaunchLocation = RoutePaths.home,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1170, 2532);
  tester.binding.platformDispatcher.localeTestValue = const Locale('zh');
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        widgetLaunchBridgeProvider.overrideWithValue(
          _FakeWidgetLaunchBridge(rawLaunchLocation: rawLaunchLocation),
        ),
        taskFlowDatabaseProvider.overrideWithValue(runtime.database),
        taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
        taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
        if (failRefresh)
          taskFlowHomeControllerProvider.overrideWith(
            _RefreshFailingHomeController.new,
          ),
      ],
      child: const ScreenNoteApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// 假启动桥只负责给应用提供稳定启动落点，避免平台入口噪声干扰页面断言。
final class _FakeWidgetLaunchBridge implements WidgetLaunchBridge {
  const _FakeWidgetLaunchBridge({required this.rawLaunchLocation});

  @override
  final String rawLaunchLocation;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();

  @override
  Future<Uri?> initiallyLaunchedUri() async => Uri.tryParse(rawLaunchLocation);

  @override
  Stream<Uri?> get widgetClicked => const Stream<Uri?>.empty();
}

/// refresh 失败替身只复现“保存后刷新降级失败”，避免误伤真实写库结果。
class _RefreshFailingHomeController extends TaskFlowHomeController {
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

/// 构造测试事项时保持与真实实体结构一致，避免页面测试绕开正式字段模型。
TaskEntity _buildTask({
  required String id,
  required String title,
  required DateTime createdAt,
  required String note,
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
