# Screen Note Phase 4 Quick Add and System Entry Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段四快速添加与系统入口能力，让用户可以从 App 内或系统轻入口快速创建事项，并在入口失败时保留草稿、回流 App，不阻断主链路。

**Architecture:** 阶段四只做轻入口与兜底回流，不把完整编辑流程塞进系统入口，也不把业务状态写入原生入口层。App Intents、控制中心、锁屏入口和 Action Button 都必须最终汇入统一的快速添加协议；`/quick-add` 是唯一失败兜底页面，所有草稿、来源和默认值都先进入应用层，再由用例创建事项。

**Tech Stack:** Flutter、App Intents、go_router、hooks_riverpod、home_widget、WidgetKit、json_serializable、freezed、Pencil

---

## 阶段四范围冻结

本计划把“阶段四”收敛为快速添加与系统入口，不提前实现以下内容：

- 不做普通通知调度和强提醒。
- 不做 Pro 购买页与会员交易。
- 不做 iCloud、Apple Reminders、AI 提取、Android 验证。
- 不把快速入口扩展成完整编辑页。
- 不让系统入口直接写库，必须先进入应用层编排。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  tasks/
    application/
    presentation/
  app/
  shared/
  quick_add/
    application/
    presentation/
    data/
  widget_bridge/
designs/
docs/
  superpowers/plans/
  screen-note-phase4-pencil-mapping-2026-05-23.md
ios/
  QuickAddIntent/
  Runner/
test/
  quick_add/
  tasks/
```

### 阶段四关键文件职责

- `lib/src/quick_add/application/quick_add_draft.dart`：快速添加草稿模型。
- `lib/src/quick_add/application/quick_add_entry_source.dart`：入口来源枚举。
- `lib/src/quick_add/application/quick_add_flow_service.dart`：统一快速添加编排。
- `lib/src/quick_add/data/quick_add_draft_store.dart`：草稿持久化或临时保留。
- `lib/src/quick_add/presentation/pages/quick_add_page.dart`：统一兜底页面。
- `lib/src/tasks/presentation/pages/home_page.dart`：App 内轻入口。
- `docs/screen-note-phase4-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 和系统入口模式的映射说明。

### Task 1: 快速添加草稿模型与入口来源

**Files:**
- Create: `lib/src/quick_add/application/quick_add_draft.dart`
- Create: `lib/src/quick_add/application/quick_add_entry_source.dart`
- Create: `lib/src/quick_add/application/quick_add_defaults.dart`
- Create: `lib/src/quick_add/data/quick_add_draft_store.dart`

- [ ] **Step 1: 固化草稿模型**

快速添加草稿至少包含：

```text
draftText
source
dueAt
isPinned
isPrivate
hasUnsavedChanges
createdAt
updatedAt
```

- [ ] **Step 2: 固化入口来源枚举**

`QuickAddEntrySource` 只允许：

```text
home
appIntent
controlCenter
lockScreen
actionButton
deepLink
fallback
```

- [ ] **Step 3: 固化默认值策略**

不同入口只允许设置默认值，不允许直接创建事项。默认值至少支持：

- 默认置顶
- 默认隐私
- 默认截止时间

- [ ] **Step 4: 实现草稿存储**

`quick_add_draft_store.dart` 负责在入口失败、页面切换或系统回流时保留草稿内容。

- [ ] **Step 5: 验证草稿字段完整性**

测试至少覆盖草稿文本、来源、默认值和修改痕迹不会丢失。

### Task 2: 统一快速添加流程编排

**Files:**
- Create: `lib/src/quick_add/application/quick_add_flow_service.dart`
- Create: `lib/src/quick_add/application/quick_add_flow_result.dart`
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`

- [ ] **Step 1: 建立统一编排入口**

所有系统入口和 App 内轻入口都先进入 `quick_add_flow_service.dart`，由它决定是否跳转 `/quick-add`、是否补默认值、是否创建草稿。

- [ ] **Step 2: 建立流程结果模型**

`QuickAddFlowResult` 至少区分：

```text
openedQuickAdd
createdTask
savedDraft
returnedToApp
failedButRecovered
```

- [ ] **Step 3: 保证创建仍然走应用层用例**

真正创建事项时仍然调用 `create_task_use_case.dart`，禁止系统入口绕过应用层直接写库。

- [ ] **Step 4: 保证失败不丢输入**

任何失败都要优先保存草稿，并提供回流到 `/quick-add` 或首页的路径。

- [ ] **Step 5: 做流程测试**

测试至少覆盖从草稿进入创建、失败回流、默认值生效和输入保留。

### Task 3: Pencil 快速添加设计源

**Files:**
- Create: `designs/screen_note_stage4.pen`
- Create: `docs/screen-note-phase4-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 建立快速添加页面总稿**

