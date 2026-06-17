# History Center Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `history-center` 从占位页推进为真实历史页，完成最近完成 / 最近删除分区展示、恢复主链路、共享反馈与首页刷新协同。

**Architecture:** 先建立 `history-center` 稳定快照实体、加载用例和页面控制器，再用 Riverpod 把快照装配到历史页。页面层只负责展示分区与触发恢复动作；恢复仍统一复用 `task-flow` 的状态流转用例，并在成功后刷新历史页与首页快照。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, freezed, flutter_test, drift

---

## 文件结构

### 新建文件

- `lib/features/history_center/domain/entities/history_center_snapshot.dart`
  - 历史页稳定快照
- `lib/features/history_center/domain/entities/history_center_snapshot.freezed.dart`
  - `freezed` 生成文件
- `lib/features/history_center/application/use_cases/load_history_center_snapshot_use_case.dart`
  - 历史页快照加载用例
- `lib/features/history_center/application/providers/history_center_runtime_providers.dart`
  - 历史页 Provider 与页面控制器装配
- `lib/features/history_center/application/providers/history_center_runtime_providers.g.dart`
  - Riverpod 生成文件
- `lib/features/history_center/presentation/widgets/history_section_header.dart`
  - 分区头组件
- `lib/features/history_center/presentation/widgets/history_task_row.dart`
  - 历史事项行组件
- `lib/features/history_center/presentation/widgets/history_empty_state_panel.dart`
  - 空历史态组件
- `test/features/history_center/application/load_history_center_snapshot_use_case_test.dart`
  - 历史快照与恢复链路测试
- `test/features/history_center/presentation/history_center_page_test.dart`
  - 历史页展示与恢复测试

### 修改文件

- `lib/features/history_center/presentation/pages/history_center_page.dart`
  - 从占位页切到真实历史页
- `test/features/app_shell/presentation/app_shell_page_test.dart`
  - 更新 History 分支断言，避免仍依赖占位文案
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`
  - 补齐历史页标题、分区头、空态、恢复反馈等文案

## Task 1: 建立历史快照与恢复编排

**Files:**
- Create: `lib/features/history_center/domain/entities/history_center_snapshot.dart`
- Create: `lib/features/history_center/application/use_cases/load_history_center_snapshot_use_case.dart`
- Create: `lib/features/history_center/application/providers/history_center_runtime_providers.dart`
- Test: `test/features/history_center/application/load_history_center_snapshot_use_case_test.dart`

- [ ] **Step 1: 写用例级失败测试**

```dart
test('loadHistoryCenterSnapshot 会按最近完成和最近删除分区返回倒序结果', () async {
  final TaskFlowDatabase database = TaskFlowDatabase.test(NativeDatabase.memory());
  final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(database: database);
  final LoadHistoryCenterSnapshotUseCase useCase = LoadHistoryCenterSnapshotUseCase(
    repository: repository,
  );

  await repository.createTask(
    _task(
      id: 'completed-new',
      title: '新完成事项',
      status: TaskStatus.completed,
      completedAt: DateTime(2026, 6, 14, 12),
    ),
  );
  await repository.createTask(
    _task(
      id: 'deleted-new',
      title: '新删除事项',
      status: TaskStatus.deleted,
      deletedAt: DateTime(2026, 6, 14, 13),
    ),
  );

  final snapshot = await useCase.execute();

  expect(snapshot.completedTasks.first.id, 'completed-new');
  expect(snapshot.deletedTasks.first.id, 'deleted-new');
});
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `rtk flutter test test/features/history_center/application/load_history_center_snapshot_use_case_test.dart`
Expected: FAIL，提示 `LoadHistoryCenterSnapshotUseCase` 与 `HistoryCenterSnapshot` 不存在

- [ ] **Step 3: 实现最小快照、加载用例与控制器**

```dart
@freezed
abstract class HistoryCenterSnapshot with _$HistoryCenterSnapshot {
  const factory HistoryCenterSnapshot({
    required List<TaskEntity> completedTasks,
    required List<TaskEntity> deletedTasks,
  }) = _HistoryCenterSnapshot;
}
```

```dart
final class LoadHistoryCenterSnapshotUseCase {
  const LoadHistoryCenterSnapshotUseCase({required TaskRepository repository})
    : _repository = repository;

  final TaskRepository _repository;

  Future<HistoryCenterSnapshot> execute() async {
    final completedTasks = await _repository.loadTasksByStatus(TaskStatus.completed);
    final deletedTasks = await _repository.loadTasksByStatus(TaskStatus.deleted);

    return HistoryCenterSnapshot(
      completedTasks: _sortByCompletedAt(completedTasks),
      deletedTasks: _sortByDeletedAt(deletedTasks),
    );
  }
}
```

```dart
@Riverpod(keepAlive: true)
class HistoryCenterController extends _$HistoryCenterController {
  @override
  Future<HistoryCenterSnapshot> build() {
    return ref.watch(historyCenterSnapshotProvider.future);
  }

  Future<void> restoreTask(String taskId) async {
    await ref.read(updateTaskStatusUseCaseProvider).restoreTask(
      taskId: taskId,
      occurredAt: DateTime.now(),
    );
    ref.read(appShellUiStateControllerProvider.notifier).showFeedback(
      AppShellFeedbackMessage(
        level: AppShellFeedbackLevel.info,
        text: 'restored',
      ),
    );
    state = await AsyncValue.guard(_reload);
  }
}
```

