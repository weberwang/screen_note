# Flutter Init 文档先行基线补齐设计

## 1. 背景

`screen_note` 当前并不是待初始化的空 Flutter 工程，而是已经具备任务生命周期、历史记录、设置、快速添加、小组件桥接等较完整实现的业务项目。  
现有仓库已经接入 `go_router`、`hooks_riverpod`、`freezed`、`json_serializable`、`drift` 与 Flutter 官方国际化链路，但还没有完全对齐新引入的 `flutter-init` / `flutter-project-guardrails` 基线。

当前最明显的缺口有三类：

1. 缺少项目本地 `flutter-dev` 技能，后续实现阶段没有项目级落地规范入口。
2. 缺少“当前事实结构”和“目标标准结构”的统一映射说明，容易让后续开发者误判目录落点。
3. 与 guardrails 的部分差距尚未被显式记录，例如 `riverpod_annotation`、`riverpod_generator`、`dio`、`retrofit`、`flutter_secure_storage`、`logger` 等尚未进入当前运行链路。

本次工作目标不是重做初始化，也不是迁移现有业务代码，而是在不扰动现有运行链路的前提下，把初始化基线补齐为“可读、可遵循、可扩展”的状态。

## 2. 目标

本轮补齐要达成以下目标：

1. 生成项目本地 `flutter-dev` 技能，承接 `flutter-project-guardrails`，并记录 `screen_note` 的现实约束。
2. 生成项目专属参考文档，明确项目背景、功能边界和关键决策。
3. 新增初始化基线审计文档，明确区分“当前事实”“目标基线”“本轮仅记录不落地项”。
4. 为 `lib/app`、`lib/core`、`lib/features` 建立说明性占位，显式表达未来标准结构的职责分工。
5. 保持现有 `lib/src` 作为真实运行代码根，不制造双份运行代码或伪接入基础设施。

## 3. 非目标

本轮明确不做以下事项：

1. 不迁移 `lib/src` 中的现有业务实现到 `lib/app`、`lib/core`、`lib/features`。
2. 不为了对齐 checklist 强行引入 `dio` / `retrofit` / `flutter_secure_storage` / `logger` 等当前未接入的运行时代码。
3. 不改动现有路由、Provider、数据库、原生桥接、小组件或快速添加链路。
4. 不对现有 feature 进行大规模目录重构或命名调整。
5. 不把目录占位伪装成“当前已完成迁移”的真实结构。

## 4. 方案概览

本次采用“文档先行 + 基线审计 + 结构占位”的补齐方案。

### 4.1 交付物

计划新增以下产物：

1. `.agents/skills/flutter-dev/SKILL.md`
2. `.agents/skills/flutter-dev/references/project-context.md`
3. `.agents/skills/flutter-dev/references/feature-map.md`
4. `.agents/skills/flutter-dev/references/decision-log.md`
5. 初始化基线审计文档
6. `lib/app/README.md`
7. `lib/core/README.md`
8. `lib/features/README.md`

### 4.2 生成位置决策

模板默认建议生成项目内 `skills/flutter-dev/`，但结合当前仓库现有技能组织方式，本次改为生成到 `.agents/skills/flutter-dev/`。

这样处理的原因是：

1. 当前仓库已经把项目技能统一放在 `.agents/skills/`。
2. 与现有技能并列更容易被后续协作直接复用。
3. 可以避免平行再创建一套未被当前仓库采用的技能目录规范。

## 5. 当前结构与目标结构映射

### 5.1 当前真实结构

当前真实运行代码根保持为 `lib/src`，主要结构如下：

1. `lib/src/app`
   - 负责应用入口装配、路由构建、路径常量。
2. `lib/src/shared`
   - 负责主题、通用 Scaffold、通用组件、展示层工具。
3. `lib/src/tasks`
   - 负责任务实体、用例、数据库仓储、页面与交互。
4. `lib/src/history`
   - 负责已完成与已删除历史视图。
