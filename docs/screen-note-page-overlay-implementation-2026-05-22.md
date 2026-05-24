# 屏记页面与弹出组件实现细分 v1.0

## 1. 文档信息

- 文档名称：屏记页面与弹出组件实现细分
- 文档日期：2026-05-22
- 来源文档：`docs/screen-note-prd-2026-05-22.md`、`docs/screen-note-rd-plan-2026-05-22.md`、`docs/screen-note-visual-design-guide-2026-05-22.md`
- 适用范围：Flutter 主 App、iOS 快速入口落地页、iOS 锁屏小组件展示状态
- 输出目的：把所有页面、底部弹层、对话框、提示组件和系统入口拆到可实现粒度

## 2. 实现原则

- 页面只负责展示、输入和导航，不直接写数据库。
- 弹出组件只负责一次轻量决策，不承载复杂流程。
- 所有状态修改通过应用层用例完成，例如创建、完成、删除、恢复、刷新小组件快照。
- 删除默认为软删除，页面和弹层不得触发物理删除。
- 过期是展示状态，页面不得把事项状态改成单独的 `expired`。
- 隐私内容在锁屏、小组件、通知和系统入口中默认不展示正文。
- 单个 Dart 文件不得超过 800 行，复杂页面必须拆分子组件。

## 3. 路由总览

| 路由 | 页面 | 优先级 | 入口 | 说明 |
| --- | --- | --- | --- | --- |
| `/` | 启动分发页 | P0 | App 启动 | 判断是否首次打开、是否有待处理深链 |
| `/onboarding` | 首次引导页 | P1 | 首次打开 | 解释锁屏提醒定位和权限边界 |
| `/home` | 首页 | P0 | 启动分发、返回主路径 | 快速添加、未完成事项、锁屏引导 |
| `/task/new` | 新建事项页 | P0 | 首页、深链兜底 | 复杂新建场景，普通创建优先用首页输入框 |
| `/task/:id` | 事项详情页 | P0 | 列表、通知、Widget 深链 | 查看、编辑、完成、删除 |
| `/history/completed` | 最近完成页 | P1 | 首页、设置 | 查看已完成事项 |
| `/history/deleted` | 最近删除页 | P1 | 首页、设置 | 恢复误删事项 |
| `/settings` | 设置页 | P0 | 首页 | 锁屏、隐私、通知、Pro、关于 |
| `/settings/widget` | 锁屏显示设置页 | P0 | 设置、引导卡片 | 管理 Widget 展示模式和引导 |
| `/settings/privacy` | 隐私设置页 | P1 | 设置 | 管理锁屏隐藏正文 |
| `/settings/notifications` | 通知设置页 | P0 | 设置、权限提示 | 查看权限、普通提醒说明 |
| `/settings/pro` | Pro 权益页 | P1 | 设置、权益入口 | 展示付费权益，不阻断基础功能 |
| `/settings/about` | 关于与反馈页 | P2 | 设置 | 版本、反馈、隐私说明 |
| `/quick-add` | 快速添加落地页 | P1 | App Intents 失败兜底、深链 | 保留草稿并完成快速添加 |
| `/android-waitlist` | Android 等待名单页 | P2 | 设置、Pro、外部链接 | 收集 Android 验证需求 |

## 4. 建议 Flutter 文件结构

```text
lib/src/
  app/
    app.dart
    router.dart
    route_paths.dart
  tasks/presentation/
    pages/
      launch_gate_page.dart
      onboarding_page.dart
      home_page.dart
      task_editor_page.dart
      task_detail_page.dart
      quick_add_page.dart
    widgets/
      quick_input_card.dart
      task_card.dart
      task_status_chip.dart
      task_action_row.dart
      task_empty_state.dart
      task_list_section.dart
      task_visibility_badge.dart
    overlays/
      quick_add_sheet.dart
      task_actions_sheet.dart
      due_time_sheet.dart
      reminder_mode_sheet.dart
      privacy_mode_sheet.dart
      delete_task_dialog.dart
      restore_task_dialog.dart
      discard_changes_dialog.dart
  history/presentation/
    pages/
      completed_history_page.dart
      deleted_history_page.dart
    widgets/
      history_task_card.dart
      deleted_task_card.dart
  settings/presentation/
    pages/
      settings_page.dart
      widget_settings_page.dart
      privacy_settings_page.dart
      notification_settings_page.dart
      pro_page.dart
      about_page.dart
      android_waitlist_page.dart
    widgets/
      settings_group.dart
      settings_tile.dart
      pro_benefit_card.dart
      widget_preview_card.dart
    overlays/
      widget_install_guide_sheet.dart
      notification_permission_sheet.dart
      pro_paywall_sheet.dart
      privacy_explain_sheet.dart
  shared/presentation/
    widgets/
      screen_note_scaffold.dart
      primary_action_button.dart
      secondary_action_button.dart
      screen_note_text_field.dart
      screen_note_snackbar.dart
      empty_state_card.dart
      error_state_card.dart
```

