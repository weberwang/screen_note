# App Shell Implementation Design

## 1. 背景

本次工作只推进 `app-shell` 模块的实现入口，目标是让当前实现重新对齐已冻结的模块文档、设计源包与视觉证据，而不是重新打开设计阶段，也不是扩展新的业务需求。

当前可依赖的上游产物已经存在：

- `docs/project/modules/app-shell/app-shell.impl.md`
- `docs/project/modules/app-shell/app-shell-design-source-packet.md`
- `docs/project/modules/app-shell/app-shell-freeze-decision.md`
- `docs/project/modules/app-shell/app-shell-architecture.md`
- `docs/project/modules/app-shell/app-shell-effect-home-v2.png`
- `docs/project/modules/app-shell/prototype/index.html`
- `DESIGN.md`

## 2. 目标

本次实现只做一件事：按 `app-shell.impl.md` 已明确写出的职责，恢复并实现 `app-shell` 的共享壳层与首页结构，不新增文档之外的功能、交互或模块边界变化。

成功标准：

- `Home / History / Settings` 三栏共享壳层稳定存在。
- `global quick add` 保持独立悬浮入口，而不是 tab、内嵌输入框或新业务页。
- Home 首屏结构恢复为冻结证据要求的层级：
  - 顶部问候/摘要区
  - 单一主优先卡片
  - 紧急队列行式列表
  - 三栏底部壳层
- `History` 与 `Settings` 仅承担壳层承载关系，不在本次扩展其模块内最终业务内容。
- 壳层验证可通过稳定的 widget key 和测试断言完成。

## 3. 范围

本次只覆盖 `app-shell.impl.md` 已写明的共享壳层职责：

- 共享底部导航：`Home / History / Settings`
- 全局 quick add 入口
- 首页共享壳层结构
- 系统回流宿主
- 轻量反馈宿主

本次允许的实现方式：

- 沿用现有路由与壳层归属
- 在显示层拆分 focused widgets 以恢复冻结层级
- 通过测试和稳定 key 固定结构
- 使用现有本地化文案键，不新增无关文案范围

## 4. 非目标

以下内容明确不在本次范围内：

- 新增下拉刷新
- 系统回流后自动打开 quick add
- 三栏改四栏或五栏
- 把 quick add 退化成 tab、列表行或独立业务页
- 在 `app-shell` 中新增 `task-flow`、`history-center`、`settings-center` 的业务判断
- 扩展 `History` / `Settings` 模块最终业务界面
- 重新定义共享视觉方向、交互原则或冻结设计源

## 5. 设计决策

### 5.1 壳层职责保持不变

`app-shell` 仍只负责共享壳层、导航、quick add 宿主、系统回流分发与轻量反馈承载，不回收下游 feature 的业务真源、排序、日志或数据库逻辑。

### 5.2 Home 只恢复冻结层级，不发明新流程

Home 页的重点不是“做更多功能”，而是恢复冻结证据已经定义的结构关系：

- 问候区先于主卡片
- 主卡片绝对优先于紧急队列
- 队列保持低装饰、行式扫描节奏
- FAB 与底部导航维持彼此独立

### 5.3 视觉恢复优先于装饰增强

视觉实现以高保真结构和层级恢复为主，不追求额外装饰效果。允许对轻纸感、柔和阴影等细节做 Flutter 原生近似，但不改变以下冻结语义：

- 单一主任务卡片
- 三栏共享壳层
- 独立悬浮 quick add
- 低噪音选中态
- 反馈不遮挡主任务区

## 6. 组件与代码边界

建议维持最小改动边界：

- `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
  - 继续作为 Home 页面入口
  - 负责消费首页展示模型
- `lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart`
  - 承载 Home 的结构化分段组件
  - 至少拆出顶部问候区、主优先卡片、紧急队列行
- `test/features/app_shell/app_shell_page_test.dart`
  - 锁定壳层与 Home 结构验收

不新增新的业务层依赖，不改动 `app-shell` 模块边界，不在本次引入新的跨模块协议。

## 7. 测试策略

本次以结构回归测试为主：

- 验证壳层仍只有一个稳定宿主
- 验证 Home 关键结构 key 存在
- 验证主优先卡片、元信息行、状态 chip、紧急队列行可被稳定定位
- 验证切到 `Settings` 后，Home 结构不再停留在可见树上

如果 Flutter 测试环境仍有外部阻塞，需要明确记录阻塞，而不是假定通过。

## 8. 风险与约束

- 当前任务是“按 impl 文档实现”，不是“顺手补完整产品体验”；任何额外交互都可能越界。
- `History` / `Settings` 目前只作为壳层承载目标，后续 feature 实现不能误把本次占位结构当成最终视觉冻结。
- 如果实现过程中发现必须修改三栏结构、quick add 姿态或首页主层级，应停止实现并回到设计控制链，而不是直接改代码。

## 9. 实施结论

本次 `Spec` 的推荐执行方式是：

1. 先用测试锁定 Home 壳层结构。
2. 再拆分 Home 显示层组件。
3. 最后恢复主卡片与紧急队列层级，并补齐稳定 key。

该方案满足“只实现 impl 文档描述”的边界要求，同时保持与现有冻结设计、实现计划和工作流门禁一致。
