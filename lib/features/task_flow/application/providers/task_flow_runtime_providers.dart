import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/application/ports/task_flow_side_effect_port.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_flow_degradation_hint.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_notification_permission_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_degradation_hint_source.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

part 'task_flow_runtime_providers.g.dart';

/// 运行时数据库 Provider，统一复用 `TaskFlowDatabase` 真源入口，避免页面层直接感知连接细节。
@Riverpod(keepAlive: true)
TaskFlowDatabase taskFlowDatabase(Ref ref) {
  return TaskFlowDatabase();
}

/// 任务写仓储 Provider，显式暴露变更契约，避免在写用例装配时做向下转型。
@Riverpod(keepAlive: true)
TaskMutationRepository taskFlowMutationRepository(Ref ref) {
  return TaskFlowRepositoryImpl(database: ref.watch(taskFlowDatabaseProvider));
}

/// 任务只读仓储 Provider，首页和查询用例只依赖读契约，不接触写能力细节。
@Riverpod(keepAlive: true)
TaskRepository taskFlowRepository(Ref ref) {
  return ref.watch(taskFlowMutationRepositoryProvider);
}

/// 默认副作用端口 Provider，当前先降级到 no-op，后续通知、Widget 等能力都从这里替换接线。
@Riverpod(keepAlive: true)
TaskFlowSideEffectPort defaultTaskFlowSideEffectPort(Ref ref) {
  return const TaskFlowNoopSideEffectPort();
}

/// 任务流副作用装配点，默认复用降级实现，但保留清晰可替换入口以满足后续能力接入。
@Riverpod(keepAlive: true)
TaskFlowSideEffectPort taskFlowSideEffectPort(Ref ref) {
  return ref.watch(defaultTaskFlowSideEffectPortProvider);
}

/// 首页降级提示来源默认先接通知权限状态，后续其他能力降级仍可沿这个入口继续汇总。
@Riverpod(keepAlive: true)
TaskFlowDegradationHintSource taskFlowDegradationHintSource(Ref ref) {
  try {
    return TaskFlowNotificationPermissionDegradationHintSource(
      notificationRepository: ref.watch(
        notificationPermissionRepositoryProvider,
      ),
    );
  } catch (_) {
    return const TaskFlowNoopDegradationHintSource();
  }
}

/// 创建事项用例 Provider，供后续编辑页或快捷入口直接读取，不把构造细节散落到展示层。
@riverpod
CreateTaskUseCase createTaskUseCase(Ref ref) {
  return CreateTaskUseCase(
    repository: ref.watch(taskFlowMutationRepositoryProvider),
    sideEffectPort: ref.watch(taskFlowSideEffectPortProvider),
    uuid: const Uuid(),
  );
}

/// 首页快照用例 Provider，统一封装任务分组与优先级选择规则。
@riverpod
LoadTaskFeedUseCase loadTaskFeedUseCase(Ref ref) {
  return LoadTaskFeedUseCase(
    repository: ref.watch(taskFlowRepositoryProvider),
    degradationHintSource: ref.watch(taskFlowDegradationHintSourceProvider),
  );
}

/// 单事项读取 Provider，供编辑页按身份读取既有任务并预填，避免页面层直接碰仓储。
@riverpod
Future<TaskEntity?> taskFlowTaskById(Ref ref, String taskId) {
  return ref.watch(taskFlowRepositoryProvider).findTaskById(taskId);
}

/// 更新事项用例 Provider，统一承接编辑态保存，不允许页面层误走新建链路。
@riverpod
UpdateTaskUseCase updateTaskUseCase(Ref ref) {
  return UpdateTaskUseCase(
    repository: ref.watch(taskFlowMutationRepositoryProvider),
    uuid: const Uuid(),
  );
}

/// 状态流转用例 Provider，供后续页面直接读取，保持状态写入仍通过应用层编排。
@riverpod
UpdateTaskStatusUseCase updateTaskStatusUseCase(Ref ref) {
  return UpdateTaskStatusUseCase(
    repository: ref.watch(taskFlowMutationRepositoryProvider),
    sideEffectPort: ref.watch(taskFlowSideEffectPortProvider),
    uuid: const Uuid(),
  );
}

