# Screen Note Phase 7 Smart Extract and Android Validation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development`. 并行批次中的任务包必须交给独立子代理处理；协调者负责分发完整任务上下文、合流审查和最终回归。Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成阶段七智能提取与 Android 验证能力，让文本提取只生成候选事项、用户确认后才创建事项，并通过等待名单与技术评估验证 Android 方向，不拖慢 iOS 主线。

**Architecture:** 阶段七只做候选提取、人工确认和 Android 需求验证，不把 AI 结果自动写入事项，也不把 Android 做成完整客户端。候选提取结果必须先进入应用层确认页，确认后再调用创建用例；Android 方向只做等待名单、问卷和桌面小组件技术评估，所有展示和验证状态先有 `Pencil` 设计源。

**Tech Stack:** Flutter、go_router、hooks_riverpod、freezed、json_serializable、Pencil、Android widget 预研

---

## 阶段七范围冻结

本计划把“阶段七”收敛为智能提取与 Android 验证，不提前实现以下内容：

- 不做自动写入事项。
- 不做完整 Android 客户端。
- 不把 AI 提取结果当成最终事项。
- 不把等待名单页面做成营销页。
- 不让 Android 验证影响 iOS 主链路稳定性。

## 文件结构总览

### 计划新增目录

```text
lib/src/
  extract/
    application/
    data/
    domain/
    presentation/
  android_validation/
    application/
    presentation/
designs/
docs/
  superpowers/plans/
  screen-note-phase7-pencil-mapping-2026-05-23.md
test/
  extract/
  android_validation/
```

### 阶段七关键文件职责

- `lib/src/extract/application/extract_candidate_service.dart`：候选提取服务。
- `lib/src/extract/application/extract_confirmation_service.dart`：候选确认后创建事项。
- `lib/src/extract/domain/models/extract_candidate.dart`：候选事项模型。
- `lib/src/extract/presentation/pages/extract_candidate_page.dart`：候选确认页。
- `lib/src/android_validation/presentation/pages/android_waitlist_page.dart`：等待名单页。
- `docs/screen-note-phase7-pencil-mapping-2026-05-23.md`：`Pencil` 节点到 Flutter 组件和验证状态的映射说明。

## 并行开发总览

### 并行协作原则

- 智能提取只产生候选事项，用户确认前不得创建事项、写状态日志或触发事项主链路副作用。
- 设计源码先行：任何候选确认页、忽略态、等待名单页、Android 验证说明或失败态实现前，必须先由设计子代理在 `designs/screen_note_stage7.pen` 完成对应节点和状态稿，并同步 `docs/screen-note-phase7-pencil-mapping-2026-05-23.md`。
- 候选模型、来源记录、确认服务和页面状态先冻结，再让提取服务、确认页和测试并行实现。
- Android 方向只做等待名单和技术验证，不做完整客户端，也不影响 iOS 主线交付。
- `Pencil` 设计源必须同时覆盖候选确认、忽略态、等待名单和验证说明；页面不能临时改成营销落地页。
- AI 或解析失败只能转为候选失败态或手动输入引导，不能阻断 App 既有创建流程。
- 同一批次内的并行任务必须由不同子代理领取；子代理只能处理被分配的候选、确认页、Android 验证或测试任务包。
- 每个子代理完成后必须先做规格符合性审查，再做代码质量审查，审查通过后才能进入批次合流。

### 批次划分

| 批次 | 子代理任务包 | 前置条件 | 合流产物 |
| --- | --- | --- | --- |
| P0 候选契约 | `Task 1`、`Task 3` | 阶段六完成 | 候选模型、来源枚举、提取与 Android 设计源 |
| P1 提取与验证页面 | `Task 2`、`Task 4`、`Task 5` | P0 契约冻结 | 候选提取服务、确认页、Android 等待名单 |
| P2 联动与技术评估 | `Task 6`、`Task 7` | P1 接口可用 | Android 技术评估边界、人工确认创建联动 |
| P3 测试验收 | `Task 8`、`Task 9` | P2 链路可运行 | 阶段七测试矩阵、最终验收和维护输入 |

### 子代理领取规则

