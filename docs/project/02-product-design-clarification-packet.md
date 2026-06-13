# Product Design Clarification Packet

## 1. Core User Journeys

### 1.1 记录一件不能忘的小事

1. 用户在首页或系统快捷入口触发快速添加。
2. 用户输入一句事项标题。
3. 用户按需补充时间、提醒、隐私或置顶。
4. 保存后事项进入 `active`，并进入稳定快照链路。
5. 用户回到首页即可再次看见当前主事项或任务队列。

### 1.2 看见当前最重要事项并继续处理

1. 用户进入首页。
2. 首屏立即看见当前最重要事项。
3. 用户通过主卡片或列表继续进入详情、完成、推迟或编辑。

### 1.3 误删后恢复

1. 用户删除事项。
2. 事项进入最近删除。
3. 用户在历史中心恢复事项。
4. 事项重新回到 `active`，并保留可追溯记录。

### 1.4 权限或系统能力降级后继续使用

1. 用户拒绝通知权限，或 Widget/系统入口失败。
2. 应用明确提示能力降级。
3. 用户仍可继续创建、查看、完成、删除和恢复事项。

## 2. Page Families

- `home`
  - 当前最重要事项
  - 紧急任务 / 后续任务队列
  - 全局快速添加入口
- `task_editor`
  - 标题
  - 备注
  - 时间 / 提醒
  - 隐私 / 置顶
- `history_center`
  - 最近完成
  - 最近删除
  - 恢复入口
- `settings_center`
  - 通知
  - 隐私
  - 展示样式
  - 同步
  - 会员入口
- `shared_shell`
  - Home
  - History
  - Settings
  - 全局快速添加

## 3. Critical States

- first_use_empty
- no_urgent_tasks
- active_today
- active_overdue
- private_safe
- notification_permission_denied
- widget_refresh_failed
- recently_deleted
- recently_completed
- long_title
- short_title

## 4. Interaction Goals

- 首屏 3 秒内看懂当前最重要事项。
- 快速添加不进入重表单路径。
- 状态变更可感知，但不过度打断。
- 能力失败始终表达为“降级”，而不是“任务消失”。
- 删除、恢复、完成、编辑都应在交互上有清晰去向。

## 5. Platform Identifier

- `platform_identifier`: `ios_device`
- 当前设计与后续实现默认按 iPhone 主体验推进。
- 非主平台不参与当前共享冻结判断。

## 6. Platform-Aware Navigation And Feedback Expectations

- 顶级导航采用 `Home / History / Settings` 三栏共享壳层。
- 快速添加为独立全局动作，不作为底栏中的第四导航项。
- 首页反馈应轻、快、稳定，优先局部更新和轻量状态反馈。
- 删除、恢复、权限拒绝、刷新失败都需要 iOS 工具型产品常见的克制式反馈。

## 7. Per-Surface Information-Density Posture

### 7.1 Home

- `primary_task_visibility`: 当前最重要事项必须首屏直接可见。
- `deferred_or_secondary_content`: 次级任务队列可在主卡片之后；设置、历史和低频系统信息不得抢首屏。
- `density_posture`: `lean`
- `platform_adaptation_notes`: 允许纵向滚动，但不能靠压缩留白来换更多首屏项目。

### 7.2 Task Editor

- `primary_task_visibility`: 标题输入与关键时间/提醒动作优先。
- `deferred_or_secondary_content`: 备注、隐私、置顶等高级项可弱化或折叠。
- `density_posture`: `standard`
- `platform_adaptation_notes`: 应更像轻编辑而不是复杂配置面板。

### 7.3 History Center

- `primary_task_visibility`: 最近完成与最近删除分区清楚可扫读。
- `deferred_or_secondary_content`: 长解释文案与二级说明下沉。
- `density_posture`: `standard`
- `platform_adaptation_notes`: 保持列表中心式结构，不引入仪表盘布局。

### 7.4 Settings Center

- `primary_task_visibility`: 与当前用户决策最相关的能力项优先。
- `deferred_or_secondary_content`: 低频说明、品牌信息、辅助文本下沉。
- `density_posture`: `standard`
- `platform_adaptation_notes`: 保持 iOS 设置类页面的清晰分组，不堆叠过多营销信息。

## 8. Shared Shell Confirmation

- 已确认共享公共壳层：`Home / History / Settings + 全局快速添加`
- 已确认共享视觉基线候选：`docs/project/design-direction-ab-home.png`
- 已确认共享设计目标：单主任务优先、轻列表、独立快速添加、主卡片轻微温和纸感
