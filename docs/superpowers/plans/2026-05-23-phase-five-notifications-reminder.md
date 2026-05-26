# Screen Note Phase 5 Notifications and Persistent Reminder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段五通知基础链路，让 App 能调度普通提醒、处理通知点击跳转、在事项完成/删除/改期时取消或重排提醒，并为强提醒保留接口但不破坏免费主链路。

**Architecture:** 阶段五只做通知权限、普通提醒和点击跳转，不把通知逻辑散落到页面里，也不把强提醒做成默认行为。`notifications/` 模块负责权限、调度、取消、重排和点击解析，页面只展示状态和授权入口；所有通知相关文案和说明必须先完成对应 `.pen` 设计稿，再参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 校准风格，最后进入 Flutter 和原生实现。

**Tech Stack:** Flutter、flutter_local_notifications、timezone、flutter_timezone、go_router、hooks_riverpod、Pencil

---

## 阶段五范围冻结

本计划把“阶段五”收敛为通知与强提醒基础，不提前实现以下内容：

- 不做 Pro 购买页与会员交易。
- 不做 iCloud、Apple Reminders、AI 提取、Android 验证。
- 不做 App Intents、控制中心、锁屏快速添加入口。
- 不把强提醒作为默认行为，不做重复震动的强运营通知。
- 不让通知权限拒绝阻断事项创建、编辑、完成、删除和恢复。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  notifications/
    application/
    data/
    domain/
    presentation/
  tasks/
    application/
    presentation/
  settings/
    presentation/
designs/
docs/
  superpowers/plans/
  screen-note-phase5-pencil-mapping-2026-05-23.md
ios/
  Runner/
test/
  notifications/
  settings/
  tasks/
```

### 阶段五关键文件职责

- `lib/src/notifications/application/notification_permission_service.dart`：权限读取与请求。
- `lib/src/notifications/application/notification_scheduler.dart`：普通提醒调度。
- `lib/src/notifications/application/notification_cancel_service.dart`：取消与重排。
- `lib/src/notifications/application/notification_route_resolver.dart`：通知点击跳转解析。
- `lib/src/notifications/data/local_notification_adapter.dart`：flutter_local_notifications 适配层。
- `lib/src/settings/presentation/pages/notification_settings_page.dart`：权限与提醒说明页。
- `docs/screen-note-phase5-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件和通知状态的映射说明。

## 并行开发总览

### 并行协作原则

- 通知能力统一放在 `notifications/` 边界内，页面只展示权限状态和触发用户意图。
- 设计源码先行：任何通知设置页、权限说明弹层、提醒预览、降级提示或强提醒边界展示实现前，必须先由设计子代理在 `designs/screen_note_stage5.pen` 完成对应节点和状态 `.pen` 稿，再参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 校准状态表达、文案语气和说明层级，并同步 `docs/screen-note-phase5-pencil-mapping-2026-05-23.md`；未完成设计稿或风格校准，不得进入 Flutter 或原生实现。
- `.pen` 文件创建约束：凡是计划中要求新建或补齐的 `designs/*.pen` 设计源文件，必须通过 `Pencil` MCP 创建与编辑，禁止手写空白 `.pen` 文件、复制已有 `.pen` 文件充当新稿，或绕过 `Pencil` 直接生成设计源。
- 权限、调度、取消重排、点击解析必须拆给独立子代理并行处理，但必须共享通知目标、提醒模式和调度标识。
- 通知权限拒绝、调度失败、点击找不到事项都只能降级，不能阻断事项创建、编辑、完成、删除和恢复。
- 普通提醒先落地；强提醒仅保留策略边界，不进入默认调度链路。
- 通知文案、权限说明和降级提示必须先进入 `Pencil` 与国际化资源，再进入页面。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的权限、调度、点击解析、页面或测试任务包。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 通知契约 | `Task 1`、`Task 5` | 阶段四完成 | 通知模型、提醒模式、通知设计源 |
| P1 服务并行 | `Task 2`、`Task 3`、`Task 4` | P0 契约冻结 | 权限服务、普通提醒调度、点击跳转解析 |
| P2 页面与生命周期 | `Task 6`、`Task 7` | P1 服务接口可用 | 通知设置页、事项生命周期联动 |
| P3 测试验收 | `Task 8`、`Task 9` | P2 链路可运行 | 通知测试矩阵、验收和阶段六输入 |

