# Screen Note Phase 4 Pencil 映射说明

## 目标

本文档把 [screen_note_stage4.pen](/E:/Projects/flutter/screen_note/designs/screen_note_stage4.pen) 中的阶段四设计节点，映射到 Flutter 页面、首页轻入口和系统入口回流语义，作为实现与验收的唯一对应表。

## 页面与入口映射

| Pencil 节点 | 实现落点 | 说明 |
| --- | --- | --- |
| `QuickAddPage` | `/quick-add` | 阶段四唯一失败兜底页，承接系统入口失败、草稿恢复和最终提交。 |
| `QuickAddSheet` | 首页轻入口底部弹层 | App 内最短路径的轻量快速添加入口，只保留一句话输入和少量默认值。 |
| `QuickAddFallbackState` | `/quick-add` 失败回流态 | 用于表达“入口失败但草稿已恢复”，强调不阻断主链路。 |
| `QuickAddSuccessState` | 快速添加成功反馈态 | 用于温和确认事项已创建，不扩展成复杂成功页。 |
| `QuickAddDraftState` | 草稿保留与恢复态 | 用于表达系统回流、用户收起或暂不提交后的草稿保留语义。 |
| `QuickAddEntrySourceHint` | 来源枚举与提示文案基线 | 冻结阶段四允许的入口来源以及对应安全提示表达。 |
| `AppIntentEntry` | App Intents 入口说明 | 描述 App Intent 只转发来源和草稿，不直接创建事项。 |
| `ControlCenterEntry` | 控制中心入口说明 | 描述控制中心入口失败后统一回流到 `/quick-add`。 |
| `LockScreenEntry` | 锁屏入口说明 | 描述锁屏入口只携带来源和默认值，不泄露隐私正文。 |
| `ActionButtonEntry` | Action Button 入口说明 | 描述硬件快捷入口的失败兜底与主链路关系。 |
| `DeepLinkFallbackEntry` | 深链失败回流说明 | 描述失败统一回流页和草稿恢复策略。 |

## 组件映射

| Pencil 节点 | Flutter 组件 | 说明 |
| --- | --- | --- |
| `QuickAddInput` | `quick_add_input.dart` | 快速添加统一输入区域，支持一句话输入和草稿恢复。 |
| `QuickAddSourceChip` | `quick_add_source_chip.dart` | 展示入口来源，统一视觉表达，不在页面散落字符串常量。 |
| `QuickAddDefaultOptionRow` | `quick_add_default_option_row.dart` | 展示时间、置顶、隐私等少量默认值与轻量操作。 |
| `QuickAddNonBlockingHint` | `quick_add_non_blocking_hint.dart` | 强调“失败不阻断主链路”的降级提示。 |
| `QuickAddErrorHint` | `quick_add_error_hint.dart` | 快速添加失败后的恢复提示，明确草稿仍被保留。 |

## 验收图对应

| 导出图 | 对应节点 | 用途 |
| --- | --- | --- |
| `page-quick-add.png` | `QuickAddPage` | 验证 `/quick-add` 的完整态布局。 |
| `page-quick-add-draft.png` | `QuickAddDraftState` | 验证草稿恢复态与保留语义。 |
| `page-quick-add-success.png` | `QuickAddSuccessState` | 验证成功反馈的温和确认风格。 |
| `page-quick-add-fallback.png` | `QuickAddFallbackState` | 验证失败回流态的错误提示和草稿恢复。 |
| `page-quick-add-entry-states.png` | `EntryStates` | 验证系统入口说明稿与来源提示一致性。 |

## 设计约束

- 阶段四所有快速添加相关展示必须沿用 Stage 1 的暖纸感、轻描边和低噪声层级，不另起一套视觉语言。
- `/quick-add` 是唯一失败兜底页，任何系统入口失败都不能新增第二套回流页面。
- 系统入口说明稿只表达来源、默认值和回流语义，不在原生入口层承载业务状态流转。
- 隐私优先于展示便利，任何系统入口说明和失败回流态都不得泄露隐私事项正文。