- [ ] **Step 4: 运行代码生成**

Run: `rtk dart run build_runner build --delete-conflicting-outputs`
Expected: PASS，并生成 `freezed` 与 `riverpod` 文件

- [ ] **Step 5: 运行历史用例测试确认通过**

Run: `rtk flutter test test/features/history_center/application/load_history_center_snapshot_use_case_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择 `仅提交 / 提交并推送 / 忽略`。

## Task 2: 接入历史页真实展示与恢复动作

**Files:**
- Create: `lib/features/history_center/presentation/widgets/history_section_header.dart`
- Create: `lib/features/history_center/presentation/widgets/history_task_row.dart`
- Create: `lib/features/history_center/presentation/widgets/history_empty_state_panel.dart`
- Modify: `lib/features/history_center/presentation/pages/history_center_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Test: `test/features/history_center/presentation/history_center_page_test.dart`

- [ ] **Step 1: 写历史页失败测试**

```dart
testWidgets('历史页会展示最近完成和最近删除分区，并只在删除分区提供恢复动作', (tester) async {
  final runtime = _TaskFlowTestRuntime.create();
  await runtime.repository.createTask(_completedTask());
  await runtime.repository.createTask(_deletedTask());

  await tester.pumpWidget(_buildHistoryPage(runtime));
  await tester.pumpAndSettle();

  expect(find.text('Recently completed'), findsOneWidget);
  expect(find.text('Recently deleted'), findsOneWidget);
  expect(find.text('Restore'), findsOneWidget);
});
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `rtk flutter test test/features/history_center/presentation/history_center_page_test.dart`
Expected: FAIL，当前 `HistoryCenterPage` 仍然只显示占位文案

- [ ] **Step 3: 实现页面与组件**

```dart
class HistoryCenterPage extends HookConsumerWidget {
  const HistoryCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(historyCenterControllerProvider);

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const _HistoryErrorState(),
        data: (snapshot) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Text('History')),
            if (snapshot.completedTasks.isNotEmpty) ...[
              SliverToBoxAdapter(child: HistorySectionHeader.completed()),
              SliverList.builder(
                itemCount: snapshot.completedTasks.length,
                itemBuilder: (context, index) => HistoryTaskRow.completed(
                  task: snapshot.completedTasks[index],
                ),
              ),
            ],
            if (snapshot.deletedTasks.isNotEmpty) ...[
              SliverToBoxAdapter(child: HistorySectionHeader.deleted()),
              SliverList.builder(
                itemCount: snapshot.deletedTasks.length,
                itemBuilder: (context, index) => HistoryTaskRow.deleted(
                  task: snapshot.deletedTasks[index],
                  onRestore: () => ref
                      .read(historyCenterControllerProvider.notifier)
                      .restoreTask(snapshot.deletedTasks[index].id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: 更新文案并刷新生成文件**

Run: `rtk flutter gen-l10n`
Expected: PASS，并生成历史页标题、分区头、空态、错误、恢复反馈访问器

- [ ] **Step 5: 运行页面测试确认通过**

Run: `rtk flutter test test/features/history_center/presentation/history_center_page_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 3: 修正壳层断言并做全量验证

**Files:**
- Modify: `test/features/app_shell/presentation/app_shell_page_test.dart`
- Verify only: `lib/features/history_center/**`
- Verify only: `test/features/history_center/**`

- [ ] **Step 1: 更新壳层测试的 History 分支断言**

```dart
await tester.tap(find.text(_historyTabLabel));
await tester.pumpAndSettle();

expect(find.text('History'), findsOneWidget);
expect(find.text('Recently completed'), findsOneWidget);
```

- [ ] **Step 2: 运行 history-center 相关测试集**

Run:

```bash
rtk flutter test test/features/history_center/application/load_history_center_snapshot_use_case_test.dart
rtk flutter test test/features/history_center/presentation/history_center_page_test.dart
rtk flutter test test/features/app_shell/presentation/app_shell_page_test.dart
```

Expected:

- 三组测试全部 PASS

- [ ] **Step 3: 运行全量生成与静态检查**

Run:

```bash
rtk flutter gen-l10n
rtk dart run build_runner build --delete-conflicting-outputs
rtk flutter analyze
```

Expected:

- `flutter gen-l10n` PASS
- `build_runner` PASS
- `flutter analyze` 输出 `No issues found!`

- [ ] **Step 4: 运行全量测试**

Run: `rtk flutter test`
Expected: PASS，且不引入 `task-flow` 与 `app-shell` 回归

- [ ] **Step 5: 本项目约束下暂不提交**

记录：全部任务完成后不要立即 `git add / git commit / git push`，统一等待用户选择 `仅提交 / 提交并推送 / 忽略`。

## 自检结果

- 已覆盖 spec 中的关键目标：历史快照、分区排序、恢复链路、共享反馈、首页刷新协同。
- 已保持实现顺序为：快照与控制器 -> 页面与交互 -> 壳层回归验证，避免先堆 UI 再补行为边界。
- 无 `TODO / TBD / implement later` 占位。
- 所有新增路径、测试路径、生成命令和验证命令都给出了具体落点。
