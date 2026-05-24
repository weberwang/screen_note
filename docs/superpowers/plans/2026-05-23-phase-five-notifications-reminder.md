# Screen Note Phase 5 Notifications and Persistent Reminder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段五通知基础链路，让 App 能调度普通提醒、处理通知点击跳转、在事项完成/删除/改期时取消或重排提醒，并为强提醒保留接口但不破坏免费主链路。

**Architecture:** 阶段五只做通知权限、普通提醒和点击跳转，不把通知逻辑散落到页面里，也不把强提醒做成默认行为。`notifications/` 模块负责权限、调度、取消、重排和点击解析，页面只展示状态和授权入口；所有通知相关文案和说明先有 `Pencil` 设计源，再进入 Flutter 和原生实现。

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

## 并行建议

可以并行的任务：

- `Task 1 + Task 2`：通知模型与权限链路可并行设计。
- `Task 3 + Task 4`：调度重排和点击跳转可并行实现。
- `Task 5 + Task 6`：`Pencil` 设计源和设置页可并行推进。

必须串行的依赖：

- `Task 3` 依赖 `Task 1` 的通知模型冻结。
- `Task 8` 依赖前面链路基本完成后再写。

## 阶段五完成定义

满足以下条件才允许进入阶段六：

- 普通提醒可以可靠调度、取消和重排。
- 通知点击可以进入对应事项详情。
- 权限拒绝不会阻断事项主链路。
- 通知设置页和权限说明已与 `Pencil` 对齐。
- 强提醒只预留接口和边界，不破坏免费主链路。
