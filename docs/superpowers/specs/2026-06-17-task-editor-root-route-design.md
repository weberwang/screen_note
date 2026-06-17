# task-editor 独立根路由设计

## 1. 目标

把 `task-flow` 的编辑页从 `home` 分支子路由调整为独立根级路由，使编辑页进入后完全脱离 `StatefulShellRoute` 壳层，不再显示底部导航、全局 FAB 和壳层反馈宿主，同时继续保留现有的新建、编辑和 Widget 回流能力。

本次成功标准：

- 编辑页通过独立根级路由打开，不再渲染壳层 chrome。
- 首页主事项、列表行、quick add、Widget 回流仍能进入编辑页。
- 编辑页返回后能回到原有页面栈，不引入错误的双层返回。
- 现有页面测试和路由测试同步更新并保持通过。

## 2. 现状

- 当前 `task-editor` 定义在 [app_router.dart](D:/Projects/Flutter/screen_note/lib/app/router/app_router.dart) 的 `home` 分支子路由下。
- 当前路径常量是 [route_paths.dart](D:/Projects/Flutter/screen_note/lib/app/router/route_paths.dart) 里的 `taskEditor = 'task-editor'`。
- `AppShellPage` 会根据当前路径决定是否显示 FAB，但编辑页仍在 shell 体系内。
- 首页、quick add、Widget 回流和测试都依赖当前 `task-editor` 路径。

## 3. 方案

采用“独立根级路由”方案：

- `task-editor` 从 `home` 分支子路由中移出，提升为根级 `GoRoute`。
- 路径改为绝对路径，例如 `/task-editor`，继续支持 `taskId` 查询参数。
- `TaskFlowEditorPage` 继续复用当前页面实现，不重做页面结构。
- 所有进入编辑页的地方统一改为跳转到根级编辑路由，不再拼接 `home` 前缀。

## 4. 路由调整

- `app_router.dart`
  - 从 `StatefulShellBranch(home)` 内移除 `task-editor` 子路由。
  - 在根路由层新增 `GoRoute(path: RoutePaths.taskEditor, ...)`。
- `route_paths.dart`
  - 把 `taskEditor` 从相对路径改为绝对路径常量，避免页面层继续手拼。

## 5. 调用点调整

以下入口统一切到新的根级编辑路由：

- `TaskFlowHomePage` 主事项卡片和队列行
- `AppShellPage` quick add 主按钮
- `AppShellLaunchResolver` / Widget 回流落点
- 相关测试中的路由初始值和断言路径

## 6. 行为约束

- 编辑页进入后必须完整占满页面，不显示底栏、FAB 和共享壳层反馈。
- 返回逻辑仍然优先使用当前导航栈 `pop`，不强制改成固定回首页。
- 不修改编辑页保存逻辑、业务用例、数据层和表单状态。
- 不顺带重构其他页面路由结构。

## 7. 测试调整

至少更新这些测试：

- `test/features/task_flow/presentation/task_flow_home_page_test.dart`
- `test/features/task_flow/presentation/task_flow_editor_page_test.dart`
- `test/features/app_shell/presentation/app_shell_page_test.dart`
- `test/features/app_shell/app_shell_launch_routing_test.dart`
- `test/features/app_shell/widget_launch_routing_test.dart`
- 其他直接依赖 `RoutePaths.taskEditor` 的路由测试

重点验证：

- 首页点击仍能进入编辑页
- quick add 仍能进入编辑页
- Widget 回流仍能进入编辑页
- 编辑页出现时不再带 shell chrome

## 8. 风险与控制

- 风险：如果仍有入口拼接 `home + taskEditor`，会出现旧路径失效或测试断裂。
  - 控制：统一通过 `RoutePaths.taskEditor` 跳转，不保留旧拼接方式。
- 风险：Widget 回流仍按旧相对路径解析，会导致启动落点错误。
  - 控制：同步更新 `AppShellLaunchResolver` 相关规则和测试。
- 风险：根级路由调整后返回栈异常。
  - 控制：保留 `Navigator.pop` 语义，并通过页面测试覆盖从首页进入编辑页再返回的主链路。

## 9. 非目标

- 不修改 `task-flow` 编辑页的视觉稿。
- 不调整 `history-center`、`settings-center` 的路由结构。
- 不引入新的路由抽象层或导航服务。
