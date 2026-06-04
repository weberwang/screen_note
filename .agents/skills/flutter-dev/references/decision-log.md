# Decision Log

## Base Decisions

| Area | Decision | Reason | Impact |
| --- | --- | --- | --- |
| State | `flutter_riverpod + hooks_riverpod + riverpod_generator` | `项目规则要求注解优先，并且显示层默认使用 hooks 风格。` | `后续 provider 与页面状态都应走生成链，不再新增手写全局样板。` |
| Routing | `go_router` stateful shell + feature entry routes | `首页/历史/锁屏预览/设置存在并列根入口，同时完整新建页需要壳层外推入。` | `新增页面先判断属于 tab 分支还是壳层外路由，避免页面层自行拼路径。` |
| Network | `dio + retrofit` scaffold only | `当前 MVP 没有远端后端，但 guardrails 要求有统一可扩展网络基座。` | `未确认真实远端边界前，不要在 feature 内散落手写 HTTP 调用。` |
| Storage | `drift + shared_preferences + flutter_secure_storage` | `事项事实源、轻量偏好和敏感值分别有不同持久化边界。` | `业务层不得直接依赖三方存储类型，统一通过 feature 基础设施适配。` |

## Change Records

- 2026-06-04：完成 `flutter-init` 基线补齐，移除旧的半成品 `tasks/quick_add/history/settings` 骨架，统一切换到 `app_shell / task_flow / history_center / widget_bridge / settings_center` 结构。
