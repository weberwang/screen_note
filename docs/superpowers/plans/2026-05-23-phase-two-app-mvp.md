# Screen Note Phase 2 App MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段二 App 内 MVP，让用户能在 App 中 3 秒完成创建、查看、编辑、完成、删除、恢复，并把首页、详情、新建、历史和设置入口全部对齐 `Pencil` 设计源。

**Architecture:** 阶段二只做 App 内主链路，不扩展真实 Widget、系统入口、通知调度或 Pro 商业化。页面层继续只负责展示与交互，用例层统一处理状态流转、日志、排序、快照触发和草稿保护，所有页面与共享组件必须先有 `Pencil` 设计稿，再进入 Flutter 实现。

**Tech Stack:** Flutter、hooks_riverpod、go_router、drift、freezed、json_serializable、intl、Pencil

---

## 阶段二范围冻结

本计划把“阶段二”收敛为 App 内 MVP，不提前实现以下内容：

- 不做真实 iOS WidgetKit 渲染。
- 不做 App Intents、控制中心、锁屏入口、Action Button。
- 不做普通通知调度和强提醒。
- 不做 iCloud、Apple Reminders、AI 提取、Android 验证。
- 不做 Pro 付费页的真实交易链路。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  app/
  tasks/
    application/
    presentation/
  history/
    presentation/
  settings/
    presentation/
  shared/
    presentation/
designs/
docs/
  superpowers/plans/
  screen-note-phase2-pencil-mapping-2026-05-23.md
test/
  tasks/
  history/
  settings/
```

### 阶段二关键文件职责

- `lib/src/app/router.dart`：扩展首页、新建、详情、历史、设置路由。
- `lib/src/tasks/presentation/pages/home_page.dart`：首页主链路。
- `lib/src/tasks/presentation/pages/task_editor_page.dart`：完整新建与编辑页。
- `lib/src/tasks/presentation/pages/task_detail_page.dart`：事项详情页。
- `lib/src/history/presentation/pages/completed_history_page.dart`：最近完成页。
- `lib/src/history/presentation/pages/deleted_history_page.dart`：最近删除页。
- `lib/src/settings/presentation/pages/settings_page.dart`：设置入口页。
- `lib/src/settings/presentation/pages/widget_settings_page.dart`：锁屏显示设置页的 App 内预览基线。
- `lib/src/settings/presentation/pages/privacy_settings_page.dart`：隐私设置页。
- `docs/screen-note-phase2-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件的映射说明。

## 并行开发总览

### 并行协作原则

- 阶段二以 App 内 MVP 为目标，路由、页面职责、设计节点和应用层用例先定契约，再分页面并行实现。
- 设计源码先行：任何首页、新建页、详情页、历史页、设置页、组件或弹层实现前，必须先由设计子代理在 `designs/screen_note_stage2.pen` 完成对应节点和状态稿，并同步 `docs/screen-note-phase2-pencil-mapping-2026-05-23.md`。
- 首页、历史页、设置页必须拆给独立子代理并行处理；新建页和详情页依赖编辑表单、放弃修改和状态切换契约，不能抢先自定义流程。
- 页面层只触发用户意图，不直接写库、不直接刷新快照、不绕过应用层用例。
- 设计任务包先冻结页面状态和组件映射；显示层任务包发现缺稿时回流到设计任务包，不在 Flutter 中临时改版。
- 测试任务可以提前按契约写骨架，但断言必须在页面和用例合流后统一校准。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的页面、用例或测试包。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 路由与设计契约 | `Task 1`、`Task 2`、`Task 8` | 阶段一完成 | 阶段二路由、页面状态稿、数据接入接口 |
| P1 页面并行 | `Task 3`、`Task 6`、`Task 7` | P0 对应契约冻结 | 首页、历史页、设置页与共享组件 |
| P2 编辑闭环 | `Task 4`、`Task 5` | P0 设计与用例接口可用 | 新建/编辑页、详情页与状态操作闭环 |
| P3 测试验收 | `Task 9`、`Task 10` | P1/P2 页面链路可运行 | 测试矩阵、MVP 验收、阶段三输入 |