### 子代理领取规则

- `Task 1` 拥有通知领域模型和仓储接口；其他任务包不得新增散落的通知 ID 生成规则。
- `Task 2` 拥有权限读取、请求和降级语义；页面只消费状态，不直接调三方包。
- `Task 3` 拥有普通提醒调度、取消和重排；生命周期任务只调用统一接口。
- `Task 4` 拥有通知点击路由解析；不得把跳转规则分散到页面或原生回调里。
- `Task 5` 拥有通知 `.pen` 设计源码和映射；它必须先完成对应 `.pen` 设计稿并参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 完成风格校准，之后通知设置页、权限说明和提醒预览实现才能开始。
- `Task 6` 与 `Task 7` 交给两个独立子代理并行处理前，必须统一权限说明文案、失败提示和非阻塞策略。

### Task 1: 通知领域模型与调度标识

**Files:**
- Create: `lib/src/notifications/domain/models/notification_policy.dart`
- Create: `lib/src/notifications/domain/models/notification_target.dart`
- Create: `lib/src/notifications/domain/enums/notification_reminder_mode.dart`
- Create: `lib/src/notifications/domain/repositories/notification_scheduler_repository.dart`
- Create: `lib/src/notifications/domain/repositories/notification_permission_repository.dart`

- [ ] **Step 1: 固化提醒模式枚举**

`NotificationReminderMode` 只允许：

```text
normal
persistent
```

其中 `persistent` 只是预留策略，不在阶段五默认启用重复提醒。

- [ ] **Step 2: 固化通知目标模型**

`NotificationTarget` 至少包含：

```text
taskId
route
source
payload
scheduledAt
```

- [ ] **Step 3: 固化通知策略模型**

`NotificationPolicy` 至少包含：

```text
reminderMode
scheduledAt
timeZone
shouldRepeat
```

- [ ] **Step 4: 定义仓储边界**

通知权限读取和调度都通过仓储接口完成，页面与用例都不直接调用平台插件。

- [ ] **Step 5: 验证模型完整性**

测试至少覆盖提醒模式、目标参数和策略字段能够正确序列化与反序列化。

### Task 2: 通知权限服务与降级

**Files:**
- Create: `lib/src/notifications/application/notification_permission_service.dart`
- Create: `lib/src/notifications/application/notification_permission_state.dart`
- Create: `lib/src/notifications/application/notification_permission_result.dart`
- Create: `lib/src/notifications/data/notification_permission_repository_impl.dart`

- [ ] **Step 1: 建立权限状态模型**

权限状态至少区分：

```text
unknown
granted
denied
permanentlyDenied
```

- [ ] **Step 2: 建立权限请求服务**

权限请求只能返回状态，不得在权限层写业务逻辑。

- [ ] **Step 3: 建立降级策略**

权限拒绝时只做降级说明，不阻断创建、编辑、完成、删除和恢复。

- [ ] **Step 4: 建立系统设置跳转入口**

当权限已拒绝或永久拒绝时，引导用户打开系统设置，不反复弹出系统请求。

- [ ] **Step 5: 做权限链路测试**

测试至少覆盖首次请求、拒绝、永久拒绝和跳转系统设置的状态变化。

### Task 3: 普通提醒调度与取消重排

**Files:**
- Create: `lib/src/notifications/application/notification_scheduler.dart`
- Create: `lib/src/notifications/application/notification_cancel_service.dart`
- Create: `lib/src/notifications/application/notification_reschedule_service.dart`
- Create: `lib/src/notifications/data/local_notification_adapter.dart`

- [ ] **Step 1: 建立普通提醒调度**

普通提醒只负责一次到点通知，不默认重复。

- [ ] **Step 2: 建立取消服务**

完成、删除和清除时间后必须取消已调度提醒。

- [ ] **Step 3: 建立重排服务**

改期后必须取消旧通知并重建新通知，避免重复提醒或悬挂提醒。

- [ ] **Step 4: 建立适配层**

`local_notification_adapter.dart` 负责和 `flutter_local_notifications` 对接，平台差异只留在这一层。

- [ ] **Step 5: 做调度测试**

测试至少覆盖创建、取消、改期重排和删除取消的行为。

### Task 4: 通知点击跳转解析