- `Task 1` 拥有候选字段、来源枚举和候选仓储接口；其他任务包不得直接把 AI 输出写成 `Task`。
- `Task 2` 拥有候选提取与确认流程服务；页面只编辑候选并提交确认意图。
- `Task 3` 拥有候选确认和 Android 验证 `.pen` 设计源码；它必须先于候选确认页、等待名单页和验证说明实现完成，等待名单页面必须按映射文档实现。
- `Task 5` 与 `Task 6` 属于 Android 验证侧，必须由独立子代理推进，且不得修改 iOS 主链路。
- `Task 7` 是最终联动门禁，必须确认后才调用创建用例，并保留来源可追踪。

### Task 1: 候选事项模型与来源记录

**Files:**
- Create: `lib/src/extract/domain/models/extract_candidate.dart`
- Create: `lib/src/extract/domain/enums/extract_source.dart`
- Create: `lib/src/extract/domain/repositories/extract_candidate_repository.dart`

- [ ] **Step 1: 固化候选事项模型**

`ExtractCandidate` 至少包含：

```text
candidateText
sourceText
confidence
origin
suggestedTitle
suggestedDueAt
requiresConfirmation
createdAt
updatedAt
```

- [ ] **Step 2: 固化来源枚举**

`ExtractSource` 只允许：

```text
clipboard
shareText
pasteboard
manualPaste
ruleBased
aiAssist
fallback
```

- [ ] **Step 3: 固化候选仓储边界**

候选数据只能先保存在候选层，不得自动落到事项表。

- [ ] **Step 4: 保留确认前状态**

候选必须显式标记 `requiresConfirmation`，避免误把建议当最终事项。

- [ ] **Step 5: 验证字段完整性**

测试至少覆盖候选文本、来源、置信度和确认标记。

### Task 2: 候选提取服务与确认流程

**Files:**
- Create: `lib/src/extract/application/extract_candidate_service.dart`
- Create: `lib/src/extract/application/extract_confirmation_service.dart`
- Create: `lib/src/extract/application/extract_parse_result.dart`
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`

- [ ] **Step 1: 建立候选提取服务**

提取服务只生成候选，不直接创建事项。

- [ ] **Step 2: 建立确认服务**

只有用户确认后才调用创建用例，进入真正的事项表。

- [ ] **Step 3: 建立解析结果模型**

`ExtractParseResult` 至少区分：

```text
candidateReady
parseFailed
needsManualEdit
ignored
```

- [ ] **Step 4: 保持人工确认必需**

任何 `aiAssist` 或规则提取结果都必须经过确认页。

- [ ] **Step 5: 做流程测试**

测试至少覆盖提取成功、提取失败、人工确认创建和忽略候选。

### Task 3: Pencil 智能提取与 Android 设计源

**Files:**
- Create: `designs/screen_note_stage7.pen`
- Create: `docs/screen-note-phase7-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 建立候选确认页总稿**

在 `screen_note_stage7.pen` 中完成这些 frame：

```text
ExtractCandidatePage
ExtractCandidateList
ExtractCandidateDetail
ExtractConfirmationState
ExtractIgnoredState
AndroidWaitlistPage
AndroidValidationState
```

- [ ] **Step 2: 建立候选提示稿**

补齐这些节点：

```text
CandidateSourceChip
CandidateConfidenceBadge
CandidateSuggestionRow
CandidateEditHint
CandidateNonBlockingHint
```

- [ ] **Step 3: 建立 Android 验证稿**

至少补齐：

```text
AndroidWaitlistForm
AndroidDeviceHint
AndroidUseCaseHint
AndroidValidationDisclaimer
AndroidThresholdHint
```

- [ ] **Step 4: 锁定映射关系**

`docs/screen-note-phase7-pencil-mapping-2026-05-23.md` 必须明确：

- `ExtractCandidatePage` 对应候选确认页
- `ExtractConfirmationState` 对应确认创建前状态
- `AndroidWaitlistPage` 对应等待名单页
- `AndroidValidationState` 对应 Android 技术验证说明

- [ ] **Step 5: 导出设计验收图**

至少导出：

- 候选列表态
- 候选详情态
- 确认创建态
- 忽略态
- Android 等待名单态
- Android 验证说明态

