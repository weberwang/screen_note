# widget-bridge UI/UX RD

## 模块目标与目标用户

- 目标：把稳定快照以隐私安全、层级清晰的方式展示到锁屏/桌面 Widget。
- 目标用户：高频点亮手机、依赖持续可见提醒的用户。

## 页面范围与导航入口

- 页面范围：Widget 单条、三条与空态展示样式；隐私占位展示。
- 导航入口：系统 Widget，而非 App 内页面。

## 核心用户路径

1. 主应用更新任务后刷新稳定快照。
2. Widget 读取快照并按展示样式渲染。
3. 用户点击 Widget 回流 App。

## 状态矩阵

| 状态 | 说明 |
| --- | --- |
| ideal | 展示最需要处理的事项，结构清晰 |
| empty | 展示克制空态，不制造焦虑 |
| loading | not_applicable |
| error | 保留上一份有效快照 |
| permission | 隐私模式下只显示安全占位 |
| partial_data | 使用上次有效快照 |
| disabled | not_applicable |
| success | 点击后顺畅回流到 App |
| locked_or_premium | 后续展示样式扩展时使用，不进入 MVP |

## 结构语义

- `scroll_model`: none
- `list_model`: static block
- `overlay_model`: none
- `layout_model`: layered
- `sticky_model`: none
- `component_repeatability`: Widget 卡片、隐私占位块、空态块

## 模块级组件骨架

- `WidgetSingleCard`：单条重点任务卡
- `WidgetTripleList`：三条简化任务列表
- `WidgetPrivacyPlaceholder`：隐私事项或整体隐私模式下的安全展示

## 设计来源

- 共享设计包：`docs/rd/02-shared-design-packet.md`
- 共享冻结：`docs/rd/global-design-guidelines.md`
- 视觉证据：沿用 `home-overview` 的列表层级与卡片节奏

## 设计冻结卡

- 冻结目标：单条/三条 Widget 层级、隐私占位表达、空态姿态
- 不可变项：Widget 不泄露隐私正文；刷新失败保留最后有效内容
- 允许调整：系统容器边距、文字截断策略、图标密度
- 审批记录：`workflow-orchestrator --auto` 于 2026-06-04 自动确认

## 接受门禁

- UI/UX：无需进入 App 即能读懂当前重点事项
- 模块冻结：隐私占位与空态都具备稳定表达
- 代码交接：Widget 只读快照，不承载复杂排序推导
