# task-flow 实现 RD

## 关联文档

- 配对 UI/UX：`docs/rd/modules/task-flow/task-flow.ui-ux.md`
- 全局技术基线：`docs/rd/01-global-technical-baseline.md`

## 业务能力与边界

- 责任：任务创建、编辑、完成、删除、恢复前置校验、首页排序与过滤、快速添加。
- 非责任：Widget 展示实现、设置偏好持久化。

## 边界上下文

- 聚合根：`Task`
- 关键规则：持久状态仅 `active/completed/deleted`；`expired` 仅查询派生
- 应用用例：`createTask`、`updateTask`、`completeTask`、`deleteTask`、`restoreTask`、`loadTaskFeed`

## 状态与协作

- 首页列表只读取稳定查询结果，不直接拼装多源插件状态
- 写操作后统一触发：
  - 任务表更新
  - 任务事件日志写入
  - 快照重建请求
  - 提醒取消/重建

## 存储与仓储

- `drift`：任务表、任务事件表、快照元数据
- 仓储接口：`TaskRepository`
- 时间字段统一用 UTC 持久化，本地时区展示

## 最小数据合同

- `TaskFeedCard`
  - 字段：`id`、`title`、`dueAt`、`status`、`isPinned`、`isPrivate`、`reminderMode`
  - 约束：首页列表只消费稳定查询结果，不额外拼接 Widget 或通知插件状态
- `TaskEditorDraft`
  - 字段：`title`、`scheduledAt`、`privacyMode`、`reminderMode`、`pinState`
  - 约束：表单保存前只在页面层维护草稿，状态流转统一由应用层用例落库

## 展示层与数据层边界

- 展示层不直接操作数据库
- 展示层不直接调通知或 Widget 插件
- 所有关键副作用由应用层编排服务下沉处理

## 导航与返回

- 新建/编辑都走同一详情页模型
- 保存成功返回首页或回流来源页，并保证列表即时刷新
- 删除成功优先返回上一级，不留悬空详情页

## 埋点、监控与测试

- 埋点事件：`task_created`、`task_completed`、`task_deleted`、`task_restored`、`quick_add_used`
- 关键测试：排序规则、过期派生、软删除恢复、通知降级不阻断

## 实现约束

- 不允许页面绕过用例直接写状态
- 不允许新增第四种持久状态
- 代码消费冻结设计源时，不得改动任务行层级与主次 CTA
- 返工后的视觉证据只绑定 `home-page-light-refresh-v2.png` 与 `task-editor-refresh-v1.png`，不再接受旧预览文件名
