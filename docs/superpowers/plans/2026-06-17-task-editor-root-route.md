# Task Editor Root Route Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `task-flow` 编辑页提升为独立根级路由，并保持首页、quick add 与 Widget 回流都能稳定进入该页。

**Architecture:** 保持现有 `StatefulShellRoute` 负责三大分支，把 `task-editor` 从 `home` 子树移到根级 `GoRoute`。所有编辑页入口统一改为使用新的绝对路径常量，避免页面层再手拼 `home` 前缀。

**Tech Stack:** Flutter、go_router、hooks_riverpod、flutter_test

---

### Task 1: 路由树调整

**Files:**
- Modify: `lib/app/router/route_paths.dart`
- Modify: `lib/app/router/app_router.dart`
- Modify: `lib/features/app_shell/application/app_shell_launch_resolver.dart`

- [ ] 把 `taskEditor` 改为绝对路径常量
- [ ] 从 `home` 分支移除 `task-editor` 子路由
- [ ] 在根级新增 `task-editor` 路由
- [ ] 同步更新启动落点拼接与解析逻辑

### Task 2: 编辑页入口统一

**Files:**
- Modify: `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- Modify: `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`

- [ ] quick add 改为跳转根级编辑页
- [ ] 首页主卡片与队列行改为跳转根级编辑页
- [ ] 清理旧的 `home + taskEditor` 路径拼接

### Task 3: 测试更新

**Files:**
- Modify: `test/features/task_flow/presentation/task_flow_home_page_test.dart`
- Modify: `test/features/app_shell/presentation/app_shell_page_test.dart`
- Modify: `test/features/app_shell/app_shell_launch_routing_test.dart`
- Modify: `test/features/app_shell/widget_launch_routing_test.dart`
- Modify: `test/features/app_shell/application/app_router_launch_test.dart`
- Modify: `test/features/app_shell/application/widget_launch_bridge_test.dart`
- Modify: `test/features/app_shell/application/app_shell_launch_resolver_test.dart`

- [ ] 更新路由测试中的目标路径
- [ ] 更新首页进入编辑页测试用的测试路由树
- [ ] 验证初始启动到编辑页时不再经过 shell
- [ ] 验证运行时回流仍能进入编辑页

### Task 4: 验证

**Files:**
- Test only

- [ ] 运行受影响测试
- [ ] 运行相关 analyze
