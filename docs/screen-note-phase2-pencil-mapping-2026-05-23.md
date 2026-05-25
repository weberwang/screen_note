# 屏记阶段二 Pencil 映射文档

## 1. 文档目的

本文档用于冻结阶段二 App 内 MVP 的 `Pencil` 设计源结构、组件边界与 Flutter 映射关系，作为阶段二显示层与测试实现的唯一设计依据。

适用范围：

- `designs/screen_note_stage2.pen`
- 首页、新建页、详情页、历史页、设置页、Widget 预览页
- 阶段二共享组件与页面状态分支

不包含：

- Dart 业务实现细节
- 阶段三真实 Widget 渲染、通知调度或系统入口设计
- 开发标注图与交互动效说明

## 2. 当前阶段二设计源结果

阶段二设计源已通过 `Pencil` MCP 创建并落库到 `designs/screen_note_stage2.pen`。

当前设计源包含以下顶层页面 frame：

- `HomePage`
- `TaskEditorPage`
- `TaskDetailPage`
- `CompletedHistoryPage`
- `DeletedHistoryPage`
- `SettingsPage`
- `WidgetSettingsPage`
- `PrivacySettingsPage`

当前设计源包含以下可复用组件节点：

- `QuickInputCard`
- `TaskCard`
- `TaskStatusChip`
- `TaskListSection`
- `SettingsGroup`
- `SettingsTile`
- `WidgetPreviewCard`
- `EmptyStateCard`
- `ErrorStateCard`
- `PrimaryActionButton`
- `SecondaryActionButton`
- `ScreenNoteTextField`

阶段二继续沿用阶段一的纸质便签视觉语义：

- 背景与卡片采用浅纸面层级，不引入新的高饱和主题方向。
- 颜色、字号、间距、圆角全部通过变量定义，不在组件内散写魔法值。
- 组件优先先冻结再复用，页面只负责拼装状态稿，不在页面节点内再发明临时组件。

## 3. 阶段二 Token 基线

### 3.1 颜色 Token

| Token | 数值 | 语义 |
| --- | --- | --- |
| `surfacePaper` | `#F8F3EA` | 页面底色 |
| `surfaceCard` | `#FFFBF4` | 一级卡片底色 |
| `surfaceMuted` | `#EFE7DA` | 弱化信息块底色 |
| `inkPrimary` | `#211B14` | 主文案 |
| `inkSecondary` | `#6F6254` | 次级文案 |
| `lineSoft` | `#E2D6C7` | 轻描边 |
| `accentAmber` | `#D9822B` | 主操作强调 |
| `statusOverdue` | `#B94A3A` | 风险/保留期提示 |
| `statusDone` | `#4F8A62` | 完成/置顶提示 |
| `statusPrivate` | `#6D6A75` | 隐私提示 |
| `actionBlue` | `#3366CC` | 跳转/辅助动作 |

### 3.2 字号 Token

| Token | 数值 | 语义 |
| --- | --- | --- |
| `fontDisplay` | `32` | 强标题 |
| `fontTitle` | `24` | 页面标题 |
| `fontSection` | `18` | 区块标题 |
| `fontBody` | `16` | 正文 |
| `fontBodySmall` | `14` | 说明与次正文 |
| `fontCaption` | `12` | 标签与提示 |

### 3.3 间距与圆角 Token

| Token | 数值 | 语义 |
| --- | --- | --- |
| `space4` | `4` | 紧凑微距 |
| `space8` | `8` | 小间距 |
| `space12` | `12` | 控件间距 |
| `space16` | `16` | 卡片内边距 |
| `space20` | `20` | 页面边距 |
| `space24` | `24` | 分组间距 |
| `space32` | `32` | 大留白 |
| `radius12` | `12` | 输入框/次按钮 |
| `radius18` | `18` | 卡片 |
| `radius20` | `20` | 快速输入卡 |
| `radius28` | `28` | 页面容器 |
| `radiusPill` | `999` | 标签 |

## 4. 页面状态分支冻结

### 4.1 首页

- `HomePage.content`
- `HomePage.empty`
- `HomePage.error`
- `HomePage.loading`
- `HomePage.widgetGuide`
- `HomePage.permissionHint`

### 4.2 新建页

- `TaskEditorPage.content`
- `TaskEditorPage.empty`
- `TaskEditorPage.error`
- `TaskEditorPage.loading`
- `TaskEditorPage.discardChanges`

### 4.3 详情页

- `TaskDetailPage.active`
- `TaskDetailPage.completed`
- `TaskDetailPage.deleted`
- `TaskDetailPage.empty`
- `TaskDetailPage.error`
- `TaskDetailPage.loading`

### 4.4 历史页

- `CompletedHistoryPage.content`
- `CompletedHistoryPage.empty`
- `CompletedHistoryPage.error`
- `CompletedHistoryPage.loading`
- `DeletedHistoryPage.content`
- `DeletedHistoryPage.empty`
- `DeletedHistoryPage.error`
- `DeletedHistoryPage.loading`
- `DeletedHistoryPage.retentionHint`

### 4.5 设置页

