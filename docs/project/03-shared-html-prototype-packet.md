# Shared HTML Prototype Packet

## Purpose

本文件作为共享 HTML 交互原型设计源的结构化说明稿，限定当前全局范围只覆盖共享主题、共享公共壳层、共享公共组件族和共享交互原则，不进入模块级最终页面实现代码。

## Scope

- 共享壳层：`Home / History / Settings`
- 全局快速添加入口
- 首页主事项卡片的共享结构原则
- 通用任务列表行的共享结构原则
- 状态标签、时间信息、空状态和降级提示的共享表达原则

## Shared Page Skeleton

### Home

- 顶部轻量品牌区
- 一个主事项卡片区
- 一个次级任务队列区
- 一个固定共享底部导航
- 一个全局快速添加入口

### History

- 共享壳层内的二级中心页
- 承接最近完成与最近删除
- 列表结构沿用共享任务行语义，不引入新的视觉世界

### Settings

- 共享壳层内的偏好与能力配置入口
- 列表组结构保持克制，优先信息清晰而不是“设置中心感”

## Shared Component Families

- `priority_reminder_card`
- `task_row`
- `status_chip`
- `bottom_nav_shell`
- `global_quick_add`
- `section_header`
- `empty_state_panel`
- `degradation_notice_inline`

## Interaction Principles

- 主事项卡片永远优先于列表扫描。
- 快速添加是全局高频动作，但不能压过当前最重要事项。
- 删除、恢复、通知拒绝、刷新失败都按“能力降级而非任务消失”来表达。
- 共享原型中的交互仅用于验证壳层、层级和共享行为原则，不替代模块实现文档。

## Visual Baseline

- 代表性共享视觉基线：`docs/project/design-direction-ab-home.png`
- 设计系统基线：`DESIGN.md`
- Mobbin 方向证据：`docs/project/03-mobbin-direction-evidence.md`

## Freeze Constraint

- 不允许在共享原型阶段引入模块级最终页面细节。
- 不允许改变已确认的共享壳层结构。
- 不允许把列表做成卡片堆叠式复杂管理界面。
- 不允许引入与当前浅色基线冲突的新视觉世界。
- 不允许把主卡片的轻微纸感扩大成重便签隐喻。