**Files:**
- Create: `lib/src/notifications/application/notification_route_resolver.dart`
- Create: `lib/src/notifications/application/notification_click_handler.dart`
- Modify: `lib/src/app/router.dart`

- [ ] **Step 1: 固化点击跳转规则**

通知点击默认跳转到 `/task/:id`，找不到事项时回到首页并提示可能已删除。

- [ ] **Step 2: 固化参数传递**

点击解析必须传递 `taskId` 和来源，不在通知 payload 中暴露正文。

- [ ] **Step 3: 固化 deleted / missing 处理**

事项已删除时仍进入详情页，事项不存在时回首页，不直接报技术错误。

- [ ] **Step 4: 固化 deep link 一致性**

通知点击和页面深链必须复用同一套解析逻辑，避免两套入口行为不一致。

- [ ] **Step 5: 做点击跳转测试**

测试至少覆盖存在、已删除和不存在三种点击路径。

### Task 5: Pencil 通知设计源

**Files:**
- Create: `designs/screen_note_stage5.pen`
- Create: `docs/screen-note-phase5-pencil-mapping-2026-05-23.md`

执行顺序：先完成通知相关 `.pen` 设计稿，再参考 [screen-note-stage1-style-extraction-2026-05-26.md](../screen-note-stage1-style-extraction-2026-05-26.md) 校准风格，最后补齐映射文档；不要先写 Flutter 或原生通知展示代码。

- [ ] **Step 1: 建立通知设置页总稿**

在 `screen_note_stage5.pen` 中完成这些 frame：

```text
NotificationSettingsPage
NotificationPermissionSheet
NotificationFallbackState
NotificationGrantedState
NotificationDeniedState
NotificationSchedulePreview
```

- [ ] **Step 2: 建立提醒说明稿**

补齐这些说明节点：

```text
NormalReminderCard
PersistentReminderHint
TimeZoneHint
ClickThroughHint
DegradeHint
```

- [ ] **Step 3: 建立组件与状态稿**

至少补齐：

```text
NotificationPermissionBadge
NotificationPermissionAction
NotificationReminderModeRow
NotificationRoutePreview
NotificationBlockingHint
```

- [ ] **Step 4: 锁定映射关系**

`docs/screen-note-phase5-pencil-mapping-2026-05-23.md` 必须明确：

- `NotificationSettingsPage` 对应通知设置页
- `NotificationPermissionSheet` 对应权限说明弹层
- `NotificationSchedulePreview` 对应提醒预览
- `ClickThroughHint` 对应通知点击跳转说明

- [ ] **Step 5: 导出设计验收图**

至少导出：

- 权限未决定态
- 权限已允许态
- 权限已拒绝态
- 普通提醒预览态
- 点击跳转说明态

### Task 6: 通知设置页与权限说明弹层

**Files:**
- Create: `lib/src/settings/presentation/pages/notification_settings_page.dart`
- Create: `lib/src/settings/presentation/overlays/notification_permission_sheet.dart`
- Create: `lib/src/settings/presentation/widgets/notification_permission_badge.dart`
- Create: `lib/src/settings/presentation/widgets/notification_reminder_mode_row.dart`

- [ ] **Step 1: 实现通知设置页**

通知设置页只说明权限、普通提醒和降级，不承载真实调度。

- [ ] **Step 2: 实现权限说明弹层**

在请求权限前先说明用途，拒绝后说明仍可用锁屏和主链路。

- [ ] **Step 3: 实现状态徽标**

权限状态要清晰展示 unknown、granted、denied、permanentlyDenied。

- [ ] **Step 4: 实现提醒方式入口**

普通提醒免费可用，强提醒只显示预留入口或说明。

- [ ] **Step 5: 验证设置页不阻断主链路**

权限设置、弹层或说明出现异常时都不能影响事项管理。

### Task 7: 与事项生命周期联动

