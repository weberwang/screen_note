import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/tasks/application/services/task_display_state_resolver.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';

/// 验证事项显示态解析规则。
void main() {
  final TaskDisplayStateResolver resolver = TaskDisplayStateResolver();
  final DateTime now = DateTime(2026, 5, 25, 10);

  Task buildTask({
    required String id,
    required TaskStatus status,
    DateTime? dueAt,
    bool isPinned = false,
    bool isPrivate = false,
  }) {
    return Task(
      id: id,
      title: 'task-$id',
      status: status,
      dueAt: dueAt,
      isPinned: isPinned,
      isPrivate: isPrivate,
      reminderMode: TaskReminderMode.normal,
      createdAt: now.subtract(const Duration(days: 1)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    );
  }

  test('过期 active 事项仍是显示态，不会变成第四种持久状态', () {
    final Task task = buildTask(
      id: 'overdue',
      status: TaskStatus.active,
      dueAt: now.subtract(const Duration(hours: 2)),
    );

    expect(resolver.resolve(task, now: now), TaskDisplayState.overdue);
    expect(task.status, TaskStatus.active);
  });

  test('今天到期事项解析为 today', () {
    final Task task = buildTask(
      id: 'today',
      status: TaskStatus.active,
      dueAt: DateTime(2026, 5, 25, 18),
    );

    expect(resolver.resolve(task, now: now), TaskDisplayState.today);
  });

  test('隐私事项在外露场景会被遮罩', () {
    final Task task = buildTask(
      id: 'private',
      status: TaskStatus.active,
      isPrivate: true,
    );

    expect(
      resolver.resolve(task, now: now, maskPrivate: true),
      TaskDisplayState.privateMasked,
    );
  });
}
