import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/tasks/application/use_cases/complete_task_use_case.dart';
import 'package:screen_note/src/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/src/tasks/application/use_cases/delete_task_use_case.dart';
import 'package:screen_note/src/tasks/application/use_cases/restore_task_use_case.dart';
import 'package:screen_note/src/tasks/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';
import 'package:screen_note/src/tasks/domain/entities/task_event.dart';
import 'package:screen_note/src/tasks/domain/repositories/task_event_repository.dart';
import 'package:screen_note/src/tasks/domain/repositories/task_repository.dart';
import 'package:screen_note/src/widget_bridge/application/widget_refresh_result.dart';
import 'package:screen_note/src/widget_bridge/application/widget_snapshot_refresher.dart';

/// 验证事项生命周期用例。
void main() {
  final DateTime now = DateTime(2026, 5, 25, 10);

  test('创建、完成、删除、恢复都会追加 TaskEvent 并刷新快照', () async {
    final InMemoryTaskRepository taskRepository = InMemoryTaskRepository();
    final InMemoryTaskEventRepository taskEventRepository =
        InMemoryTaskEventRepository();
    final RecordingWidgetSnapshotRefresher refresher =
        RecordingWidgetSnapshotRefresher();
    int idSeed = 0;
    String nextId() => 'id-${idSeed++}';

    final CreateTaskUseCase createTaskUseCase = CreateTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final CompleteTaskUseCase completeTaskUseCase = CompleteTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final RestoreTaskUseCase restoreTaskUseCase = RestoreTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );

    final Task createdTask = await createTaskUseCase(
      const CreateTaskInput(title: 'buy milk'),
    );
    expect(createdTask.status, TaskStatus.active);

    final Task completedTask = await completeTaskUseCase(createdTask.id);
    expect(completedTask.status, TaskStatus.completed);
    expect(completedTask.completedAt, now);

    final Task deletedTask = await deleteTaskUseCase(createdTask.id);
    expect(deletedTask.status, TaskStatus.deleted);
    expect(deletedTask.deletedAt, now);

    final Task restoredTask = await restoreTaskUseCase(createdTask.id);
    expect(restoredTask.status, TaskStatus.active);
    expect(restoredTask.deletedAt, isNull);

    expect(
      taskEventRepository.events.map((TaskEvent event) => event.action).toList(),
      <TaskEventAction>[
        TaskEventAction.create,
        TaskEventAction.complete,
        TaskEventAction.delete,
        TaskEventAction.restore,
      ],
    );
    expect(refresher.refreshCount, 4);
  });

  test('刷新失败不会阻断事项主链路', () async {
    final InMemoryTaskRepository taskRepository = InMemoryTaskRepository();
    final InMemoryTaskEventRepository taskEventRepository =
        InMemoryTaskEventRepository();
    final ThrowingWidgetSnapshotRefresher refresher =
        ThrowingWidgetSnapshotRefresher();
    int idSeed = 0;
    String nextId() => 'id-${idSeed++}';

    final CreateTaskUseCase createTaskUseCase = CreateTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final CompleteTaskUseCase completeTaskUseCase = CompleteTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final RestoreTaskUseCase restoreTaskUseCase = RestoreTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );
    final UpdateTaskUseCase updateTaskUseCase = UpdateTaskUseCase(
      taskRepository: taskRepository,
      taskEventRepository: taskEventRepository,
      widgetSnapshotRefresher: refresher,
      now: () => now,
      idGenerator: nextId,
    );

    final Task createdTask = await createTaskUseCase(
      const CreateTaskInput(title: 'buy milk'),
    );
    final Task updatedTask = await updateTaskUseCase(
      UpdateTaskInput(
        id: createdTask.id,
        title: 'buy milk and bread',
        isPinned: false,
        isPrivate: false,
        reminderMode: TaskReminderMode.normal,
      ),
    );
    final Task completedTask = await completeTaskUseCase(createdTask.id);
    final Task deletedTask = await deleteTaskUseCase(createdTask.id);
    final Task restoredTask = await restoreTaskUseCase(createdTask.id);

    expect(createdTask.status, TaskStatus.active);
    expect(updatedTask.title, 'buy milk and bread');
    expect(completedTask.status, TaskStatus.completed);
    expect(deletedTask.status, TaskStatus.deleted);
    expect(restoredTask.status, TaskStatus.active);
    expect(
      taskEventRepository.events.map((TaskEvent event) => event.action).toList(),
      <TaskEventAction>[
        TaskEventAction.create,
        TaskEventAction.update,
        TaskEventAction.complete,
        TaskEventAction.delete,
        TaskEventAction.restore,
      ],
    );
    expect(refresher.refreshCount, 5);
  });
}

class InMemoryTaskRepository implements TaskRepository {
  final Map<String, Task> _tasks = <String, Task>{};

  @override
  Future<List<Task>> findAll() async => _tasks.values.toList(growable: false);

  @override
  Future<Task?> findById(String id) async => _tasks[id];

  @override
  Future<void> save(Task task) async {
    _tasks[task.id] = task;
  }

  @override
  Future<void> saveAll(Iterable<Task> tasks) async {
    for (final Task task in tasks) {
      _tasks[task.id] = task;
    }
  }

  @override
  Stream<List<Task>> watchAll() async* {
    yield _tasks.values.toList(growable: false);
  }

  @override
  Stream<Task?> watchById(String id) async* {
    yield _tasks[id];
  }
}

class InMemoryTaskEventRepository implements TaskEventRepository {
  final List<TaskEvent> events = <TaskEvent>[];

  @override
  Future<List<TaskEvent>> findByTaskId(String taskId) async {
    return events.where((TaskEvent event) => event.taskId == taskId).toList();
  }

  @override
  Future<void> save(TaskEvent event) async {
    events.add(event);
  }

  @override
  Stream<List<TaskEvent>> watchByTaskId(String taskId) async* {
    yield events.where((TaskEvent event) => event.taskId == taskId).toList();
  }
}

class RecordingWidgetSnapshotRefresher implements WidgetSnapshotRefresher {
  int refreshCount = 0;

  @override
  Future<WidgetRefreshResult> refresh() async {
    refreshCount += 1;
    return WidgetRefreshResult.success;
  }
}

class ThrowingWidgetSnapshotRefresher implements WidgetSnapshotRefresher {
  int refreshCount = 0;

  @override
  Future<WidgetRefreshResult> refresh() async {
    refreshCount += 1;
    throw StateError('refresh_failed');
  }
}
