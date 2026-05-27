import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/tasks/application/services/task_sorting_service.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';

/// 验证事项排序规则。
void main() {
  final TaskSortingService service = TaskSortingService();
  final DateTime now = DateTime(2026, 5, 25, 10);

  Task buildTask({
    required String id,
    required DateTime createdAt,
    DateTime? dueAt,
    bool isPinned = false,
  }) {
    return Task(
      id: id,
      title: id,
      status: TaskStatus.active,
      dueAt: dueAt,
      isPinned: isPinned,
      isPrivate: false,
      reminderMode: TaskReminderMode.normal,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
  }

  test('置顶高于过期、今天和普通 active', () {
    final List<Task> tasks = service.sortActiveTasks(<Task>[
      buildTask(
        id: 'normal',
        createdAt: DateTime(2026, 5, 24, 10),
      ),
      buildTask(
        id: 'today',
        createdAt: DateTime(2026, 5, 24, 11),
        dueAt: DateTime(2026, 5, 25, 18),
      ),
      buildTask(
        id: 'overdue',
        createdAt: DateTime(2026, 5, 24, 12),
        dueAt: DateTime(2026, 5, 25, 8),
      ),
      buildTask(
        id: 'pinned',
        createdAt: DateTime(2026, 5, 24, 13),
        isPinned: true,
      ),
    ], now: now);

    expect(tasks.map((Task task) => task.id).toList(), <String>[
      'pinned',
      'overdue',
      'today',
      'normal',
    ]);
  });

  test('同优先级下最近创建靠前', () {
    final List<Task> tasks = service.sortActiveTasks(<Task>[
      buildTask(id: 'older', createdAt: DateTime(2026, 5, 24, 10)),
      buildTask(id: 'newer', createdAt: DateTime(2026, 5, 24, 12)),
    ], now: now);

    expect(tasks.map((Task task) => task.id).toList(), <String>[
      'newer',
      'older',
    ]);
  });
}
