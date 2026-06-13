# Module Index

## 模块总表

| module_name | goal_or_scope | impl_doc | depends_on | unblocks | parallel_group | recommended_stage | parallelization_notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `app-shell` | 共享壳层、顶级导航、全局快速添加、系统回流宿主 | `docs/project/modules/app-shell/app-shell.impl.md` | none | `task-flow`, `history-center`, `settings-center`, `widget-bridge` | `wave-1` | `stage-1` | 顶级壳层必须先落，其他模块依赖其路由与壳层契约 |
| `task-flow` | 事项创建、编辑、完成、删除、恢复主链路 | `docs/project/modules/task-flow/task-flow.impl.md` | `app-shell` | `history-center`, `widget-bridge` | `wave-2` | `stage-2` | 核心业务真源模块，优先于历史与快照桥接 |
| `history-center` | 最近完成、最近删除、恢复视图与交互 | `docs/project/modules/history-center/history-center.impl.md` | `app-shell`, `task-flow` | none | `wave-3` | `stage-3` | 依赖任务真源与日志链路，和设置中心可并行 |
| `settings-center` | 通知、隐私、展示样式、同步、会员入口 | `docs/project/modules/settings-center/settings-center.impl.md` | `app-shell` | `widget-bridge` | `wave-3` | `stage-3` | 与历史中心可并行，但涉及展示模式配置时需对齐 widget-bridge |
| `widget-bridge` | 稳定快照、Widget 共享数据、系统点击回流桥接 | `docs/project/modules/widget-bridge/widget-bridge.impl.md` | `app-shell`, `task-flow`, `settings-center` | none | `wave-4` | `stage-4` | 依赖任务真源与展示配置契约，适合在主链路稳定后接入 |

## 依赖说明

- `app-shell` 是共享壳层模块，独立承接底部导航、全局快速添加入口和系统回流宿主，不应被埋进任一业务模块。
- `task-flow` 是业务真源模块，承接事项状态流转、日志与主编辑链路。
- `history-center` 依赖 `task-flow` 的状态与日志输出。
- `settings-center` 主要依赖 `app-shell`，但其展示设置会影响 `widget-bridge` 的快照投影。
- `widget-bridge` 依赖 `task-flow` 提供任务快照源，依赖 `settings-center` 提供展示模式与隐私配置。

## 并行执行计划

### stage-1

- `app-shell`

### stage-2

- `task-flow`

### stage-3`

- `history-center`
- `settings-center`

说明：
- 这两个模块可并行准备，但都不得改写共享壳层契约。

### stage-4

- `widget-bridge`

## 模块边界说明

- 不单独拆出 `quick-add` 模块；快速添加属于 `app-shell` 的全局动作与 `task-flow` 的业务能力联合结果。
- 不单独拆出 `notifications` 模块；提醒能力先作为 `task-flow` / `settings-center` / `widget-bridge` 的边界能力落在实现文档中，后续若规模明显膨胀再考虑提升为独立模块。

## 当前推荐活动模块

- `app-shell`

原因：
- 它是所有后续模块的共享宿主。
- 当前冻结已经明确共享壳层与全局快速添加方向，适合先做模块级实现文档与后续视觉证据。