### 子代理领取规则

- `Task 1` 拥有路由和页面边界；其他任务包新增入口前必须先同步 route path。
- `Task 2` 拥有 `.pen` 页面、状态和组件映射；它必须先于对应 Flutter 页面实现完成，页面实现只消费映射文档，不自行拆组件边界。
- `Task 8` 拥有应用层数据接入和排序状态解析；页面任务不得直接依赖 DAO 或三方包实例。
- `Task 3`、`Task 6`、`Task 7` 必须由不同子代理并行领取，需复用同一套 `TaskCard`、`EmptyStateCard`、`ErrorStateCard`。
- `Task 4`、`Task 5` 涉及同一事项编辑语义，必须约定表单状态、保存、放弃修改和恢复动作的共享接口后，再交给两个独立子代理处理。

### Task 1: 阶段二路由与页面边界

**Files:**
- Modify: `lib/src/app/router.dart`
- Modify: `lib/src/app/route_paths.dart`
- Create: `lib/src/tasks/presentation/pages/task_editor_page.dart`
- Create: `lib/src/tasks/presentation/pages/task_detail_page.dart`
- Create: `lib/src/history/presentation/pages/completed_history_page.dart`
- Create: `lib/src/history/presentation/pages/deleted_history_page.dart`
- Create: `lib/src/settings/presentation/pages/settings_page.dart`
- Create: `lib/src/settings/presentation/pages/widget_settings_page.dart`
- Create: `lib/src/settings/presentation/pages/privacy_settings_page.dart`

- [ ] **Step 1: 扩展阶段二主路由**

在已有 `/home`、`/task/:id`、`/history/completed`、`/history/deleted` 基础上，补充以下入口：

```text
/task/new
/settings
/settings/widget
/settings/privacy
```

阶段二仍不引入 `/quick-add`、`/settings/notifications`、`/settings/pro`。

- [ ] **Step 2: 明确页面职责边界**

把首页、详情、新建、历史、设置五类页面的职责写死，页面只做展示、输入、导航，不直接写数据库或快照。

- [ ] **Step 3: 统一页面跳转协议**

所有页面进入详情页和历史页时使用统一路由参数，避免每个入口各自发明导航规则。

- [ ] **Step 4: 运行路由回归**

Run: `rtk flutter analyze`

Expected: 新增路由和页面壳层不破坏现有国际化和应用启动。

### Task 2: Pencil 首页、新建页、详情页、历史页、设置页设计源

