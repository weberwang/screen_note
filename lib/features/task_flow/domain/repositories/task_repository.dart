import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

/// 任务只读仓储，统一屏蔽页面与查询用例对持久化细节的感知。
abstract interface class TaskRepository {
  /// 按主键读取事项。
  Future<TaskEntity?> findTaskById(String id);

  /// 按持久状态读取事项集合。
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status);

  /// 统计指定状态的事项数量。
  Future<int> countTasksByStatus(TaskStatus status);
}

/// 任务变更仓储，所有关键状态写入都必须通过事务化入口提交事项与事件。
abstract interface class TaskMutationRepository implements TaskRepository {
  /// 事务化提交“创建事项 + 首条事件”，避免任务与日志写入分裂。
  Future<void> createTaskWithEvent({
    required TaskEntity task,
    required TaskEventEntity event,
  });

  /// 事务化提交“更新事项 + 状态事件”，避免状态变化与日志失真。
  Future<void> updateTaskWithEvent({
    required TaskEntity task,
    required TaskEventEntity event,
  });

  /// 新建测试或预置数据时直接写入事项。
  Future<void> createTask(TaskEntity task);
}
