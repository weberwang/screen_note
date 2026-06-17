# App Edge-to-Edge Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把应用切到全局 `edge-to-edge` 模式，让页面背景延伸到系统栏下方，同时保留现有正文 `SafeArea`。

**Architecture:** 启动阶段统一设置 `SystemUiMode.edgeToEdge`，根应用层统一提供透明系统栏与图标样式。页面层不单独接管系统栏，也不调整业务布局结构。

**Tech Stack:** Flutter、MaterialApp.router、SystemChrome、flutter_test

---

### Task 1: 补启动阶段失败测试

**Files:**
- Create: `test/app/bootstrap/app_bootstrap_test.dart`

- [ ] 写 bootstrap 的失败测试，断言启动阶段会请求 `SystemUiMode.edgeToEdge`
- [ ] 运行单测确认在改实现前先失败

### Task 2: 实现全局 edge-to-edge 装配

**Files:**
- Modify: `lib/app/bootstrap/app_bootstrap.dart`
- Modify: `lib/app/app.dart`

- [ ] 在 bootstrap 阶段开启 `SystemUiMode.edgeToEdge`
- [ ] 在根应用层统一收口系统栏透明背景与图标样式
- [ ] 保持现有 `SafeArea` 和页面业务逻辑不变

### Task 3: 验证与回归

**Files:**
- Test only

- [ ] 重新运行新增 bootstrap 测试并确认通过
- [ ] 运行 `test/app/bootstrap/local_notifications_bootstrap_test.dart`
- [ ] 运行根应用相关测试，确认装配未回归