在 `screen_note_stage4.pen` 中完成这些 frame：

```text
QuickAddPage
QuickAddSheet
QuickAddFallbackState
QuickAddSuccessState
QuickAddDraftState
QuickAddEntrySourceHint
```

- [ ] **Step 2: 建立系统入口说明稿**

补齐这些入口说明节点：

```text
AppIntentEntry
ControlCenterEntry
LockScreenEntry
ActionButtonEntry
DeepLinkFallbackEntry
```

- [ ] **Step 3: 建立组件与状态稿**

至少补齐：

```text
QuickAddInput
QuickAddSourceChip
QuickAddDefaultOptionRow
QuickAddNonBlockingHint
QuickAddErrorHint
```

- [ ] **Step 4: 锁定映射关系**

`docs/screen-note-phase4-pencil-mapping-2026-05-23.md` 必须明确：

- `QuickAddPage` 对应 `/quick-add`
- `QuickAddSheet` 对应首页轻入口
- `AppIntentEntry` 对应系统原生入口说明
- `DeepLinkFallbackEntry` 对应失败回流页面

- [ ] **Step 5: 导出设计验收图**

至少导出：

- 快速添加完整态
- 草稿态
- 成功态
- 失败回流态
- 系统入口说明态

### Task 4: App 内快速添加入口

**Files:**
- Modify: `lib/src/tasks/presentation/pages/home_page.dart`
- Create: `lib/src/tasks/presentation/overlays/quick_add_sheet.dart`
- Create: `lib/src/tasks/presentation/widgets/quick_input_card.dart`

- [ ] **Step 1: 首页提供轻入口**

首页快速输入卡必须允许直接进入轻量快速添加，不需要先打开完整编辑页。

- [ ] **Step 2: 实现快速添加底部弹层**

`quick_add_sheet.dart` 只承担最少输入、默认值、确认和取消，不展开复杂设置。

- [ ] **Step 3: 保持首页 3 秒创建链路**

App 内快速添加不得破坏首页已有的 3 秒创建目标。

- [ ] **Step 4: 保持失败草稿**

添加失败时必须保留输入内容与入口来源，方便用户再次回流。

- [ ] **Step 5: 验证首页入口不退化**

测试必须覆盖首页轻入口和快速添加弹层不会影响原有创建流程。

### Task 5: `/quick-add` 失败兜底页面

**Files:**
- Create: `lib/src/quick_add/presentation/pages/quick_add_page.dart`
- Create: `lib/src/quick_add/presentation/widgets/quick_add_input.dart`
- Create: `lib/src/quick_add/presentation/widgets/quick_add_source_chip.dart`
- Create: `lib/src/quick_add/presentation/widgets/quick_add_default_option_row.dart`
- Create: `lib/src/quick_add/presentation/widgets/quick_add_non_blocking_hint.dart`
- Create: `lib/src/quick_add/presentation/widgets/quick_add_error_hint.dart`

- [ ] **Step 1: 建立唯一兜底页**

所有系统入口失败都回到 `/quick-add`，不新增第二个兜底页面。

- [ ] **Step 2: 自动接回草稿**

页面打开时必须能接收并恢复 `draftText`、来源和默认值。

- [ ] **Step 3: 保持极简交互**

页面只保留输入、添加、取消和少量二级选项，不展示完整编辑能力。

- [ ] **Step 4: 加入非阻断提示**

页面必须明确“失败不影响主链路”，避免用户误解为系统失效。

- [ ] **Step 5: 验证失败回流**

测试至少覆盖系统入口失败后进入 `/quick-add`、草稿保留和再次提交成功。

### Task 6: 系统入口与原生桥接

**Files:**
- Create: `ios/QuickAddIntent/QuickAddIntent.swift`
- Create: `ios/QuickAddIntent/QuickAddBridge.swift`
- Create: `ios/QuickAddIntent/Info.plist`
- Modify: `ios/Runner.xcodeproj/project.pbxproj`
- Create: `lib/src/quick_add/data/quick_add_intent_bridge.dart`

- [ ] **Step 1: 建立 App Intents 桥接**

