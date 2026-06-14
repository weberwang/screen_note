import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';
import 'package:screen_note/features/history_center/application/use_cases/load_history_center_snapshot_use_case.dart';
import 'package:screen_note/features/history_center/domain/entities/history_center_snapshot.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';

part 'history_center_runtime_providers.g.dart';

/// 历史页快照用例 Provider，统一复用 task-flow 只读仓储，不单独引入新的历史真源。
@riverpod
LoadHistoryCenterSnapshotUseCase loadHistoryCenterSnapshotUseCase(Ref ref) {
  return LoadHistoryCenterSnapshotUseCase(
    repository: ref.watch(taskFlowRepositoryProvider),
  );
}

/// 历史页基础快照 Provider，保留独立的读取入口，避免页面直接耦合仓储查询细节。
@riverpod
Future<HistoryCenterSnapshot> historyCenterSnapshot(Ref ref) {
  return ref.watch(loadHistoryCenterSnapshotUseCaseProvider).execute();
}

/// 历史页控制器统一承接刷新与恢复链路，避免页面直接编排跨模块状态。
@Riverpod(keepAlive: true)
class HistoryCenterController extends _$HistoryCenterController {
  /// 首次构建时读取历史快照。
  @override
  Future<HistoryCenterSnapshot> build() {
    return ref.watch(historyCenterSnapshotProvider.future);
  }

  /// 主动刷新历史页快照，供恢复成功后或错误重试时复用。
  Future<void> refresh() async {
    state = _loadingState();
    state = await AsyncValue.guard(_loadSnapshot);
  }

  /// 恢复已删除事项，并在成功后同步刷新历史页与首页快照。
  Future<void> restoreTask({
    required String taskId,
    DateTime? occurredAt,
    required String successMessage,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      await ref
          .read(updateTaskStatusUseCaseProvider)
          .restoreTask(
            taskId: taskId,
            occurredAt: occurredAt ?? DateTime.now(),
          );
      await _refreshTaskFlowHomeSnapshot();
      ref
          .read(appShellUiStateControllerProvider.notifier)
          .showFeedback(
            AppShellFeedbackMessage(
              level: AppShellFeedbackLevel.info,
              text: successMessage,
            ),
          );
      return _loadSnapshot();
    });
  }

  /// 首页快照刷新属于跨模块一致性补偿，失败时只降级，不影响恢复主链路结果。
  Future<void> _refreshTaskFlowHomeSnapshot() async {
    try {
      await ref.read(taskFlowHomeControllerProvider.notifier).refresh();
    } catch (_) {
      // 首页刷新失败只做能力降级，不应把历史恢复误判为失败。
    }
  }

  /// 已有快照刷新时保留旧数据，避免恢复或手动刷新把历史页短暂清成全屏 loading。
  AsyncValue<HistoryCenterSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<HistoryCenterSnapshot>() => state,
      _ => const AsyncLoading<HistoryCenterSnapshot>(),
    };
  }

  /// 统一直接读取历史快照用例，避免通过基础快照 Provider 做额外失效和重读。
  Future<HistoryCenterSnapshot> _loadSnapshot() {
    return ref.read(loadHistoryCenterSnapshotUseCaseProvider).execute();
  }
}
