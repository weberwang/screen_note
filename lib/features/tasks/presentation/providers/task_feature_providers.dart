import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../widget_bridge/application/widget_refresh_scheduler.dart';
import '../../../widget_bridge/application/widget_snapshot_builder.dart';
import '../../../widget_bridge/application/widget_snapshot_refresher.dart';
import '../../../widget_bridge/data/app_widget_snapshot_text_resolver.dart';
import '../../../widget_bridge/presentation/providers/widget_bridge_providers.dart';
import '../../application/services/task_display_state_resolver.dart';
import '../../application/services/task_sorting_service.dart';
import '../../application/use_cases/complete_task_use_case.dart';
import '../../application/use_cases/create_task_use_case.dart';
import '../../application/use_cases/delete_task_use_case.dart';
import '../../application/use_cases/restore_task_use_case.dart';
import '../../application/use_cases/update_task_use_case.dart';
import '../../application/use_cases/watch_active_tasks_use_case.dart';
import '../../application/use_cases/watch_completed_tasks_use_case.dart';
import '../../application/use_cases/watch_deleted_tasks_use_case.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/task_events_dao.dart';
import '../../data/local/database/daos/tasks_dao.dart';
import '../../data/repositories/drift_task_event_repository.dart';
import '../../data/repositories/drift_task_repository.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_event.dart';
import '../../domain/repositories/task_event_repository.dart';
import '../../domain/repositories/task_repository.dart';

/// 当前时间提供器。
final Provider<DateTime Function()> nowProvider = Provider<DateTime Function()>((
  Ref ref,
) {
  return DateTime.now;
});

/// UUID 生成器提供器。
final Provider<String Function()> idGeneratorProvider = Provider<String Function()>(
  (Ref ref) {
    final Uuid uuid = const Uuid();
    return uuid.v4;
  },
);

/// 小组件快照刷新器提供器。
final Provider<WidgetSnapshotRefresher> widgetSnapshotRefresherProvider =
    Provider<WidgetSnapshotRefresher>((Ref ref) {
      return ref.watch(widgetRefreshSchedulerProvider);
    });

/// 数据库提供器。
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

/// 事项 DAO 提供器。
final Provider<TasksDao> tasksDaoProvider = Provider<TasksDao>((Ref ref) {
  return ref.watch(appDatabaseProvider).tasksDao;
});

/// 事项日志 DAO 提供器。
final Provider<TaskEventsDao> taskEventsDaoProvider = Provider<TaskEventsDao>((
  Ref ref,
) {
  return ref.watch(appDatabaseProvider).taskEventsDao;
});

/// 事项仓储提供器。
final Provider<TaskRepository> taskRepositoryProvider = Provider<TaskRepository>((
  Ref ref,
) {
  return DriftTaskRepository(ref.watch(tasksDaoProvider));
});

/// 事项日志仓储提供器。
final Provider<TaskEventRepository> taskEventRepositoryProvider =
    Provider<TaskEventRepository>((Ref ref) {
      return DriftTaskEventRepository(ref.watch(taskEventsDaoProvider));
    });

/// 排序服务提供器。
final Provider<TaskSortingService> taskSortingServiceProvider =
    Provider<TaskSortingService>((Ref ref) {
      return TaskSortingService();
    });

/// 显示态解析器提供器。
final Provider<TaskDisplayStateResolver> taskDisplayStateResolverProvider =
    Provider<TaskDisplayStateResolver>((Ref ref) {
      return TaskDisplayStateResolver();
    });

/// Widget 快照文本解析器提供器。
final Provider<WidgetSnapshotTextResolver> widgetSnapshotTextResolverProvider =
    Provider<WidgetSnapshotTextResolver>((Ref ref) {
      return AppWidgetSnapshotTextResolver();
    });

