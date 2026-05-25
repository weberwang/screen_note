# Screen Note Phase 3 Lock Screen Widget Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

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

## 并行开发总览

### 并行协作原则

- Widget 只消费稳定快照，任何查询、排序、状态推导和业务写入都由主 App 与 `widget_bridge/` 完成。
- 设计源码先行：任何 Widget 预览、真实 Widget 布局、展示模式或设置入口实现前，必须先由设计子代理在 `designs/screen_note_stage3.pen` 完成对应节点和状态稿，并同步 `docs/screen-note-phase3-pencil-mapping-2026-05-23.md`。
- `.pen` 文件创建约束：凡是计划中要求新建或补齐的 `designs/*.pen` 设计源文件，必须通过 `Pencil` MCP 创建与编辑，禁止手写空白 `.pen` 文件、复制已有 `.pen` 文件充当新稿，或绕过 `Pencil` 直接生成设计源。
- 快照模型、展示模式、隐私字段和 fallback 规则先冻结，再让 App 预览和 iOS Widget 并行消费。
- 原生 Widget、Flutter 预览和 `Pencil` 设计必须拆给独立子代理并行处理，但必须共享同一套 `WidgetDisplayMode` 和快照字段。
- 刷新失败只能降级，不得阻断事项主链路；所有刷新接入点必须留在应用层用例末尾。
- 原生工程任务和 Flutter 桥接任务互不直接改对方实现，只通过共享快照契约合流。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的桥接、预览、原生或测试任务包。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 快照契约 | `Task 1`、`Task 3` | 阶段二完成 | Widget 快照模型、展示模式、设计源 |
| P1 刷新与预览 | `Task 2`、`Task 4`、`Task 6` | P0 契约冻结 | 刷新编排、App 内预览、隐私和 fallback 规则 |
| P2 原生接入 | `Task 5`、`Task 7` | P0/P1 共享契约可用 | iOS Widget 壳层、主 App 用例触发 |
| P3 测试验收 | `Task 8`、`Task 9` | P2 链路可运行 | Widget 测试矩阵、验收和阶段四输入 |

### 子代理领取规则

- `Task 1` 拥有快照模型和存储接口；其他任务包不得向 Widget 侧传完整 `Task` 实体。
- `Task 3` 拥有 Widget `.pen` 设计源码和模式映射；它必须先于 App 预览和原生 Widget 布局实现完成，原生与 Flutter 预览必须按映射文档实现。
- `Task 2` 与 `Task 6` 共同处理刷新降级语义，需先统一 `WidgetRefreshResult` 和失败日志策略。
- `Task 5` 只做 iOS Widget 工程与快照读取，不接入数据库和业务排序。
- `Task 7` 只在应用层用例末尾接刷新触发，不让页面层负责刷新。

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

## 并行合流门禁

### P0 快照契约门禁

- `Task 1` 必须冻结 `WidgetSnapshot`、`WidgetSnapshotItem`、`WidgetDisplayMode` 和共享存储接口。
- `Task 3` 必须在 `designs/screen_note_stage3.pen` 冻结单条、三条、今日、隐私、空态和 fallback 的 `Pencil` 节点与映射文档。
- P0 合流后，App 预览、刷新编排和原生 Widget 才能消费快照与设计源码；未冻结字段不得进入 Swift 或页面实现，缺失 `.pen` 节点时不得用代码临时补布局。

### P1 刷新与预览门禁

- `Task 2` 负责刷新触发、结果模型和非阻塞降级。
- `Task 4` 负责 App 内 Widget 预览、模式切换和安装引导。
- `Task 6` 负责隐私遮罩、失败兜底和错误边界。
- 三个任务包必须由三个独立子代理并行处理，并使用同一套 `WidgetDisplayMode`、隐私遮罩规则和 fallback 展示语义。
- P1 合流时必须验证刷新失败不影响创建、编辑、完成、删除和恢复主链路。

### P2 原生接入门禁

- `Task 5` 只能读取共享快照并按展示模式渲染，不得连接数据库或重新排序。
- `Task 7` 只能在应用层用例末尾统一接刷新触发，不得让页面层调用 Widget 原生接口。
- P2 合流时必须验证 App 内预览、真实 Widget 和 `Pencil` 模式命名一致。

### P3 测试验收门禁

- `Task 8` 必须按快照生成、存储、刷新降级、设置页、隐私规则拆给多个测试子代理补测。
- `Task 9` 负责阶段范围、Pencil 对齐、稳定性门禁和阶段四前置物记录。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，原生 Widget 工程还需确认 Xcode 项目引用可编译。

## 阶段三完成定义

满足以下条件才允许进入阶段四：

- 锁屏 Widget 能稳定显示单条、三条、今日和隐私模式。
- 刷新失败时保留最后有效内容，不展示空白。
- 隐私模式不泄露正文。
- Widget 只消费快照，不直接查库或重新排序。
- App 内预览与真实 Widget 规则一致，且与 `Pencil` 对齐。
