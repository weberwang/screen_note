import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

/// 事项仓储接口，统一屏蔽底层 Drift 持久化实现。
abstract interface class TaskRepository {
  /// 创建事项并持久化初始事实。
  Future<void> createTask(TaskEntity task);

  /// 更新事项主体字段或状态。
  Future<void> updateTask(TaskEntity task);

  /// 根据主键读取事项。
  Future<TaskEntity?> findTaskById(String id);

  /// 按持久状态读取事项集合。
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status);

  /// 统计某个状态下的事项数量。
  Future<int> countTasksByStatus(TaskStatus status);

  /// 追加事项事件日志。
  Future<void> appendEvent(TaskEventEntity event);
}