### Task 4: 候选确认页与人工编辑

**Files:**
- Create: `lib/src/extract/presentation/pages/extract_candidate_page.dart`
- Create: `lib/src/extract/presentation/widgets/extract_candidate_list.dart`
- Create: `lib/src/extract/presentation/widgets/extract_candidate_detail.dart`
- Create: `lib/src/extract/presentation/widgets/extract_candidate_confidence_badge.dart`
- Create: `lib/src/extract/presentation/widgets/extract_candidate_non_blocking_hint.dart`

- [ ] **Step 1: 实现候选列表**

候选页展示提取结果，但明确这是“建议”不是“已创建事项”。

- [ ] **Step 2: 实现候选详情**

候选详情允许用户修改标题、备注和时间后再确认创建。

- [ ] **Step 3: 实现置信度标记**

置信度只作为辅助信息，不作为自动创建依据。

- [ ] **Step 4: 实现非阻断提示**

页面必须明确“未确认前不会创建事项”，防止误解。

- [ ] **Step 5: 验证人工确认**

测试至少覆盖候选编辑、确认创建、忽略候选和返回不丢草稿。

### Task 5: Android 等待名单页

**Files:**
- Create: `lib/src/android_validation/presentation/pages/android_waitlist_page.dart`
- Create: `lib/src/android_validation/presentation/widgets/android_device_hint.dart`
- Create: `lib/src/android_validation/presentation/widgets/android_use_case_hint.dart`
- Create: `lib/src/android_validation/presentation/widgets/android_validation_disclaimer.dart`

- [ ] **Step 1: 建立等待名单页**

等待名单页只收集需求验证信息，不承诺 Android 上线排期。

- [ ] **Step 2: 建立设备与场景收集**

至少收集机型、使用场景和联系方式，用于验证需求集中度。

- [ ] **Step 3: 建立免责声明**

页面必须明确这是等待名单和验证页，不是已上线功能。

- [ ] **Step 4: 保护表单输入**

提交失败时保留输入，不允许重置表单。

- [ ] **Step 5: 验证提交链路**

测试至少覆盖提交成功、失败重试和草稿保留。

### Task 6: Android 技术评估边界

**Files:**
- Create: `lib/src/android_validation/application/android_validation_service.dart`
- Create: `lib/src/android_validation/application/android_threshold_policy.dart`
- Create: `lib/src/android_validation/data/android_validation_store.dart`

- [ ] **Step 1: 建立验证门槛策略**

验证门槛至少可以判断等待名单人数和需求集中度是否达到后续评估条件。

- [ ] **Step 2: 建立验证状态模型**

验证状态至少包含：

```text
collecting
thresholdReached
underReview
paused
```

- [ ] **Step 3: 建立本地验证存储**

用于保存等待名单、阈值和评估状态，不保存用户正文内容。

- [ ] **Step 4: 保持不阻断**

Android 验证状态变化不能影响 iOS 主链路。

- [ ] **Step 5: 做验证测试**

测试至少覆盖阈值未达、达到、暂停和恢复评估。

### Task 7: 人工确认与事项创建联动

**Files:**
- Modify: `lib/src/extract/application/extract_confirmation_service.dart`
- Modify: `lib/src/tasks/application/use_cases/create_task_use_case.dart`
- Modify: `lib/src/extract/presentation/pages/extract_candidate_page.dart`

- [ ] **Step 1: 确认后才创建**

只有用户明确确认后才调用创建用例。

- [ ] **Step 2: 保留建议与正文**

候选正文与用户修改内容在确认前都要保留，避免重复输入。

- [ ] **Step 3: 保持来源可追踪**

创建后仍要知道它来自候选提取，而不是普通手动输入。

- [ ] **Step 4: 保持不自动化**

自动提取结果不能直接成为事项，不允许绕过确认页。

- [ ] **Step 5: 验证联动**

测试至少覆盖候选确认后创建、确认前不创建和编辑后再确认。

### Task 8: 阶段七测试矩阵

**Files:**
- Create: `test/extract/extract_candidate_service_test.dart`
- Create: `test/extract/extract_confirmation_service_test.dart`
- Create: `test/extract/extract_candidate_page_test.dart`
- Create: `test/android_validation/android_waitlist_page_test.dart`
- Create: `test/android_validation/android_validation_service_test.dart`

