# Screen Note Phase 6 Pro Boundary and Commercialization Preload Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段六 Pro 预埋与商业化边界，让权益入口、配置、样式预埋和同步验证都可以落地，但免费主链路不被付费逻辑打断。

**Architecture:** 阶段六只做商业化边界和权益预埋，不把 Pro 做成影响创建/编辑/完成/删除/恢复的强耦合层。权益读取、展示、试用、购买占位和降级都必须走统一的权益配置中心；`Pencil` 负责先把免费版与 Pro 版的视觉边界定义清楚，再进入 Flutter 页面和原生预埋实现。

**Tech Stack:** Flutter、go_router、hooks_riverpod、shared_preferences、Pencil、iCloud / StoreKit 占位预研

---

## 阶段六范围冻结

本计划把“阶段六”收敛为 Pro 预埋与商业化边界，不提前实现以下内容：

- 不做真实 iCloud 同步作为强依赖。
- 不做 Apple Reminders、AI 提取、Android 验证。
- 不把 Pro 变成阻断免费主链路的购买墙。
- 不在创建/编辑/完成/删除/恢复流程中强插付费弹层。
- 不把基础隐私、基础可靠性、普通提醒做成付费门槛。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  pro/
    application/
    data/
    domain/
    presentation/
  settings/
    presentation/
  tasks/
    application/
designs/
docs/
  superpowers/plans/
  screen-note-phase6-pencil-mapping-2026-05-23.md
test/
  pro/
  settings/
```

### 阶段六关键文件职责

- `lib/src/pro/application/pro_entitlement_service.dart`：权益读取与边界决策。
- `lib/src/pro/application/pro_feature_gate.dart`：功能开关和入口可用性判断。
- `lib/src/pro/data/pro_entitlement_store.dart`：本地权益缓存。
- `lib/src/settings/presentation/pages/pro_page.dart`：权益展示页。
- `lib/src/settings/presentation/overlays/pro_paywall_sheet.dart`：购买或试用说明弹层。
- `docs/screen-note-phase6-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件和权益状态的映射说明。

## 并行开发总览

### 并行协作原则

- Pro 只做边界和预埋，不阻断免费主链路；创建、编辑、完成、删除、恢复不得依赖权益成功读取。
- 设计源码先行：任何 Pro 页、权益卡片、付费说明弹层、试用态、购买失败态或预埋入口展示实现前，必须先由设计子代理在 `designs/screen_note_stage6.pen` 完成对应节点和状态稿，并同步 `docs/screen-note-phase6-pencil-mapping-2026-05-23.md`。
- 权益模型、缓存、功能门禁和配置中心先冻结，再让 Pro 页面、预埋入口和同步占位并行消费。
- 购买、试用、同步和 StoreKit 只做占位或验证，不在阶段六形成真实交易依赖。
- 免费版与 Pro 版视觉边界以 `Pencil` 为准，页面不能临时把基础功能做成付费入口。
- 任何权益读取失败、购买失败或试用失败都必须降级显示，不能中断主流程。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的权益、缓存、页面、预埋或测试任务包。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 权益契约 | `Task 1`、`Task 3` | 阶段五完成 | 权益模型、功能枚举、Pro 设计源 |
| P1 数据与页面 | `Task 2`、`Task 4`、`Task 7` | P0 契约冻结 | 权益缓存、Pro 页、配置中心和入口边界 |
| P2 功能预埋 | `Task 5`、`Task 6` | P0/P1 门禁接口可用 | 强提醒、多样式、同步占位边界 |
| P3 测试验收 | `Task 8`、`Task 9` | P2 链路可运行 | Pro 测试矩阵、验收和阶段七输入 |

### 子代理领取规则

