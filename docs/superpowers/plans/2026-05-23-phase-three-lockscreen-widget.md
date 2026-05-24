# Screen Note Phase 3 Lock Screen Widget Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段三锁屏小组件能力，让 Widget 只读取稳定快照即可可靠展示单条、三条、今日和隐私模式内容，并在刷新失败时保留最后有效内容。

**Architecture:** 阶段三只做 Widget 展示链路，不把复杂查询、排序、状态推导和业务写入放进 Widget 工程。主 App 负责排序、快照生成和状态派生，`widget_bridge/` 负责共享快照写入，Widget 只负责读取和渲染；所有展示样式先有 `Pencil` 设计源，再进入 Flutter 预览与 iOS Widget 实现。

**Tech Stack:** Flutter、home_widget、WidgetKit、App Group、drift、json_serializable、freezed、Pencil

---

## 阶段三范围冻结

本计划把“阶段三”收敛为锁屏小组件，不提前实现以下内容：

- 不做 App Intents、控制中心、锁屏快速添加入口。
- 不做普通通知调度和强提醒。
- 不做 Pro 购买页与会员交易。
- 不做 iCloud、Apple Reminders、AI 提取、Android 验证。
- 不把 Widget 做成可编辑业务页，Widget 只做只读展示。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  widget_bridge/
    application/
    data/
    domain/
  settings/
    presentation/
designs/
docs/
  superpowers/plans/
  screen-note-phase3-pencil-mapping-2026-05-23.md
ios/
  Runner/
  WidgetExtension/
test/
  widget_bridge/
  settings/
```

### 阶段三关键文件职责

- `lib/src/widget_bridge/application/widget_snapshot_builder.dart`：把事项列表转成 Widget 可消费快照。
- `lib/src/widget_bridge/application/widget_snapshot_refresher.dart`：刷新触发与失败降级入口。
- `lib/src/widget_bridge/data/widget_snapshot_store.dart`：共享快照读写。
- `lib/src/settings/presentation/pages/widget_settings_page.dart`：App 内 Widget 预览与展示模式入口。
- `docs/screen-note-phase3-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件和 Widget 模式的映射说明。
- `ios/WidgetExtension/`：iOS Widget 展示工程壳层。

### Task 1: Widget 快照模型与共享存储

**Files:**
- Create: `lib/src/widget_bridge/domain/models/widget_snapshot.dart`
- Create: `lib/src/widget_bridge/domain/models/widget_snapshot_item.dart`
- Create: `lib/src/widget_bridge/domain/enums/widget_display_mode.dart`
- Create: `lib/src/widget_bridge/domain/repositories/widget_snapshot_store.dart`
- Create: `lib/src/widget_bridge/application/widget_snapshot_builder.dart`
- Create: `lib/src/widget_bridge/data/widget_snapshot_store_impl.dart`

- [ ] **Step 1: 固化 Widget 快照结构**

Widget 快照只保留锁屏展示所需字段，不包含完整事项实体：

```text
snapshotId
generatedAt
displayMode
items
hasPrivateContent
hasFallbackContent
version
```

- [ ] **Step 2: 固化快照条目结构**

`WidgetSnapshotItem` 只保留：

```text
title
statusLabel
dueLabel
isPinned
isOverdue
isPrivate
rank
```

不在 Widget 条目里存备注、长文本或业务状态机。

- [ ] **Step 3: 固化展示模式枚举**

`WidgetDisplayMode` 只允许：

```text
single
list3
today
private
empty
```

- [ ] **Step 4: 实现快照生成器**

`widget_snapshot_builder.dart` 负责把首页排序结果转成 Widget 快照，并在隐私模式下替换正文为模糊文案或数量文案。

- [ ] **Step 5: 实现共享存储接口**

`widget_snapshot_store_impl.dart` 负责写入 App Group 共享存储，并保留最后有效快照，避免刷新失败后空白。

### Task 2: Widget 刷新编排与降级

**Files:**
- Modify: `lib/src/widget_bridge/application/widget_snapshot_refresher.dart`
- Create: `lib/src/widget_bridge/application/widget_refresh_scheduler.dart`
- Create: `lib/src/widget_bridge/application/widget_refresh_result.dart`

- [ ] **Step 1: 固化刷新触发点**

事项创建、编辑、完成、删除、恢复后都必须触发 Widget 刷新编排，但刷新失败不能阻断主链路。

- [ ] **Step 2: 固化刷新结果模型**

`WidgetRefreshResult` 至少区分：

```text
success
savedFallback
failedButNonBlocking
```

- [ ] **Step 3: 固化降级策略**

