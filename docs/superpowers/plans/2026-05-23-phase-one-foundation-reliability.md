# Screen Note Phase 1 Foundation and Reliability Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段一可交付范围，先建立 `Pencil` 设计源与 Flutter 工程基线，再交付“事项不消失、可恢复、可追踪”的可靠性闭环。

**Architecture:** 当前仓库仍是 Flutter 示例级骨架，阶段一不能直接堆页面逻辑；必须先拆出 `app/`、`tasks/`、`history/`、`shared/`、`widget_bridge/` 等边界，再把状态流转、日志写入、排序和快照刷新触发统一下沉到应用层。`Pencil` 设计稿是显示层唯一设计源，本阶段必须先完成可靠性相关页面、组件和状态 `.pen` 设计稿，再参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 校准 token、层级和组件骨架，最后再让 Flutter 用最小验证页面对齐这些设计源。

**Tech Stack:** Flutter、hooks_riverpod、go_router、drift、freezed、json_serializable、intl、home_widget、flutter_local_notifications、Pencil

---

## 阶段一范围冻结

本计划把“阶段一”收敛为 `M0 工程基线 + M1 可靠性闭环 + 阶段一必需的 Pencil 设计源`，不提前实现以下内容：

- 不接真实 iOS WidgetKit 渲染，只预留 `widget_bridge/` 快照刷新接口和 App 内预览基线。
- 不接真实通知调度，只预留提醒字段、权限读取边界和后续接入点。
- 不做 App Intents、控制中心、锁屏入口、Action Button。
- 不做 Pro、iCloud、Apple Reminders、AI 提取、Android 等待名单。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  app/
  shared/
  tasks/
    application/
    data/
    domain/
    presentation/
  history/
    presentation/
  widget_bridge/
    application/
designs/
docs/
  superpowers/plans/
  screen-note-phase1-pencil-mapping-2026-05-23.md
test/
  tasks/
  history/
```

### 阶段一关键文件职责

- `lib/main.dart`：只保留启动入口，不再承载应用结构。
- `lib/src/app/app.dart`：集中应用壳层、主题、路由和国际化装配。
- `lib/src/app/router.dart`：阶段一路由，只包含首页、详情、最近完成、最近删除。
- `lib/src/tasks/domain/`：Task、TaskEvent、仓储接口和纯业务规则。
- `lib/src/tasks/application/`：创建、更新、完成、删除、恢复、查询、排序、过期派生、日志编排、快照刷新触发。
- `lib/src/tasks/data/`：drift 表、DAO、仓储实现。
- `lib/src/tasks/presentation/`：阶段一验证页面与设计源映射组件。
- `lib/src/history/presentation/`：最近完成、最近删除页面与卡片。
- `lib/src/widget_bridge/application/widget_snapshot_refresher.dart`：阶段一快照刷新占位接口。
- `designs/screen_note_stage1.pen`：阶段一 `Pencil` 设计源。
- `docs/screen-note-phase1-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件的映射说明。

## 并行开发总览

### 并行协作原则

- 先冻结契约，再并行实现：路由、领域模型、设计节点和快照刷新接口必须在各自批次合流前明确。
- 设计源码先行：任何页面、组件、弹层或预览实现前，必须先由设计子代理在 `designs/screen_note_stage1.pen` 完成对应节点和状态 `.pen` 稿，再参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 完成风格校准，并同步 `docs/screen-note-phase1-pencil-mapping-2026-05-23.md`；未完成设计稿或风格校准，不得进入 Flutter 实现。
- `.pen` 文件创建约束：凡是计划中要求新建或补齐的 `designs/*.pen` 设计源文件，必须通过 `Pencil` MCP 创建与编辑，禁止手写空白 `.pen` 文件、复制已有 `.pen` 文件充当新稿，或绕过 `Pencil` 直接生成设计源。
- 每个任务包只拥有自己的主文件集合；涉及共用文件时，先由契约任务包落接口和占位实现，再由消费方接入。
- `Pencil` 与 Flutter 分开推进，但 Flutter 显示层只能消费已冻结的 `Pencil` 节点和映射文档。
- 数据层、应用层、显示层必须拆给独立子代理并行开发，但状态流转、日志写入和快照刷新触发只能在应用层合流。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的文件和任务包，不跨包抢改共享契约。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。
- 每个批次结束都要跑本批次最小验证，最终合流再跑完整回归。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 契约冻结 | `Task 1`、`Task 2`、`Task 4` | 无 | 路由骨架、设计 token/组件、Task/TaskEvent 持久模型 |
| P1 核心并行 | `Task 3`、`Task 5` | P0 对应契约冻结 | 页面/弹层设计源、生命周期用例、排序与状态解析 |
| P2 页面合流 | `Task 6` | P1 设计源和用例接口可用 | 阶段一验证页面与共享组件 |
| P3 验收收口 | `Task 7`、`Task 8` | P2 页面链路可运行 | 测试矩阵、范围复核、阶段二输入 |

