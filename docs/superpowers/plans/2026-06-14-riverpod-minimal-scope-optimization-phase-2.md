# Riverpod Minimal Scope Optimization Phase 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 收敛 `settings_center` 与 `history_center` 的重复 Provider 失效重读链路，并保持已有页面数据在刷新期间不被整页 loading 清空。

**Architecture:** 延续 `task_flow` 第一阶段做法，把 `SettingsCenterController` 与 `HistoryCenterController` 的刷新主路径改为直接调用对应 `Load...SnapshotUseCase`，不再依赖 `invalidate(snapshotProvider) + read(future)`。页面层保持不动，风险集中在 Provider 控制器与现有页面测试，确保设置页的全局偏好同步语义和历史页的跨模块首页补偿刷新语义不回退。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, flutter_test

---

## 文件结构

- 修改：`lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
  负责设置页刷新、写后刷新、全局偏好同步的 Provider 控制器收敛。
- 修改：`lib/features/history_center/application/providers/history_center_runtime_providers.dart`
  负责历史页刷新、恢复链路、跨模块首页补偿刷新的 Provider 控制器收敛。
- 修改：`test/features/settings_center/presentation/settings_center_page_test.dart`
  承接设置页控制器刷新语义回归测试，避免新增平行测试宿主。
- 修改：`test/features/history_center/presentation/history_center_page_test.dart`
  承接历史页控制器刷新与恢复降级语义回归测试。

### Task 1: 收敛 settings_center 刷新链路

**Files:**
- Modify: `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
- Test: `test/features/settings_center/presentation/settings_center_page_test.dart`

- [ ] **Step 1: 写出设置控制器失败用例**

在 `test/features/settings_center/presentation/settings_center_page_test.dart` 增加控制器级测试，覆盖“刷新不依赖基础 snapshot provider 失效重读”和“已有旧快照时不立刻清空数据”两条语义。可直接追加到 `main()` 末尾，使用 `ProviderContainer` 读取控制器：

```dart
  test('settings refresh 不应依赖基础 snapshot provider 的二次失效重读', () async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );
    final container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsCenterControllerProvider.future);
    var invalidated = false;
    container.listen<AsyncValue<SettingsCenterSnapshot>>(
      settingsCenterSnapshotProvider,
      (_, __) {
        invalidated = true;
      },
      fireImmediately: false,
    );

    await container.read(settingsCenterControllerProvider.notifier).refresh();

    expect(invalidated, isFalse);
  });

  test('settings refresh 有旧快照时不会立刻清空页面数据', () async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
      loadDelay: const Duration(milliseconds: 10),
    );
    final container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    final firstSnapshot = await container.read(
      settingsCenterControllerProvider.future,
    );

    final refreshFuture =
        container.read(settingsCenterControllerProvider.notifier).refresh();

    expect(
      container.read(settingsCenterControllerProvider).valueOrNull,
      equals(firstSnapshot),
    );

    await refreshFuture;
  });
```

- [ ] **Step 2: 运行设置页测试并确认先失败**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`

Expected: FAIL，失败点应落在 `SettingsCenterController.refresh()` 仍会触发 `settingsCenterSnapshotProvider` 失效重读，或在刷新起始阶段丢失旧快照。

- [ ] **Step 3: 用最小实现改 settings_center 控制器**

把 `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart` 中 `SettingsCenterController` 的刷新主路径改成和 `task_flow` 一致的 `_loadingState() + _loadSnapshot()`，并删除 `_reloadSnapshot()`。目标形态如下：

```dart
  Future<void> refresh() async {
    state = _loadingState();
    state = await AsyncValue.guard(_loadSnapshot);
  }

  Future<void> updatePrivacyMode({
    required bool enabled,
    required String feedbackText,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      final SettingsCenterPreferences next = await ref
          .read(updatePrivacyModeUseCaseProvider)
          .execute(enabled: enabled);
      _syncGlobalPreferences(next);
      _showFeedback(feedbackText);
      return _loadSnapshot();
    });
  }

  Future<SettingsCenterSnapshot> _loadSnapshot() {
    return ref.read(loadSettingsCenterSnapshotUseCaseProvider).execute();
  }

  AsyncValue<SettingsCenterSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<SettingsCenterSnapshot>() => state,
      _ => const AsyncLoading<SettingsCenterSnapshot>(),
    };
  }
