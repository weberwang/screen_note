import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/data/quick_add_draft_store.dart';
import 'package:screen_note/src/quick_add/presentation/providers/quick_add_providers.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/domain/entities/task_event.dart';
import 'package:screen_note/src/tasks/domain/repositories/task_event_repository.dart';
import 'package:screen_note/src/tasks/domain/repositories/task_repository.dart';
import 'package:screen_note/src/tasks/presentation/overlays/quick_add_sheet.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/src/widget_bridge/application/widget_refresh_result.dart';
import 'package:screen_note/src/widget_bridge/application/widget_snapshot_refresher.dart';

/// 验证首页轻入口快速添加底部弹层行为。
void main() {
  testWidgets('快速添加底部弹层在创建失败时保留输入并展示失败提示', (
    WidgetTester tester,
  ) async {
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
          quickAddDraftStoreProvider.overrideWithValue(_MemoryQuickAddDraftStore()),
        ],
        child: const _TestApp(
          child: Scaffold(body: QuickAddSheet(initialText: 'take umbrella')),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.descendant(
      of: find.byType(QuickAddSheet),
      matching: find.widgetWithText(FilledButton, '添加'),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('take umbrella'), findsWidgets);
    expect(find.text('暂时还没保存成功，但输入内容还在。'), findsOneWidget);
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

class _MemoryQuickAddDraftStore implements QuickAddDraftStore {
  QuickAddDraft? _draft;

  @override
  Future<void> clear() async {
    _draft = null;
  }

  @override
  Future<QuickAddDraft?> read() async => _draft;

  @override
  Future<void> save(QuickAddDraft draft) async {
    _draft = draft;
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