**Files:**
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/update_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/complete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/delete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/restore_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/update_task_use_case.dart`

- [ ] **Step 1: 接入创建后的普通提醒调度**

创建事项时若设置了时间和权限允许，才调度普通提醒。

- [ ] **Step 2: 接入完成/删除取消**

完成和删除后必须取消对应提醒，避免继续响铃。

- [ ] **Step 3: 接入改期重排**

改期后先取消旧提醒，再调度新提醒。

- [ ] **Step 4: 保持调度非阻塞**

通知调度失败只能记录日志和提示，不影响事项主链路。

- [ ] **Step 5: 验证生命周期联动**

测试至少覆盖创建调度、完成取消、删除取消、改期重排和恢复后重新调度。

### Task 8: 阶段五测试矩阵

**Files:**
- Create: `test/notifications/notification_permission_service_test.dart`
- Create: `test/notifications/notification_scheduler_test.dart`
- Create: `test/notifications/notification_cancel_service_test.dart`
- Create: `test/notifications/notification_route_resolver_test.dart`
- Create: `test/settings/presentation/notification_settings_page_test.dart`

- [ ] **Step 1: 覆盖权限链路**

测试至少覆盖首次请求、拒绝、永久拒绝和系统设置跳转。

- [ ] **Step 2: 覆盖调度链路**

测试至少覆盖普通提醒的创建、取消和重排。

- [ ] **Step 3: 覆盖点击跳转**

测试至少覆盖通知点击进入详情、回首页和找不到事项三种情况。

- [ ] **Step 4: 覆盖设置页与弹层**

测试至少覆盖权限说明、提醒方式入口和降级提示。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段五通知链路可回归，且权限拒绝不阻断主链路。

### Task 9: 阶段五验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-five-notifications-reminder.md`
- Modify: `docs/screen-note-phase5-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段五交付范围**

确认只交付：

- 通知权限服务
- 普通提醒调度
- 取消与重排
- 通知点击跳转
- 通知设置页与说明弹层

- [ ] **Step 2: 核对 Pencil 对齐**

核对通知设置页、权限说明、提醒预览与降级提示是否与 `Pencil` 一致。

- [ ] **Step 3: 核对主链路门禁**

必须满足：

- 权限拒绝不阻断创建、编辑、完成、删除和恢复
- 普通提醒可用
- 改期可重排
- 删除和完成可取消

- [ ] **Step 4: 记录阶段六前置物**

把以下内容留给阶段六：

- Pro 权益入口
- 强提醒视觉边界
- 同步能力预埋

## 并行合流门禁

### P0 通知契约门禁

- `Task 1` 必须冻结 `NotificationReminderMode`、`NotificationTarget`、调度仓储和权限仓储接口。
- `Task 5` 必须在 `designs/screen_note_stage5.pen` 冻结通知设置页、权限说明、提醒预览、降级提示和强提醒边界设计源码，并同步映射文档。
- P0 合流后，只有在对应 `.pen` 设计稿与风格校准完成的前提下，权限、调度、点击跳转和设置页才能消费同一套通知术语、状态名和设计源码；缺失 `.pen` 节点时不得用页面代码临时补 UI。

### P1 服务并行门禁

- `Task 2` 负责权限读取、请求、拒绝和非阻塞降级。
- `Task 3` 负责普通提醒调度、取消和改期重排。
- `Task 4` 负责通知点击 payload 解析和 `go_router` 跳转目标。
- 三个任务包必须由三个独立子代理并行处理，并统一错误模型、日志策略和“失败不阻断主链路”的返回语义。
- P1 合流时必须验证权限拒绝、调度失败和点击目标缺失都能降级。

### P2 页面与生命周期门禁

- `Task 6` 负责通知设置页、权限说明弹层和提醒方式入口。
- `Task 7` 负责创建后调度、完成/删除取消、改期重排和恢复后重新调度。
- 两个任务包交给子代理并行处理时，不得让设置页直接操作事项用例，也不得让事项用例直接读取页面状态。
- P2 合流时必须验证通知能力不影响事项主链路，且用户可见文案都来自国际化资源。

### P3 测试验收门禁

- `Task 8` 必须按权限、调度、取消、点击跳转、设置页拆给多个测试子代理补测。
- `Task 9` 负责阶段范围、Pencil 对齐、主链路门禁和阶段六前置物记录。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，并确认强提醒没有成为默认调度行为。

## 阶段五完成定义

满足以下条件才允许进入阶段六：

- 普通提醒可以可靠调度、取消和重排。
- 通知点击可以进入对应事项详情。
- 权限拒绝不会阻断事项主链路。
- 通知设置页和权限说明已与 `Pencil` 对齐。
- 强提醒只预留接口和边界，不破坏免费主链路。
