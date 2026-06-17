# task-flow 实现设计说明

## 1. 目标

本设计说明用于约束 `task-flow` 模块的首轮真实实现范围。目标是在共享壳层、共享冻结、模块效果图、模块原型和架构映射都已完成的前提下，把事项真源模块从“空白占位”推进到“可承接真实创建、编辑、完成、删除、恢复与首页展示”的稳定业务模块。

本轮实现成功标准：

- 首页能从真实任务真源读取并展示一条主事项与一组次级事项
- 编辑页能承接创建 / 编辑主链路
- 关键状态变化统一经过应用层用例
- 三态状态仅保留 `active / completed / deleted`
- 日志写入、主事项选取、排序派生、恢复语义形成稳定边界

## 2. 当前输入

当前实现必须严格遵循以下已冻结输入：

- [task-flow.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-design-source-packet.md)
- [task-flow-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-freeze-decision.md)
- [task-flow-architecture.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-architecture.md)
- [07-bootstrap-code-summary.md](D:/Projects/Flutter/screen_note/docs/project/07-bootstrap-code-summary.md)

其中最关键的实现约束是：

- 首页主事项卡片永远来自当前最高优先级 `active` 事项
- 列表行为必须保持行式结构，不允许页面层直接重新推导业务状态
- 编辑页必须保持单任务单主轴，不演化成复杂设置中心
- 所有关键状态变化必须通过应用层用例统一编排并写入日志
- 删除默认是软删除，恢复沿用原事项 ID

## 3. 本轮范围

### 3.1 范围内

- 建立 `task-flow` 领域实体、仓储接口与状态枚举
- 建立 `drift` 数据表、数据库连接与仓储实现
- 建立首页任务快照用例、编辑保存用例、完成 / 删除 / 恢复用例
- 建立首页展示 Provider / ViewState
- 把首页 branch 从占位页切到真实 `task-flow` 首页
- 建立编辑页路由与基础表单状态
- 补齐主事项选取、排序派生、软删除与恢复测试

### 3.2 范围外

- `history-center` 的最终展示页面实现
- `settings-center` 的真实偏好写入
- 通知调度与 Widget 快照同步
- 云同步、Reminders 联动、会员能力
- 复杂筛选、搜索、多标签高级管理

## 4. 设计决策

### 4.1 真源优先，页面只消费快照

首页不直接查表和拼接排序，而是通过应用层用例拿到稳定快照：

- `priorityTask`
- `urgentTasks`
- `regularTasks`
- `degradationHints`

这样后续 `history-center` 和 `widget-bridge` 也能复用相同业务边界。

### 4.2 领域规则不下沉到展示层

以下规则必须待在领域 / 应用层：

- 主事项选取
- 过期派生
- 今日 / 普通 / 过期排序
- 删除与恢复语义
- 日志写入

首页页面层只负责展示这些结果，不做业务再解释。

### 4.3 编辑链路只做单任务编辑

编辑页在本轮只承接最核心的单任务编辑：

- 标题
- 到期日期
- 到期时间
- 分类
- 隐私
- 备注

不引入复杂提醒策略面板、多段校验流程或二级配置页。

### 4.4 日志与状态流转统一编排

所有关键状态变化都必须经过用例：

- `createTask`
- `updateTask`
- `completeTask`
- `deleteTask`
- `restoreTask`

每个用例都负责：

- 校验业务边界
- 落库
- 写操作日志
- 触发首页快照刷新

## 5. 文件边界

本轮实现建议优先集中在这些文件：

- `lib/features/task_flow/domain/entities/`
- `lib/features/task_flow/domain/repositories/`
- `lib/features/task_flow/application/use_cases/`
- `lib/features/task_flow/application/providers/`
- `lib/features/task_flow/infrastructure/`
- `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
- `lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`

可能需要轻改：

- `lib/app/router/app_router.dart`
- `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- `lib/app/startup/widget_launch_bridge.dart`

不应触碰：

- `history-center` 的最终展示逻辑
- `settings-center` 的业务层
- `widget-bridge` 的真实桥接实现

## 6. 测试策略

本轮至少补齐以下测试：

- 主事项选取规则测试
- 排序与过期派生测试
- 软删除与恢复测试
- 首页快照 Provider 测试
- 编辑保存用例测试
- 首页页面展示测试
- 编辑页基本交互测试

测试目标不是追求全量 UI 截图，而是证明业务边界、状态流转和显示装配都稳定。

## 7. 风险与控制

### 风险 1：页面层重新吸收业务逻辑

如果首页直接在 Widget 里做排序、主事项选取或状态派生，后续 `history-center` 与 `widget-bridge` 都会被迫重复逻辑。

控制方式：

- 首页只消费 ViewState / Snapshot
- 所有状态派生与选取逻辑下沉到应用层

### 风险 2：编辑页先有外观、后补业务边界

如果先写表单壳，再临时塞保存逻辑，容易形成“UI 可点但链路不稳定”的假进展。

控制方式：

- 先完成领域实体、仓储接口和用例
- 再接首页快照
- 最后恢复编辑页显示层

### 风险 3：日志与状态变化脱节

如果完成、删除、恢复分别散落在不同页面直接改库，后续历史中心和恢复链路会失真。

控制方式：

- 状态变更统一由应用层用例编排
- 所有关键变更同步写日志

## 8. 实现后预期状态

完成本轮后，项目应满足：

- `task-flow` 成为真实业务真源模块
- 首页不再是纯视觉占位，而是能读真实任务快照
- 编辑页可承接创建 / 编辑主链路
- `history-center` 与 `widget-bridge` 后续能建立在稳定任务真源之上，而不是反向定义任务模型

## 9. 非目标声明

本轮不是要完成全部产品能力，也不是要把 `history-center`、`settings-center`、`widget-bridge` 一起拉通。核心目的只有一个：在不破坏现有共享壳层与冻结设计的前提下，把 `task-flow` 建成可持续扩展的真实任务真源模块。