拆分要求：

- `home_page.dart` 只组装页面，不内联事项卡片、输入框和引导卡片。
- `task_detail_page.dart` 不内联时间选择、删除确认、提醒方式选择等弹层。
- `settings_page.dart` 只放设置分组入口，具体设置项进入独立页面。
- 所有弹层放入 `overlays`，避免页面文件过长。

## 5. 页面实现细分

### 5.1 启动分发页

文件：`lib/src/tasks/presentation/pages/launch_gate_page.dart`

职责：

- 处理 App 冷启动后的第一跳。
- 判断是否首次打开。
- 处理通知、Widget、快速添加兜底深链。
- 避免业务页面承担启动分发逻辑。

数据依赖：

- 首次打开状态。
- 深链参数。
- 通知点击参数。
- 快速添加草稿参数。

页面状态：

- 加载中。
- 跳转首页。
- 跳转首次引导。
- 跳转事项详情。
- 跳转快速添加。

交互规则：

- 不展示复杂 UI，只展示极简品牌加载。
- 深链解析失败时进入首页并展示非阻断提示。
- 任何启动异常都不能阻止用户进入首页。

验收标准：

- 首次用户进入引导页。
- 老用户直接进入首页。
- 通知点击可进入对应事项详情。
- 无效深链不会导致白屏。

### 5.2 首次引导页

文件：`lib/src/tasks/presentation/pages/onboarding_page.dart`

职责：

- 解释屏记的核心价值。
- 引导用户理解锁屏小组件不是实时刷新承诺。
- 引导开启通知但不强制。

页面结构：

- 品牌标题：“把不能忘的小事放到锁屏上”。
- 三个价值点：随手记、锁屏看、不丢失。
- 主按钮：“开始记录”。
- 次按钮：“先不设置通知”。

弹层依赖：

- `notification_permission_sheet.dart`。
- `widget_install_guide_sheet.dart`。

交互规则：

- 不在第一屏要求登录。
- 不强制打开通知权限。
- 用户跳过权限后仍进入首页。

验收标准：

- 新用户能在 2 步内进入首页。
- 拒绝通知权限不影响后续使用。
- 文案不承诺 Widget 实时刷新。

### 5.3 首页

文件：`lib/src/tasks/presentation/pages/home_page.dart`

职责：

- 提供 3 秒内快速记录入口。
- 展示当前未完成事项。
- 暴露低干扰的锁屏、历史和设置入口。

页面结构：

- 顶部日期和轻文案。
- 快速输入卡片。
- 当前事项列表。
- 锁屏小组件引导卡片。
- 底部或右上角设置入口。

数据依赖：

- 未完成事项列表。
- 已排序展示列表。
- 过期派生状态。
- Widget 是否已引导。
- 通知权限状态。

空状态：

- 标题：“写下一件别忘的事”。
- 说明：“屏记会把重要事项放到锁屏提醒。”
- 主操作聚焦输入框。

交互规则：

- 输入框回车或点击添加后立即创建 active 事项。
- 事项创建成功后清空输入框，并触发 Widget 快照刷新。
- 创建失败时保留输入内容。
- 点击事项卡片进入详情页。
- 点击完成按钮直接完成事项，不二次确认。
- 左滑事项展示完成和删除快捷操作。

弹层依赖：

- `quick_add_sheet.dart`。
- `task_actions_sheet.dart`。
- `delete_task_dialog.dart`。
- `widget_install_guide_sheet.dart`。
- `notification_permission_sheet.dart`。

验收标准：

- 首页首屏可见输入框。
- 无事项、加载、错误、空快照状态都有明确展示。
- 过期事项仍显示在当前事项列表。
- 创建失败不丢失用户输入。

