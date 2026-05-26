import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/src/app/route_paths.dart';
import 'package:screen_note/src/quick_add/application/quick_add_defaults.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/src/quick_add/application/quick_add_flow_result.dart';
import 'package:screen_note/src/quick_add/application/quick_add_flow_service.dart';
import 'package:screen_note/src/quick_add/data/quick_add_draft_store.dart';
import 'package:screen_note/src/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/src/tasks/domain/entities/task.dart';

/// 验证快速添加统一流程编排。
void main() {
  test('openQuickAdd 会保存草稿并返回统一兜底路由', () async {
    final _MemoryQuickAddDraftStore store = _MemoryQuickAddDraftStore();
    final QuickAddFlowService service = QuickAddFlowService(
      draftStore: store,
      createTask: (CreateTaskInput input) async => _buildTask(input),
      now: () => DateTime(2026, 5, 26, 10),
    );

    final QuickAddFlowResult result = await service.openQuickAdd(
      source: QuickAddEntrySource.appIntent,
      defaults: const QuickAddDefaults(isPinned: true),
      draftText: '带钥匙',
    );

    expect(result.status, QuickAddFlowStatus.openedQuickAdd);
    expect(result.routePath, RoutePaths.quickAdd);
    expect(result.draft?.draftText, '带钥匙');
    expect(await store.read(), result.draft);
  });

  test('submitDraft 成功后会清空草稿并返回已创建结果', () async {
    final _MemoryQuickAddDraftStore store = _MemoryQuickAddDraftStore();
    final QuickAddFlowService service = QuickAddFlowService(
      draftStore: store,
      createTask: (CreateTaskInput input) async => _buildTask(input),
      now: () => DateTime(2026, 5, 26, 10),
    );
    final QuickAddDraft draft = service.prepareDraft(
      source: QuickAddEntrySource.home,
      draftText: '买纸巾',
    );

    final QuickAddFlowResult result = await service.submitDraft(draft);

    expect(result.status, QuickAddFlowStatus.createdTask);
    expect(result.routePath, RoutePaths.home);
    expect(result.taskId, 'task-1');
    expect(await store.read(), isNull);
  });

  test('submitDraft 失败后会保留草稿并返回失败恢复结果', () async {
    final _MemoryQuickAddDraftStore store = _MemoryQuickAddDraftStore();
    final QuickAddFlowService service = QuickAddFlowService(
      draftStore: store,
      createTask: (CreateTaskInput input) async {
        throw Exception('save_failed');
      },
      now: () => DateTime(2026, 5, 26, 10),
    );
    final QuickAddDraft draft = service.prepareDraft(
      source: QuickAddEntrySource.lockScreen,
      draftText: '寄快递',
    );

    final QuickAddFlowResult result = await service.submitDraft(draft);

    expect(result.status, QuickAddFlowStatus.failedButRecovered);
    expect(result.routePath, RoutePaths.quickAdd);
    expect(result.draft?.draftText, '寄快递');
    expect(await store.read(), result.draft);
  });

  test('returnToApp 会保留草稿并回到首页', () async {
    final _MemoryQuickAddDraftStore store = _MemoryQuickAddDraftStore();
    final QuickAddFlowService service = QuickAddFlowService(
      draftStore: store,
      createTask: (CreateTaskInput input) async => _buildTask(input),
      now: () => DateTime(2026, 5, 26, 10),
    );
    final QuickAddDraft draft = service.prepareDraft(
      source: QuickAddEntrySource.deepLink,
      draftText: '回家拿文件',
    );

    final QuickAddFlowResult result = await service.returnToApp(draft);

    expect(result.status, QuickAddFlowStatus.returnedToApp);
    expect(result.routePath, RoutePaths.home);
    expect(await store.read(), isNotNull);
  });
}

Task _buildTask(CreateTaskInput input) {
  return Task(
    id: 'task-1',
    title: input.title,
    note: input.note,
    status: TaskStatus.active,
    dueAt: input.dueAt,
    isPinned: input.isPinned,
    isPrivate: input.isPrivate,
    reminderMode: input.reminderMode,
    createdAt: DateTime(2026, 5, 26, 10),
    updatedAt: DateTime(2026, 5, 26, 10),
  );
}

class _MemoryQuickAddDraftStore implements QuickAddDraftStore {
  QuickAddDraft? _draft;

  @override
  Future<void> clear() async {
    _draft = null;
  }

  @override
  Future<QuickAddDraft?> read() async => _draft;

  @override
  Future<void> save(QuickAddDraft draft) async {
    _draft = draft;
  }
}
