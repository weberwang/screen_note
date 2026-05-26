# 项目协作规则

## 沟通

- 始终使用简体中文回复用户。
- 列出任务、计划、步骤、风险、结果或下一步时，使用中文。
- 任务名保持简短、可执行、便于快速扫描。

## 完成流程

- 完成用户请求后，如存在可提交改动，必须提醒用户选择：`仅提交`、`提交并推送`、`忽略`。
- 等待用户选择后再执行 git 提交动作。
- 用户选择 `仅提交` 时，直接执行 git add 与 git commit，不推送。
- 用户选择 `提交并推送` 时，直接执行 git add、git commit，再推送当前远端分支。
- 用户选择 `忽略` 时，不执行 git add、git commit 或 git push。
- 如果没有可提交改动，明确说明并跳过提交提示。
- 如果推送因远端、上游分支或权限缺失受阻，在尝试推送后用中文说明阻塞原因。

## 代码注释

- 新增或修改代码时，使用简体中文添加必要注释。
- 复杂函数、关键分支、特殊处理逻辑至少补充 1 条中文注释。
- 类、函数、实体定义必须添加注释。
- 注释重点说明设计原因、业务意图、边界条件、兼容处理、安全限制和性能取舍。
- 不要给显而易见的代码添加注释。
- 完成任务前，检查本次改动是否缺少必要中文注释；缺少时先补充。

## 代码规模

- 单个代码文件不得超过 800 行。
- 新增代码预计会让文件超过 800 行时，优先拆分模块、提取公共逻辑或下沉子组件。
- 修改既有超长文件时，不得继续增加体量，应优先借本次改动推动拆分。

## 业务实现约定

- 事项持久状态只保留 `active`、`completed`、`deleted` 三种；`expired` 只能作为展示派生状态，不能落库为第四种状态。
- 删除默认必须走软删除；用户删除时只允许写入删除状态和删除时间，不允许直接物理删除事项。
- 所有会改变事项状态或关键字段的行为，必须通过应用层用例统一编排，并补齐对应操作日志，避免页面直接改库。
- Widget、小组件、锁屏展示只读取稳定快照，不直接承载复杂查询、排序和状态推导逻辑。
- 隐私规则默认高于展示便利：锁屏、小组件、通知和系统快捷入口不得泄露隐私事项正文。
- 通知权限、Widget 刷新失败、系统入口失败都只能做能力降级，不能阻断事项创建、编辑、完成、删除和恢复主链路。

## 代码实现约定

- 代码实现优先使用注解与代码生成链路，减少样板 DTO、不可变模型和数据库映射的手写重复代码。
- 显示层默认优先使用 `hooks_riverpod` 组织页面、表单、局部状态和副作用；Riverpod 相关 Provider、Notifier 与状态装配必须优先使用注解生成方案实现，除非注解链路明确无法覆盖，否则不要回退到手写样板。
- `data/`、`domain/` 下的实体类必须优先使用 `freezed` 注解定义，通过代码生成统一维护不可变能力、值相等和 `copyWith`，不要长期保留手写实体样板。
- 页面层只负责展示、输入和导航；业务规则、状态流转、日志写入、快照刷新、通知调度必须下沉到应用层或数据层。
- 任何新增目录或模块都应优先贴合项目既定分层：`app/`、`tasks/`、`history/`、`settings/`、`widget_bridge/`、`notifications/`、`shared/`。
- 编写实现文档或落地显示层任务时，必须以 `Pencil` 设计稿作为唯一设计标准；如果 `Pencil` 与当前理解不一致，以 `Pencil` 为准；必要时只调整实现，不擅自修改设计源。

## 插件使用约定

### 使用时机

