import '../entities/task_event.dart';

/// 事项日志仓储接口。
abstract interface class TaskEventRepository {
  /// 监听某个事项的操作日志。
  Stream<List<TaskEvent>> watchByTaskId(String taskId);

  /// 查询某个事项的操作日志。
  Future<List<TaskEvent>> findByTaskId(String taskId);

  /// 追加一条事项操作日志。
  Future<void> save(TaskEvent event);
}
