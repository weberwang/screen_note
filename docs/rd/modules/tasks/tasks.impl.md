# Tasks 模块实现 RD

## 0. 文档信息

- 模块名称：`tasks`
- 文档成熟度：`implementation_final`
- 对应 UI/UX：[tasks.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/tasks/tasks.ui-ux.md)
- 继承技术基线：[01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/rd/01-global-technical-baseline.md)

## 1. 边界与业务职责

- 管理事项真相源：创建、更新、完成、删除、恢复前验证。
- 管理任务排序、展示派生状态与事件日志主链路。
- 向 `history`、`quick_add`、`widget_bridge` 提供统一任务读取与状态变更能力。

## 2. 领域模型与应用层

- 核心实体：
  - `Task`
  - `TaskEvent`
- 核心用例：
  - `CreateTaskUseCase`
  - `UpdateTaskUseCase`
  - `CompleteTaskUseCase`
  - `DeleteTaskUseCase`
  - `RestoreTaskUseCase`
  - `WatchActiveTasksUseCase`
- 关键规则：
  - 只允许 `active / completed / deleted` 三种持久状态
  - 过期只作为展示派生状态，不允许落库为第四状态
  - 所有关键状态流转必须同时补写事件日志

## 3. 数据与基础设施

- 数据存储：`drift`
- 仓储：
  - `TaskRepository`
  - `TaskEventRepository`
- 关键依赖：
  - 排序服务
  - 展示状态解析服务
  - 通知调度适配入口
  - Widget 快照刷新触发入口

## 4. 屏幕级状态协调

- 首页：
  - 订阅活动事项列表
  - 基于排序结果选出主事项与次级事项
  - 主卡、快速录入、列表区各自保持独立状态边界
- 详情 / 编辑：
  - 表单草稿与已保存实体分离
  - 保存失败不丢当前输入
  - 删除与恢复通过确认弹层进入应用层用例

## 5. 导航与返回行为

- 首页是默认入口。
- 点击主事项或列表项进入详情 / 编辑。
- 保存成功返回首页并触发快照刷新。
- 从通知、Widget 或系统入口回流时，优先落到目标事项详情或快速补录页。

## 6. 测试、埋点与监控

- 规则测试：
  - 排序优先级
  - 过期展示派生
  - 状态流转与事件日志补写
- 页面 / 集成测试：
  - 首页空态、隐私态、保存回流
  - 详情编辑保存与删除确认
- 埋点：
  - 创建事项
  - 编辑事项
  - 完成事项
  - 删除事项

## 7. 实现约束

- 实现不得改写 [tasks.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/tasks/tasks.ui-ux.md) 中冻结的主层级、CTA 优先级与隐私预览结构。
- 需要消费共享冻结源：
  - [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
  - [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/light-theme-freeze.yaml)
  - [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/dark-theme-freeze.yaml)
- 本文档已达到实现前粒度，可直接进入架构映射与编码准备。
