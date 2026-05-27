import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/features/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/domain/entities/task_event.dart';
import 'package:screen_note/features/tasks/domain/repositories/task_event_repository.dart';
import 'package:screen_note/features/tasks/domain/repositories/task_repository.dart';
import 'package:screen_note/features/tasks/presentation/overlays/quick_add_sheet.dart';
import 'package:screen_note/features/tasks/presentation/pages/home_page.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/features/widget_bridge/application/widget_refresh_result.dart';
import 'package:screen_note/features/widget_bridge/application/widget_snapshot_refresher.dart';

/// 验证首页关键行为。
void main() {
  testWidgets('首页创建失败不会丢输入', (WidgetTester tester) async {
    final CreateTaskUseCase createTaskUseCase = CreateTaskUseCase(
      taskRepository: _ThrowingTaskRepository(),
      taskEventRepository: _NoopTaskEventRepository(),
      widgetSnapshotRefresher: _NoopWidgetRefresher(),
      now: DateTime.now,
      idGenerator: () => 'id-1',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          createTaskUseCaseProvider.overrideWithValue(createTaskUseCase),
          activeTasksProvider.overrideWith((Ref ref) => Stream.value(<Task>[])),
        ],
        child: const _TestApp(child: HomePage()),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'take umbrella');
    await tester.tap(find.byType(FilledButton).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final Finder sheetAddButton = find.descendant(
      of: find.byType(QuickAddSheet),
      matching: find.widgetWithText(FilledButton, '添加'),
    );
    await tester.dragUntilVisible(
      sheetAddButton,
      find.byType(SingleChildScrollView).last,
      const Offset(0, -120),
    );
    await tester.tap(sheetAddButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('take umbrella'), findsWidgets);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildScreenNoteLightTheme(),
      darkTheme: buildScreenNoteDarkTheme(),
      home: child,
    );
  }
}

class _NoopTaskRepository implements TaskRepository {
  @override
  Future<List<Task>> findAll() async => <Task>[];

  @override
  Future<Task?> findById(String id) async => null;

  @override
  Future<void> save(Task task) async {}

  @override
  Future<void> saveAll(Iterable<Task> tasks) async {}

  @override
  Stream<List<Task>> watchAll() async* {
    yield <Task>[];
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield null;
  }
}

class _ThrowingTaskRepository extends _NoopTaskRepository {
  @override
  Future<void> save(Task task) async {
    throw Exception('save_failed');
  }
}

class _NoopTaskEventRepository implements TaskEventRepository {
  @override
  Future<List<TaskEvent>> findByTaskId(String taskId) async => <TaskEvent>[];

  @override
  Future<void> save(TaskEvent event) async {}

  @override
  Stream<List<TaskEvent>> watchByTaskId(String taskId) async* {
    yield <TaskEvent>[];
  }
}

class _NoopWidgetRefresher implements WidgetSnapshotRefresher {
  @override
  Future<WidgetRefreshResult> refresh() async {
    return WidgetRefreshResult.success;
  }
}