- `Task 1` 拥有 `ProEntitlement`、`ProFeature` 和功能门禁接口；其他任务包不得散落硬编码权益判断。
- `Task 2` 拥有本地权益缓存和失败恢复；页面只消费服务状态。
- `Task 3` 拥有 Pro `.pen` 设计源码；它必须先于 Pro 页面、权益卡片、付费说明弹层和预埋入口展示实现完成。
- `Task 7` 拥有配置中心和入口可见性；`Task 5`、`Task 6` 只注册预埋能力，不自行决定入口展示。
- `Task 4` 的付费说明弹层必须保持解释性，不得强插到免费主链路。

### Task 1: Pro 权益模型与功能门禁

**Files:**
- Create: `lib/src/pro/domain/models/pro_entitlement.dart`
- Create: `lib/src/pro/domain/enums/pro_feature.dart`
- Create: `lib/src/pro/domain/repositories/pro_entitlement_repository.dart`
- Create: `lib/src/pro/application/pro_feature_gate.dart`

- [ ] **Step 1: 固化权益模型**

`ProEntitlement` 至少包含：

```text
isProEnabled
trialAvailable
renewalStatus
updatedAt
source
```

- [ ] **Step 2: 固化权益枚举**

`ProFeature` 只允许：

```text
strongReminder
multiWidgetStyle
icloudSync
remindersSync
aiExtract
appleWatch
privacyEnhance
deletedRestore
```

- [ ] **Step 3: 建立功能门禁**

功能门禁只负责判断功能是否可见、可点、可用，不直接写 UI 文案。

- [ ] **Step 4: 定义仓储边界**

权益读取和缓存通过仓储接口完成，页面和业务层不直接操作本地存储。

- [ ] **Step 5: 验证模型完整性**

测试至少覆盖权益状态、功能枚举和门禁结果的稳定输出。

### Task 2: 本地权益缓存与恢复

**Files:**
- Create: `lib/src/pro/data/pro_entitlement_store.dart`
- Create: `lib/src/pro/application/pro_entitlement_service.dart`
- Create: `lib/src/pro/application/pro_restore_purchase_service.dart`

- [ ] **Step 1: 建立本地缓存**

本地缓存只保存权益状态、更新时间和来源，不保存用户内容。

- [ ] **Step 2: 建立权益恢复**

恢复购买或首次同步后能刷新本地权益缓存。

- [ ] **Step 3: 建立失败降级**

权益读取失败时默认回退为免费版显示，但不清空用户已有功能。

- [ ] **Step 4: 建立缓存过期策略**

权益缓存可带有效期或更新时间，避免长期展示陈旧状态。

- [ ] **Step 5: 做缓存测试**

测试至少覆盖首次写入、读取、恢复与失败降级。

### Task 3: Pencil Pro 设计源

