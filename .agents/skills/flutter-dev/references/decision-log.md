# Decision Log

## Base Decisions

| Area | Decision | Reason | Impact |
| --- | --- | --- | --- |
| State | `flutter_riverpod + hooks_riverpod，新增状态默认优先走 @riverpod 注解生成` | `现有手写 Provider 已覆盖运行链路，但初始化基线已补回注解链，后续不再继续扩散手写样板` | `存量代码可分批迁移；新增 Provider、状态聚合与装配优先使用 @riverpod` |
| Routing | `go_router` | `当前主要页面与系统回流入口已统一接入同一路由树` | `后续路由扩展必须延续现有路由树，不要再平行维护其他路由机制` |
| Network | `core/network 已补齐 dio + retrofit 初始化模板，但当前业务未接真实远程接口` | `满足项目基线并让后续后端接入复用统一链路，同时避免在初始化阶段编造业务接口契约` | `新远程能力必须复用 core/network 基座，再在 feature 内声明具体 API 与 DTO` |
| Storage | `drift + shared_preferences + flutter_secure_storage` | `分别承担结构化业务数据、轻量偏好/桥接草稿和敏感配置预留` | `涉及令牌、私密配置或高敏感键值时，不允许继续写入 shared_preferences` |
| Structure | `当前真实运行代码根为 lib/app、lib/shared、lib/features；业务模块统一收口到 lib/features/<feature>` | `让目录事实与模块边界保持一致，避免 app 壳层与业务模块继续混在 lib/src` | `后续新增业务能力默认落在 lib/features，跨 feature 复用再沉淀到 lib/shared` |

## Change Records

| Date | Change | Reason | Impact |
| --- | --- | --- | --- |
| `2026-05-26` | `生成项目本地 flutter-dev 技能并固定当前结构现实` | `补齐 flutter-init 文档基线，避免后续实现误把目标状态当成当前事实` | `团队后续可以直接按项目技能与审计文档扩展，而不需要反复回看长 RD` |
| `2026-06-04` | `执行 flutter-init --force，补齐 core 初始化基座、@riverpod/@RestApi 代码生成链、flutter_secure_storage 与通知平台配置` | `让已存在工程重新对齐 flutter-init / flutter-project-guardrails 的初始化交付标准` | `后续实现可直接复用统一启动、网络、存储与插件基线，减少继续手搓基础设施的空间` |