**Files:**
- Create: `designs/screen_note_stage2.pen`
- Create: `docs/screen-note-phase2-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 先建立阶段二页面总稿**

在 `screen_note_stage2.pen` 中完成这些页面 frame：

```text
HomePage
TaskEditorPage
TaskDetailPage
CompletedHistoryPage
DeletedHistoryPage
SettingsPage
WidgetSettingsPage
PrivacySettingsPage
```

- [ ] **Step 2: 补齐阶段二共享组件稿**

在设计源中补这些组件节点，并标记为可复用：

```text
QuickInputCard
TaskCard
TaskStatusChip
TaskListSection
SettingsGroup
SettingsTile
WidgetPreviewCard
EmptyStateCard
ErrorStateCard
PrimaryActionButton
SecondaryActionButton
ScreenNoteTextField
```

- [ ] **Step 3: 补齐页面状态分支**

每个页面至少有 `loading`、`empty`、`error`、`content` 四个分支；其中：

- `HomePage` 额外补 `widgetGuide` 与 `permissionHint`
- `TaskEditorPage` 额外补 `discardChanges`
- `TaskDetailPage` 额外补 `active`、`completed`、`deleted`
- `DeletedHistoryPage` 额外补 `retentionHint`
- `WidgetSettingsPage` 额外补 `privatePreview`

- [ ] **Step 4: 锁定组件复用关系**

`docs/screen-note-phase2-pencil-mapping-2026-05-23.md` 必须写清：

- 首页输入卡只对应 `QuickInputCard`
- 事项卡只对应 `TaskCard`
- 设置页每个设置分组只对应 `SettingsGroup` + `SettingsTile`
- 预览卡只对应 `WidgetPreviewCard`
- 空/错状态只对应统一 `EmptyStateCard` / `ErrorStateCard`

- [ ] **Step 5: 导出设计验收图**

至少导出这些验收图：

- 首页完整态
- 首页空态
- 新建页完整态
- 详情页完成态
- 最近完成页空态
- 最近删除页含恢复提示
- 设置页与 Widget 预览态

### Task 3: 首页与快速创建链路

**Files:**
- Create: `lib/src/tasks/presentation/pages/home_page.dart`
- Create: `lib/src/tasks/presentation/widgets/quick_input_card.dart`
- Create: `lib/src/tasks/presentation/widgets/task_card.dart`
- Create: `lib/src/tasks/presentation/widgets/task_status_chip.dart`
- Create: `lib/src/tasks/presentation/widgets/task_list_section.dart`
- Create: `lib/src/shared/presentation/widgets/empty_state_card.dart`
- Create: `lib/src/shared/presentation/widgets/error_state_card.dart`

- [ ] **Step 1: 实现首页首屏输入**

首页首屏必须把 `QuickInputCard` 放到最显眼位置，用户无需进入二级页面即可快速创建事项。

- [ ] **Step 2: 实现当前事项列表**

当前事项列表仅展示 active 事项的排序结果，不把历史项混进首页主列表。

- [ ] **Step 3: 实现完成与删除快捷操作**

首页列表每个事项支持完成和删除，完成后立即从首页消失，删除后进入最近删除。

- [ ] **Step 4: 实现空态与错误态**

空态文案、错误态文案和加载态必须来自国际化资源，不允许在页面里写死。

- [ ] **Step 5: 首次验证 3 秒创建**

Run: `rtk flutter test`

Expected: 首页输入不丢、创建后列表立即刷新、空态能正确回退。

### Task 4: TaskEditorPage 完整新建与编辑

**Files:**
- Create: `lib/src/tasks/presentation/pages/task_editor_page.dart`
- Create: `lib/src/tasks/presentation/overlays/due_time_sheet.dart`
- Create: `lib/src/tasks/presentation/overlays/privacy_mode_sheet.dart`
- Create: `lib/src/tasks/presentation/overlays/discard_changes_dialog.dart`

- [ ] **Step 1: 实现完整编辑表单**

`TaskEditorPage` 负责标题、备注、截止时间、置顶、隐私、提醒模式等完整编辑内容，但阶段二不接真实通知调度。

- [ ] **Step 2: 实现放弃修改保护**

有未保存改动时返回必须弹出 `discardChangesDialog`，避免编辑草稿丢失。

- [ ] **Step 3: 实现时间与隐私入口**

时间和隐私使用底部弹层选择，不把复杂配置直接展开到页面主体。

- [ ] **Step 4: 实现保存与回流**

保存成功后回到首页或详情页，并清空草稿状态。

- [ ] **Step 5: 验证表单行为**

页面测试至少覆盖标题为空禁用保存、修改后返回拦截、保存后数据回流。

### Task 5: TaskDetailPage 详情与操作闭环

**Files:**
- Create: `lib/src/tasks/presentation/pages/task_detail_page.dart`
- Create: `lib/src/tasks/presentation/overlays/delete_task_dialog.dart`
- Create: `lib/src/tasks/presentation/overlays/restore_task_dialog.dart`

- [ ] **Step 1: 实现详情页读取与展示**

详情页必须根据事项状态展示 active、completed、deleted 三种视图，不允许把过期做成独立持久状态。

- [ ] **Step 2: 实现编辑与保存**

详情页编辑标题、备注、时间、置顶和隐私时，统一走应用层用例。

- [ ] **Step 3: 实现完成、删除、恢复**

完成、删除、恢复是详情页的核心动作，完成和删除后都要写入操作日志。

- [ ] **Step 4: 实现危险操作确认**

删除必须经过软删除确认，恢复必须明确会回到 active 列表与首页排序。

- [ ] **Step 5: 验证状态切换**

测试覆盖 active -> completed、active -> deleted、deleted -> active 的完整链路。

### Task 6: 历史页与恢复链路

**Files:**
- Create: `lib/src/history/presentation/pages/completed_history_page.dart`
- Create: `lib/src/history/presentation/pages/deleted_history_page.dart`
- Create: `lib/src/history/presentation/widgets/history_task_card.dart`
- Create: `lib/src/history/presentation/widgets/deleted_task_card.dart`

- [ ] **Step 1: 实现最近完成页**

按完成时间倒序展示最近完成项，支持从历史页恢复回 active。

- [ ] **Step 2: 实现最近删除页**

按删除时间倒序展示软删除事项，并展示剩余保留时间。

- [ ] **Step 3: 统一历史卡片样式**

`HistoryTaskCard` 和 `DeletedTaskCard` 必须严格对应 `Pencil` 卡片设计，不能临时改成普通列表样式。

- [ ] **Step 4: 补历史页空态**

空态必须说明“完成后会出现在这里”或“删除后会暂存这里”，避免用户误以为数据丢失。

- [ ] **Step 5: 验证恢复行为**

测试覆盖从最近完成和最近删除恢复后，事项回到首页列表与详情页状态正确。

### Task 7: 设置页与基础偏好

**Files:**
- Create: `lib/src/settings/presentation/pages/settings_page.dart`
- Create: `lib/src/settings/presentation/pages/widget_settings_page.dart`
- Create: `lib/src/settings/presentation/pages/privacy_settings_page.dart`
- Create: `lib/src/settings/presentation/widgets/settings_group.dart`
- Create: `lib/src/settings/presentation/widgets/settings_tile.dart`
- Create: `lib/src/settings/presentation/widgets/widget_preview_card.dart`

- [ ] **Step 1: 实现设置页入口**

设置页只放阶段二需要的低频入口，不提前塞通知、Pro 和系统入口。

- [ ] **Step 2: 实现锁屏显示预览基线**

`WidgetPreviewCard` 在 App 内模拟锁屏展示模式，作为后续 Widget 阶段的视觉参考。

- [ ] **Step 3: 实现隐私设置**

隐私设置只管理基础展示偏好，不做复杂权限流程。

- [ ] **Step 4: 实现设置分组与设置项**

设置页分组与条目统一由 `SettingsGroup`、`SettingsTile` 驱动，避免样式散落。

- [ ] **Step 5: 验证设置页不阻断主链路**

设置页不能打断首页创建流程，任何异常都只能降级显示。

### Task 8: 数据接入、排序和状态解析

**Files:**
- Modify: `lib/src/tasks/application/services/task_sorting_service.dart`
- Modify: `lib/src/tasks/application/services/task_display_state_resolver.dart`
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/update_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/complete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/delete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/restore_task_use_case.dart`

