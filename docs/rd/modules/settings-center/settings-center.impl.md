# settings-center 实现 RD

## 关联文档

- 配对 UI/UX：`docs/rd/modules/settings-center/settings-center.ui-ux.md`
- 全局技术基线：`docs/rd/01-global-technical-baseline.md`

## 业务能力与边界

- 责任：管理通知偏好、隐私显示偏好、Widget 样式偏好、未来同步/权益占位。
- 非责任：任务业务状态流转。

## 数据与服务

- 偏好持久化：`shared_preferences`
- 插件协作：
  - 通知权限读取
  - Widget 样式同步

## 状态与交互

- 设置项切换后应立即写本地偏好并触发相关刷新
- 权限拒绝时展示可继续使用主链路的说明
- 未开放能力保留占位，不提前接入真实实现

## 埋点与测试

- 埋点事件：`privacy_mode_changed`、`widget_style_changed`、`notification_permission_prompted`
- 关键测试：偏好写入、权限拒绝降级、样式切换后 Widget 数据刷新

## 实现约束

- 不允许把基础隐私能力放进付费门槛
- 不允许设置页直接调任务数据库写核心业务字段