- 本节“插件”特指 `pubspec.yaml` 中已经声明或准备新增的三方依赖包。
- 当现有依赖已经覆盖目标场景时，默认必须优先复用现有包能力，不要先写占位实现、手搓简化版能力或绕开包写临时逻辑。
- 只有在以下情况才允许暂不直接接入现有依赖：平台前置条件尚未具备、当前任务被明确限制为纯占位/纯视觉稿、或用户明确要求暂不接入真实能力。
- 新增依赖前必须先确认：现有 `pubspec.yaml` 是否已有可用包、能力是否真的依赖平台或外部 SDK、以及是否有清晰的模块落点。

### 最佳实践

- 一个三方包只暴露一个项目内适配入口，优先封装为 `Repository`、`DataSource`、`Gateway` 或 `Service`，不要让多个页面各自直接调用同一个包。
- 包返回值先在边界层转换成项目内部模型，再向内传递，避免展示层、应用层或领域层依赖三方类型、错误码和枚举。
- 初始化、权限检查、失败重试、降级策略集中处理，不要把同一套平台判断散落在多个页面或控制器中。
- 依赖能力默认要可替换：优先通过接口、Provider override、Fake/Mock 或内存实现支持测试，避免测试依赖真实设备环境。
- 真正接入一个包后，至少补一条规则测试、装配测试或降级测试，避免只在真机上人工验证。

### 分层归属

- `domain/` 禁止直接使用三方包；只保留业务实体、值对象、规则和仓储接口。
- `application/` 不直接调用三方依赖；只负责用例编排、状态聚合、日志写入和流程推进。
- `presentation/` 不直接持有三方包实例；页面和组件只负责触发用户意图、订阅状态和展示结果。
- `presentation/` 默认优先使用 `hooks_riverpod` 与 Riverpod 注解生成链路组织显示层代码，目标是压缩样板、统一副作用管理并保持页面实现简洁一致。
- `data/` 是业务插件的主要落点；`widget_bridge/` 只承接小组件快照桥接；`notifications/` 只承接提醒调度与权限适配；`app/bootstrap/` 只承接全局初始化型依赖。

### 现有第三方包清单

- `flutter_riverpod`：默认状态管理与依赖注入入口；新增页面状态、异步状态和模块装配优先基于注解生成的 Provider 实现，不要回退到全局单例或裸 `InheritedWidget`。
- `flutter_hooks`：显示层 Hook 基础能力；局部控制器、输入状态、生命周期副作用优先通过 Hook 管理，不要散落手写 `StatefulWidget` 样板。
- `hooks_riverpod`：显示层默认 Riverpod 入口；页面、弹层、表单和局部交互优先使用 `HookConsumerWidget`、`HookWidget` 与 Riverpod 注解生成方案实现。
- `go_router`：默认路由和跳转能力；启动分发、详情跳转、设置子页和系统入口回流统一走它，不要再并行维护另一套路由状态机。
- `collection`：集合工具包；列表分组、排序辅助、安全查找等通用集合操作优先复用它。
- `drift`：结构化本地数据默认落点；事项、事项日志、最近删除和稳定快照元数据优先用它，不要堆在内存列表或松散 JSON 里。
- `path`：路径拼接与规范化默认工具；文件路径、目录名组合优先用它，不要手写字符串拼接路径分隔符。
- `path_provider`：应用沙箱目录入口；本地数据库、导出文件、缓存目录和临时文件都应优先通过它获取目录。
- `shared_preferences`：轻量本地标记与简单用户偏好；引导状态、布尔开关、轻量配置可用它，结构化业务数据必须优先切到 `drift`。
- `sqlite3_flutter_libs`：`drift` 的 SQLite 运行时基础包；只作为数据库基础设施存在，不直接承载业务逻辑。
- `home_widget`：桌面与锁屏小组件桥接默认实现；真实 Widget 引导、快照写入、点击回流优先通过 `widget_bridge/` 封装接入。
- `flutter_local_notifications`：本地提醒默认实现；到点提醒、恢复后取消提醒、删除后取消提醒必须优先基于它调度，不要保留手写定时占位逻辑。
- `timezone`：时区感知的时间计算与通知调度基础包；真实定时提醒和跨时区时间推算优先用它，不要只靠本地 `DateTime` 硬算。
- `flutter_timezone`：系统时区读取默认入口；通知调度、小组件时间展示和跨时区处理需要系统时区时优先用它。
- `device_info_plus`：设备环境读取；仅在诊断、平台差异分流、反馈信息补充时使用，不提前侵入业务流程。
- `freezed_annotation`：不可变模型注解入口；`data/`、`domain/` 实体类、领域模型、表单状态和 ViewState 默认必须优先配合 `freezed` 使用。
- `json_annotation`：JSON 模型注解入口；缓存结构、快照 DTO、系统桥接 DTO 需要 JSON 映射时优先用它。
- `intl`：时间、数字和文案格式化默认工具；日期展示、本地化格式化、相对时间和格式化字符串优先用它。
- `package_info_plus`：应用版本和包信息读取；仅在关于页、诊断页、升级检查和反馈附加信息时使用。
- `uuid`：稳定 ID 生成默认工具；本地实体、快照记录和离线日志标识优先用它，不要散落手写随机字符串方案。
- `build_runner`：统一代码生成入口；所有 `freezed`、`json_serializable`、`drift` 相关生成流程统一通过它执行。
- `flutter_lints`：项目静态检查基线；新增代码默认遵守，不允许为了省事批量关闭规则。
- `drift_dev`：`drift` 代码生成与开发工具入口；数据库表、DAO 和迁移脚手架统一通过它生成。
- `freezed`：不可变模型生成器；`data/`、`domain/` 实体类以及需要值相等、`copyWith`、联合类型的模型必须优先用它，不再长期手写样板模型。
- `json_serializable`：JSON 代码生成器；需要稳定 Map/JSON 映射时优先使用，不要长期手写脆弱的转换代码。

