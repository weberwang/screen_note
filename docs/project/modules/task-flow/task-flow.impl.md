# task-flow.impl

## 文档信息

- module_name: `task-flow`
- paired_uiux_doc: `not_used_in_current_workflow`
- global_technical_baseline: `docs/project/01-global-technical-baseline.md`
- design_sources:
  - `DESIGN.md`
  - `docs/project/global-design-guidelines.md`
  - `docs/project/design-direction-ab-home.png`
  - `docs/project/02-product-design-clarification-packet.md`

## 模块目标与边界

`task-flow` 是事项业务真源模块，负责创建、编辑、完成、删除、恢复、排序、过期派生与日志写入。它是整个产品最核心的业务模块。

## 业务能力

- 创建事项
- 编辑事项
- 完成事项
- 软删除事项
- 恢复事项
- 首页任务队列加载
- 过期/今日/普通任务派生排序
- 写入与读取操作日志

## 页面与状态范围

- 首页任务队列
- 主事项卡片内容来源
- 事项编辑页
- 完成 / 删除 / 恢复后的即时刷新

## Product Design Clarification Packet 继承

- core_user_journeys：记录不能忘的小事、看见当前最重要事项并继续处理
- page_families：`home`, `task_editor`
- critical_states：`active_today`, `active_overdue`, `private_safe`, `long_title`, `short_title`
- platform_identifier：`ios_device`
- density_posture：首页 `lean`，编辑页 `standard`

## 领域规则

- 持久状态只允许：`active`, `completed`, `deleted`
- `expired` 只能是展示派生态
- 删除必须软删除
- 所有关键状态变更必须写日志

## 状态与交互边界

- 首页主事项卡片永远来自当前优先级最高的 `active` 事项
- 列表行只承接次级事项队列
- 编辑事项不能重置既有终态
- 恢复事项需沿用原事项 ID，并补齐恢复日志

## 数据与依赖边界

- 数据真源：本地数据库
- 读写边界：仓储 + 用例
- 不直接依赖 Widget 展示投影
- 供给 `history-center` 日志与状态数据
- 供给 `widget-bridge` 稳定任务快照源

## 埋点与监控

- `task_created`
- `task_updated`
- `task_completed`
- `task_deleted`
- `task_restored`
- `task_feed_loaded`

## 测试范围

- 三态流转
- 过期派生与排序
- 删除恢复
- 长短标题处理
- 首页主事项选取逻辑

## 实现约束

- 页面层不得直接改库
- 关键状态变化必须通过应用层用例统一编排
- 首页必须优先服务主任务，不因列表密度扩张而稀释首要任务

## 后续视觉与实现准备

- module_effect_image_target: `task home and task editor priority flow`
- high_fidelity_priority: `single priority card plus light list rhythm`
- deferred_content_rule: `低优先级任务与高级配置下沉，不抢首屏`

## Provenance

- superpowers_refinement_status: `not_executed`
- superpowers_refinement_notes: `当前为 orchestrator 自动推进下的模块实现文档初稿，后续实现执行仍需显式进入 @superpowers`
