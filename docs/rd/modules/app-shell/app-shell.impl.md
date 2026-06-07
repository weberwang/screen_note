# app-shell 实现 RD

## 关联文档

- 配对 UI/UX：`docs/rd/modules/app-shell/app-shell.ui-ux.md`
- 全局技术基线：`docs/rd/01-global-technical-baseline.md`

## 业务能力与边界

- 责任：根路由、底部宿主、入口参数分发、全局 Theme/Locale/ProviderScope 装配。
- 非责任：任务业务规则、Widget 查询、通知调度。

## 分层方案

- `presentation`：Shell 页面、底部导航、启动分发 Widget。
- `application`：回流目标解析、壳层状态同步。
- `domain`：路由目标值对象、入口来源枚举。
- `infrastructure`：系统入口参数适配、日志门面接入。

## 继承包栈与模块用法

- `go_router`：唯一路由宿主
- `flutter_riverpod/hooks_riverpod`：壳层状态与依赖注入
- `intl/gen_l10n`：标题与系统提示国际化

## 状态与导航契约

- 默认入口：首页
- 支持参数化回流：编辑页、最近完成、最近删除、设置
- 回流参数异常时回退首页并写警告日志
- 返回行为统一由 `go_router` 管理，不允许页面自行重建壳层

## 最小数据合同

- `AppShellLaunchIntent`
  - 字段：`targetRoute`、`sourceType`、`fallbackReason`
  - 约束：只允许最小必要参数穿过壳层，不携带任务正文或其他隐私正文
- `ShellTabState`
  - 字段：`currentTab`、`restoredFromExternalEntry`
  - 约束：只表达导航宿主状态，不承载业务模块数据

## 数据、安全与监控

- 不持有业务数据，仅持有入口来源和当前 Tab
- 日志只记录入口类型与目标路由，不记录隐私正文
- 监控事件：`app_launch_routed`、`external_entry_fallback`

## 实现约束

- 不允许在壳层实现任务逻辑
- 不允许并行出现第二套路由守卫
- 后续 `flutter-init` 需先落壳层 scaffold，其他模块再接入
- 返工后的设计源仍以共享设计包和冻结规则为准；运行态截图只用于 parity 复核，不升级为新的壳层设计源