## 国际化通用约束

- 新增面向用户的业务文案、按钮文案、提示文案、标题、空态、错误文案时，默认必须按国际化方案接入，不允许直接在页面、组件、控制器中长期写死字符串。
- 只有在以下情况才允许短期不接国际化：当前任务被明确限制为纯占位稿、调试日志、测试断言文案或内部开发辅助文案。
- 领域层、应用层、数据层不承载最终展示文案；需要展示给用户的文本应尽量在展示层通过国际化资源解析，避免业务层拼装中文常量。
- 一旦某个功能进入真实可交付状态，对应用户可见文案必须补齐到国际化资源，不允许长期保留“后续再国际化”的临时字符串。

## Flutter 国际化

- 本项目使用 Flutter 官方 `gen-l10n` 生成国际化代码，配置文件是 `l10n.yaml`。
- 国际化资源统一放在 `lib/l10n`，模板文件是 `app_en.arb`，简体中文文件是 `app_zh.arb`。
- 新增用户可见文案时，必须先写入 ARB 文件，再通过 `AppLocalizations.of(context)` 读取。
- 不要在 Widget、路由标题、通知文案或错误提示中新增硬编码用户可见文案。
- 修改 ARB 或 `l10n.yaml` 后，运行 `rtk flutter gen-l10n` 重新生成本地化代码。
- 新增本地化 key 时，必须提供 `@key.description`，说明文案用途或上下文。
- 调整支持语言时，同步更新 `MaterialApp.supportedLocales` 接入处以及相关测试。
- `MaterialApp` 或 `MaterialApp.router` 必须挂载 `AppLocalizations.localizationsDelegates` 与 `AppLocalizations.supportedLocales`。
- 应用标题等依赖语言环境的文案通过 `onGenerateTitle` 或 widget 上下文读取，不要在应用启动前静态读取本地化实例。

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **screen_note** (2345 symbols, 4931 relationships, 87 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/screen_note/context` | Codebase overview, check index freshness |
| `gitnexus://repo/screen_note/clusters` | All functional areas |
| `gitnexus://repo/screen_note/processes` | All execution flows |
| `gitnexus://repo/screen_note/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
