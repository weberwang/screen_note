import '../entities/task.dart';

/// 事项仓储接口。
///
/// 这里只定义纯数据读写契约，不在接口层表达完成、删除、恢复等业务动作，
/// 避免页面或基础设施层绕过应用层直接做状态流转。
abstract interface class TaskRepository {
  /// 监听全部事项快照。
  Stream<List<Task>> watchAll();

  /// 监听指定事项。
  Stream<Task?> watchById(String id);

  /// 查询指定事项。
  Future<Task?> findById(String id);

  /// 查询全部事项快照。
  Future<List<Task>> findAll();

  /// 保存单个事项。
  Future<void> save(Task task);

  /// 批量保存事项。
  Future<void> saveAll(Iterable<Task> tasks);
}