5. `lib/src/settings`
   - 负责设置、隐私设置、Widget 设置。
6. `lib/src/quick_add`
   - 负责系统快捷添加、草稿存取与桥接。
7. `lib/src/widget_bridge`
   - 负责小组件快照、显示模式、刷新调度。

### 5.2 目标标准结构

本轮只建立说明性占位，不接入运行：

1. `lib/app`
   - 未来承载应用壳、bootstrap、router、route guard、全局装配。
2. `lib/core`
   - 未来承载网络、错误模型、日志、配置、安全存储、跨 feature 基础设施。
3. `lib/shared`
   - 未来承载纯展示复用、设计系统组件、公共展示工具。
4. `lib/features`
   - 未来承载按业务边界组织的 `domain / application / infrastructure / presentation` 结构。

### 5.3 映射规则

本轮明确以下迁移口径，但不执行代码迁移：

1. `lib/src/app` 未来对齐到 `lib/app`。
2. `lib/src/shared` 未来拆分到 `lib/shared` 与 `lib/core`。
3. `lib/src/tasks`、`history`、`settings`、`quick_add`、`widget_bridge` 未来收口为 `lib/features/<feature>/...`。
4. 在 feature 没有被实质性重做前，不进行“为了目录好看而迁移”的纯搬运式调整。

## 6. 项目本地 flutter-dev 技能设计

项目本地 `flutter-dev` 技能需要同时承接两类信息：

1. 继承 `flutter-project-guardrails` 的硬约束。
2. 记录 `screen_note` 当前阶段的现实边界，避免后续开发误把目标结构当成当前事实。

技能中需要明确写入以下项目规则：

1. 当前真实代码根仍是 `lib/src`。
2. 新增功能默认优先扩展现有业务边界，不做无意义迁移。
3. 只有当某个 feature 被实质性重做时，才允许迁入 `lib/features/...`。
4. 不允许在 `lib/src/<feature>` 与 `lib/features/<feature>` 并行维护两份真代码。
5. 新增依赖必须记录所有者、使用场景和影响范围。
6. 不得手改生成代码。
7. 任何新的项目级决策都要同步写回 `decision-log.md`。

## 7. 项目专属参考文档设计

### 7.1 project-context.md

该文档用于固定以下信息：

1. 项目名称、目标、目标用户。
2. 当前包名与平台范围。
3. 首版交付范围与明确不做范围。
4. 当前核心集成能力，例如 `drift`、`home_widget`、`flutter_local_notifications`、`shared_preferences`、国际化链路等。
5. 项目统一命令，包括 `rtk flutter pub get`、`rtk dart run build_runner build --delete-conflicting-outputs`、`rtk flutter analyze`、`rtk flutter test` 等。

### 7.2 feature-map.md

该文档用于固定当前主要 bounded feature 及默认落点规则：

1. `tasks`
   - 任务生命周期、列表、详情、编辑、排序、状态推导。
2. `history`
   - 已完成与已删除历史视图。
3. `settings`
   - 设置、隐私设置、Widget 设置入口。
4. `quick_add`
   - 系统快捷添加、输入草稿、桥接恢复。
5. `widget_bridge`
   - 小组件快照、显示模式、刷新调度。

并明确：

1. 共享业务语言与生命周期的需求优先归入现有 feature。
2. 引入全新业务边界时才新建 feature。
3. 跨 feature 协作必须显式记录，不允许隐式耦合扩散。

### 7.3 decision-log.md

该文档用于记录项目级关键选择，至少覆盖：

1. 状态管理
   - 当前采用 `flutter_riverpod` / `hooks_riverpod`，但 Provider 仍以手写为主。
2. 路由
   - 当前统一采用 `go_router`。
3. 存储
   - 当前以 `drift` 承担结构化本地数据，以 `shared_preferences` 承担轻量偏好与部分桥接草稿。
