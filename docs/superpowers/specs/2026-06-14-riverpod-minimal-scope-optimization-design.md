# Riverpod 最小范围优化设计

## 背景

当前项目的 Riverpod 状态入口集中在 `task_flow`、`settings_center`、`history_center` 与应用壳层。初步排查发现，过量监听和刷新主要来自以下模式：

- 页面直接监听整页控制器状态，局部状态变化会带动页面级重建。
- 控制器刷新时使用 `invalidate + read(provider.future)`，导致基础快照 Provider 与控制器状态之间存在重复刷新链路。
- 写操作前统一把整页状态切换为 `AsyncLoading`，容易造成已展示内容短暂消失。

本次先按模块递进处理，避免一次性重构多个业务区域造成回归。

## 范围

第一阶段只处理 `task_flow` 模块：

- `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
- `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
- `lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
- 相关 `task_flow` 测试

暂不处理：

- `settings_center` 的设置页控制器刷新链路。
- `history_center` 的历史页恢复后联动刷新链路。
- 根应用主题、语言和路由 Provider。
- 大规模拆分首页组件树或重写状态管理方式。

## 设计

### 状态入口

保留 `TaskFlowHomeController` 作为首页唯一写后刷新入口。页面继续监听控制器，不新增并行状态源，避免首页、编辑页和跨模块入口出现不同步的刷新路径。

`taskFlowHomeSnapshotProvider` 只保留为控制器内部或轻量读取入口。控制器不再通过 `ref.invalidate(taskFlowHomeSnapshotProvider)` 强制失效再读取，而是通过 `LoadTaskFeedUseCase` 主动重新加载快照，减少 Provider 图中的重复刷新。

### 刷新策略

`refresh()`、`createQuickTask()`、`completeTask()`、`deleteTask()` 成功后都走同一个私有加载方法。该方法直接读取 `loadTaskFeedUseCaseProvider` 并执行，避免刷新策略散落。

写操作开始时优先保留旧快照。如果当前已有 `AsyncData`，刷新期间不把页面切换为全屏 loading；只有首次加载或没有可用快照时才呈现 loading。这样能缩小 UI 抖动范围，并保持错误状态可恢复。

### 编辑页联动

编辑页保存成功后继续调用 `taskFlowHomeControllerProvider.notifier.refresh()`。刷新失败仍然降级处理，不阻断已成功的创建或更新主链路。

本阶段不把编辑页保存流程改成新的控制器，避免扩大改动面。后续如果要进一步降低编辑页监听，可单独处理 `taskFlowTaskByIdProvider` 与表单回填。

### 测试

优先复用现有测试：

- `test/features/task_flow/application/task_flow_use_cases_test.dart`
- `test/features/task_flow/presentation/task_flow_home_page_test.dart`
- `test/features/task_flow/presentation/task_flow_editor_page_test.dart`

如现有断言覆盖不到刷新行为，可补充最小控制器测试，验证写后刷新不会依赖 `invalidate + future` 的重复链路，并确保保存失败/刷新失败仍保持既有降级语义。

## 后续阶段

第一阶段通过后，再按同一原则处理：

- `settings_center`：减少设置更新后的整页 loading 与重复快照失效。
- `history_center`：收敛恢复事项后的历史页与首页联动刷新。

每个模块独立验证，避免跨模块状态链路一次性变化。

## 验收标准

- `task_flow` 首页、编辑页既有交互保持不变。
- 写操作后首页能展示最新任务快照。
- 写库成功但首页刷新失败时，编辑页仍按既有逻辑返回，不误报保存失败。
- 不新增硬编码用户可见文案。
- 不引入新的手写全局单例或绕开 Riverpod 注解链路。
- 相关测试与静态检查通过。
