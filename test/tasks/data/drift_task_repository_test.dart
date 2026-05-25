import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/tasks/data/local/database/app_database.dart';
import 'package:screen_note/src/tasks/data/repositories/drift_task_repository.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';

/// 验证 Drift 仓储的持久化行为。
void main() {
  test('保存后的任务可以再次读回', () async {
    final AppDatabase database = AppDatabase.forExecutor(NativeDatabase.memory());
    final DriftTaskRepository repository = DriftTaskRepository(database.tasksDao);
    final DateTime now = DateTime(2026, 5, 25, 10);

    final Task task = Task(
      id: 'task-1',
      title: 'persist me',
      status: TaskStatus.active,
      reminderMode: TaskReminderMode.normal,
      createdAt: now,
      updatedAt: now,
    );

    await repository.save(task);
    final Task? persistedTask = await repository.findById(task.id);

    expect(persistedTask?.title, 'persist me');
    await database.close();
  });
}