- `SettingsPage.content`
- `SettingsPage.empty`
- `SettingsPage.error`
- `SettingsPage.loading`
- `WidgetSettingsPage.content`
- `WidgetSettingsPage.privatePreview`
- `WidgetSettingsPage.empty`
- `WidgetSettingsPage.error`
- `WidgetSettingsPage.loading`
- `PrivacySettingsPage.content`
- `PrivacySettingsPage.empty`
- `PrivacySettingsPage.error`
- `PrivacySettingsPage.loading`

## 5. 组件复用关系冻结

### 5.1 必须一一对应的组件边界

- 首页输入卡只对应 `QuickInputCard`
- 当前事项卡只对应 `TaskCard`
- 标签只对应 `TaskStatusChip`
- 列表区块只对应 `TaskListSection`
- 设置分组只对应 `SettingsGroup`
- 设置条目只对应 `SettingsTile`
- Widget 预览只对应 `WidgetPreviewCard`
- 空态只对应 `EmptyStateCard`
- 错误态只对应 `ErrorStateCard`
- 主按钮只对应 `PrimaryActionButton`
- 次按钮只对应 `SecondaryActionButton`
- 文本输入行只对应 `ScreenNoteTextField`

### 5.2 页面内允许存在的非共享结构

以下结构保留在页面状态稿内，不提升为阶段二共享组件：

- 最近完成页历史卡
- 最近删除页恢复卡
- 详情页 completed/deleted 状态操作块
- 放弃修改确认块
- 设置页降级说明块

理由：

- 这些结构目前只在单页或单状态内出现。
- 先冻结行为语义和信息层次，避免为复用而提前抽象出错误边界。
- Flutter 实现可以拆成独立 Widget，但视觉与交互来源仍以对应页面状态稿为准。

## 6. Flutter 映射约束

### 6.1 页面落点

| Pencil 节点 | Flutter 落点 | 约束 |
| --- | --- | --- |
| `HomePage.*` | `lib/src/tasks/presentation/pages/home_page.dart` | 首页只负责拼装快速输入、列表和历史入口 |
| `TaskEditorPage.*` | `lib/src/tasks/presentation/pages/task_editor_page.dart` | 新建与编辑共用表单语义 |
| `TaskDetailPage.*` | `lib/src/tasks/presentation/pages/task_detail_page.dart` | 按三种持久状态切换视图 |
| `CompletedHistoryPage.*` | `lib/src/history/presentation/pages/completed_history_page.dart` | 补齐恢复入口 |
| `DeletedHistoryPage.*` | `lib/src/history/presentation/pages/deleted_history_page.dart` | 明确保留期提示 |
| `SettingsPage.*` | `lib/src/settings/presentation/pages/settings_page.dart` | 只保留阶段二低频入口 |
| `WidgetSettingsPage.*` | `lib/src/settings/presentation/pages/widget_settings_page.dart` | 仅做 App 内预览基线 |
| `PrivacySettingsPage.*` | `lib/src/settings/presentation/pages/privacy_settings_page.dart` | 仅管理基础隐私展示偏好 |

### 6.2 组件落点

| Pencil 组件 | Flutter 落点 |
| --- | --- |
| `QuickInputCard` | `lib/src/tasks/presentation/widgets/quick_input_card.dart` |
| `TaskCard` | `lib/src/tasks/presentation/widgets/task_card.dart` |
| `TaskStatusChip` | `lib/src/tasks/presentation/widgets/task_status_chip.dart` |
| `TaskListSection` | `lib/src/tasks/presentation/widgets/task_list_section.dart` |
| `SettingsGroup` | `lib/src/settings/presentation/widgets/settings_group.dart` |
| `SettingsTile` | `lib/src/settings/presentation/widgets/settings_tile.dart` |
| `WidgetPreviewCard` | `lib/src/settings/presentation/widgets/widget_preview_card.dart` |
| `EmptyStateCard` | `lib/src/shared/presentation/widgets/empty_state_card.dart` |
| `ErrorStateCard` | `lib/src/shared/presentation/widgets/error_state_card.dart` |
| `ScreenNoteTextField` | 优先拆到任务编辑共享输入组件 |

### 6.3 页面职责边界

- 页面只做展示、输入与导航，不直接写数据库。
- 完成、删除、恢复、更新都必须走应用层用例。
- 快照刷新只能由应用层动作触发，页面不直接刷新 Widget 桥接。
- `expired` 只能是展示派生状态，不在设计和实现中落成第四种持久状态。
- 隐私规则优先级高于展示便利，设计上已默认外露场景隐藏正文。

## 7. 阶段二导出验收图

以下验收图已从 `screen_note_stage2.pen` 导出到 `docs/design_exports/screen_note_stage2`：

- `page-home-content.png`
- `page-home-empty.png`
- `page-task-editor-content.png`
- `page-task-detail-completed.png`
- `page-completed-history-empty.png`
- `page-deleted-history-content.png`
- `page-settings-content.png`
- `page-widget-settings-private-preview.png`

## 8. 对后续实现的强约束

- Flutter 页面实现不得跳过本设计稿直接临时改版。
- 如实现中发现结构缺口，先补 `screen_note_stage2.pen`，再修改 Dart。
- 设置页不得提前接入通知、Pro、系统入口等阶段外内容。
- 最近完成页必须支持恢复，不再沿用阶段一“仅查看原记录”的旧语义。
- Widget 预览页只能模拟稳定快照，不在阶段二承载真实 Widget 查询和刷新逻辑。