- [ ] **Step 1: 接通首页和详情页数据**

首页、详情、新建、历史页全部通过应用层用例读取或修改数据，不允许页面直连 DAO。

- [ ] **Step 2: 接通排序与展示状态**

阶段二继续沿用阶段一的排序和显示状态规则，首页只展示 active 列表。

- [ ] **Step 3: 接通草稿保留**

新建页和详情页的未保存内容必须保留到用例层或页面状态层，避免返回即丢。

- [ ] **Step 4: 触发快照刷新占位**

所有影响首页列表和详情状态的动作仍要调用快照刷新占位接口，为后续 Widget 阶段保留触发点。

- [ ] **Step 5: 验证数据链路**

至少覆盖创建、编辑、完成、删除、恢复后页面状态的正确性。

### Task 9: 阶段二测试矩阵

**Files:**
- Create: `test/tasks/presentation/home_page_test.dart`
- Create: `test/tasks/presentation/task_editor_page_test.dart`
- Create: `test/tasks/presentation/task_detail_page_test.dart`
- Create: `test/history/presentation/completed_history_page_test.dart`
- Create: `test/history/presentation/deleted_history_page_test.dart`
- Create: `test/settings/presentation/settings_page_test.dart`
- Create: `test/settings/presentation/widget_settings_page_test.dart`
- Create: `test/settings/presentation/privacy_settings_page_test.dart`

