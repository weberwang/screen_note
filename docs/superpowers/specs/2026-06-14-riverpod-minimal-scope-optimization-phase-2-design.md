# Riverpod 最小范围优化第二阶段设计

## 背景

第一阶段已经收敛了 `task_flow` 的重复刷新链路，但 `settings_center` 与 `history_center` 仍保留同类问题：

- 控制器刷新仍通过 `invalidate(snapshotProvider) + read(snapshotProvider.future)` 触发基础快照 Provider 的二次失效重读。
- 写后刷新或手动刷新会切换到整页 `AsyncLoading`，导致页面已有稳定数据时仍出现整屏转圈。
- `history_center` 还包含跨模块首页补偿刷新，处理时必须保证恢复主链路不被首页刷新失败拖垮。

本阶段只处理上述两个模块的最小范围收敛，目标是延续第一阶段的控制器模式，不扩展到页面结构拆分或更大范围的 Riverpod 重构。

## 范围

本阶段包含：

- `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
- `lib/features/history_center/application/providers/history_center_runtime_providers.dart`
- 对应测试文件的补充或调整

本阶段不包含：

- `settings_center_page.dart`、`history_center_page.dart` 的组件拆分或更细粒度 `select` 监听
- `SettingsCenterPreferencesController` 的架构重构
- `app.dart`、`app_shell` 的监听策略调整
- 任何新的状态模型、分页模型或缓存层

## 设计

### 1. settings_center 控制器收敛

`SettingsCenterController` 延续 `task_flow` 的方式，统一改为直接调用 `LoadSettingsCenterSnapshotUseCase` 主动加载快照，而不是依赖基础 `settingsCenterSnapshotProvider` 的显式失效重读。

具体策略：

- `build()` 仍保留通过 `settingsCenterSnapshotProvider.future` 完成首次加载，维持现有入口不变。
- `refresh()`、`updatePrivacyMode()`、`updateWidgetDisplayMode()`、`updateThemeModePreference()`、`updateLanguagePreference()`、`reviewNotificationPermission()` 都改为复用 `_loadingState()` 与 `_loadSnapshot()`。
- `_loadSnapshot()` 只负责 `ref.read(loadSettingsCenterSnapshotUseCaseProvider).execute()`。
- `_loadingState()` 与第一阶段保持一致：若当前已有 `AsyncData<SettingsCenterSnapshot>`，则直接保留旧状态；仅在无旧数据时进入 `AsyncLoading`。

这样可以避免设置页在每次写后刷新时重复触发底层 FutureProvider 失效，也避免页面已有数据时整页闪烁。

### 2. settings_center 全局偏好同步语义保留

设置模块和 `task_flow` 不同，它还承担根应用主题、语言等全局偏好的同步职责，因此本阶段不会移除 `_syncGlobalPreferences()`。

必须保持的语义：

- 更新隐私、展示模式、主题、语言成功后，仍先通过 `_syncGlobalPreferences()` 直接覆盖 `settingsCenterPreferencesController`。
- `currentSettingsCenterPreferencesProvider` 继续作为 `MaterialApp` 的稳定同步偏好来源。
- 本阶段不修改 `SettingsCenterPreferencesController.refresh()`，因为它属于根应用偏好同步入口，不属于本次“页面快照重复失效链路”问题本身。

这能保证优化设置页刷新方式时，不把全局主题/语言切换语义一并打散。

### 3. history_center 控制器收敛

`HistoryCenterController` 也采用相同模式：直接通过 `LoadHistoryCenterSnapshotUseCase` 重载历史快照，而不是 `invalidate(historyCenterSnapshotProvider) + read(future)`。

具体策略：

- `refresh()` 改为 `_loadingState() + _loadSnapshot()`。
- `restoreTask()` 在完成恢复后，仍保持“先尝试刷新首页，再刷新历史页自身”的顺序，但历史页自身刷新改为 `_loadSnapshot()`。
- `_loadingState()` 同样保留旧快照，避免历史页已有数据时因为恢复动作整页切成 loading。

### 4. history_center 跨模块补偿刷新语义保留

`restoreTask()` 当前存在一条明确的业务约束：恢复成功后要尽量让首页同步，但首页刷新失败只能做能力降级，不能把恢复误判为失败。

本阶段必须保留：

- `_refreshTaskFlowHomeSnapshot()` 继续通过 `taskFlowHomeControllerProvider.notifier.refresh()` 做补偿刷新。
- 失败继续吞掉异常，只保留注释说明是能力降级。
- 历史页自身最终仍应返回最新 `HistoryCenterSnapshot`，不因为首页同步失败而中断恢复结果。

### 5. 页面层保持不动

`SettingsCenterPage` 与 `HistoryCenterPage` 继续 `ref.watch(...ControllerProvider)`，本阶段不做页面结构拆分。

原因：

- 当前的主要浪费在控制器层的重复失效与重读，不在页面 `watch` 结构本身。
- 只要控制器在已有快照时不切成全屏 `AsyncLoading`，页面现有 `when(...)` 分支就不会在写后刷新中反复整页闪烁。
- 这样可以把风险控制在 Provider 层，避免在同一阶段同时引入 UI 结构改动。

## 测试策略

需要补齐或更新以下验证：

- `settings_center` 控制器测试：验证 `refresh()` 不再依赖 `settingsCenterSnapshotProvider` 的显式失效重读。
- `settings_center` 控制器测试：验证已有旧快照时刷新不会立刻清空页面数据。
- `settings_center` 控制器测试：验证偏好更新后仍会同步 `settingsCenterPreferencesController`，不破坏根应用主题/语言来源。
- `history_center` 控制器测试：验证 `refresh()` 不再依赖 `historyCenterSnapshotProvider` 的显式失效重读。
- `history_center` 控制器测试：验证 `restoreTask()` 仍会尝试刷新首页，但首页刷新失败不会让恢复链路失败。
- 相关页面或模块测试继续跑通，确保现有 UI 与降级语义不回退。

## 验收标准

- `settings_center` 与 `history_center` 都不再使用 `invalidate(snapshotProvider) + read(snapshotProvider.future)` 作为刷新主路径。
- 两个模块在已有快照时执行刷新或写后刷新，不会立刻切到整页 loading。
- 设置页的主题、语言、隐私、展示模式更新后，根应用同步偏好语义保持不变。
- 历史页恢复事项后，首页刷新失败仍只做降级，不影响恢复成功结果。
- 第二阶段相关测试与 `flutter analyze` 通过。