### 5.4 新建事项页

文件：`lib/src/tasks/presentation/pages/task_editor_page.dart`

职责：

- 承载比首页快速输入更完整的新建流程。
- 支持备注、截止时间、置顶、隐私、提醒方式。

页面结构：

- 标题输入。
- 备注输入。
- 截止或提醒时间入口。
- 置顶开关。
- 隐私开关。
- 提醒方式入口。
- 保存按钮。

数据依赖：

- 新建草稿。
- 通知权限状态。
- Pro 权益状态。

交互规则：

- 标题为空时禁用保存。
- 返回时若有改动，弹出放弃修改确认。
- 保存成功后返回首页或进入详情页。
- 若通知权限未开但设置了提醒，展示非阻断提示。

弹层依赖：

- `due_time_sheet.dart`。
- `reminder_mode_sheet.dart`。
- `privacy_explain_sheet.dart`。
- `discard_changes_dialog.dart`。

验收标准：

- 保存后事项进入未完成列表。
- 设置截止时间后能调度普通提醒。
- 权限不足时事项仍可保存。

### 5.5 事项详情页

文件：`lib/src/tasks/presentation/pages/task_detail_page.dart`

职责：

- 查看和编辑单个事项。
- 执行完成、删除、恢复相关操作。
- 展示操作后的可靠状态。

页面结构：

- 标题编辑区。
- 备注编辑区。
- 状态标签区。
- 截止时间区。
- 置顶开关。
- 隐私开关。
- 提醒方式区。
- 操作区：完成、删除、恢复。

数据依赖：

- Task 详情。
- TaskEvent 最近操作。
- 过期派生状态。
- 通知权限状态。
- Pro 权益状态。

交互规则：

- active 事项显示完成和删除。
- completed 事项显示恢复到未完成或删除。
- deleted 事项显示恢复，不显示完成。
- 修改字段自动进入未保存状态。
- 离开有未保存改动时展示确认。
- 删除后返回上一页并显示可恢复提示。

弹层依赖：

- `due_time_sheet.dart`。
- `reminder_mode_sheet.dart`。
- `delete_task_dialog.dart`。
- `restore_task_dialog.dart`。
- `discard_changes_dialog.dart`。
- `pro_paywall_sheet.dart`。

验收标准：

- 过期 active 事项不会从详情页消失。
- 删除事项进入最近删除。
- 完成事项进入最近完成。
- 恢复事项回到未完成列表。
- 任何状态修改都会触发 Widget 快照刷新。

### 5.6 快速添加落地页

文件：`lib/src/tasks/presentation/pages/quick_add_page.dart`

职责：

- 作为 App Intents、控制中心、锁屏或 Action Button 失败兜底。
- 保留系统入口传入的草稿。
- 用最少交互完成创建。

页面结构：

- 自动聚焦输入框。
- 添加按钮。
- 取消按钮。
- 二级选项：时间、置顶、隐私。

数据依赖：

- 深链草稿文本。
- 快速入口来源。
- 通知权限状态。

交互规则：

- 有草稿时自动填入输入框。
- 添加成功后展示短反馈并返回上一场景或首页。
- 添加失败时保留草稿。
- 不展示完整设置入口。

弹层依赖：

- `due_time_sheet.dart`。
- `privacy_mode_sheet.dart`。

验收标准：

- 快速添加默认写入 active 事项。
- 用户输入不会因权限失败丢失。
- 流程不超过 3 秒。

### 5.7 最近完成页

文件：`lib/src/history/presentation/pages/completed_history_page.dart`

职责：

- 展示最近完成事项。
- 支持恢复到未完成。
- 让用户确认事项没有丢失。

页面结构：

- 页面标题：“最近完成”。
- 完成事项列表。
- 空状态。
- 恢复入口。

数据依赖：

- status 为 completed 的事项。
- completedAt 排序。

交互规则：

- 点击卡片进入详情页。
- 点击恢复弹出恢复确认。
- MVP 不提供批量清空。

弹层依赖：

- `restore_task_dialog.dart`。

验收标准：

- 完成事项按完成时间倒序展示。
- 恢复后事项回到首页未完成列表。
- 恢复行为写入操作日志。

### 5.8 最近删除页