/// Widget 快照生成器提供器。
final Provider<WidgetSnapshotBuilder> widgetSnapshotBuilderProvider =
    Provider<WidgetSnapshotBuilder>((Ref ref) {
      return WidgetSnapshotBuilder(
        displayStateResolver: ref.watch(taskDisplayStateResolverProvider),
        textResolver: ref.watch(widgetSnapshotTextResolverProvider),
        now: ref.watch(nowProvider),
        snapshotIdGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// Widget 刷新调度器提供器。
///
/// 主应用统一从这里装配排序服务、展示模式和共享快照存储，
/// 保证所有状态变更都走同一条非阻塞刷新链路。
final Provider<WidgetRefreshScheduler> widgetRefreshSchedulerProvider =
    Provider<WidgetRefreshScheduler>((Ref ref) {
      return WidgetRefreshScheduler(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskSortingService: ref.watch(taskSortingServiceProvider),
        displayModeRepository: ref.watch(widgetDisplayModeRepositoryProvider),
        snapshotBuilder: ref.watch(widgetSnapshotBuilderProvider),
        snapshotStore: ref.watch(widgetSnapshotStoreProvider),
        now: ref.watch(nowProvider),
      );
    });

/// 创建事项用例提供器。
final Provider<CreateTaskUseCase> createTaskUseCaseProvider =
    Provider<CreateTaskUseCase>((Ref ref) {
      return CreateTaskUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskEventRepository: ref.watch(taskEventRepositoryProvider),
        widgetSnapshotRefresher: ref.watch(widgetSnapshotRefresherProvider),
        now: ref.watch(nowProvider),
        idGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// 更新事项用例提供器。
final Provider<UpdateTaskUseCase> updateTaskUseCaseProvider =
    Provider<UpdateTaskUseCase>((Ref ref) {
      return UpdateTaskUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskEventRepository: ref.watch(taskEventRepositoryProvider),
        widgetSnapshotRefresher: ref.watch(widgetSnapshotRefresherProvider),
        now: ref.watch(nowProvider),
        idGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// 完成事项用例提供器。
final Provider<CompleteTaskUseCase> completeTaskUseCaseProvider =
    Provider<CompleteTaskUseCase>((Ref ref) {
      return CompleteTaskUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskEventRepository: ref.watch(taskEventRepositoryProvider),
        widgetSnapshotRefresher: ref.watch(widgetSnapshotRefresherProvider),
        now: ref.watch(nowProvider),
        idGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// 删除事项用例提供器。
final Provider<DeleteTaskUseCase> deleteTaskUseCaseProvider =
    Provider<DeleteTaskUseCase>((Ref ref) {
      return DeleteTaskUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskEventRepository: ref.watch(taskEventRepositoryProvider),
        widgetSnapshotRefresher: ref.watch(widgetSnapshotRefresherProvider),
        now: ref.watch(nowProvider),
        idGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// 恢复事项用例提供器。
final Provider<RestoreTaskUseCase> restoreTaskUseCaseProvider =
    Provider<RestoreTaskUseCase>((Ref ref) {
      return RestoreTaskUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskEventRepository: ref.watch(taskEventRepositoryProvider),
        widgetSnapshotRefresher: ref.watch(widgetSnapshotRefresherProvider),
        now: ref.watch(nowProvider),
        idGenerator: ref.watch(idGeneratorProvider),
      );
    });

/// 监听当前事项列表用例提供器。
final Provider<WatchActiveTasksUseCase> watchActiveTasksUseCaseProvider =
    Provider<WatchActiveTasksUseCase>((Ref ref) {
      return WatchActiveTasksUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskSortingService: ref.watch(taskSortingServiceProvider),
        now: ref.watch(nowProvider),
      );
    });

/// 监听最近完成列表用例提供器。
final Provider<WatchCompletedTasksUseCase> watchCompletedTasksUseCaseProvider =
    Provider<WatchCompletedTasksUseCase>((Ref ref) {
      return WatchCompletedTasksUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskSortingService: ref.watch(taskSortingServiceProvider),
      );
    });

/// 监听最近删除列表用例提供器。
final Provider<WatchDeletedTasksUseCase> watchDeletedTasksUseCaseProvider =
    Provider<WatchDeletedTasksUseCase>((Ref ref) {
      return WatchDeletedTasksUseCase(
        taskRepository: ref.watch(taskRepositoryProvider),
        taskSortingService: ref.watch(taskSortingServiceProvider),
        now: ref.watch(nowProvider),
      );
    });

/// 当前事项流提供器。
final StreamProvider<List<Task>> activeTasksProvider = StreamProvider<List<Task>>((
  Ref ref,
) {
  return ref.watch(watchActiveTasksUseCaseProvider).call();
});

/// 最近完成流提供器。
final StreamProvider<List<Task>> completedTasksProvider =
    StreamProvider<List<Task>>((Ref ref) {
      return ref.watch(watchCompletedTasksUseCaseProvider).call();
    });

/// 最近删除流提供器。
final StreamProvider<List<Task>> deletedTasksProvider = StreamProvider<List<Task>>((
  Ref ref,
) {
  return ref.watch(watchDeletedTasksUseCaseProvider).call();
});

/// 单个事项流提供器。
final taskProvider = StreamProvider.autoDispose.family<Task?, String>((
  Ref ref,
  String taskId,
) {
  return ref.watch(taskRepositoryProvider).watchById(taskId);
});

/// 单个事项日志流提供器。
final taskEventsProvider = StreamProvider.autoDispose.family<List<TaskEvent>, String>((
  Ref ref,
  String taskId,
) {
  return ref.watch(taskEventRepositoryProvider).watchByTaskId(taskId);
});
