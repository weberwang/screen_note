# Riverpod Minimal Scope Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 先在 `task_flow` 模块收敛 Riverpod 重复刷新链路，并保留已有首页快照以减少整页 loading 抖动。

**Architecture:** 保留 `TaskFlowHomeController` 作为首页和编辑页写后刷新的单一入口。控制器内部直接读取 `LoadTaskFeedUseCase` 重新加载快照，不再通过 `invalidate + read(taskFlowHomeSnapshotProvider.future)` 触发重复 Provider 刷新。已有数据刷新时保留旧快照，首次加载或无可用数据时才展示 loading。

**Tech Stack:** Flutter、hooks_riverpod、riverpod_annotation、drift 内存数据库测试、flutter_test。

---

## File Structure

- Modify: `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
  - 负责 `task_flow` 运行时 Provider 和 `TaskFlowHomeController` 刷新策略。
- Modify: `test/features/task_flow/presentation/task_flow_home_page_test.dart`
  - 增加控制器级行为测试，覆盖刷新时保留旧快照、写后刷新仍产出新快照。
- Run only: `test/features/task_flow/presentation/task_flow_editor_page_test.dart`
  - 验证编辑页保存成功后刷新失败仍降级，不阻断保存主链路。

## Task 1: Add Controller Refresh Regression Test

**Files:**
- Modify: `test/features/task_flow/presentation/task_flow_home_page_test.dart`

- [ ] **Step 1: Add test for keeping old snapshot while refresh runs**

In `test/features/task_flow/presentation/task_flow_home_page_test.dart`, inside `group('TaskFlowHomeController', () { ... })`, after the existing `createQuickTask 后会刷新首页快照` test, add this test:

```dart
    test('refresh 有旧快照时不会立刻清空首页数据', () async {
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(
        database: database,
      );
      final ProviderContainer container = ProviderContainer(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowMutationRepositoryProvider.overrideWithValue(repository),
          taskFlowRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);

      await repository.createTask(
        _buildTask(
          id: 'existing-task',
          title: '刷新前已有事项',
          createdAt: DateTime(2026, 6, 14, 8),
        ),
      );
      final TaskFeedSnapshot initialSnapshot = await container.read(
        taskFlowHomeControllerProvider.future,
      );
      expect(initialSnapshot.activeCount, 1);

      final Future<void> refreshFuture = container
          .read(taskFlowHomeControllerProvider.notifier)
          .refresh();

      final AsyncValue<TaskFeedSnapshot> refreshingState = container.read(
        taskFlowHomeControllerProvider,
      );
      expect(refreshingState.hasValue, isTrue);
      expect(refreshingState.requireValue.activeCount, 1);

      await refreshFuture;
    });
```

- [ ] **Step 2: Run focused test and verify it fails**

Run:

```powershell
rtk flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected result before implementation: the new test fails because `refresh()` currently sets `state = const AsyncLoading<TaskFeedSnapshot>()`, so `refreshingState.hasValue` is false or `requireValue` cannot read the old snapshot.

## Task 2: Implement Minimal Refresh Scope Change

**Files:**
- Modify: `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`

- [ ] **Step 1: Replace full-loading refresh with guarded reload that preserves old data**

In `TaskFlowHomeController`, replace the methods from `refresh()` through `_reloadSnapshot()` with this implementation:

```dart
  /// 主动刷新首页快照，供页面重试或后续系统回流场景复用。
  Future<void> refresh() async {
    state = _loadingState();
    state = await AsyncValue.guard(_loadSnapshot);
  }

  /// 创建快捷事项后立即刷新首页快照，确保首页不会停留在旧状态。
  Future<void> createQuickTask(CreateTaskInput input, {DateTime? now}) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      await ref.read(createTaskUseCaseProvider).execute(input, now: now);
      return _loadSnapshot();
    });
  }

  /// 完成事项后立即刷新首页快照，避免主事项卡片与队列展示滞后。
  Future<void> completeTask({
    required String taskId,
    required DateTime occurredAt,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
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
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      await ref
          .read(updateTaskStatusUseCaseProvider)
          .deleteTask(taskId: taskId, occurredAt: occurredAt);
      return _loadSnapshot();
    });
  }

  /// 已有快照刷新时保留旧数据，避免写后刷新把首页短暂清成全屏 loading。
  AsyncValue<TaskFeedSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<TaskFeedSnapshot>(:final value) => AsyncLoading<
        TaskFeedSnapshot
      >().copyWithPrevious(AsyncData<TaskFeedSnapshot>(value)),
      _ => const AsyncLoading<TaskFeedSnapshot>(),
    };
  }

  /// 统一读取首页快照用例，避免通过基础快照 Provider 做重复失效和重读。
  Future<TaskFeedSnapshot> _loadSnapshot() {
    return ref.read(loadTaskFeedUseCaseProvider).execute();
  }
```

Keep `build()` unchanged for now:

```dart
  /// 首次构建时读取首页快照。
  @override
  Future<TaskFeedSnapshot> build() {
    return ref.watch(taskFlowHomeSnapshotProvider.future);
  }
```

This keeps initial wiring stable while changing manual refresh paths only.

- [ ] **Step 2: Run focused test and verify it passes**

Run:

```powershell
rtk flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected result: all tests in `task_flow_home_page_test.dart` pass.

## Task 3: Verify Editor Save Degradation Still Holds

**Files:**
- Run only: `test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: Run editor page tests**

Run:

```powershell
rtk flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected result: all editor tests pass, especially `refresh 失败不会误报保存失败或重复创建事项`.

- [ ] **Step 2: If the refresh-failure test fails, preserve downgrade behavior**

Only if the test fails, inspect `TaskFlowEditorPage.saveTask()` and keep this pattern intact:

```dart
        try {
          // 写库成功就视为保存成功；后续首页刷新失败只能降级，不能把已保存结果误报成失败。
          await ref.read(taskFlowHomeControllerProvider.notifier).refresh();
        } catch (_) {}
```

Expected result after any necessary correction: refresh failure is swallowed after successful write, and the editor pops normally.

## Task 4: Run Module Verification

**Files:**
- Verify: `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
- Verify: `test/features/task_flow/presentation/task_flow_home_page_test.dart`
- Verify: `test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: Run task-flow application tests**

Run:

```powershell
rtk flutter test test/features/task_flow/application/task_flow_use_cases_test.dart
```

Expected result: all task-flow use case tests pass.

- [ ] **Step 2: Run static analysis**

Run:

```powershell
rtk flutter analyze
```

Expected result: no new analyzer errors.

- [ ] **Step 3: Review generated-file impact**

Run:

```powershell
git diff -- lib/features/task_flow/application/providers/task_flow_runtime_providers.dart test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected result: only manual source and test files changed. No generated `.g.dart` file should change because provider declarations and signatures remain unchanged.

## Self-Review

- Spec coverage: the plan covers the first-stage `task_flow` scope, keeps `TaskFlowHomeController` as the single write-after-refresh entry, removes `invalidate + read(future)` from manual refresh paths, preserves editor refresh degradation, and verifies task-flow tests plus analyzer.
- Placeholder scan: no placeholder tasks remain; every code edit step includes concrete code and exact commands.
- Type consistency: all referenced providers, entities, tests, and methods already exist in the current codebase. The implementation only uses `AsyncValue`, `AsyncData`, and `AsyncLoading` types already available through `riverpod_annotation` exports in the provider file.
