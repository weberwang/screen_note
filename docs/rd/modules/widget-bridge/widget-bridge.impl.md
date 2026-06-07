# widget-bridge 实现 RD

## 关联文档

- 配对 UI/UX：`docs/rd/modules/widget-bridge/widget-bridge.ui-ux.md`
- 全局技术基线：`docs/rd/01-global-technical-baseline.md`

## 业务能力与边界

- 责任：从稳定快照读取展示数据、按样式渲染 Widget、处理回流参数。
- 非责任：任务真实排序、状态流转、提醒调度。

## 数据与服务

- 输入：`TaskSnapshotRepository`
- 偏好：`shared_preferences` 中的样式与隐私开关
- 插件边界：`home_widget`

## 最小数据合同

- `WidgetSnapshotItem`
  - 字段：`safeTitle`、`safeSubtitle`、`isPrivate`、`priorityRank`
  - 约束：输出到 Widget 前必须完成隐私投影，不允许把正文或完整时间信息直出到系统层
- `WidgetSnapshotEnvelope`
  - 字段：`displayMode`、`items`、`emptyHint`、`fallbackHint`
  - 约束：Widget 与 App 内预览统一消费同源快照合同，避免双份文案分叉

## 展示策略

- 单条样式：展示最高优先级任务
- 三条样式：展示前三个稳定快照项
- 空态：显示平静提示与回流入口
- 刷新失败：继续使用上次有效快照

## 隐私与回流

- 隐私事项仅显示占位文案/数量/安全提示
- Widget 点击传递最小必要参数，不传递正文

## 测试与监控

- 关键测试：空快照、隐私快照、刷新失败回退、样式切换
- 监控事件：`widget_snapshot_written`、`widget_refresh_failed`、`widget_opened_app`

## 实现约束

- 不允许 Widget 直接查询主数据库复杂排序
- 不允许 Widget 成为写入入口
- 返工后的设计源保持文本优先；golden 与运行态截图只用于 parity 复核，不晋升为新的 Widget 设计源
