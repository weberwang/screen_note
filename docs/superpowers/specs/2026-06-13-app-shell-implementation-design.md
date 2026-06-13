# app-shell 实现设计说明

## 1. 目标

本设计说明用于约束 `app-shell` 模块的首轮真实实现范围。目标是在已经完成 `bootstrap_code_ready` 的前提下，把共享壳层从“可运行占位”推进到“可承接真实模块接入的稳定宿主”，同时不越界实现 `task-flow`、`history-center`、`settings-center`、`widget-bridge` 的业务逻辑。

本轮实现的成功标准是：

- 共享壳层继续保持 `Home / History / Settings` 三栏结构
- 全局快速添加继续保持独立浮层入口
- 系统回流入口开始具备可扩展的分发骨架
- 共享反馈宿主有稳定落点
- `app-shell` 的页面与路由宿主不再只是 bootstrap 占位，而是成为后续 feature 接入的正式外壳

## 2. 当前输入

当前实现必须严格遵循以下已冻结输入：

- [app-shell.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell.impl.md)
- [app-shell-architecture.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-architecture.md)
- [app-shell-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-freeze-decision.md)
- [app-shell-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-design-source-packet.md)
- [07-bootstrap-code-summary.md](D:/Projects/Flutter/screen_note/docs/project/07-bootstrap-code-summary.md)

其中最关键的实现约束是：

- 壳层只负责共享导航、共享宿主、快速添加入口和系统回流入口
- 不直接承载事项真源、状态推导、数据库访问或通知调度
- 共享壳层结构不可扩展为四栏或五栏
- 快速添加不能退化成底栏普通 tab
- 全局反馈不能遮挡主任务首屏区域

## 3. 本轮范围

### 3.1 范围内

- `AppShellPage` 结构从纯占位稳定为真实共享宿主
- `AppShellNavigationSurface` 具备稳定 tab 分支切换行为
- `widget_launch_bridge` 扩展为可承接后续深链/系统回流的统一入口抽象
- 为首页、历史、设置三个根分支建立更明确的“宿主页 vs 业务页”边界
- 为全局快速添加弹层建立可复用的宿主组件和状态入口
- 为全局降级反馈建立统一的宿主位置和最小展示模型
- 为后续 feature 接入预留清晰 provider / widget / route ownership

### 3.2 范围外

- 真实任务列表数据
- 真实历史恢复能力
- 真实设置项与偏好读写逻辑
- Widget 真正点击回流
- 通知权限拒绝后的真实降级来源
- 数据库、仓储、日志写入和业务用例实现

## 4. 设计决策

### 4.1 路由宿主保持不变，但责任更清晰

根路由继续使用 `StatefulShellRoute.indexedStack`，因为它已经与冻结架构一致。当前不改路由拓扑，只把壳层和分支页面的责任边界明确下来：

- `AppShellPage` 负责真正的共享 `Scaffold`
- 三个分支页负责各自页面根语义
- 快速添加和共享反馈保持在壳层级 overlay，不下沉到业务页

### 4.2 壳层组件分层

建议把 `app-shell` 的显示层拆成以下稳定单元：

- `AppShellPage`
  - 只负责 scaffold、FAB、bottom nav、feedback host、modal sheet 触发
- `AppShellNavigationSurface`
  - 只负责 tab 切换与选中态
- `AppShellQuickAddSheet`
  - 只负责共享快速添加弹层外壳
- `AppShellFeedbackHost`
  - 只负责展示共享降级反馈
- `AppShellLaunchResolver`
  - 只负责把系统入口参数解析成安全落点

这样后续 `task-flow` 接入首页真实内容时，不需要反向改写壳层主结构。

### 4.3 共享状态最小化

本轮 `app-shell` 只引入 3 类共享状态：

- 当前 tab / 当前 branch
- 快速添加弹层开关
- 启动入口解析结果与安全回退结果

不引入：

- 真实任务流状态
- 历史中心业务状态
- 设置项业务状态

### 4.4 共享反馈最小模型

壳层级反馈统一走一份轻量模型，例如：

- `info`
- `warning`
- `degradation`

当前阶段只要求它能被渲染和关闭，不要求接入真实业务来源。后续由模块通过应用层把消息喂给壳层宿主。

## 5. 文件边界

本轮实现建议优先集中在这些文件：

- `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- `lib/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart`
- 新增：
  - `lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart`
  - `lib/features/app_shell/presentation/widgets/app_shell_feedback_host.dart`
  - `lib/features/app_shell/application/app_shell_launch_resolver.dart`
  - `lib/features/app_shell/application/providers/app_shell_ui_state.dart`
  - `lib/features/app_shell/domain/entities/app_shell_launch_intent.dart`
- 可能需要轻改：
  - `lib/app/router/app_router.dart`
  - `lib/app/startup/widget_launch_bridge.dart`

不应触碰：

- `task_flow` 的数据、用例和实体实现
- `history_center` 的业务层
- `settings_center` 的业务层
- `widget_bridge` 的真实桥接逻辑

## 6. 测试策略

本轮实现至少补齐以下测试：

- `app_shell_page` 的三栏切换测试
- 快速添加弹层打开/关闭测试
- 启动桥接的默认安全回退测试
- 共享反馈宿主基础展示测试

测试目标不是覆盖业务数据，而是证明共享壳层作为“公共宿主”已经稳定。

## 7. 风险与控制

### 风险 1：壳层吸收业务逻辑

如果为了“先跑起来”把首页任务选择、历史筛选或设置状态直接塞进 `app-shell`，后续模块边界会再次塌掉。

控制方式：

- 壳层层只允许依赖抽象输入
- 真实数据留给后续 feature 注入

### 风险 2：快速添加变成假的第四导航项

如果为了省事把快速添加改成底栏项，会直接违反冻结设计。

控制方式：

- FAB 与 modal sheet 继续保留壳层级独立结构

### 风险 3：反馈遮挡主首屏

如果共享反馈直接用居中阻断弹窗，会破坏首页主任务层级。

控制方式：

- 反馈宿主限制为轻量顶部/底部内联区域

## 8. 实现后预期状态

完成本轮后，项目应满足：

- `bootstrap_code_ready` 之后的共享壳层宿主正式稳定
- `app-shell` 可以作为第一个进入真实模块执行的活动模块
- 后续 `task-flow`、`history-center`、`settings-center` 接入时，只需要替换分支内容，不需要推翻壳层结构

## 9. 非目标声明

本轮不是要把首页做成最终视觉成品，也不是要把 `task-flow` 数据流接进来。核心目的只有一个：把 `app-shell` 从“能展示的 bootstrap”提升到“能承载后续模块接入的正式共享宿主”。