### 子代理领取规则

- `Task 1` 是工程边界拥有者；其他任务包不要直接重写路由和应用壳层。
- `Task 2` 与 `Task 3` 是 `.pen` 设计源码拥有者；它们必须先完成对应 `.pen` 设计稿并参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 完成风格校准，之后对应 Flutter 页面和组件实现才能启动；显示层缺少状态稿时先回补设计和映射文档。
- `Task 4` 与 `Task 5` 是数据和应用契约拥有者；页面任务只通过用例接口表达用户意图。
- `Task 7` 必须按领域、应用、数据、页面拆给多个测试子代理处理，最终由一个测试合流负责人统一跑全量回归。

### Task 1: 工程骨架与阶段一路由

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/src/app/app.dart`
- Create: `lib/src/app/router.dart`
- Create: `lib/src/app/route_paths.dart`
- Create: `lib/src/shared/presentation/widgets/screen_note_scaffold.dart`
- Create: `lib/src/shared/presentation/widgets/screen_note_loading_view.dart`
- Create: `lib/src/shared/presentation/widgets/screen_note_error_view.dart`

- [ ] **Step 1: 建立 `lib/src` 分层骨架**

创建 `app/`、`shared/`、`tasks/`、`history/`、`widget_bridge/` 目录，先把后续会共同增长的边界固定住，避免继续把所有代码堆在 `lib/main.dart`。

- [ ] **Step 2: 收缩 `lib/main.dart` 到纯启动入口**

把 `MaterialApp`、路由和页面结构迁移到 `lib/src/app/app.dart`，保留 `main()` 只负责 `runApp(const ScreenNoteApp())`，避免入口文件继续膨胀。

- [ ] **Step 3: 建立阶段一路由**

在 `lib/src/app/router.dart` 中只注册这 4 个页面：

```text
/home
/task/:id
/history/completed
/history/deleted
```

启动默认进入 `/home`，后续再按 M2 扩展 `/settings`、`/quick-add` 等低频页面。

- [ ] **Step 4: 建立统一页面骨架**

在 `screen_note_scaffold.dart` 中固定纸感背景、安全区、20pt 页面边距和空/错/载插槽，避免每个页面重复拼背景和间距。

- [ ] **Step 5: 运行基础校验**

Run: `rtk flutter analyze`

Run: `rtk flutter test`

Expected: 分层迁移后仍能通过现有国际化测试，且没有新的 analyzer 阻塞问题。

### Task 2: Pencil 视觉基线与组件库

**Files:**
- Create: `designs/screen_note_stage1.pen`
- Create: `docs/screen-note-phase1-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 在 `screen_note_stage1.pen` 中建立全局变量**

把视觉指导文档中的 token 先落成 `Pencil` 变量：

```text
surfacePaper
surfaceCard
surfaceMuted
inkPrimary
inkSecondary
lineSoft
accentAmber
statusOverdue
statusDone
statusPrivate
actionBlue
```

同时建立字号、间距、圆角变量，保证 Flutter 后续能按 token 对齐，不靠肉眼猜尺寸。