```

同样模式同步改 `updateWidgetDisplayMode()`、`updateThemeModePreference()`、`updateLanguagePreference()`、`reviewNotificationPermission()`，但保留 `_syncGlobalPreferences()` 与 `_showFeedback()` 不变。

- [ ] **Step 4: 运行设置页测试确认转绿**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`

Expected: PASS，原有页面测试和新加的控制器回归测试都通过。

### Task 2: 保住 settings 全局偏好同步语义

**Files:**
- Modify: `test/features/settings_center/presentation/settings_center_page_test.dart`

- [ ] **Step 1: 写出全局偏好同步失败用例**

继续在 `test/features/settings_center/presentation/settings_center_page_test.dart` 中增加一条控制器测试，直接验证 `updateThemeModePreference()` 或 `updateLanguagePreference()` 后 `currentSettingsCenterPreferencesProvider` 已同步变化：

```dart
  test('settings 更新主题后会同步根应用消费的当前偏好', () async {
    final preferencesRepository = _InMemorySettingsPreferencesRepository(
      initial: const SettingsCenterPreferences(),
    );
    final notificationRepository = _FakeNotificationPermissionRepository(
      initialStatus: NotificationPermissionStatus.enabled,
    );
    final container = ProviderContainer(
      overrides: [
        settingsPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
        notificationPermissionRepositoryProvider.overrideWithValue(
          notificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(settingsCenterControllerProvider.future);

    await container.read(settingsCenterControllerProvider.notifier)
        .updateThemeModePreference(
          mode: SettingsThemeModePreference.dark,
          feedbackText: 'theme updated',
        );

    expect(
      container
          .read(currentSettingsCenterPreferencesProvider)
          .themeModePreference,
      SettingsThemeModePreference.dark,
    );
  });
```

- [ ] **Step 2: 运行单测验证当前行为**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`

Expected: 可能直接 PASS；若如此，保留该回归测试作为语义护栏，继续后续步骤，不需要强行制造新的失败点。

- [ ] **Step 3: 对照实现确认不误伤全局同步入口**

检查 `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`，确保以下代码仍保留：

```dart
  void _syncGlobalPreferences(SettingsCenterPreferences preferences) {
    ref
        .read(settingsCenterPreferencesControllerProvider.notifier)
        .sync(preferences);
  }
```

并确保所有偏好更新入口仍先拿到 `next`，再调用 `_syncGlobalPreferences(next)` 后刷新快照。

- [ ] **Step 4: 再次运行设置页测试确认整体稳定**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`

Expected: PASS，说明页面操作、控制器刷新、根应用偏好同步三条语义同时成立。

### Task 3: 收敛 history_center 刷新与恢复链路

**Files:**
- Modify: `lib/features/history_center/application/providers/history_center_runtime_providers.dart`
- Test: `test/features/history_center/presentation/history_center_page_test.dart`

- [ ] **Step 1: 写出 history 控制器失败用例**

在 `test/features/history_center/presentation/history_center_page_test.dart` 中增加控制器测试，至少覆盖“refresh 不再依赖基础 snapshot provider 失效重读”和“restore 成功后首页刷新失败不影响历史恢复结果”。可复用现有 `_TaskFlowTestRuntime`：

```dart
  test('history refresh 不应依赖基础快照 provider 的二次失效重读', () async {
    final runtime = _TaskFlowTestRuntime.create();
    addTearDown(runtime.dispose);
    final container = ProviderContainer(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(runtime.database),
        taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
        taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(historyCenterControllerProvider.future);
    var invalidated = false;
    container.listen<AsyncValue<HistoryCenterSnapshot>>(
      historyCenterSnapshotProvider,
      (_, __) {
        invalidated = true;
      },
      fireImmediately: false,
    );

    await container.read(historyCenterControllerProvider.notifier).refresh();

    expect(invalidated, isFalse);
  });
```

