# history-center.impl

## 文档信息

- module_name: `history-center`
- paired_uiux_doc: `not_used_in_current_workflow`
- global_technical_baseline: `docs/project/01-global-technical-baseline.md`
- design_sources:
  - `DESIGN.md`
  - `docs/project/global-design-guidelines.md`
  - `docs/project/02-product-design-clarification-packet.md`

## 模块目标与边界

`history-center` 承接最近完成与最近删除两条历史回看链路，核心职责是帮助用户建立“事项没有无故消失”的信任感，并提供恢复入口。

## 业务能力

- 加载最近完成事项
- 加载最近删除事项
- 执行恢复动作
- 展示关键状态时间线

## 页面与状态范围

- 最近完成列表
- 最近删除列表
- 恢复成功态
- 空历史态

## Product Design Clarification Packet 继承

- core_user_journeys：误删后恢复
- page_families：`history_center`
- critical_states：`recently_deleted`, `recently_completed`
- platform_identifier：`ios_device`
- density_posture：`standard`

## 状态与交互边界

- 历史中心以列表分区为主，不做仪表盘
- 恢复动作必须明确反馈“已恢复到 active”
- 最近完成默认只读，最近删除提供恢复

## 数据与依赖边界

- 依赖 `task-flow` 的状态与日志
- 不直接生成新快照
- 不持有独立任务真源

## 埋点与监控

- `history_completed_opened`
- `history_deleted_opened`
- `history_restore_triggered`
- `history_restore_succeeded`

## 测试范围

- 分区加载
- 恢复链路
- 空状态
- 删除与完成列表的排序

## 实现约束

- 不允许把历史中心做成复杂统计页
- 恢复链路优先于装饰和分析信息

## 后续视觉与实现准备

- module_effect_image_target: `history list with completed and deleted sections`
- high_fidelity_priority: `clear trust-restoring structure over decorative polish`

## Provenance

- superpowers_refinement_status: `not_executed`
- superpowers_refinement_notes: `当前为 orchestrator 自动推进下的模块实现文档初稿，后续实现执行仍需显式进入 @superpowers`