**Files:**
- Create: `designs/screen_note_stage6.pen`
- Create: `docs/screen-note-phase6-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 建立 Pro 页面总稿**

在 `screen_note_stage6.pen` 中完成这些 frame：

```text
ProPage
ProBenefitCard
ProPaywallSheet
ProTrialState
ProLockedState
ProEnabledState
ProCompareSection
```

- [ ] **Step 2: 建立权益卡片稿**

补齐这些权益节点：

```text
StrongReminderBenefit
MultiWidgetStyleBenefit
ICloudSyncBenefit
RemindersSyncBenefit
AIExtractBenefit
AppleWatchBenefit
PrivacyEnhanceBenefit
DeletedRestoreBenefit
```

- [ ] **Step 3: 建立状态与边界稿**

至少补齐：

```text
FreeUserState
ProUserState
TrialAvailableState
UpgradeCTAState
PurchaseFailedState
FeaturePreviewState
```

- [ ] **Step 4: 锁定映射关系**

`docs/screen-note-phase6-pencil-mapping-2026-05-23.md` 必须明确：

- `ProPage` 对应权益页
- `ProPaywallSheet` 对应购买/试用说明弹层
- `ProBenefitCard` 对应权益卡片
- `FeaturePreviewState` 对应功能预览和入口说明

- [ ] **Step 5: 导出设计验收图**

至少导出：

- 免费版态
- Pro 已启用态
- 试用可用态
- 购买失败态
- 权益对比态

### Task 4: Pro 权益页与付费说明弹层

**Files:**
- Create: `lib/src/settings/presentation/pages/pro_page.dart`
- Create: `lib/src/settings/presentation/overlays/pro_paywall_sheet.dart`
- Create: `lib/src/settings/presentation/widgets/pro_benefit_card.dart`
- Create: `lib/src/settings/presentation/widgets/pro_compare_section.dart`

- [ ] **Step 1: 实现权益页**

权益页只负责展示 Pro 能力、免费说明和入口，不做强制购买。

- [ ] **Step 2: 实现付费说明弹层**

弹层只能承接入口说明、购买或试用入口，不能在 P0 主链路强制弹出。

- [ ] **Step 3: 实现权益对比**

必须清楚展示免费版可用内容，避免把基础能力误导成付费专属。

- [ ] **Step 4: 实现购买失败降级**

购买失败后只能提示重试或返回，不影响继续使用基础功能。

- [ ] **Step 5: 验证入口不阻断**

测试保证 Pro 页和弹层不会干扰创建、编辑、完成、删除、恢复流程。

### Task 5: 强提醒与多样式预埋

**Files:**
- Create: `lib/src/pro/application/pro_strong_reminder_feature.dart`
- Create: `lib/src/pro/application/pro_widget_style_feature.dart`
- Modify: `lib/src/notifications/application/notification_scheduler.dart`
- Modify: `lib/src/settings/presentation/pages/widget_settings_page.dart`

- [ ] **Step 1: 预留强提醒开关**

强提醒只能作为预留功能，不默认启用重复提醒。

- [ ] **Step 2: 预留多样式小组件入口**

Widget 多样式只预留入口和样式状态，不影响基础快照展示。

- [ ] **Step 3: 保持免费链路不变**

免费用户必须继续拥有基础提醒、基础隐私和基础 Widget 预览。

- [ ] **Step 4: 防止误导**

界面不得把未真实接入的能力显示成已稳定可用。

- [ ] **Step 5: 做边界测试**

测试至少覆盖强提醒未购买时的入口、样式预览和降级路径。

### Task 6: iCloud / 同步边界预埋

**Files:**
- Create: `lib/src/pro/application/pro_sync_preload_service.dart`
- Create: `lib/src/pro/application/pro_sync_status.dart`
- Create: `lib/src/pro/data/pro_sync_stub.dart`

- [ ] **Step 1: 预留同步状态模型**

同步状态至少包含：

```text
disabled
available
syncing
failed
```

- [ ] **Step 2: 预留同步占位接口**

只保留状态和提示，不在阶段六实现真实同步业务。

- [ ] **Step 3: 保持本地优先**

同步不可用时仍然完整使用本地数据和本地功能。

- [ ] **Step 4: 设计同步说明**

同步入口要明确是预埋或验证，不承诺阶段六已稳定上线。

- [ ] **Step 5: 做同步占位测试**

测试至少覆盖 disabled、available、failed 的展示边界。

### Task 7: 权益配置中心与入口边界

**Files:**
- Create: `lib/src/pro/application/pro_config_center.dart`
- Modify: `lib/src/settings/presentation/pages/settings_page.dart`
- Modify: `lib/src/settings/presentation/widgets/settings_tile.dart`

- [ ] **Step 1: 建立权益配置中心**

所有 Pro 相关可见性、可点性和说明都由统一配置中心驱动。

- [ ] **Step 2: 入口说明分层**

设置页里 Pro 入口只做说明和跳转，不强制购买。

- [ ] **Step 3: 保持入口不打断主链路**

Pro 入口不能打断首页快速记录、历史恢复和详情编辑。

- [ ] **Step 4: 允许灰度开关**

可按本地开关或配置控制是否展示某些 Pro 能力的占位入口。

- [ ] **Step 5: 验证边界清晰**

测试至少覆盖入口展示、入口隐藏和未购买态说明。

### Task 8: 阶段六测试矩阵

**Files:**
- Create: `test/pro/pro_entitlement_service_test.dart`
- Create: `test/pro/pro_feature_gate_test.dart`
- Create: `test/pro/pro_entitlement_store_test.dart`
- Create: `test/settings/presentation/pro_page_test.dart`
- Create: `test/settings/presentation/pro_paywall_sheet_test.dart`

- [ ] **Step 1: 覆盖权益模型**

测试至少覆盖权益状态、权益来源和功能门禁。

- [ ] **Step 2: 覆盖权益缓存**

测试至少覆盖读取、写入、恢复和失败降级。

- [ ] **Step 3: 覆盖 Pro 页面**

测试至少覆盖免费态、Pro 态、试用态和购买失败态。

- [ ] **Step 4: 覆盖功能预埋**

测试至少覆盖强提醒、多样式和同步预埋入口。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段六 Pro 边界可回归，且免费主链路不被商业化影响。

### Task 9: 阶段六验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-six-pro-boundary.md`
- Modify: `docs/screen-note-phase6-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段六交付范围**

确认只交付：

- Pro 权益模型和缓存
- Pro 页和购买说明弹层
- 强提醒、多样式、同步预埋
- 权益配置中心
- 免费与 Pro 的视觉边界

- [ ] **Step 2: 核对 Pencil 对齐**

核对 Pro 页、权益卡片、试用态与购买失败态是否与 `Pencil` 一致。

- [ ] **Step 3: 核对免费主链路**

必须满足：

- 免费版仍可创建、编辑、完成、删除、恢复
- 基础隐私不收费
- 基础提醒不收费
- Pro 不阻断主链路

- [ ] **Step 4: 记录阶段七前置物**

把以下内容留给阶段七：

- 候选提取与人工确认
- Android 等待名单
- AI 建议流程

## 并行合流门禁

### P0 权益契约门禁

- `Task 1` 必须冻结 `ProEntitlement`、`ProFeature`、权益仓储和功能门禁接口。
- `Task 3` 必须在 `designs/screen_note_stage6.pen` 冻结免费态、Pro 态、试用态、购买失败态、权益卡片和付费说明弹层设计源码，并同步映射文档。
- P0 合流后，缓存、页面、配置中心和功能预埋才能消费同一套权益状态和设计源码；缺失 `.pen` 节点时不得用页面代码临时补商业化 UI。

### P1 数据与页面门禁

- `Task 2` 负责本地权益读取、写入、恢复和失败降级。
- `Task 4` 负责 Pro 权益页和付费说明弹层。
- `Task 7` 负责权益配置中心、设置页入口和灰度开关。
- 三个任务包必须由三个独立子代理并行处理，并统一未购买态、试用态、已购买态和失败态的展示语义。
- P1 合流时必须验证 Pro 入口不会打断首页快速记录、历史恢复和详情编辑。

### P2 功能预埋门禁

- `Task 5` 负责强提醒、多样式和高级展示入口的预埋边界。
- `Task 6` 负责 iCloud / 同步占位、失败提示和本地优先兜底。
- 两个任务包只能注册能力和说明，不得让预埋能力反向改变免费版基础提醒、基础隐私和可靠性链路。
- P2 合流时必须验证权益读取失败时所有预埋入口都能降级。

### P3 测试验收门禁

- `Task 8` 必须按权益服务、功能门禁、缓存、Pro 页、付费说明弹层拆给多个测试子代理补测。
- `Task 9` 负责范围核对、Pencil 对齐、免费主链路门禁和阶段七前置物记录。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，并确认基础能力没有被 Pro 门禁包裹。

## 阶段六完成定义

满足以下条件才允许进入阶段七：

- 免费主链路完全不受 Pro 干扰。
- Pro 页、弹层和权益卡片与 `Pencil` 对齐。
- 强提醒、多样式、同步仅作为预埋或验证，不反向破坏稳定功能。
- 权益缓存和门禁可以稳定工作。
- 购买失败、试用失败或权益读取失败都只能降级，不能阻断主流程。
