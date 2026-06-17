# History Center Empty State Asset Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 基于最新效果图，为 `history-center` 空状态落地独立插图资源和新的页面级空状态显示层。

**Architecture:** 先生成单独插图资源图，再由 `HistoryEmptyStatePanel` 负责组合插图、文案和圆形 `+` 动作。`HistoryCenterPage` 只在 `snapshot.isEmpty` 时切到新分支，并通过现有根级 `task-editor` 路由进入新建链路。

**Tech Stack:** Flutter、go_router、hooks_riverpod、flutter_test、gpt-image-2

---

### Task 1: 生成插图资源

**Files:**
- Create: `assets/history_center/history-empty-illustration.png`

- [ ] 用 `gpt-image-2-generator` 生成单独插图资源图
- [ ] 确认资源图不包含整页文案和按钮

### Task 2: 接入资源与空状态布局

**Files:**
- Modify: `pubspec.yaml`
- Modify: `lib/features/history_center/presentation/pages/history_center_page.dart`
- Modify: `lib/features/history_center/presentation/widgets/history_empty_state_panel.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`

- [ ] 声明 `assets/history_center/` 资源目录
- [ ] 空状态组件改为插图 + 文案 + 圆形 `+` 动作
- [ ] `+` 动作接到 `RoutePaths.taskEditor`
- [ ] 补齐空状态文案和无障碍 tooltip 的国际化

### Task 3: 测试与验证

**Files:**
- Modify: `test/features/history_center/presentation/history_center_page_test.dart`

- [ ] 断言空状态新文案
- [ ] 断言空状态不再使用卡片组件
- [ ] 断言点击 `+` 会进入事项编辑页新建态
- [ ] 跑测试和 analyze
