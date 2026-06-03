# 屏记模块索引

## 模块总览

| module_name | goal_or_scope | uiux_doc | impl_doc | depends_on | unblocks | parallel_group | recommended_stage | parallelization_notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| tasks | 承载首页主事项、详情、编辑、状态流转与主链路交互 | [tasks.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/tasks/tasks.ui-ux.md) | [tasks.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/tasks/tasks.impl.md) | none | history, quick_add, widget_bridge, settings | core | Stage 1 | 任务域是所有其他模块的数据与交互源头，需先稳定。 |
| history | 承载最近完成、最近删除、恢复与追溯视图 | [history.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history/history.ui-ux.md) | [history.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history/history.impl.md) | tasks | settings | support_a | Stage 2 | 依赖任务域状态流转与事件日志，但与快速添加可并行。 |
| quick_add | 承载 App 内快速录入、快捷入口回流与草稿链路 | [quick_add.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/quick_add/quick_add.ui-ux.md) | [quick_add.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/quick_add/quick_add.impl.md) | tasks | widget_bridge | support_a | Stage 2 | 依赖任务创建用例，但与历史页无直接视觉或数据耦合。 |
| widget_bridge | 承载锁屏 / Widget 稳定快照、展示模式与刷新降级 | [widget_bridge.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget_bridge/widget_bridge.ui-ux.md) | [widget_bridge.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget_bridge/widget_bridge.impl.md) | tasks, quick_add | settings | support_b | Stage 2 | 依赖任务真相源和快速添加回流，但可与历史模块并行。 |
| settings | 承载设置首页、隐私设置、Widget 设置和能力降级解释 | [settings.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings/settings.ui-ux.md) | [settings.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings/settings.impl.md) | tasks, history, widget_bridge | none | support_c | Stage 3 | 依赖前序模块提供真实展示模式、历史入口与能力状态。 |

## 依赖摘要

- `tasks` 是产品主链路与数据真相源，必须先于其他模块稳定。
- `history` 依赖 `tasks` 的软删除、完成与事件日志，但不反向阻塞创建链路。
- `quick_add` 依赖 `tasks` 的创建用例和默认值策略，是系统快捷入口与 App 主链路的补充入口。
- `widget_bridge` 依赖 `tasks` 的稳定排序与 `quick_add` 的入口回流，负责把真相源映射为系统可消费快照。
- `settings` 依赖前序模块暴露出的隐私、展示模式、历史与降级状态，因此放在最后一波。

## 并行执行计划

### Stage 1

- `tasks`
- 目标：先固化事项主链路、首页层级、编辑 / 完成 / 删除流程与状态规则。

### Stage 2

- `history`
- `quick_add`
- `widget_bridge`
- 目标：在 `tasks` 稳定后并行补齐回收追溯、快捷录入和系统展示桥接。

### Stage 3

- `settings`
- 目标：统一收口隐私、Widget 展示模式、权限降级解释和入口导航。

## 条件性说明

- `widget_bridge` 与 `settings` 若在真实实现中共享展示模式枚举或快照 DTO，可并行开发基础数据层，但界面定稿应保持 `widget_bridge` 先落地。
- 若后续新增同步、会员或 Reminders 模块，它们应作为新模块追加，不应回写拆散当前五个核心模块边界。
- 当前模块拆分以现有 `lib/features` 边界为优先落点，后续实现不得重新平铺回顶层业务目录。
