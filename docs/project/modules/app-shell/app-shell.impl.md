# app-shell.impl

## 文档信息

- module_name: `app-shell`
- paired_uiux_doc: `not_used_in_current_workflow`
- global_technical_baseline: `docs/project/01-global-technical-baseline.md`
- design_sources:
  - `DESIGN.md`
  - `docs/project/global-design-guidelines.md`
  - `docs/project/design-direction-ab-home.png`
  - `docs/project/02-product-design-clarification-packet.md`
  - `docs/project/modules/app-shell/app-shell-design-source-packet.md`

## 模块目标与边界

`app-shell` 负责共享壳层、顶级导航、全局快速添加入口与系统回流宿主。它不负责事项真源、历史数据或 Widget 快照计算，但负责承接这些模块的稳定入口与共享容器。

## 业务能力

- 渲染 `Home / History / Settings` 三栏底部导航
- 提供全局快速添加触发位
- 承接系统快捷入口、深链或回流启动后的页面分发
- 为后续功能模块提供共享 Scaffold 与导航上下文

## 页面与状态范围

- 壳层首页选中态
- 历史页选中态
- 设置页选中态
- 全局快速添加触发态
- 系统回流到指定模块的跳转态

## Product Design Clarification Packet 继承

- core_user_journeys：继承首页看见最重要事项、历史恢复与降级可继续使用三条主链路
- page_families：`shared_shell`
- critical_states：`first_use_empty`, `notification_permission_denied`, `widget_refresh_failed`
- platform_identifier：`ios_device`
- density_posture：首页保持 `lean`

## 模块级共享组件约束

- `bottom_nav_shell`
  - 不可改为四栏或五栏
  - 图标与标签都必须清楚可扫读
- `global_quick_add`
  - 必须是独立全局动作
  - 不能退化成底栏普通 tab
- `app_shell_feedback_host`
  - 承接全局轻量反馈
  - 不能遮挡主任务优先级

## 状态与交互边界

- 允许的顶级导航切换：`home <-> history <-> settings`
- 快速添加应优先作为浮层、半页或上下文入口，不进入新视觉世界
- 系统回流失败时，回退到首页，不阻断主壳层展示

## 数据与依赖边界

- 不直接持有任务真源
- 通过 Provider / 路由装配依赖 `task-flow`、`history-center`、`settings-center`
- 后续由 `widget-bridge` 通过系统回流参数接入壳层

## 埋点与监控

- `shell_tab_switched`
- `global_quick_add_opened`
- `launch_route_resolved`
- `launch_route_fallback`

## 测试范围

- 底栏切换逻辑
- 默认启动页落点
- 深链 / 系统回流分发
- 全局快速添加入口展示与触发

## 实现约束

- 必须保持共享冻结的壳层结构
- 不得把业务判断塞回壳层页面
- 不得在壳层实现中重新发明另一套导航或反馈语言

## 后续视觉与实现准备

- 当前文档已足够进入模块效果图与模块原型阶段
- module_effect_image_target: `home shell with global quick add and bottom nav`
- module_effect_image_path: `docs/project/modules/app-shell/app-shell-effect-home-v2.png`
- high_fidelity_priority: `shared shell consistency before decorative polish`
- effect_image_notes: `已确认使用去装饰化的 v2 版本作为模块视觉证据，保留轻微纸感但不引入额外情绪化装饰`
- frozen_design_source_packet: `docs/project/modules/app-shell/app-shell-design-source-packet.md`
- freeze_decision_record: `docs/project/modules/app-shell/app-shell-freeze-decision.md`

## Provenance

- superpowers_refinement_status: `not_executed`
- superpowers_refinement_notes: `当前为 orchestrator 自动推进下的模块实现文档初稿，后续实现执行仍需显式进入 @superpowers`