文件：`lib/src/history/presentation/pages/deleted_history_page.dart`

职责：

- 展示 30 天内软删除事项。
- 支持恢复误删。
- 展示剩余保留时间。

页面结构：

- 页面标题：“最近删除”。
- 说明：“删除事项会保留 30 天”。
- 删除事项列表。
- 空状态。

数据依赖：

- status 为 deleted 的事项。
- deletedAt 排序。
- 剩余保留天数。

交互规则：

- 恢复按钮比永久删除更明显。
- MVP 不提供用户手动永久删除。
- 过保留期清理由维护任务处理，不从页面直接触发。

弹层依赖：

- `restore_task_dialog.dart`。

验收标准：

- 删除事项可恢复。
- 页面不提供危险批量操作。
- 剩余天数展示准确。

### 5.9 设置页

文件：`lib/src/settings/presentation/pages/settings_page.dart`

职责：

- 承载低频配置入口。
- 不打断首页快速记录。

页面结构：

- 锁屏显示。
- 隐私。
- 通知提醒。
- 最近完成。
- 最近删除。
- Pro 能力。
- 关于与反馈。

数据依赖：

- Widget 引导状态。
- 隐私模式状态。
- 通知权限状态。
- Pro 权益状态。

交互规则：

- 每个设置项进入独立页面。
- 权限未开启时显示轻提示，不使用红色警告。
- Pro 入口展示说明，不强插购买。

验收标准：

- 设置页没有影响快速记录的弹窗。
- 权限状态展示准确。
- 免费功能和 Pro 功能边界清晰。

### 5.10 锁屏显示设置页

文件：`lib/src/settings/presentation/pages/widget_settings_page.dart`

职责：

- 管理小组件展示模式。
- 引导用户添加锁屏小组件。
- 解释刷新限制。

页面结构：

- 小组件预览卡片。
- 展示模式选择：单条、三条、今日。
- 隐私模式入口。
- 添加到锁屏引导。
- 刷新说明。

数据依赖：

- 当前 Widget 展示模式。
- 当前 Widget 快照。
- 隐私模式状态。

交互规则：

- 切换展示模式后立即写入设置并刷新快照。
- 点击引导打开安装说明弹层。
- 文案不得承诺实时刷新。

弹层依赖：

- `widget_install_guide_sheet.dart`。
- `privacy_mode_sheet.dart`。

验收标准：

- 展示模式切换后小组件快照数据更新。
- 隐私模式启用后预览不展示正文。
- 刷新限制说明明确。

### 5.11 隐私设置页

文件：`lib/src/settings/presentation/pages/privacy_settings_page.dart`

职责：

- 管理锁屏正文隐藏策略。
- 解释隐私事项和全局隐私模式的区别。

页面结构：

- 全局锁屏隐私开关。
- 隐私事项默认隐藏说明。
- 通知隐私说明。
- 示例预览。

数据依赖：

- 全局隐私模式。
- 单事项隐私默认值。

交互规则：

- 开关变更后立即刷新 Widget 快照。
- 隐私说明使用底部弹层，不跳复杂页面。
- VoiceOver 也不能读取隐藏正文。

弹层依赖：

- `privacy_explain_sheet.dart`。

验收标准：

- 开启隐私后 Widget 和通知不显示正文。
- 关闭隐私后仍尊重单事项 `isPrivate`。
- 示例预览和真实规则一致。

### 5.12 通知设置页

文件：`lib/src/settings/presentation/pages/notification_settings_page.dart`

职责：

- 展示通知权限状态。
- 请求通知权限。
- 解释普通提醒和强提醒。

页面结构：

- 权限状态卡片。
- 普通提醒说明。
- 强提醒 Pro 入口。
- 打开系统设置入口。

数据依赖：

- 系统通知权限。
- Pro 权益状态。
- 强提醒开关状态。

交互规则：

- 权限未决定时可请求权限。
- 权限拒绝后只能引导打开系统设置。
- 未开权限不阻断事项创建。
- 强提醒入口未购买时打开 Pro 弹层。

弹层依赖：

- `notification_permission_sheet.dart`。
- `pro_paywall_sheet.dart`。

验收标准：

- 权限状态与系统一致。
- 权限拒绝后核心功能仍可用。
- 强提醒不影响普通提醒。

### 5.13 Pro 权益页