若写入失败，保留上一次有效快照；若完全没有快照，则回退为空状态，不展示错误栈或空白页。

- [ ] **Step 4: 把刷新失败视为降级而非阻塞**

任何刷新失败都只能记录日志和提示，不允许影响创建、编辑、完成、删除、恢复。

- [ ] **Step 5: 做刷新链路测试**

测试至少覆盖：

- 更新后触发刷新
- 刷新失败保留最后有效内容
- 无快照时展示空态

### Task 3: Pencil Widget 设计源

**Files:**
- Create: `designs/screen_note_stage3.pen`
- Create: `docs/screen-note-phase3-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 建立 Widget 页面总稿**

在 `screen_note_stage3.pen` 中完成这些 Widget frame：

```text
WidgetSingleMode
WidgetList3Mode
WidgetTodayMode
WidgetPrivateMode
WidgetEmptyMode
WidgetPreviewCard
```

- [ ] **Step 2: 建立 Widget 组件稿**

至少补齐这些可复用节点：

```text
WidgetTitle
WidgetItemRow
WidgetPrivacyBadge
WidgetDueLabel
WidgetEmptyHint
WidgetFallbackHint
```

- [ ] **Step 3: 补齐状态分支**

每个 Widget mode 至少补：

- `normal`
- `overdue`
- `today`
- `private`
- `fallback`

- [ ] **Step 4: 锁定 App 预览与真实 Widget 一致性**

`docs/screen-note-phase3-pencil-mapping-2026-05-23.md` 必须明确：

- `WidgetPreviewCard` 对应 App 内预览
- `WidgetSingleMode` 对应锁屏单条模式
- `WidgetList3Mode` 对应锁屏三条模式
- `WidgetTodayMode` 对应锁屏今日模式
- `WidgetPrivateMode` 对应隐私模式

- [ ] **Step 5: 导出设计验收图**

至少导出：

- 单条模式
- 三条模式
- 今日模式
- 隐私模式
- 空状态
- 刷新失败保留最后内容的说明图

### Task 4: App 内 Widget 预览与展示设置

**Files:**
- Modify: `lib/src/settings/presentation/pages/widget_settings_page.dart`
- Create: `lib/src/settings/presentation/widgets/widget_preview_card.dart`
- Create: `lib/src/settings/presentation/widgets/widget_mode_selector.dart`
- Create: `lib/src/settings/presentation/widgets/widget_install_guide_card.dart`

- [ ] **Step 1: 实现 App 内预览卡片**

`WidgetPreviewCard` 必须能模拟单条、三条、今日、隐私和空态，作为设计验收与设置页预览。

- [ ] **Step 2: 实现展示模式切换**

展示模式切换只修改本地设置，不直接操作 Widget 原生工程。

- [ ] **Step 3: 实现安装引导卡片**

引导用户理解 Widget 需要系统操作才能出现在锁屏上，但文案不能承诺实时刷新。

- [ ] **Step 4: 实现隐私预览**

隐私预览必须隐藏正文，只保留数量或模糊文案。

- [ ] **Step 5: 验证预览一致性**

App 预览与 `Pencil` 设计稿必须完全一致，设置页不得自行改布局。

### Task 5: iOS Widget 工程壳层

**Files:**
- Create: `ios/WidgetExtension/WidgetExtension.entitlements`
- Create: `ios/WidgetExtension/Info.plist`
- Create: `ios/WidgetExtension/Widget.swift`
- Create: `ios/WidgetExtension/WidgetEntryView.swift`
- Create: `ios/WidgetExtension/WidgetTimelineProvider.swift`
- Create: `ios/WidgetExtension/WidgetSnapshotLoader.swift`
- Modify: `ios/Runner.xcodeproj/project.pbxproj`

- [ ] **Step 1: 建立 Widget Extension 工程壳**

创建独立 Widget Extension，保证主 App 和 Widget 的边界分离。

- [ ] **Step 2: 实现快照读取**

`WidgetSnapshotLoader` 只做共享快照读取，不直接连数据库。

- [ ] **Step 3: 实现时间线提供者**

`WidgetTimelineProvider` 只基于共享快照构建 timeline，不做业务排序。

- [ ] **Step 4: 实现展示视图**

`WidgetEntryView` 只按照 `WidgetDisplayMode` 选择展示结构，不临时发明 UI。

- [ ] **Step 5: 验证原生工程接入**

确认 Widget Extension 正确加入 Xcode 工程，且能读取 App Group 数据。

### Task 6: 隐私与失败降级链路

**Files:**
- Modify: `lib/src/widget_bridge/application/widget_snapshot_builder.dart`
- Modify: `lib/src/widget_bridge/application/widget_snapshot_refresher.dart`
- Modify: `lib/src/widget_bridge/data/widget_snapshot_store_impl.dart`

- [ ] **Step 1: 固化隐私规则**

隐私模式下 Widget 只能展示数量、模糊文案或安全状态标签，不能展示正文、备注或可推断敏感内容。

- [ ] **Step 2: 固化失败兜底规则**

Widget 失败时优先保留最后有效快照，没有快照才显示空态。

- [ ] **Step 3: 固化错误边界**

刷新失败、读取失败、时间线构建失败都只能降级，不允许冒泡为主链路失败。

- [ ] **Step 4: 记录失败日志**

失败应写入可排查日志，但不在 Widget 上暴露技术错误。

- [ ] **Step 5: 验证隐私不泄露**

测试至少覆盖隐私模式下正文不出现在 Widget、预览和空态中。

### Task 7: 与主 App 的联动触发

**Files:**
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/update_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/complete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/delete_task_use_case.dart`
- Modify: `lib/src/tasks/application/use_cases/restore_task_use_case.dart`

