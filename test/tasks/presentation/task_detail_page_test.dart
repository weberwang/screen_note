import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/domain/repositories/task_repository.dart';
import 'package:screen_note/src/tasks/presentation/pages/task_detail_page.dart';
import 'package:screen_note/src/tasks/presentation/providers/task_feature_providers.dart';

/// 验证事项详情页按阶段一状态稿切换编辑能力。
void main() {
  final DateTime now = DateTime(2026, 5, 25, 10);

  Task buildTask({required TaskStatus status}) {
    return Task(
      id: 'task-1',
      title: '今晚八点前把药带回家',
      note: '回家前记得先去取药，再顺手买第二天要用的早餐。',
      status: status,
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now,
      completedAt: status == TaskStatus.completed ? now : null,
      deletedAt: status == TaskStatus.deleted ? now : null,
    );
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    required Task task,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(
            _SingleTaskRepository(task: task),
          ),
        ],
        child: const _TestApp(child: TaskDetailPage(taskId: 'task-1')),
      ),
    );
    await tester.pump();
  }

  testWidgets('已完成事项详情页不再展示编辑表单', (WidgetTester tester) async {
    await pumpPage(tester, task: buildTask(status: TaskStatus.completed));

    expect(find.byType(TextField), findsNothing);
    expect(find.text('保存修改'), findsNothing);
    expect(find.text('恢复事项'), findsOneWidget);
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

class _SingleTaskRepository implements TaskRepository {
  const _SingleTaskRepository({required this.task});

  final Task task;

  @override
  Future<List<Task>> findAll() async => <Task>[task];

  @override
  Future<Task?> findById(String id) async => task.id == id ? task : null;

  @override
  Future<void> save(Task task) async {}

  @override
  Future<void> saveAll(Iterable<Task> tasks) async {}

  @override
  Stream<List<Task>> watchAll() async* {
    yield <Task>[task];
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield task.id == id ? task : null;
  }
}