文件：`lib/src/settings/presentation/pages/pro_page.dart`

职责：

- 展示 Pro 能力和边界。
- 不把基础可靠性包装成付费点。

页面结构：

- Pro 标题卡片。
- 权益列表：多样式、强提醒、iCloud、Apple Reminders、AI 提取、Apple Watch。
- 免费版仍保留说明。
- 购买或试用入口。

数据依赖：

- Pro 权益状态。
- 远程或本地权益配置。

交互规则：

- 点击未上线能力展示“正在验证”说明。
- 购买失败展示可重试提示，不阻断返回。
- 不在创建任务过程中强制弹出。

弹层依赖：

- `pro_paywall_sheet.dart`。

验收标准：

- 免费版能力不被误导为不可用。
- Pro 权益描述与 PRD 一致。
- 购买失败不影响基础事项管理。

### 5.14 关于与反馈页

文件：`lib/src/settings/presentation/pages/about_page.dart`

职责：

- 展示版本信息、隐私说明和反馈入口。
- 承载任务误消失反馈入口。

页面结构：

- App 名称和版本。
- 隐私说明。
- 反馈入口。
- 任务误消失反馈入口。

数据依赖：

- App 版本。
- 设备和系统信息。
- 最近错误摘要。

交互规则：

- 反馈不上传用户事项正文，除非用户主动确认。
- 任务误消失反馈优先提示最近删除和操作日志可排查。

验收标准：

- 用户可以找到反馈入口。
- 隐私说明明确“不上传用户内容到第三方模型”。

### 5.15 Android 等待名单页

文件：`lib/src/settings/presentation/pages/android_waitlist_page.dart`

职责：

- 收集 Android 需求验证信息。
- 不承诺完整 Android 客户端排期。

页面结构：

- Android 验证说明。
- 邮箱或联系方式输入。
- 机型选择。
- 使用场景选择。
- 提交按钮。

数据依赖：

- 等待名单表单。
- 提交状态。

交互规则：

- 提交前说明用途。
- 提交失败保留表单。
- 达到 500 人后再进入开发评审。

验收标准：

- 用户知道这是等待名单，不是已上线功能。
- 表单失败不丢失输入。

## 6. 弹出组件实现细分

### 6.1 快速添加底部弹层

文件：`lib/src/tasks/presentation/overlays/quick_add_sheet.dart`

用途：

- 从首页或其他轻入口快速创建事项。
- 比完整新建页更轻。

内容：

- 单行或多行输入框。
- 添加按钮。
- 时间、置顶、隐私轻选项。

输入参数：

- `initialText`。
- `source`。
- `defaultPinned`。
- `defaultPrivate`。

输出结果：

- 创建成功的 `taskId`。
- 用户取消。
- 创建失败原因。

交互规则：

- 打开后自动聚焦。
- 标题为空时禁用添加。
- 失败时保留输入。
- 成功后关闭弹层并展示短提示。

### 6.2 事项操作底部弹层

文件：`lib/src/tasks/presentation/overlays/task_actions_sheet.dart`

用途：

- 长按或更多按钮后展示当前事项可用操作。

内容：

- 编辑。
- 置顶或取消置顶。
- 设置时间。
- 设为隐私或取消隐私。
- 完成。
- 删除。

输入参数：

- `taskId`。
- 当前展示状态。
- 当前权限和权益状态。

交互规则：

- completed 事项不显示完成。
- deleted 事项只显示恢复和查看。
- 删除必须进入删除确认对话框。
- Pro 功能点击时打开 Pro 弹层。

### 6.3 截止时间底部弹层

文件：`lib/src/tasks/presentation/overlays/due_time_sheet.dart`

用途：

- 选择或清除事项截止和提醒时间。

内容：

- 快捷项：今天晚些时候、明早、明天、下周。
- 日期选择。
- 时间选择。
- 清除时间。

输入参数：

- `initialDueAt`。
- `allowClear`。

输出结果：

- 新的 `dueAt`。
- 清除时间。
- 取消。

交互规则：

- 默认不强制选择时间。
- 选择过去时间时允许保存，但显示为已过期。
- 清除时间后取消已调度通知。

### 6.4 提醒方式底部弹层

文件：`lib/src/tasks/presentation/overlays/reminder_mode_sheet.dart`

用途：

