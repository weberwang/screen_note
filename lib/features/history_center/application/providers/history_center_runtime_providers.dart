import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/history_center/application/use_cases/load_history_snapshot_use_case.dart';
import 'package:screen_note/features/history_center/domain/entities/history_snapshot.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';

part 'history_center_runtime_providers.g.dart';

/// 历史中心读取用例提供器，复用 task-flow 仓储避免重复维护数据边界。
@riverpod
LoadHistorySnapshotUseCase loadHistorySnapshotUseCase(Ref ref) {
  return LoadHistorySnapshotUseCase(
    repository: ref.watch(taskRepositoryProvider),
  );
}

/// 历史中心控制器，统一收口历史读取、恢复和跨页快照刷新。
@riverpod
class HistoryCenterController extends _$HistoryCenterController {
  /// 构建历史页快照。
  @override
  Future<HistorySnapshot> build() async {
    return _loadSnapshot();
  }

  /// 恢复最近删除事项，并主动刷新首页任务流，避免 Tab 切换后看到旧快照。
  Future<void> restoreTask(String taskId) async {
    await _mutate(() async {
      await ref.read(updateTaskStatusUseCaseProvider).restoreTask(taskId: taskId);
      ref.invalidate(taskFlowHomeControllerProvider);
    });
  }

  /// 主动刷新历史快照。
  Future<void> refresh() async {
    state = AsyncData(await _loadSnapshot());
  }

  Future<void> _mutate(Future<void> Function() operation) async {
    final AsyncValue<HistorySnapshot> previousState = state;
    try {
      await operation();
      state = AsyncData(await _loadSnapshot());
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      state = previousState;
      rethrow;
    }
  }

  Future<HistorySnapshot> _loadSnapshot() {
    return ref.read(loadHistorySnapshotUseCaseProvider).execute();
  }
}
