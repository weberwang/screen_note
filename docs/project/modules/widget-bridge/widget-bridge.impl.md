# widget-bridge.impl

## 文档信息

- module_name: `widget-bridge`
- paired_uiux_doc: `not_used_in_current_workflow`
- global_technical_baseline: `docs/project/01-global-technical-baseline.md`
- design_sources:
  - `DESIGN.md`
  - `docs/project/global-design-guidelines.md`
  - `docs/project/02-product-design-clarification-packet.md`
  - `docs/project/design-direction-ab-home.png`

## 模块目标与边界

`widget-bridge` 负责把应用内稳定任务结果投影到 Widget / 锁屏共享层，并承接系统点击回流。它不负责复杂业务推导，只消费稳定快照。本轮同时把 App 内的安装引导页也收口到本模块，保持“入口在设置，页面归 bridge”。

## 业务能力

- 生成稳定快照
- 写入共享数据
- 在刷新失败时保留最后一次有效快照
- 读取展示模式与隐私配置
- 处理 Widget 点击后的回流参数
- 承接 App 内安装与预览页

## 页面与状态范围

- App 内安装与预览页
- Widget / 锁屏展示快照
- 空快照态
- 私密快照态
- 刷新失败降级态

## Product Design Clarification Packet 继承

- core_user_journeys：看见当前最重要事项并继续处理；能力降级后仍可继续使用
- page_families：`shared_shell`, `home`
- critical_states：`widget_refresh_failed`, `private_safe`, `no_urgent_tasks`
- platform_identifier：`ios_device`
- density_posture：`lean`

## 状态与交互边界

- 只展示稳定快照，不直接承载数据库查询或复杂排序。
- 刷新失败时必须保留最后一次有效结果。
- 私密事项不得泄露正文。
- Widget 点击回流必须回到共享壳层安全落点。
- 设置页里的“添加桌面小组件”只负责跳转，本模块负责完整页面体验。

## 数据与依赖边界

- 上游依赖 `task-flow` 的稳定任务结果
- 依赖 `settings-center` 的展示模式与隐私配置
- 通过桥接层调用 Widget 插件能力
- 不反向写任务真源

## 埋点与监控

- `widget_snapshot_generated`
- `widget_snapshot_write_failed`
- `widget_refresh_failed`
- `widget_launch_routed`

## 测试范围

- 稳定快照投影
- 空状态 / 私密状态
- 刷新失败保底
- 点击回流参数解析
- 安装页主动作与降级提示

## 实现约束

- Widget 读取层必须尽量简单。
- 不能把状态推导和排序逻辑搬进共享层。
- 降级策略必须稳定高于“尝试炫技刷新”。
- 安装页首屏必须先呈现预览和动作，而不是长说明文案。

## 后续视觉与实现准据

- module_effect_image_target: `widget snapshot representations plus in-app install guide page`
- high_fidelity_priority: `snapshot clarity, action clarity, and privacy discipline over decorative styling`

## Provenance

- superpowers_refinement_status: `not_executed`
- superpowers_refinement_notes: `当前由 orchestrator 自动推进生成模块实现文档初稿，后续真实实现执行仍需显式进入 @superpowers`