- 选择普通提醒或强提醒。

内容：

- 普通提醒。
- 强提醒。
- 权限状态提示。
- Pro 说明。

输入参数：

- `currentMode`。
- `notificationPermissionStatus`。
- `isProEnabled`。

交互规则：

- 普通提醒免费可用。
- 强提醒未购买时进入 Pro 弹层。
- 通知权限拒绝时展示系统设置入口。

### 6.5 隐私模式底部弹层

文件：`lib/src/tasks/presentation/overlays/privacy_mode_sheet.dart`

用途：

- 设置单事项隐私或全局锁屏隐私。

内容：

- 隐私开关。
- 锁屏展示预览。
- 说明：“隐私模式下只显示数量或模糊文案。”

输入参数：

- `isPrivate`。
- `scope`：task 或 global。

交互规则：

- 单事项隐私高于全局展示正文设置。
- 保存后触发 Widget 快照刷新。
- 不把基础隐私作为 Pro 门槛。

### 6.6 删除确认对话框

文件：`lib/src/tasks/presentation/overlays/delete_task_dialog.dart`

用途：

- 防止误删。
- 明确删除可恢复。

内容：

- 标题：“删除这件事？”
- 说明：“删除后 30 天内可在最近删除恢复。”
- 主按钮：“删除”。
- 次按钮：“取消”。

输入参数：

- `taskId`。
- `taskTitle`。

交互规则：

- 点击删除只执行软删除。
- 删除成功后关闭并提示可恢复。
- 删除失败时留在当前页面。

### 6.7 恢复确认对话框

文件：`lib/src/tasks/presentation/overlays/restore_task_dialog.dart`

用途：

- 确认从已完成或最近删除恢复事项。

内容：

- 标题：“恢复到未完成？”
- 说明：“恢复后会重新出现在首页和锁屏排序中。”
- 主按钮：“恢复”。
- 次按钮：“取消”。

输入参数：

- `taskId`。
- `fromStatus`。

交互规则：

- 恢复后状态改为 active。
- 恢复后触发 Widget 快照刷新。
- 恢复行为写入 TaskEvent。

### 6.8 放弃修改确认对话框

文件：`lib/src/tasks/presentation/overlays/discard_changes_dialog.dart`

用途：

- 用户编辑后返回时防止草稿丢失。

内容：

- 标题：“放弃这次修改？”
- 说明：“离开后未保存的内容不会保留。”
- 主按钮：“继续编辑”。
- 危险按钮：“放弃”。

输入参数：

- `hasUnsavedChanges`。

交互规则：

- 没有改动时不弹出。
- 放弃后不写操作日志。

### 6.9 小组件安装引导底部弹层

文件：`lib/src/settings/presentation/overlays/widget_install_guide_sheet.dart`

用途：

- 引导用户添加锁屏小组件。
- 解释系统刷新限制。

内容：

- 步骤 1：长按锁屏。
- 步骤 2：点击自定。
- 步骤 3：添加屏记小组件。
- 说明：系统会决定刷新时机。

输入参数：

- `entrySource`。

交互规则：

- 不承诺实时刷新。
- 引导完成后记录已展示状态。
- 可从首页和设置重复打开。

### 6.10 通知权限说明底部弹层

文件：`lib/src/settings/presentation/overlays/notification_permission_sheet.dart`

用途：

- 请求通知权限前解释用途。
- 权限拒绝后提供降级说明。

内容：

- 标题：“需要到点提醒吗？”
- 说明：“不开通知也能继续用锁屏提醒。”
- 主按钮：“打开通知”或“去系统设置”。
- 次按钮：“暂时不用”。

输入参数：

- `permissionStatus`。

交互规则：

- 未决定时触发系统权限请求。
- 已拒绝时打开系统设置。
- 用户跳过后不再频繁打扰。

### 6.11 Pro 付费说明弹层

文件：`lib/src/settings/presentation/overlays/pro_paywall_sheet.dart`

用途：

- 解释 Pro 权益。
- 承接强提醒、多样式、同步等入口。

内容：

- Pro 标题。
- 触发来源对应权益说明。
- 免费版仍可用说明。
- 购买或试用按钮。
- 关闭按钮。

输入参数：

- `sourceFeature`。
- `benefits`。

交互规则：