- [ ] **Step 2: 先做可复用组件，不先堆页面**

在 `screen_note_stage1.pen` 中完成这些组件，并全部设为可复用节点：

```text
QuickInputCard
TaskCard
TaskStatusChip
TaskEmptyState
TaskErrorState
HistoryTaskCard
DeletedTaskCard
WidgetPreviewCard
PrimaryActionButton
SecondaryActionButton
```

- [ ] **Step 3: 为关键组件补齐状态分支**

至少补齐以下状态，避免 Flutter 页面实现时临时发明分支：

```text
TaskCard.active
TaskCard.activePinned
TaskCard.activeOverdue
TaskCard.activePrivate
TaskCard.completed
TaskCard.deleted
QuickInputCard.idle
QuickInputCard.submitting
QuickInputCard.error
WidgetPreviewCard.single
WidgetPreviewCard.list
WidgetPreviewCard.private
WidgetPreviewCard.empty
```

- [ ] **Step 4: 写映射文档**

在 `docs/screen-note-phase1-pencil-mapping-2026-05-23.md` 中明确这些一一映射关系：

- `QuickInputCard` -> `lib/src/tasks/presentation/widgets/quick_input_card.dart`
- `TaskCard` -> `lib/src/tasks/presentation/widgets/task_card.dart`
- `TaskStatusChip` -> `lib/src/tasks/presentation/widgets/task_status_chip.dart`
- `HistoryTaskCard` -> `lib/src/history/presentation/widgets/history_task_card.dart`
- `DeletedTaskCard` -> `lib/src/history/presentation/widgets/deleted_task_card.dart`
- `WidgetPreviewCard` -> `lib/src/settings/presentation/widgets/widget_preview_card.dart`

- [ ] **Step 5: 输出阶段一设计验收图**

从 `designs/screen_note_stage1.pen` 导出至少 1 组组件总览图和 1 组页面状态图，作为 Flutter 实现对照基线。

### Task 3: Pencil 页面与弹层设计源