4. 结构策略
   - 当前真实运行根为 `lib/src`，`lib/app` / `lib/core` / `lib/features` 仅为目标占位。
5. 本轮未落地差距
   - 明确哪些 guardrails 基线能力尚未接入运行链路，仅作为后续补齐欠账。

## 8. Guardrails 对齐口径

本轮不会伪造“已完全对齐”，而是把对齐状态分为三类：

### 8.1 已对齐

1. `go_router`
2. `freezed` / `json_serializable`
3. `drift`
4. Flutter 官方国际化
5. 按业务边界拆分模块

### 8.2 部分对齐

1. Riverpod 已接入，但尚未切换到注解生成主路径。
2. 现有目录已经按业务领域拆分，但还未迁移到目标标准结构。

### 8.3 未对齐但本轮只记录

1. `riverpod_annotation`
2. `riverpod_generator`
3. `custom_lint`
4. `riverpod_lint`
5. `dio`
6. `retrofit`
7. `flutter_secure_storage`
8. `logger`

## 9. 前提假设

1. 现有 `lib/src` 结构在后续若无实质性重构需求，将继续作为短中期真实运行结构。
2. 本轮用户目标是“补齐初始化基线表达”，而不是“立即完成架构迁移”。
3. 新增的目录占位将仅用于表达未来职责，不承担当前运行职责。
4. 当前包名可继续沿用示例值，后续如果要正式发布，再单独处理 Bundle ID / Application ID 收口。

## 10. 待确认项

以下事项不会阻塞本轮文档补齐，但需要在后续真正推进结构迁移或基础设施补齐前确认：

1. 是否要把 `notifications` 独立为新 feature，而不是继续分散在现有边界中。
2. 是否要引入 `flutter_secure_storage` 作为后续隐私或凭据存储基线。
3. 是否要把 Riverpod 迁移到 `@riverpod` 注解生成链路。
4. 是否要在未来补入 `dio` / `retrofit` 统一网络基座，即使当前首版核心能力主要依赖本地数据与系统桥接。
5. 是否要在正式发布前统一替换当前示例包名。

## 11. 验证策略

本轮验证分为内容验证与工程验证两层。

### 11.1 内容验证

1. `flutter-dev` 技能及参考文档中不应残留模板占位符。
2. 文档中的项目名称、包名、平台、命令、主要 feature 必须与当前仓库一致。
3. 初始化基线审计文档必须明确区分当前事实、目标基线和本轮未落地项。
4. `lib/app`、`lib/core`、`lib/features` 的占位说明不得暗示已完成迁移。

### 11.2 工程验证

1. 新增文档和说明性占位不影响当前 Flutter 工程运行。
2. 至少执行一次 `rtk flutter analyze`。
3. 如时间允许，执行一次 `rtk flutter test`。
4. 若存在与本轮无关的已有失败，需要在结果中明确说明，不得误记为本轮引入问题。

## 12. 风险与控制

### 12.1 主要风险

1. 目录占位被误读成真实迁移结构。
2. 项目技能写成目标状态，掩盖当前真实结构。
3. 为了凑 checklist 引入未接线的伪基础设施代码。
4. 同时维护 `lib/src` 与 `lib/features` 两份真实代码，导致结构分裂。

### 12.2 控制策略

1. 所有占位目录只放职责说明，不放伪接入代码。
2. 在技能与审计文档中反复强调 `lib/src` 才是当前真实运行根。
3. 对所有未落地基线能力统一标记为“仅记录”。
4. 后续任何 feature 迁移都必须以真实业务重做为触发条件。

## 13. 完成定义

本轮工作完成的标志是：

1. 项目本地 `flutter-dev` 技能已经生成并填充真实信息。
2. 三份参考文档已经按项目实际内容写完。
3. 初始化基线审计文档已经写完。
4. `lib/app`、`lib/core`、`lib/features` 的说明性占位已经建立。
5. 文档与占位整体通过内容校验，且不影响现有工程分析与测试链路。
