import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

part 'task_flow_runtime_providers.g.dart';

/// task-flow 数据库提供器，统一托管持久层生命周期。
@Riverpod(keepAlive: true)
TaskFlowDatabase taskFlowDatabase(Ref ref) {
  final TaskFlowDatabase database = TaskFlowDatabase();
  ref.onDispose(database.close);
  return database;
}

/// 事项仓储提供器，隔离页面层对 Drift 的直接依赖。
@riverpod
TaskRepository taskRepository(Ref ref) {
  return TaskFlowRepositoryImpl(database: ref.watch(taskFlowDatabaseProvider));
}

/// 副作用端口提供器，当前先用空实现保住主链路，后续再接提醒与快照刷新。
@riverpod
TaskFlowSideEffectPort taskFlowSideEffectPort(Ref ref) {
  return const TaskFlowNoopSideEffectPort();
}

/// 创建事项用例提供器。
@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  return CreateTaskUseCase(
    repository: ref.watch(taskRepositoryProvider),
    sideEffectPort: ref.watch(taskFlowSideEffectPortProvider),
    uuid: const Uuid(),
  );
}

/// 首页任务流读取用例提供器。
@riverpod
LoadTaskFeedUseCase loadTaskFeedUseCase(Ref ref) {
  return LoadTaskFeedUseCase(repository: ref.watch(taskRepositoryProvider));
}

/// 事项状态流转用例提供器。
@riverpod
UpdateTaskStatusUseCase updateTaskStatusUseCase(Ref ref) {
  return UpdateTaskStatusUseCase(
    repository: ref.watch(taskRepositoryProvider),
    sideEffectPort: ref.watch(taskFlowSideEffectPortProvider),
  );
}

/// 首页任务流控制器，统一收口首页读取与快速状态变更。
@riverpod
class TaskFlowHomeController extends _$TaskFlowHomeController {
  /// 构建首页任务流状态。
  @override
  Future<TaskFeedSnapshot> build() async {
    return _loadSnapshot();
  }

  /// 快速添加事项，默认只要求标题，其余字段由完整编辑页补充。
  Future<void> createQuickTask(CreateTaskInput input) async {
    await _mutate(() async {
      await ref.read(createTaskUseCaseProvider).execute(input);
    });
  }

  /// 完成事项。
  Future<void> completeTask(String taskId) async {
    await _mutate(() async {
      await ref.read(updateTaskStatusUseCaseProvider).completeTask(taskId: taskId);
    });
  }

  /// 软删除事项。
  Future<void> deleteTask(String taskId) async {
    await _mutate(() async {
      await ref.read(updateTaskStatusUseCaseProvider).deleteTask(taskId: taskId);
    });
  }

  /// 主动刷新首页快照。
  Future<void> refresh() async {
    state = AsyncData(await _loadSnapshot());
  }

  Future<void> _mutate(Future<void> Function() operation) async {
    final AsyncValue<TaskFeedSnapshot> previousState = state;
    try {
      await operation();
      state = AsyncData(await _loadSnapshot());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      state = previousState;
      rethrow;
    }
  }

  Future<TaskFeedSnapshot> _loadSnapshot() {
    return ref.read(loadTaskFeedUseCaseProvider).execute();
  }
}
