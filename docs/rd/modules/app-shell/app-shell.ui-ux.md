# app-shell UI/UX RD

## 模块目标与目标用户

- 目标：为屏记提供稳定的根导航、启动分发、系统回流与全局视觉宿主。
- 目标用户：所有进入 App 的用户，尤其是从 Widget、通知、快捷入口回流的高频查看用户。

## 页面范围与导航入口

- 页面范围：启动分发、底部导航壳、全局空壳骨架、全局弹层宿主。
- 导航入口：App 图标、Widget 点击、通知点击、未来快捷入口回流。

## 核心用户路径

1. 启动后进入壳层。
2. 壳层决定默认落点：首页或回流目标页。
3. 展示统一底部宿主、主题、本地化和全局反馈容器。

## 状态矩阵

| 状态 | 说明 |
| --- | --- |
| ideal | 成功进入默认 Tab 或回流目标页 |
| loading | 启动态短暂占位，不展示闪屏式冗余信息 |
| error | 回流参数异常时回退首页并记录日志 |
| permission | not_applicable |
| partial_data | 使用默认 Tab 宿主，延后页面自身数据加载 |
| disabled | not_applicable |
| success | 路由恢复成功，页面上下文稳定 |
| locked_or_premium | not_applicable |

## 结构语义

- `scroll_model`: none
- `list_model`: not-a-list
- `overlay_model`: modal layer + global feedback
- `layout_model`: layered
- `sticky_model`: fixed shell
- `component_repeatability`: 底部导航宿主、页面标题宿主、全局 Snack/Sheet 容器

## 模块级组件骨架

- `ShellScaffold`：承载底部宿主与回流后的子路由区域；仅允许一个主导航结构。
- `LaunchRouterGate`：根据入口参数和初始状态决定跳转目标。
- `GlobalFeedbackHost`：统一容纳轻提示、确认对话和错误反馈。

## 设计来源

- 共享设计包：`docs/rd/02-shared-design-packet.md`
- 共享冻结：`docs/rd/global-design-guidelines.md`
- 主题冻结：`docs/rd/light-theme-freeze.yaml`、`docs/rd/dark-theme-freeze.yaml`
- 视觉证据策略：
  - 共享锚点：`docs/rd/home-page-light-refresh-v2.png`
  - 模块级效果图：`docs/rd/modules/app-shell/app-shell-refresh-v1.png`
  - 模块图用于补充壳层宿主、底部导航与回流反馈的页面级证据；共享设计包继续约束壳层层级与页首节奏。
  - 运行态截图仅作为实现复核参考：`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c002/launch-settings.png`、`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c002/launch-history-deleted.png`、`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c002/launch-fallback-home.png`

## 设计冻结卡

- 冻结目标：根导航结构、页首留白节奏、全局反馈位置
- 不可变项：仅一个壳层导航体系；主页面切换不引入第二宿主
- 允许调整：iOS 安全区细节、底部高度、过渡动画时长
- 审批记录：`workflow-orchestrator --auto` 于 2026-06-04 自动确认
- 当前返工补充：本轮仅细化设计源说明与证据索引，不把已实现截图回写为新的设计源。

## 验收门禁

- UI/UX：系统回流不会打断主任务路径
- 设计冻结：底部宿主、标题节奏、反馈容器位置固定
- 代码交接：子模块只能通过壳层声明路由挂载
