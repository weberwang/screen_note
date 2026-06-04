# history-center 实现 RD

## 关联文档

- 配对 UI/UX：`docs/rd/modules/history-center/history-center.ui-ux.md`
- 全局技术基线：`docs/rd/01-global-technical-baseline.md`

## 业务能力与边界

- 责任：读取最近完成、最近删除；触发恢复；展示时间与操作来源。
- 依赖：`task-flow` 提供统一状态流转与日志记录能力。

## 数据与用例

- 读模型：
  - 最近完成查询
  - 最近删除查询
- 写模型：
  - `restoreTask`

## 状态与交互

- 恢复成功后刷新当前页与首页
- 最近完成默认只读，不承载再次编辑主入口
- 最近删除恢复后需同步重建快照与提醒

## 安全与隐私

- 隐私事项在历史页可显示受控标题或占位文案，具体遵循设置偏好
- 日志只保留操作时间和操作类型

## 埋点与测试

- 埋点事件：`history_completed_opened`、`history_deleted_opened`、`task_restored_from_history`
- 关键测试：恢复成功、恢复失败、空列表、时间排序

## 实现约束

- 不允许在历史页物理删除记录
- 不允许恢复逻辑绕过任务主用例
