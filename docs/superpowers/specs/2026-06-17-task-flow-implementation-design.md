# Task Flow Implementation Design

## 1. 背景

本次工作用于把 `task-flow` 从“已冻结设计源”推进到“可进入实现计划”的状态，不重开产品设计，也不扩展新的业务需求。

当前已确认并可直接消费的上游产物：

- [task-flow.impl.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-design-source-packet.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-design-source-packet.md)
- [task-flow-freeze-decision.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-freeze-decision.md)
- [task-flow-architecture.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-architecture.md)
- [task-flow-home.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-home.png)
- [task-flow-editor.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-editor.png)
- [prototype/index.html](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/prototype/index.html)
- [DESIGN.md](/E:/Projects/flutter/screen_note/DESIGN.md)

## 2. 目标

本次 `Spec` 只为一件事服务：在不突破冻结设计边界的前提下，实现 `task-flow` 的首页主任务视图与任务编辑主链路。

成功标准：

- 首页继续由 `TaskFlowHomeDisplayModel` 驱动，只呈现一个主任务卡片和一个轻紧急队列。
- 编辑页继续承接“新建 / 编辑任务”的最小闭环，不新增额外业务流程。
- 持久状态仍严格限制为 `active`、`completed`、`deleted`，不引入第四种落库状态。
- 隐私安全语义在编辑页可控，且后续实现不会把它降级成纯视觉开关。
- 保存后必须自动刷新首页任务数据。
- 保存后必须自动回到首页，而不是停留在编辑页或落到其他分支。
- 首页、编辑页和保存后的回流都通过测试验证，不以人工想象代替验收。

## 3. 范围

本次实现只覆盖：

- `task-flow` 首页主任务卡片展示
- `task-flow` 首页紧急队列展示
- `task-flow` 编辑页字段组织与保存主链路
- 首页加载、错误、空态的结构化降级
- 新建任务、编辑任务、保存后刷新首页

本次明确不覆盖：

- 历史中心恢复链路
- 设置中心通知、展示模式、同步能力
- Widget 快照写入
- 提醒调度、通知下发、深链矩阵扩展
- 任何未在冻结设计里出现的新字段、新按钮或新页面

## 4. 非目标

以下内容即使看起来顺手，也不在本次实现范围内：

- 新增下拉刷新
- 保存后自动打开其他弹层
- 首页改为多卡片或高密度看板
- 给编辑页补更多高级字段
- 把首页排序、状态推导或日志写入搬进页面层
- 为了“更像产品”而擅自修改冻结视觉层级

## 5. 设计决策

### 5.1 首页继续是“一个主任务 + 一个轻队列”

首页的第一职责是让用户三秒内看懂“现在最重要的事是什么”，而不是提供任务总览控制台。

因此：

- 主任务卡片必须继续作为首屏第一阅读层。
- 紧急队列只能承接次级任务，不得和主任务争抢视觉重量。
- 共享底栏与全局快速新增继续由 `app-shell` 负责，`task-flow` 不回收壳层责任。

### 5.2 编辑页继续是最小闭环，而不是设置页

编辑页的职责是快速完成任务输入与修改：

- 标题、到期时间、优先级、状态、隐私安全、备注必须首屏可见。
- 附件和提醒等支持项只能作为次级信息区存在。
- 保存动作必须是唯一明确主 CTA。

### 5.3 视觉保真优先于“工程顺手”

实现可以用 Flutter 原生方式近似暖白卡片、轻阴影和轻胶囊，但不能为了省事把：

- 主任务卡片压回普通列表行
- 队列改成卡片瀑布流
- 编辑页改成稠密设置墙

### 5.4 业务规则继续留在应用层

页面层只做展示、输入与导航：

- 创建和编辑通过 `CreateTaskUseCase`、`UpdateTaskUseCase`
- 首页通过 `taskFlowHomeControllerProvider` 加载稳定快照
- 保存成功后默认返回 `app-shell` 的 `Home` 分支，并立即触发首页任务刷新
- 如果首页刷新失败，只能降级提示，不得回滚已保存结果

## 6. 组件与代码边界

优先沿用现有文件边界，不新增无必要抽象：

- [task_flow_home_page.dart](/E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_home_page.dart)
  - 继续作为首页入口，只负责状态分发
- [task_flow_home_sections.dart](/E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart)
  - 继续承接首页主结构与主要显示组件
- [task_flow_editor_page.dart](/E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart)
  - 继续承接新建 / 编辑主链路
- `application/use_cases/*`
  - 不改业务职责，只在必要时补齐页面链路需要的最小配合
- 测试优先落在：
  - 首页壳层 / 结构测试
  - 编辑页交互与保存链路测试
  - 用例层关键行为测试（如果现有覆盖不足）

## 7. 测试策略

本次默认采用 TDD 节奏推进：

- 先写首页结构与编辑链路的失败测试
- 再补最小实现让测试通过
- 再运行聚焦测试与静态检查

最少需要覆盖：

- 首页主任务卡片存在
- 首页紧急队列存在且维持轻行结构
- 切换到其他壳层分支后，首页关键结构不应残留在可见树中
- 编辑页新建态可保存
- 编辑页编辑态只在首次加载时回填
- 标题为空时不允许保存
- 保存成功后自动回到首页
- 保存成功后自动刷新首页任务数据

如果测试环境阻塞，必须明确记录阻塞，而不是假设通过。

## 8. 风险与约束

- 当前冻结视觉强调低密度与主任务优先，实现时最容易被“顺手多放几条数据”破坏。
- 编辑页如果继续堆字段，会直接破坏“核心字段首屏可见”的冻结约束。
- 隐私安全当前只在编辑页有显式入口，但后续实现必须保证它不是孤立 UI 状态。
- 由于当前仓库处在 `docs/rd -> docs/project` 迁移中，本次实现必须避免依赖旧路径作为真实来源。

## 9. 实施结论

本次 `Spec` 推荐的实现顺序是：

1. 先锁定首页与编辑链路的失败测试。
2. 再分别最小化修正首页显示层与编辑页保存链路。
3. 最后补齐必要的降级态验证和静态检查。

这条路径满足“只实现已冻结范围”的要求，同时也把后续 `Plan` 的任务边界收得足够窄，不会把 `task-flow` 扩成新的产品设计轮次。