- 不在 P0 主链路强制出现。
- 购买失败不影响当前操作。
- 基础隐私不进入付费弹层。

### 6.12 隐私说明底部弹层

文件：`lib/src/settings/presentation/overlays/privacy_explain_sheet.dart`

用途：

- 解释隐私事项、全局隐私和锁屏显示的关系。

内容：

- 隐私事项：单条不显示正文。
- 全局隐私：锁屏统一隐藏正文。
- App 内仍可查看。
- VoiceOver 也不会读取隐藏正文。

输入参数：

- `scope`。

交互规则：

- 只说明规则，不直接修改状态。
- 从设置和事项详情都可打开。

### 6.13 SnackBar 轻提示

文件：`lib/src/shared/presentation/widgets/screen_note_snackbar.dart`

用途：

- 表达短反馈，不打断主流程。

提示类型：

- 创建成功：“已放到锁屏提醒”。
- 完成成功：“已完成”。
- 删除成功：“已删除，可在最近删除恢复”。
- 恢复成功：“已恢复到未完成”。
- 通知未开：“通知没打开，锁屏提醒仍可使用”。
- 快照失败：“锁屏显示稍后更新，内容不会丢失”。

交互规则：

- 删除成功提示可带“查看”操作进入最近删除。
- 错误提示要保留用户输入或说明下一步。
- 不使用强警告色大面积展示。

## 7. 共享组件实现细分

### 7.1 页面骨架

文件：`lib/src/shared/presentation/widgets/screen_note_scaffold.dart`

职责：

- 统一纸感背景。
- 统一安全区。
- 统一页面左右边距。
- 统一加载、错误和空状态插槽。

适用页面：

- 首页。
- 历史页。
- 设置页。
- 详情页。

### 7.2 快速输入卡片

文件：`lib/src/tasks/presentation/widgets/quick_input_card.dart`

职责：

- 承载首页 3 秒创建入口。
- 支持输入、添加、快捷时间和隐私入口。

状态：

- 空输入。
- 输入中。
- 提交中。
- 提交失败。

验收：

- 提交失败时文本不丢。
- 键盘回车可创建。
- VoiceOver 能读出用途和当前输入。

### 7.3 事项卡片

文件：`lib/src/tasks/presentation/widgets/task_card.dart`

职责：

- 展示 active、completed、deleted 的统一事项卡片。
- 显示置顶、过期、今日、隐私、完成状态。

输入参数：

- `task`。
- `displayState`。
- `showActions`。
- `onTap`。
- `onComplete`。
- `onDelete`。
- `onRestore`。

验收：

- 过期状态不覆盖 active 状态。
- 隐私事项在需要隐藏正文的上下文不展示标题。
- 颜色不是唯一状态表达。

### 7.4 状态标签

文件：`lib/src/tasks/presentation/widgets/task_status_chip.dart`

职责：

- 统一展示置顶、已过期、今天、隐私、已完成、已删除。

规则：

- 列表中最多显示 2 个标签。
- 详情页可显示完整状态。
- 标签文案短，不超过 4 个汉字。

### 7.5 历史事项卡片

文件：`lib/src/history/presentation/widgets/history_task_card.dart`

职责：

- 展示已完成事项。
- 提供恢复入口。

字段：

- 标题。
- 完成时间。
- 备注摘要。
- 恢复按钮。

### 7.6 最近删除卡片

文件：`lib/src/history/presentation/widgets/deleted_task_card.dart`

职责：

- 展示已删除事项。
- 展示剩余保留时间。
- 提供恢复入口。

字段：

- 标题。
- 删除时间。
- 剩余天数。
- 恢复按钮。

### 7.7 设置分组与设置项

文件：

- `lib/src/settings/presentation/widgets/settings_group.dart`
- `lib/src/settings/presentation/widgets/settings_tile.dart`

职责：

- 统一设置页视觉结构。
- 支持状态说明、开关、箭头和权限提示。

验收：

- 设置项可被 VoiceOver 正确读取。
- 权限状态不只依赖颜色。

### 7.8 小组件预览卡片

文件：`lib/src/settings/presentation/widgets/widget_preview_card.dart`

职责：

- 在 App 内模拟锁屏小组件展示效果。
- 用于设置页和引导页。

展示模式：

- 单条重点。
- 三条列表。
- 今日事项。
- 隐私模式。
- 空状态。

