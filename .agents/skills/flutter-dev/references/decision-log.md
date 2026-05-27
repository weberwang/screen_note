# Decision Log

## Base Decisions

| Area | Decision | Reason | Impact |
| --- | --- | --- | --- |
| State | `flutter_riverpod + hooks_riverpod，当前以手写 Provider 为主` | `已覆盖当前状态组织，但尚未迁入注解生成链路` | `后续新增状态要先遵守既有边界，再决定是否分批迁移到 @riverpod` |
| Routing | `go_router` | `当前主要页面与系统回流入口已统一接入同一路由树` | `后续路由扩展必须延续现有路由树，不要再平行维护其他路由机制` |
| Network | `当前暂无 dio/retrofit 运行时入口` | `首版核心能力以本地数据与系统桥接为主，还没有真实远程接口需求` | `dio + retrofit 仍是目标基线，真正引入远程接口时再补齐，不预埋假代码` |
| Storage | `drift + shared_preferences` | `分别承担结构化业务数据与轻量偏好/桥接草稿` | `本轮不额外引入安全存储运行时实现；涉及敏感数据时再引入 flutter_secure_storage` |
| Structure | `当前真实运行代码根为 lib/app、lib/shared、lib/features；业务模块统一收口到 lib/features/<feature>` | `让目录事实与模块边界保持一致，避免 app 壳层与业务模块继续混在 lib/src` | `后续新增业务能力默认落在 lib/features，跨 feature 复用再沉淀到 lib/shared` |

## Change Records

| Date | Change | Reason | Impact |
| --- | --- | --- | --- |
| `2026-05-26` | `生成项目本地 flutter-dev 技能并固定当前结构现实` | `补齐 flutter-init 文档基线，避免后续实现误把目标状态当成当前事实` | `团队后续可以直接按项目技能与审计文档扩展，而不需要反复回看长 RD` |