/// 首页基础快照 Provider，保留 Task 2 的最小快照读取入口，供 controller 或其他轻量读取复用。
@riverpod
Future<TaskFeedSnapshot> taskFlowHomeSnapshot(Ref ref) {
  return ref.watch(loadTaskFeedUseCaseProvider).execute();
}

/// 首页控制器统一承接快照刷新与后续写后刷新入口，避免页面直接操心失效策略。
@Riverpod(keepAlive: true)
class TaskFlowHomeController extends _$TaskFlowHomeController {
  /// 首次构建时读取首页快照。
  @override
  Future<TaskFeedSnapshot> build() {
    return ref.watch(taskFlowHomeSnapshotProvider.future);
  }

  /// 主动刷新首页快照，供页面重试或后续系统回流场景复用。
  Future<void> refresh() async {
    await _runWithSnapshotFallback(_loadSnapshot);
  }

  /// 创建快捷事项后立即刷新首页快照，确保首页不会停留在旧状态。
  Future<void> createQuickTask(CreateTaskInput input, {DateTime? now}) async {
    await _runWithSnapshotFallback(() async {
      await ref.read(createTaskUseCaseProvider).execute(input, now: now);
      return _loadSnapshot();
    });
  }

  /// 完成事项后立即刷新首页快照，避免主事项卡片与队列展示滞后。
  Future<void> completeTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    await _runWithSnapshotFallback(() async {
      await ref
          .read(updateTaskStatusUseCaseProvider)
          .completeTask(taskId: taskId, occurredAt: occurredAt);
      return _loadSnapshot();
    });
  }

  /// 删除事项后立即刷新首页快照，保证软删除后的首页分组实时收敛。
  Future<void> deleteTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    await _runWithSnapshotFallback(() async {
      await ref
          .read(updateTaskStatusUseCaseProvider)
          .deleteTask(taskId: taskId, occurredAt: occurredAt);
      return _loadSnapshot();
    });
  }

  /// 已有快照刷新时保留旧数据，避免写后刷新把首页短暂清成全屏 loading。
  AsyncValue<TaskFeedSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<TaskFeedSnapshot>() => state,
      _ => const AsyncLoading<TaskFeedSnapshot>(),
    };
  }

  /// 读取失败但已有旧快照时，只追加降级提示而不把首页整体打成错误页。
  Future<void> _runWithSnapshotFallback(
    Future<TaskFeedSnapshot> Function() loader,
  ) async {
    final TaskFeedSnapshot? previousSnapshot = switch (state) {
      AsyncData<TaskFeedSnapshot>(:final value) => value,
      _ => null,
    };
    state = _loadingState();
    try {
      state = AsyncData<TaskFeedSnapshot>(await loader());
    } catch (error, stackTrace) {
      if (previousSnapshot == null) {
        state = AsyncError<TaskFeedSnapshot>(error, stackTrace);
        return;
      }
      state = AsyncData<TaskFeedSnapshot>(
        _appendRefreshFailureHint(previousSnapshot),
      );
    }
  }

  /// 旧快照回退时去重追加刷新失败提示，避免连续失败把同一条提示重复堆叠。
  TaskFeedSnapshot _appendRefreshFailureHint(TaskFeedSnapshot snapshot) {
    if (snapshot.degradationHints.contains(
      TaskFlowDegradationHint.refreshFailed,
    )) {
      return snapshot;
    }
    return snapshot.copyWith(
      degradationHints: <TaskFlowDegradationHint>[
        ...snapshot.degradationHints,
        TaskFlowDegradationHint.refreshFailed,
      ],
    );
  }

  /// 统一读取首页快照用例，避免通过基础快照 Provider 做重复失效和重读。
  Future<TaskFeedSnapshot> _loadSnapshot() {
    return ref.read(loadTaskFeedUseCaseProvider).execute();
  }
}