- [ ] **Step 1: 覆盖首页主链路**

测试至少覆盖输入、创建、完成、删除、空态和错误态。

- [ ] **Step 2: 覆盖编辑页行为**

测试至少覆盖保存、放弃修改、时间选择、隐私开关。

- [ ] **Step 3: 覆盖详情页状态切换**

测试至少覆盖 active、completed、deleted 三种状态展示和动作入口。

- [ ] **Step 4: 覆盖历史与设置页**

测试至少覆盖最近完成、最近删除、恢复入口、设置分组、预览卡片与隐私设置。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段二 App 内 MVP 链路可回归，且所有用户可见文案来自国际化资源。

### Task 10: 阶段二验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-two-app-mvp.md`
- Modify: `docs/screen-note-phase2-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段二交付范围**

确认只交付：

- 首页
- 新建页
- 详情页
- 最近完成页
- 最近删除页
- 设置页
- App 内小组件预览基线

- [ ] **Step 2: 核对 Pencil 对齐**

核对页面结构、组件边界、状态分支、空/错态、文案是否与 `Pencil` 一致。

- [ ] **Step 3: 核对主链路验收**

必须满足：

- 3 秒内可创建一条事项
- 事项可编辑、完成、删除、恢复
- 历史页可追溯
- 设置页不阻断主链路

- [ ] **Step 4: 记录阶段三前置物**

把以下内容留给阶段三：

- 真实 Widget 快照 DTO
- iOS Widget 渲染工程
- 锁屏隐私模式最终实现
- Widget 刷新失败最后快照兜底

## 并行合流门禁

### P0 路由与设计契约门禁

- `Task 1` 必须先冻结 `/task/new`、`/settings`、`/settings/widget`、`/settings/privacy` 和详情/历史路由参数协议。
- `Task 2` 必须先在 `designs/screen_note_stage2.pen` 冻结首页、新建页、详情页、历史页、设置页的 `loading / empty / error / content` 状态稿，并同步映射文档。
- `Task 8` 必须先冻结页面读取、创建、编辑、完成、删除、恢复和快照触发的应用层接口。
- P0 合流后，页面任务才能进入完整实现；如果 `.pen` 节点或映射缺失，必须先退回 `Task 2` 设计子代理补齐，任何新增用户可见文案必须先进入 ARB。

### P1 页面并行门禁

- `Task 3` 负责首页、快速创建和当前事项列表。
- `Task 6` 负责最近完成、最近删除和恢复入口。
- `Task 7` 负责设置页、Widget 预览基线和隐私设置。
- 三个任务包必须由三个独立子代理并行处理，并共用 `SettingsGroup`、`SettingsTile`、`TaskCard`、`TaskStatusChip`、空态和错误态组件边界。
- P1 合流时必须验证首页创建、历史恢复和设置页跳转互不阻塞。

### P2 编辑闭环门禁

- `Task 4` 负责完整新建与编辑表单，必须复用 P0 的数据接口和 P1 的共享输入组件。
- `Task 5` 负责详情页读取、编辑、完成、删除、恢复和危险操作确认。
- 两个任务包交给子代理并行处理前，必须统一草稿保护、保存回流、状态切换和弹层命名，避免新建页与详情页出现两套编辑模型。
- P2 合流时必须覆盖 active、completed、deleted 三类详情展示与编辑边界。

### P3 测试验收门禁

- `Task 9` 必须按首页、编辑页、详情页、历史页、设置页拆给多个测试子代理处理，但 fixture 和 Provider override 要统一维护。
- `Task 10` 负责范围核对、Pencil 对齐和阶段三前置物记录，只能在全量回归通过后收口。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，并确认用户可见文案全部来自国际化资源。

## 阶段二完成定义

满足以下条件才允许进入阶段三：

- App 内创建、编辑、完成、删除、恢复全部可用。
- 首页、详情、历史、设置页都与 `Pencil` 对齐。
- 所有用户可见文案都接入国际化。
- 草稿、空态、错误态和历史可恢复路径全部打通。
- Widget、通知、系统入口仍然保持为后续阶段输入，不在阶段二扩做。