再补一条首页刷新降级测试，思路是覆盖 `taskFlowHomeControllerProvider` 为会抛错的 fake notifier，随后断言 `restoreTask()` 仍成功完成，且事项状态回到 `active`。

- [ ] **Step 2: 运行历史页测试并确认先失败**

Run: `rtk flutter test test/features/history_center/presentation/history_center_page_test.dart`

Expected: FAIL，失败点应落在 `HistoryCenterController.refresh()` 仍会使 `historyCenterSnapshotProvider` 重新失效，或恢复链路没有被回归测试稳定覆盖。

- [ ] **Step 3: 用最小实现改 history_center 控制器**

把 `lib/features/history_center/application/providers/history_center_runtime_providers.dart` 中 `refresh()` 和 `restoreTask()` 改成直接复用 `_loadingState() + _loadSnapshot()`，并删掉 `_reloadSnapshot()`。目标形态如下：

```dart
  Future<void> refresh() async {
    state = _loadingState();
    state = await AsyncValue.guard(_loadSnapshot);
  }

  Future<void> restoreTask({
    required String taskId,
    DateTime? occurredAt,
    required String successMessage,
  }) async {
    state = _loadingState();
    state = await AsyncValue.guard(() async {
      await ref.read(updateTaskStatusUseCaseProvider).restoreTask(
            taskId: taskId,
            occurredAt: occurredAt ?? DateTime.now(),
          );
      await _refreshTaskFlowHomeSnapshot();
      ref.read(appShellUiStateControllerProvider.notifier).showFeedback(
            AppShellFeedbackMessage(
              level: AppShellFeedbackLevel.info,
              text: successMessage,
            ),
          );
      return _loadSnapshot();
    });
  }

  Future<HistoryCenterSnapshot> _loadSnapshot() {
    return ref.read(loadHistoryCenterSnapshotUseCaseProvider).execute();
  }

  AsyncValue<HistoryCenterSnapshot> _loadingState() {
    return switch (state) {
      AsyncData<HistoryCenterSnapshot>() => state,
      _ => const AsyncLoading<HistoryCenterSnapshot>(),
    };
  }
```

`_refreshTaskFlowHomeSnapshot()` 中吞异常降级的逻辑与中文注释保持不变。

- [ ] **Step 4: 运行历史页测试确认转绿**

Run: `rtk flutter test test/features/history_center/presentation/history_center_page_test.dart`

Expected: PASS，原有页面测试和新增控制器回归测试都通过。

### Task 4: 运行模块验证与静态检查

**Files:**
- Modify: `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
- Modify: `lib/features/history_center/application/providers/history_center_runtime_providers.dart`
- Modify: `test/features/settings_center/presentation/settings_center_page_test.dart`
- Modify: `test/features/history_center/presentation/history_center_page_test.dart`

- [ ] **Step 1: 运行 settings 模块验证**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`

Expected: PASS。

- [ ] **Step 2: 运行 history 模块验证**

Run: `rtk flutter test test/features/history_center/presentation/history_center_page_test.dart`

Expected: PASS。

- [ ] **Step 3: 运行受影响通路的补充验证**

Run: `rtk flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart`

Expected: PASS，证明历史模块跨模块刷新首页的补偿路径没有把第一阶段结果打回去。

- [ ] **Step 4: 运行静态检查**

Run: `rtk flutter analyze`

Expected: PASS，无新增 analyzer error 或 warning。

- [ ] **Step 5: 检查最终差异是否只落在计划文件范围内**

Run: `git diff -- lib/features/settings_center/application/providers/settings_center_runtime_providers.dart lib/features/history_center/application/providers/history_center_runtime_providers.dart test/features/settings_center/presentation/settings_center_page_test.dart test/features/history_center/presentation/history_center_page_test.dart docs/superpowers/specs/2026-06-14-riverpod-minimal-scope-optimization-phase-2-design.md docs/superpowers/plans/2026-06-14-riverpod-minimal-scope-optimization-phase-2.md`

Expected: Diff 只包含第二阶段 Provider、测试与文档改动。