**Files:**
- Modify: `designs/screen_note_stage1.pen`
- Modify: `docs/screen-note-phase1-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 输出阶段一页面稿**

本阶段只完成与可靠性闭环直接相关的页面设计源：

```text
HomePage
TaskDetailPage
CompletedHistoryPage
DeletedHistoryPage
```

其中 `HomePage` 必须包含日期区、快速输入区、当前事项列表、空状态和错误状态。

- [ ] **Step 2: 输出阶段一弹层稿**

本阶段只补可靠性链路必需弹层：

```text
DeleteTaskDialog
RestoreTaskDialog
DiscardChangesDialog
DueTimeSheet
PrivacyExplainSheet
```

删除弹层必须明确“30 天内可恢复”，恢复弹层必须明确“恢复后重新参与首页和锁屏排序”。

- [ ] **Step 3: 为页面补齐状态稿**

每个页面至少有以下分支：

- `loading`
- `empty`
- `error`
- `content`

`DeletedHistoryPage` 额外补 `retentionHint`，`TaskDetailPage` 额外补 `active`、`completed`、`deleted` 三个状态稿。

- [ ] **Step 4: 锁定信息顺序与组件边界**

在映射文档中写清这些边界，作为 Flutter 实现强约束：

- 首页不内联事项卡片。
- 详情页不内联时间、删除、恢复弹层。
- 最近删除卡片单独保留剩余天数区域。
- `TaskStatusChip` 列表态最多同时显示 2 个标签。

### Task 4: Task / TaskEvent 领域模型与 drift 表

**Files:**
- Create: `lib/src/tasks/domain/entities/task.dart`
- Create: `lib/src/tasks/domain/entities/task_event.dart`
- Create: `lib/src/tasks/domain/repositories/task_repository.dart`
- Create: `lib/src/tasks/domain/repositories/task_event_repository.dart`
- Create: `lib/src/tasks/data/local/database/app_database.dart`
- Create: `lib/src/tasks/data/local/database/tables/tasks_table.dart`
- Create: `lib/src/tasks/data/local/database/tables/task_events_table.dart`
- Create: `lib/src/tasks/data/local/database/daos/tasks_dao.dart`
- Create: `lib/src/tasks/data/local/database/daos/task_events_dao.dart`

- [ ] **Step 1: 固化持久状态枚举**

`Task.status` 只允许：

```text
active
completed
deleted
```

不允许新增持久化 `expired`，过期只通过 `dueAt < now && status == active` 派生。

- [ ] **Step 2: 落地 Task 字段**

`Task` 至少包含这些字段，并用 `freezed` 管理不可变模型：

```text
id
title
note
status
dueAt
isPinned
isPrivate
reminderMode
createdAt
updatedAt
completedAt
deletedAt
```

- [ ] **Step 3: 落地 TaskEvent 字段**

`TaskEvent.action` 至少包含：

```text
create
update
complete
delete
restore
expire
```

其中 `expire` 只记录“进入过期显示”的业务事件，不改变 `Task.status`。

- [ ] **Step 4: 建立 drift 表与 DAO**

`tasks_table.dart` 和 `task_events_table.dart` 负责结构化字段和索引，`tasks_dao.dart`、`task_events_dao.dart` 负责纯数据存取，不在 DAO 内实现业务排序和状态流转。

- [ ] **Step 5: 生成代码并校验**

Run: `rtk flutter pub run build_runner build --delete-conflicting-outputs`

Run: `rtk flutter analyze`

Expected: `drift`、`freezed`、`json_serializable` 生成文件完整且无冲突。

### Task 5: 事项生命周期用例与排序服务

**Files:**
- Create: `lib/src/tasks/application/use_cases/create_task_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/update_task_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/complete_task_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/delete_task_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/restore_task_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/watch_active_tasks_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/watch_completed_tasks_use_case.dart`
- Create: `lib/src/tasks/application/use_cases/watch_deleted_tasks_use_case.dart`
- Create: `lib/src/tasks/application/services/task_sorting_service.dart`
- Create: `lib/src/tasks/application/services/task_display_state_resolver.dart`
- Create: `lib/src/widget_bridge/application/widget_snapshot_refresher.dart`

- [ ] **Step 1: 所有状态修改只走用例层**

创建、更新、完成、删除、恢复都由应用层统一编排，页面层和 DAO 都不能直接改 `status` 或关键时间字段。

- [ ] **Step 2: 把日志写入并入用例**

每个用例在状态写入成功后必须补一条 `TaskEvent`：

- 创建 -> `create`
- 编辑 -> `update`
- 完成 -> `complete`
- 删除 -> `delete`
- 恢复 -> `restore`

- [ ] **Step 3: 固化排序服务**

`task_sorting_service.dart` 只按以下顺序输出展示列表：

```text
1. isPinned == true
2. overdue active tasks
3. today due active tasks
4. active tasks without dueAt but manually pinned
5. most recently created active tasks
```

这里保留 PRD 原始优先级，后续若发现“置顶事项”和“无截止但手动置顶”重复，再在 M2 统一收敛，不在 UI 层分叉。

- [ ] **Step 4: 固化显示状态解析器**

`task_display_state_resolver.dart` 负责把 `Task` 解析为：

```text
active
overdue
today
completed
deleted
privateMasked
```

其中 `overdue`、`today`、`privateMasked` 都是显示态，不回写数据库。

- [ ] **Step 5: 预留快照刷新接口**

在每个会改变列表结果的用例末尾调用 `WidgetSnapshotRefresher.refresh()`，阶段一先做内存或空实现，固定触发位点，不等待真实 Widget 再回头补。

### Task 6: 阶段一验证页面与共享组件

**Files:**
- Create: `lib/src/tasks/presentation/pages/home_page.dart`
- Create: `lib/src/tasks/presentation/pages/task_detail_page.dart`
- Create: `lib/src/tasks/presentation/widgets/quick_input_card.dart`
- Create: `lib/src/tasks/presentation/widgets/task_card.dart`
- Create: `lib/src/tasks/presentation/widgets/task_status_chip.dart`
- Create: `lib/src/tasks/presentation/widgets/task_list_section.dart`
- Create: `lib/src/history/presentation/pages/completed_history_page.dart`
- Create: `lib/src/history/presentation/pages/deleted_history_page.dart`
- Create: `lib/src/history/presentation/widgets/history_task_card.dart`
- Create: `lib/src/history/presentation/widgets/deleted_task_card.dart`
- Create: `lib/src/tasks/presentation/overlays/delete_task_dialog.dart`
- Create: `lib/src/tasks/presentation/overlays/restore_task_dialog.dart`
- Create: `lib/src/tasks/presentation/overlays/discard_changes_dialog.dart`

- [ ] **Step 1: 先做首页验证链路**

`home_page.dart` 只承载阶段一主链路：

- 快速输入创建
- 当前事项列表
- 完成操作
- 删除操作
- 进入详情页
- 跳转最近完成 / 最近删除

不提前塞设置、通知、Widget 安装引导。

- [ ] **Step 2: 用共享组件对齐 Pencil**

以下组件必须严格按 `screen_note_stage1.pen` 拆分：

- `QuickInputCard`
- `TaskCard`
- `TaskStatusChip`
- `HistoryTaskCard`
- `DeletedTaskCard`

如果某个状态稿缺失，先补 `Pencil` 再写代码，不允许代码层临时发明视觉分支。

- [ ] **Step 3: 详情页只服务可靠性链路**

`task_detail_page.dart` 本阶段只支持：

- 编辑标题和备注
- 修改截止时间
- 开关置顶
- 开关隐私
- 完成
- 删除
- 从已删除或已完成恢复

不提前接入通知权限页、Pro 弹层和复杂系统设置。

- [ ] **Step 4: 历史页面只做可追溯**

`completed_history_page.dart` 和 `deleted_history_page.dart` 只解决：

- 时间倒序列表
- 空状态
- 恢复入口
- 删除页 30 天保留说明

不加批量清空、永久删除和复杂筛选。

- [ ] **Step 5: 验证页接入统一错误/空状态**

所有阶段一页面必须复用 `screen_note_loading_view.dart`、`screen_note_error_view.dart` 或对应空态组件，避免不同页面各自输出不一致文案。

### Task 7: 阶段一测试矩阵

**Files:**
- Create: `test/tasks/domain/task_display_state_resolver_test.dart`
- Create: `test/tasks/application/task_sorting_service_test.dart`
- Create: `test/tasks/application/task_lifecycle_use_cases_test.dart`
- Create: `test/tasks/data/drift_task_repository_test.dart`
- Create: `test/tasks/presentation/home_page_test.dart`
- Create: `test/tasks/presentation/task_detail_page_test.dart`
- Create: `test/history/presentation/completed_history_page_test.dart`
- Create: `test/history/presentation/deleted_history_page_test.dart`

- [ ] **Step 1: 先补规则测试**

至少覆盖这些断言：

- 过期 active 事项不会改写成第四种持久状态。
- 删除后事项进入 deleted 列表并保留 `deletedAt`。
- 恢复后事项回到 active。
- 完成后事项进入 completed 列表并写入 `completedAt`。
- 每次状态修改都会追加 `TaskEvent`。

- [ ] **Step 2: 补排序测试**

至少覆盖：

- 置顶高于过期
- 过期高于今天
- 今天高于普通 active
- 最近创建在同优先级下靠前

- [ ] **Step 3: 补数据持久化测试**

用仓储或数据库测试验证：

- 重启数据库后任务仍能读回
- 最近删除和最近完成查询稳定
- 30 天保留查询能正确给出剩余天数所需字段

- [ ] **Step 4: 补页面行为测试**

至少验证：

- 首页创建失败不丢输入
- 点击完成后项目从当前列表移出并出现在最近完成
- 删除后项目从当前列表移出并出现在最近删除
- 最近删除点击恢复后项目回到首页列表

- [ ] **Step 5: 跑完整回归命令**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段一所有规则、页面和国际化链路可稳定回归。

### Task 8: 阶段一验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-one-foundation-reliability.md`
- Modify: `docs/screen-note-phase1-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 做一次范围回看**

确认阶段一只交付：

- 工程基线
- Pencil 设计源
- 可靠性数据模型
- 应用层生命周期用例
- 最小验证页面
- 测试矩阵

若发现任务已经触碰通知、Widget 原生、App Intents、Pro，同步从阶段一剔除。

- [ ] **Step 2: 做一次设计与实现对照**

逐项核对：

- 页面结构是否与 `Pencil` 一致
- 状态分支是否齐全
- Flutter 组件边界是否与 `Pencil` 节点边界一致
- 删除、恢复、过期说明文案是否与 PRD 一致

- [ ] **Step 3: 做一次可靠性门禁检查**

只有全部满足，阶段一才算完成：

- 事项不会因过期消失
- 删除可恢复
- 完成可追溯
- 重启后数据仍在
- 快照刷新触发位点已固定

- [ ] **Step 4: 记录阶段二前置物**

把以下内容作为阶段二输入，不在阶段一扩做：

- 真实 WidgetSnapshot DTO
- App Group 共享快照结构
- 通知权限与调度实现
- 设置页与 Widget 预览完整页面

## 并行合流门禁

### P0 契约冻结门禁

- `Task 1` 输出 `/home`、`/task/:id`、`/history/completed`、`/history/deleted` 路由和统一页面骨架。
- `Task 2` 输出 `designs/screen_note_stage1.pen` 中的可复用设计 token、核心组件节点，并参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 完成首轮风格校准和映射文档初稿。
- `Task 4` 输出 `Task.status = active / completed / deleted` 持久契约、`TaskEvent` 操作集合、drift 表和 DAO。
- P0 合流后只允许应用层和数据层继续推进；页面、组件、弹层实现必须继续等待 `Task 3` 在 `.pen` 中完成页面与弹层设计源码、按 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 完成风格校准并冻结映射文档。

### P1 核心并行门禁

- `Task 3` 负责冻结首页、详情、最近完成、最近删除和可靠性弹层状态稿。
- `Task 5` 负责冻结创建、更新、完成、删除、恢复、排序、展示状态和快照刷新触发接口。
- `Task 3` 和 `Task 5` 必须由两个独立子代理并行领取；`Task 5` 不依赖页面布局，`Task 3` 不定义业务状态流转。
- `Task 3` 未完成 `.pen` 页面/弹层节点和映射文档前，`Task 6` 不得启动 Flutter 显示层实现。
- P1 合流时必须核对 `Pencil` 状态名、应用层展示状态名和测试断言使用同一套术语。

### P2 页面合流门禁

- `Task 6` 只在 P1 合流后开始完整接页面，避免显示层临时发明状态和组件边界。
- 页面任务必须按 `HomePage`、`TaskDetailPage`、`History Pages`、`Overlays` 拆给独立子代理处理，并共用同一套 shared loading/error/empty 组件。
- 每个页面子任务完成后至少跑对应 widget test 或 `rtk flutter analyze`，最终由页面合流负责人跑阶段一页面回归。

### P3 验收收口门禁

- `Task 7` 必须按领域规则、排序、持久化、页面行为拆给多个测试子代理补测，但测试命名和 fixture 必须统一。
- `Task 8` 只能在完整回归通过后收口，负责移除越界范围并记录阶段二前置物。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，并确认没有新增用户可见硬编码文案。

## 阶段一完成定义

满足以下条件才允许进入阶段二：

- `Pencil` 已成为阶段一页面和组件的唯一设计源。
- Flutter 已完成可靠性闭环的最小验证页面，不再是示例应用。
- `Task.status` 只保留 `active / completed / deleted` 三种持久状态。
- 过期、删除、恢复、完成、重启场景都有测试覆盖。
- 后续 Widget 和通知接入点已下沉到应用层，不需要再回头改页面直连逻辑。