- [ ] **Step 1: 覆盖候选提取**

测试至少覆盖候选生成、解析失败和来源记录。

- [ ] **Step 2: 覆盖人工确认**

测试至少覆盖确认创建、忽略候选和编辑后确认。

- [ ] **Step 3: 覆盖等待名单**

测试至少覆盖提交、失败保留和免责声明展示。

- [ ] **Step 4: 覆盖验证门槛**

测试至少覆盖阈值未达、达到和暂停状态。

- [ ] **Step 5: 跑完整回归**

Run: `rtk flutter test`

Run: `rtk flutter analyze`

Run: `rtk flutter gen-l10n`

Expected: 阶段七智能提取与 Android 验证链路可回归，且不会自动写入事项。

### Task 9: 阶段七验收与交接

**Files:**
- Modify: `docs/superpowers/plans/2026-05-23-phase-seven-smart-extract-android-validation.md`
- Modify: `docs/screen-note-phase7-pencil-mapping-2026-05-23.md`

- [ ] **Step 1: 核对阶段七交付范围**

确认只交付：

- 候选提取模型
- 候选确认页
- 人工确认创建
- Android 等待名单页
- Android 技术验证边界

- [ ] **Step 2: 核对 Pencil 对齐**

核对候选确认、忽略态、等待名单和验证说明是否与 `Pencil` 一致。

- [ ] **Step 3: 核对主链路门禁**

必须满足：

- 候选结果不自动写入事项
- 人工确认后才创建事项
- Android 验证不阻断 iOS 主链路
- 等待名单只做收集和评估

- [ ] **Step 4: 记录最终收口**

把以下内容作为后续维护输入：

- 候选提取规则
- Android 阈值策略
- AI 建议与人工确认边界

## 并行合流门禁

### P0 候选契约门禁

- `Task 1` 必须冻结 `ExtractCandidate`、`ExtractSource`、候选仓储接口和“确认前不创建”的数据契约。
- `Task 3` 必须在 `designs/screen_note_stage7.pen` 冻结候选确认、编辑、忽略、等待名单、Android 验证说明和状态分支设计源码，并同步映射文档。
- P0 合流后，提取服务、确认页和 Android 验证页面才能消费候选字段、状态名和设计源码；缺失 `.pen` 节点时不得用页面代码临时补 UI。

### P1 提取与验证页面门禁

- `Task 2` 负责候选提取服务、解析失败处理和确认流程服务。
- `Task 4` 负责候选确认页、人工编辑、忽略和确认入口。
- `Task 5` 负责 Android 等待名单页、提交失败保留和免责声明。
- 三个任务包必须由三个独立子代理并行处理，并统一候选状态、失败态、确认动作和等待名单验证文案。
- P1 合流时必须验证候选结果不会自动落库，等待名单失败不会丢输入。

### P2 联动与技术评估门禁

- `Task 6` 负责 Android widget 技术评估、阈值状态和暂停条件，不做完整 Android 客户端。
- `Task 7` 负责确认后调用创建用例、来源追踪和编辑后确认。
- 两个任务包必须由两个独立子代理并行处理，但 Android 验证不得修改候选确认创建链路，候选确认不得依赖 Android 验证状态。
- P2 合流时必须验证人工确认前无事项写入，确认后才进入事项主链路。

### P3 测试验收门禁

- `Task 8` 必须按候选提取、人工确认、候选页、等待名单、Android 验证服务拆给多个测试子代理补测。
- `Task 9` 负责范围核对、Pencil 对齐、主链路门禁和最终维护输入记录。
- 最终合流必须运行 `rtk flutter test`、`rtk flutter analyze`、`rtk flutter gen-l10n`，并确认阶段七不会破坏 iOS 主链路。

## 阶段七完成定义

满足以下条件才算完成：

- 提取结果只作为候选，不会自动落库。
- 用户确认后才会创建事项。
- Android 只是等待名单与技术验证，不是完整客户端。
- 候选页、等待名单页和验证说明与 `Pencil` 对齐。
- 阶段七不会破坏 iOS 主链路的稳定性。