- [ ] **Step 1: 把 Widget 刷新接入用例末尾**

事项变更后统一调用刷新编排，避免页面层各自触发。

- [ ] **Step 2: 保持刷新非阻塞**

任何 Widget 刷新异常都不能回滚事项操作。

- [ ] **Step 3: 保持排序与快照一致**

Widget 快照必须复用主 App 的排序结果，不在 Widget 侧重新排序。

- [ ] **Step 4: 保持展示模式一致**

主 App 预览、真实 Widget 和设计稿必须使用同一套模式定义。

- [ ] **Step 5: 验证主链路不受影响**

测试保证创建、编辑、完成、删除、恢复在 Widget 刷新失败时仍然可用。

### Task 8: 阶段三测试矩阵

**Files:**
- Create: `test/widget_bridge/widget_snapshot_builder_test.dart`
- Create: `test/widget_bridge/widget_snapshot_store_test.dart`
- Create: `test/widget_bridge/widget_refresh_scheduler_test.dart`
- Create: `test/settings/presentation/widget_settings_page_test.dart`
- Create: `test/widget_bridge/widget_privacy_test.dart`

- [ ] **Step 1: 覆盖快照生成**

测试至少覆盖：

- 单条模式
- 三条模式
- 今日模式
- 隐私模式
- 空状态

- [ ] **Step 2: 覆盖快照存储**

测试至少覆盖共享存储写入、读取和最后有效内容保留。

- [ ] **Step 3: 覆盖刷新降级**

测试至少覆盖刷新成功、刷新失败保留 fallback、完全无快照时空态展示。

- [ ] **Step 4: 覆盖隐私规则**

测试至少覆盖隐私模式下正文不泄露到预览、快照和 Widget 展示。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段三锁屏小组件链路可回归，且失败不会阻断主 App。

### Task 9: 阶段三验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-three-lockscreen-widget.md`
- Modify: `docs/screen-note-phase3-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段三交付范围**

确认只交付：

- Widget 快照模型
- 共享快照存储
- 锁屏 Widget 展示工程
- App 内 Widget 预览与模式切换
- 隐私与失败降级

- [ ] **Step 2: 核对 Pencil 对齐**

核对单条、三条、今日、隐私、空态是否与 `Pencil` 一致。

- [ ] **Step 3: 核对稳定性门禁**

必须满足：

- 刷新失败不空白
- 无快照有空态
- 隐私不泄露正文
- Widget 只读不写

- [ ] **Step 4: 记录阶段四前置物**

把以下内容留给阶段四：

- App Intents 快速添加入口
- 控制中心与锁屏系统入口
- 快速添加草稿回流

## 并行建议

可以并行的任务：

- `Task 1 + Task 2`：快照模型与刷新链路可并行设计。
- `Task 3 + Task 4`：`Pencil` 设计源和 App 内预览可并行推进。
- `Task 5 + Task 6`：原生壳层和隐私降级可并行实现。

必须串行的依赖：

- `Task 5` 依赖 `Task 1` 的快照结构冻结。
- `Task 8` 依赖前面链路基本完成后再写。

## 阶段三完成定义

满足以下条件才允许进入阶段四：

- 锁屏 Widget 能稳定显示单条、三条、今日和隐私模式。
- 刷新失败时保留最后有效内容，不展示空白。
- 隐私模式不泄露正文。
- Widget 只消费快照，不直接查库或重新排序。
- App 内预览与真实 Widget 规则一致，且与 `Pencil` 对齐。
