# settings-center.impl

## 文档信息

- module_name: `settings-center`
- paired_uiux_doc: `not_used_in_current_workflow`
- global_technical_baseline: `docs/project/01-global-technical-baseline.md`
- design_sources:
  - `DESIGN.md`
  - `docs/project/global-design-guidelines.md`
  - `docs/project/02-product-design-clarification-packet.md`

## 模块目标与边界

`settings-center` 负责通知、隐私、展示样式、同步与会员入口等偏好配置，是系统能力边界的集中承接层。它负责暴露设置入口与状态，不负责完整的小组件安装页面本体。

## 业务能力

- 展示通知状态
- 展示与更新隐私设置
- 展示与更新小组件展示模式
- 展示同步状态与后续入口
- 展示会员入口与权益说明
- 提供“添加桌面小组件”入口跳转

## 页面与状态范围

- 设置列表
- 权限未开启提示
- 隐私模式切换
- 展示模式切换
- 同步未开启占位态

## Product Design Clarification Packet 继承

- core_user_journeys：权限或系统能力降级后继续使用
- page_families：`settings_center`
- critical_states：`notification_permission_denied`, `private_safe`
- platform_identifier：`ios_device`
- density_posture：`standard`

## 状态与交互边界

- 权限状态必须说明当前能力是否可用。
- 不允许用营销信息淹没核心设置页面。
- 同步与会员入口属于次级内容，不得压过通知 / 隐私 / 展示模式。
- “添加桌面小组件”在本模块中只是一条入口，不在这里展开完整安装说明。

## 数据与依赖边界

- 读写用户偏好
- 查询系统通知权限状态
- 向 `widget-bridge` 提供展示模式与隐私策略
- 不直接写任务真源

## 埋点与监控

- `settings_opened`
- `notification_setting_viewed`
- `privacy_mode_changed`
- `widget_display_mode_changed`
- `pro_entry_viewed`

## 测试范围

- 权限状态展示
- 偏好变更
- Widget 展示模式更新
- 隐私模式切换
- Widget 安装入口跳转

## 实现约束

- 所有权限失败都按降级提示处理。
- 不允许因未授权而阻断设置页主链路访问。
- 当冻结截图与旧实现文案冲突时，本轮以用户批准的截图显示值为准。
- 安装引导页证据和页面级效果图归 `widget-bridge`，本模块不重复持有。

## 后续视觉与实现准据

- module_effect_image_target: `settings list with notification, privacy, display mode, widget install entry, and upgrade entry`
- high_fidelity_priority: `clear grouped settings hierarchy with restrained promotional weight`
- approved_visual_value_override: `sync=Synced, membership=Active`

## Provenance

- superpowers_refinement_status: `not_executed`
- superpowers_refinement_notes: `当前由 orchestrator 自动推进生成模块实现文档初稿，后续真实实现执行仍需显式进入 @superpowers`
