# 屏记模块索引

## 模块总表

| module_name | goal_or_scope | uiux_doc | impl_doc | depends_on | unblocks | parallel_group | recommended_stage | parallelization_notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| app-shell | 根路由、Tab/Shell、全局入口、本地化与主题宿主 | `docs/rd/modules/app-shell/app-shell.ui-ux.md` | `docs/rd/modules/app-shell/app-shell.impl.md` | none | task-flow, history-center, settings-center, widget-bridge | wave-0 | stage-0 | 所有业务模块都依赖壳层路由与 Provider 宿主 |
| task-flow | 首页、快速添加、事项详情/编辑、状态流转 | `docs/rd/modules/task-flow/task-flow.ui-ux.md` | `docs/rd/modules/task-flow/task-flow.impl.md` | app-shell | history-center, widget-bridge | wave-1 | stage-1 | 先冻结任务排序与状态契约，再让历史与 Widget 消费 |
| settings-center | 通知、隐私、Widget 样式、未来权益入口 | `docs/rd/modules/settings-center/settings-center.ui-ux.md` | `docs/rd/modules/settings-center/settings-center.impl.md` | app-shell | widget-bridge | wave-1 | stage-1 | 与 task-flow 可并行，唯一共享依赖为 app-shell |
| history-center | 最近完成、最近删除、恢复 | `docs/rd/modules/history-center/history-center.ui-ux.md` | `docs/rd/modules/history-center/history-center.impl.md` | app-shell, task-flow | none | wave-2 | stage-2 | 依赖 task-flow 的状态契约与恢复用例 |
| widget-bridge | 稳定快照、锁屏/桌面 Widget 展示、隐私投影 | `docs/rd/modules/widget-bridge/widget-bridge.ui-ux.md` | `docs/rd/modules/widget-bridge/widget-bridge.impl.md` | app-shell, task-flow, settings-center | none | wave-2 | stage-2 | 依赖任务排序结果与展示偏好，不应先于它们落地 |

## 依赖摘要

- `app-shell` 是必须先行的壳层模块，负责根路由、底部宿主、系统回流和全局作用域。
- `task-flow` 定义任务聚合、主列表排序、状态流转与编辑入口，是历史中心和 Widget 的事实源。
- `settings-center` 独立承载通知、隐私和展示偏好，但会向 `widget-bridge` 输出样式与隐私配置。
- `history-center` 只在 `task-flow` 的状态契约稳定后进入实现。
- `widget-bridge` 最后进入实现，确保它消费的是已冻结的排序/快照/隐私规则。

## 并行执行计划

### stage-0

- `app-shell`

### stage-1

- `task-flow`
- `settings-center`

### stage-2

- `history-center`
- `widget-bridge`

## shell 模块说明

- 本项目明确拆分 `app-shell`，因为根路由、底部导航、系统回流入口和全局 Provider 宿主都具有独立实现价值。
- 不使用泛化的 `main` 模块名，避免壳层责任被隐藏在多个功能模块中。

## 阻塞假设

- `widget-bridge` 只有在 `task-flow` 排序规则和 `settings-center` 隐私/展示偏好都冻结后，才可安全进入代码实现。
- 同步、Reminders 协同和 Pro 权益不进入当前目标模块集，只在设置文档中预留扩展位。