验收：

- 预览规则和真实 Widget 快照一致。
- 隐私模式预览不展示正文。

## 8. 状态、加载和错误规范

### 8.1 页面加载

适用场景：

- 首页首次读取事项。
- 详情页读取事项。
- 历史页读取列表。
- 设置页读取权限状态。

展示规则：

- 使用轻量骨架或纸片占位。
- 不使用全屏进度条打断。
- 超过 2 秒显示说明：“正在读取本地记录”。

### 8.2 页面错误

错误类型：

- 本地数据库读取失败。
- 深链事项不存在。
- 通知权限读取失败。
- Widget 快照写入失败。

处理规则：

- 数据读取失败：提供重试。
- 事项不存在：返回首页并提示可能已删除。
- 权限读取失败：展示未知状态，不阻断使用。
- 快照写入失败：提示稍后更新，不删除事项。

### 8.3 空状态

空状态文案：

- 首页：“写下一件别忘的事”。
- 最近完成：“完成后会出现在这里”。
- 最近删除：“删除的事项会暂存在这里”。
- Widget 预览：“锁屏上会显示你的重要事项”。

规则：

- 不制造焦虑。
- 不放复杂插画。
- 主操作回到创建事项。

## 9. 深链与系统入口

### 9.1 通知点击

目标路由：`/task/:id`

参数：

- `taskId`。
- `source=notification`。

失败处理：

- 事项存在：进入详情页。
- 事项已删除：进入详情页并显示已删除状态。
- 事项不存在：进入首页并提示“这条事项暂时找不到”。

### 9.2 Widget 点击

目标路由：

- 单条事项：`/task/:id`。
- 隐私模式：`/home`。
- 空状态：`/home` 并聚焦输入框。

规则：

- 隐私模式不在深链参数中携带正文。
- Widget 点击失败不影响本地数据。

### 9.3 App Intents 快速添加兜底

目标路由：`/quick-add`

参数：

- `draftText`。
- `source=app_intent`。

规则：

- 原生快速添加失败时保留草稿跳转。
- Flutter 页面接管后仍默认创建 active 事项。

## 10. 页面与弹层验收矩阵

| 项目 | 必须验证 |
| --- | --- |
| 首页 | 输入、创建、完成、删除、空状态、错误状态 |
| 新建页 | 保存、放弃修改、时间、隐私、权限降级 |
| 详情页 | 编辑、完成、删除、恢复、过期展示 |
| 快速添加页 | 草稿保留、3 秒创建、失败不丢输入 |
| 最近完成页 | 倒序展示、恢复、空状态 |
| 最近删除页 | 30 天说明、恢复、无永久删除入口 |
| 设置页 | 路由入口、权限状态、Pro 边界 |
| Widget 设置页 | 模式切换、隐私预览、安装引导 |
| 隐私设置页 | 全局隐私、单事项隐私、Widget 刷新 |
| 通知设置页 | 权限请求、拒绝降级、系统设置跳转 |
| Pro 页 | 权益展示、购买失败不阻断 |
| 删除对话框 | 软删除、可恢复提示、失败停留 |
| 恢复对话框 | 状态回 active、日志写入、刷新快照 |
| 时间弹层 | 选择未来、选择过去、清除时间 |
| 权限弹层 | 未决定、拒绝、跳过 |
| SnackBar | 创建、完成、删除、恢复、快照失败 |

## 11. 推荐实现顺序

1. 建立路由和页面骨架。
2. 实现共享 Scaffold、按钮、输入框、SnackBar。
3. 实现首页和快速输入卡片。
4. 实现事项卡片和状态标签。
5. 实现新建页与详情页。
6. 实现时间、隐私、删除、恢复弹层。
7. 实现最近完成和最近删除页面。
8. 实现设置页与子设置页。
9. 实现 Widget 设置和安装引导。
10. 实现通知权限弹层和通知设置页。
11. 实现 Pro 页和 Pro 弹层。
12. 实现快速添加落地页和深链兜底。

## 12. 结论

屏记的页面体系应围绕“首页快速记录、详情可靠管理、历史可恢复、设置低干扰、锁屏可见”展开。弹出组件只处理轻量选择和确认，不承载复杂业务。后续实现时必须按页面、组件、弹层拆分文件，避免把首页、详情页或设置页堆成超长文件。
