# history-center 实现设计说明

## 1. 目标

本设计说明用于约束 `history-center` 模块的首轮真实实现范围。目标是在共享壳层、模块效果图、模块原型、冻结决议和架构映射都已完成的前提下，把当前占位页推进为真实的历史回看页面，让用户能稳定看到最近完成与最近删除事项，并在最近删除分区完成恢复。

本轮实现成功标准：

- 历史页能从真实任务真源读取最近完成与最近删除事项
- 页面以分区列表承载历史，不演化为统计看板
- 恢复动作统一复用 `task-flow` 的状态流转用例，不允许页面直接改库
- 恢复成功后会刷新历史页，并尽力刷新首页快照与共享壳层轻反馈
- 空态、加载态、错误态都保持稳定结构

## 2. 当前输入

当前实现必须严格遵循以下已冻结输入：

- [history-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center.impl.md)
- [history-center-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-design-source-packet.md)
- [history-center-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-freeze-decision.md)
- [history-center-architecture.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-architecture.md)
- [07-bootstrap-code-summary.md](D:/Projects/Flutter/screen_note/docs/project/07-bootstrap-code-summary.md)

其中最关键的实现约束是：

- 最近完成分区只读，重点表达“事项可追溯”
- 最近删除分区才承接恢复动作，重点表达“事项可找回”
- 页面层只消费稳定快照，不重新推导状态语义
- 恢复成功反馈要轻，不做重弹窗或强打断
- 历史页继续继承共享壳层与全局 quick add，不另起新的导航语义

## 3. 本轮范围

### 3.1 范围内

- 建立 `history-center` 稳定快照实体与加载用例
- 建立历史页运行时 Provider 与页面控制器
- 从 `task-flow` 真源读取 `completed / deleted` 两个分区并按时间倒序排序
- 接入恢复动作，并复用 `UpdateTaskStatusUseCase.restoreTask`
- 恢复后刷新历史页，并尽力刷新首页快照与壳层反馈
- 把历史 branch 从占位页切到真实 `history-center` 页面
- 补齐历史页展示、恢复链路、空态与排序测试

### 3.2 范围外

- 历史统计、趋势分析、筛选与搜索
- 最近完成事项上的二次操作
- 新的任务真源、独立历史表或新的日志模型
- `settings-center` 与 `widget-bridge` 的实现
- 通知、Widget 或外部系统联动

## 4. 设计决策

### 4.1 复用 task-flow 真源，不新建历史仓储

`history-center` 只消费 `task-flow` 已落地的 `TaskRepository` 与 `UpdateTaskStatusUseCase`。历史页不拥有独立数据表，不复制任务状态，不绕开原有状态流转用例。

### 4.2 历史页只消费稳定快照

页面只读取一个稳定快照：

- `completedTasks`
- `deletedTasks`
- `isEmpty`

分区排序与过滤规则都下沉到加载用例：

- 最近完成按 `completedAt` 倒序
- 最近删除按 `deletedAt` 倒序
- 只读取持久状态为 `completed` 或 `deleted` 的事项

### 4.3 恢复链路保持轻量但完整

恢复动作由页面控制器编排：

1. 调用 `UpdateTaskStatusUseCase.restoreTask`
2. 刷新历史快照
3. 尝试刷新首页快照
4. 通过共享壳层反馈宿主展示“已恢复到 active”

其中第 3 步属于尽力而为的降级刷新，不允许因为首页刷新失败而把恢复本身视为失败。

### 4.4 视觉恢复优先于扩展信息

本轮页面坚持行式结构与轻量分区头：

- 页面标题明确
- 最近完成分区用低噪音绿色语义
- 最近删除分区用低噪音橙红语义
- 恢复按钮使用原生描边按钮

不引入统计卡片、图表、勋章或复杂时间轴。

## 5. 文件边界

本轮实现建议优先集中在这些文件：

- `lib/features/history_center/domain/entities/`
- `lib/features/history_center/application/use_cases/`
- `lib/features/history_center/application/providers/`
- `lib/features/history_center/presentation/pages/history_center_page.dart`
- `lib/features/history_center/presentation/widgets/`

直接复用但不应大改：

- `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
- `lib/features/task_flow/application/use_cases/update_task_status_use_case.dart`
- `lib/features/app_shell/application/providers/app_shell_ui_state.dart`

可能需要轻改：

- `test/features/app_shell/presentation/app_shell_page_test.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`

不应触碰：

- `task-flow` 真源规则本身
- `settings-center` 业务逻辑
- `widget-bridge` 桥接逻辑

## 6. 测试策略

本轮至少补齐以下测试：

- 历史快照分区与倒序排序测试
- 恢复链路测试
- 历史页空态测试
- 历史页展示最近完成 / 最近删除分区测试
- 恢复成功后的页面刷新与共享反馈测试

测试目标是证明历史模块消费真源的边界稳定，而不是做额外视觉截图体系。

## 7. 风险与控制

### 风险 1：历史页重新吸收 task-flow 规则

如果页面直接查库并自己判断恢复、排序、分区，后续 `widget-bridge` 或别的历史入口会重复逻辑。

控制方式：

- 历史页只读稳定快照
- 恢复动作只走已有状态流转用例

### 风险 2：恢复成功与首页状态脱节

如果历史页恢复成功后不刷新首页，用户回到首页会看到旧数据。

控制方式：

- 恢复后主动触发首页控制器刷新
- 首页刷新失败仅做降级，不回滚恢复结果

### 风险 3：页面被扩展成统计中心

如果趁实现把历史页做成分析看板，会直接偏离冻结设计与模块边界。

控制方式：

- 坚持两段式列表页面
- 不新增统计块、筛选器和复杂二级信息

## 8. 实现后预期状态

完成本轮后，项目应满足：

- `history-center` 不再是占位页，而是可用的真实历史页
- 用户能看到最近完成与最近删除事项
- 用户能在最近删除分区恢复事项
- 恢复成功后共享壳层和首页数据能同步收敛
- 后续 `settings-center` 与 `widget-bridge` 能建立在稳定的任务历史消费边界之上

## 9. 非目标声明

本轮不是要做完整归档系统，也不是要引入新的历史统计面板。核心目的只有一个：在不破坏既有共享壳层、冻结设计与 `task-flow` 真源边界的前提下，让历史中心真正承担“可追溯、可恢复”的业务职责。