把 App Intents 的输入转成快速添加草稿，而不是直接创建事项。

- [ ] **Step 2: 建立系统入口统一回流**

控制中心、锁屏和 Action Button 失败时都统一跳 `/quick-add`，不各自维护不同兜底逻辑。

- [ ] **Step 3: 建立来源透传**

确保系统入口来源能传到 Flutter 应用层，用于默认值和提示文案。

- [ ] **Step 4: 保持原生层无业务逻辑**

原生层只负责入口转发，不承载状态流转或数据库写入。

- [ ] **Step 5: 验证工程接入**

确认 App Intents 工程可编译、可回流、可传递草稿文本。

### Task 7: 草稿保留与恢复策略

**Files:**
- Modify: `lib/src/quick_add/data/quick_add_draft_store.dart`
- Modify: `lib/src/quick_add/application/quick_add_flow_service.dart`
- Modify: `lib/src/quick_add/presentation/pages/quick_add_page.dart`

- [ ] **Step 1: 保留页面离开时的草稿**

页面切换、失败回流或用户临时取消时，草稿必须继续保留。

- [ ] **Step 2: 保留入口来源与默认值**

草稿恢复后仍要知道来自哪个入口，以及是否带默认置顶、隐私、时间。

- [ ] **Step 3: 保留未保存状态**

`hasUnsavedChanges` 必须准确控制放弃修改提示。

- [ ] **Step 4: 保留失败恢复路径**

任何系统入口失败都要能恢复到相同草稿上下文，而不是清空后重新开始。

- [ ] **Step 5: 验证草稿不丢**

测试至少覆盖页面返回、系统回流、创建失败和重复打开后的草稿恢复。

### Task 8: 阶段四测试矩阵

**Files:**
- Create: `test/quick_add/quick_add_flow_service_test.dart`
- Create: `test/quick_add/quick_add_draft_store_test.dart`
- Create: `test/quick_add/quick_add_page_test.dart`
- Create: `test/tasks/presentation/home_quick_add_test.dart`
- Create: `test/quick_add/quick_add_intent_bridge_test.dart`

- [ ] **Step 1: 覆盖草稿模型**

测试至少覆盖草稿文本、来源、默认值和未保存状态。

- [ ] **Step 2: 覆盖流程编排**

测试至少覆盖系统入口转草稿、草稿转创建、失败转回流。

- [ ] **Step 3: 覆盖兜底页面**

测试至少覆盖 `/quick-add` 的草稿恢复、添加、取消和失败提示。

- [ ] **Step 4: 覆盖首页轻入口**

测试至少覆盖首页轻入口不会破坏主创建流程。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段四快速添加与系统入口链路可回归，且失败不会阻断主链路。

### Task 9: 阶段四验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-four-quick-add-system-entry.md`
- Modify: `docs/screen-note-phase4-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段四交付范围**

确认只交付：

- App 内快速添加入口
- `/quick-add` 兜底页
- App Intents 桥接
- 控制中心、锁屏、Action Button 回流
- 草稿保留与恢复

- [ ] **Step 2: 核对 Pencil 对齐**

核对快速添加页面、草稿态、失败回流态和入口说明是否与 `Pencil` 一致。

- [ ] **Step 3: 核对主链路门禁**

必须满足：

- 系统入口失败不丢草稿
- 主链路不被系统入口阻断
- `/quick-add` 是唯一兜底页
- 快速添加仍能在 3 秒内完成

- [ ] **Step 4: 记录阶段五前置物**

把以下内容留给阶段五：

- 通知权限请求
- 普通提醒调度
- 通知点击跳转
- 完成/删除/改期后的取消重排

## 并行建议

可以并行的任务：

- `Task 1 + Task 2`：草稿模型与流程编排可并行设计。
- `Task 3 + Task 5`：`Pencil` 设计源和 `/quick-add` 页面可并行推进。
- `Task 4 + Task 6`：首页轻入口和原生桥接可并行实现。

必须串行的依赖：

- `Task 5` 依赖 `Task 1` 的草稿模型冻结。
- `Task 8` 依赖前面链路基本完成后再写。

## 阶段四完成定义

满足以下条件才允许进入阶段五：

- App 内和系统轻入口都能稳定创建事项。
- `/quick-add` 成为统一失败兜底页。
- 草稿、来源和默认值不会在失败时丢失。
- App Intents、控制中心、锁屏和 Action Button 都能回流到同一套快速添加流程。
- 入口失败不会阻断主 App 的创建链路。
