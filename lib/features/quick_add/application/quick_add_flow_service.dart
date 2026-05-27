import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/features/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';

import '../data/quick_add_draft_store.dart';
import 'quick_add_defaults.dart';
import 'quick_add_draft.dart';
import 'quick_add_entry_source.dart';
import 'quick_add_flow_result.dart';

/// 快速添加统一流程编排。
///
/// App 内轻入口、系统入口回流和 `/quick-add` 都通过它生成草稿、保存草稿、
/// 恢复草稿以及最终创建事项，保证所有入口走同一套应用层链路。
final class QuickAddFlowService {
  /// 创建快速添加统一流程编排。
  QuickAddFlowService({
    required QuickAddDraftStore draftStore,
    required Future<Task> Function(CreateTaskInput input) createTask,
    required DateTime Function() now,
  }) : _draftStore = draftStore,
       _createTask = createTask,
       _now = now;

  final QuickAddDraftStore _draftStore;
  final Future<Task> Function(CreateTaskInput input) _createTask;
  final DateTime Function() _now;

  /// 根据入口来源准备一份统一草稿。
  QuickAddDraft prepareDraft({
    required QuickAddEntrySource source,
    QuickAddDefaults? defaults,
    String draftText = '',
  }) {
    final QuickAddDraft draft = QuickAddDraft.create(
      source: source,
      defaults: defaults,
      draftText: draftText,
      timestamp: _now(),
    );
    final bool hasPendingInput =
        draftText.trim().isNotEmpty ||
        draft.dueAt != null ||
        draft.isPinned ||
        draft.isPrivate;
    if (!hasPendingInput) {
      return draft;
    }

    return draft.copyWith(hasUnsavedChanges: true);
  }

  /// 为系统入口或失败回流创建并保存一份统一草稿。
  Future<QuickAddFlowResult> openQuickAdd({
    required QuickAddEntrySource source,
    QuickAddDefaults? defaults,
    String draftText = '',
  }) async {
    final QuickAddDraft draft = prepareDraft(
      source: source,
      defaults: defaults,
      draftText: draftText,
    );
    await _draftStore.save(draft);
    return QuickAddFlowResult(
      status: QuickAddFlowStatus.openedQuickAdd,
      draft: draft,
      routePath: RoutePaths.quickAdd,
    );
  }

  /// 保存当前草稿，用于页面收起、用户暂时返回首页或失败回流。
  Future<QuickAddFlowResult> saveDraft(
    QuickAddDraft draft, {
    QuickAddFlowStatus status = QuickAddFlowStatus.savedDraft,
    String routePath = RoutePaths.quickAdd,
  }) async {
    await _draftStore.save(_ensurePendingDraft(draft));
    return QuickAddFlowResult(
      status: status,
      draft: _ensurePendingDraft(draft),
      routePath: routePath,
    );
  }

  /// 恢复最近一次保留的草稿。
  Future<QuickAddDraft?> restoreDraft() {
    return _draftStore.read();
  }

  /// 清空当前草稿。
  Future<void> clearDraft() {
    return _draftStore.clear();
  }

  /// 从草稿创建事项。
  ///
  /// 无论是首页直接创建、底部弹层确认还是 `/quick-add` 提交，
  /// 最终都统一落到这里调用应用层创建用例。
  Future<QuickAddFlowResult> submitDraft(QuickAddDraft draft) async {
    final QuickAddDraft pendingDraft = _ensurePendingDraft(draft);
    try {
      final Task task = await _createTask(
        CreateTaskInput(
          title: pendingDraft.draftText,
          dueAt: pendingDraft.dueAt,
          isPinned: pendingDraft.isPinned,
          isPrivate: pendingDraft.isPrivate,
        ),
      );
      await _draftStore.clear();
      return QuickAddFlowResult(
        status: QuickAddFlowStatus.createdTask,
        taskId: task.id,
        routePath: RoutePaths.home,
      );
    } catch (_) {
      await _draftStore.save(pendingDraft);
      return QuickAddFlowResult(
        status: QuickAddFlowStatus.failedButRecovered,
        draft: pendingDraft,
        routePath: RoutePaths.quickAdd,
      );
    }
  }

  /// 记录“用户先回到主 App，但草稿继续保留”的返回语义。
  Future<QuickAddFlowResult> returnToApp(QuickAddDraft draft) {
    return saveDraft(
      draft,
      status: QuickAddFlowStatus.returnedToApp,
      routePath: RoutePaths.home,
    );
  }

  QuickAddDraft _ensurePendingDraft(QuickAddDraft draft) {
    if (draft.hasUnsavedChanges) {
      return draft;
    }

    return draft.copyWith(
      hasUnsavedChanges: true,
      updatedAt: _now(),
    );
  }
}
