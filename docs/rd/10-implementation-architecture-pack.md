# 屏记实现前架构包

## 0. 文档信息

- 文档名称：屏记实现前架构包
- 文档日期：2026-06-03
- 适用阶段：`implementation_ready_waiting`
- 作用：把已冻结的共享设计与模块 RD 映射为 Flutter 可实施结构，但不开始编码。

## 1. 输入摘要

- 共享设计冻结：
  - [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
  - [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/light-theme-freeze.yaml)
  - [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/dark-theme-freeze.yaml)
- 模块实现前 RD：
  - [app-shell.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/app-shell/app-shell.ui-ux.md)
  - [app-shell.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/app-shell/app-shell.impl.md)
  - [task-flow.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/task-flow/task-flow.ui-ux.md)
  - [task-flow.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/task-flow/task-flow.impl.md)
  - [history-center.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history-center/history-center.ui-ux.md)
  - [history-center.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history-center/history-center.impl.md)
  - [widget-bridge.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget-bridge/widget-bridge.ui-ux.md)
  - [widget-bridge.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget-bridge/widget-bridge.impl.md)
  - [settings-center.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings-center/settings-center.ui-ux.md)
  - [settings-center.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings-center/settings-center.impl.md)

## 2. 主题令牌映射

- 全局令牌层：
  - `SNColor.primary / accent / background / surface / divider`
  - `SNText.display / title / body / meta`
  - `SNRadius.card / chip / button`
  - `SNShadow.card / modal`
  - `SNSpacing.xs/sm/md/lg/xl`
- 组件语义层：
  - `SNFocusCardTokens`
  - `SNHistoryRowTokens`
  - `SNQuickCaptureTokens`
  - `SNPrivacyPreviewTokens`
  - `SNSettingsRowTokens`
- 模块覆盖原则：
  - 模块只允许别名共享令牌，不得重算主题语义
  - 需要新增局部值时，只能定义模块局部语义，不得上升覆盖全局角色

## 3. 组件拆解

- 共享 primitives：
  - 按钮、图标按钮、分段选择、开关行、容器卡、骨架占位
- 共享 composites：
  - `focus_note_card`
  - `quick_capture_bar`
  - `history_note_row`
  - `privacy_preview_card`
- 模块业务组件：
  - `app-shell`: `launch_router_gate`, `global_feedback_host`
  - `task-flow`: `task_meta_row`, `editor_action_footer`, `quick_add_bar`
  - `history-center`: `history_section_header`, `history_row_action_slot`
  - `widget-bridge`: `widget_preview_frame`, `snapshot_status_hint`
  - `settings-center`: `settings_group`, `capability_explain_card`

## 4. 屏幕架构

- `app-shell`
  - `launch_router_gate` 负责回流参数解析与默认落点
  - `shell_page` 负责底部宿主、全局反馈宿主与子路由装配
- `task-flow`
  - `home_page` 负责焦点事项、次级列表与快捷录入编排
  - `task_editor_page` 负责编辑与保存
- `history-center`
  - 历史页采用单页面双区块结构，列表状态边界独立
- `widget-bridge`
  - 预览与设置解耦；展示模式、刷新状态、安装说明分区承载
- `settings-center`
  - 设置首页只做导航与摘要，隐私页 / Widget 页承接具体设置

## 5. 状态架构

- 共享状态边界：
  - ideal
  - loading
  - empty
  - error
  - permission
  - partial_data
  - disabled
  - success
- 状态归属规则：
  - 页面层负责展示状态壳
  - 应用层负责状态流转、日志补写、快照刷新与能力降级结果聚合
  - 数据层负责持久化和插件适配

## 6. 滚动与动效架构

- 只保留轻量进入、保存反馈、切换反馈和预览变更动画。
- 首页主卡可采用轻微进入或交叉淡入，不得上演大幅位移动画。
- 历史页滚动只服务浏览，不加吸顶炫技。

## 7. 保真与 Flutter 化策略

- `preserve_faithfully`
  - 首页单主卡片构图
  - 衬线标题与无衬线正文的组合
  - 隐私预览对照反馈
  - 暖纸背景与深橄榄主焦点语义
- `flutterize`
  - 纸纹与手写缩略图可用轻纹理、插画或统一缩略图占位实现
  - 预览设备壳可用纯 Flutter 画法或轻边框容器表达
- `simplify`
  - 极细阴影
  - 环境装饰物
  - 小票边缘噪点

## 8. 实现边界

- 可直接进入编码的前提：
  - 所有模块 UI/UX 与实现 RD 已实现前最终化
  - 所有模块共享冻结源已引用
  - 项目脚手架已存在，且项目内 `flutter-dev` 技能可用
- 编码不得做的事：
  - 改主层级
  - 换主题语义
  - 把隐私降级改成内容泄露
  - 把历史页和设置页做回系统模板

## 9. Flutter 初始化输入

- Flutter 项目根目录：`D:\Projects\Flutter\screen_note`
- 当前已存在：
  - `lib/app`
  - `lib/shared`
  - `lib/features/app_shell`
  - `lib/features/task_flow`
  - `lib/features/history_center`
  - `lib/features/widget_bridge`
  - `lib/features/settings_center`
- 因仓库已初始化，本架构包供 `flutter-dev` 与 `flutter-project-guardrails` 直接消费，不再重复跑初始化脚手架。

## 10. 风险与开放项

- 当前模块级冻结依赖共享三张预览图、模块文档与显式文本设计包；后续若用户主动改视觉，必须回到设计源控制流程。
- 深色主题尚未生成独立静态预览，但共享冻结已给出完整 theme freeze 值，编码阶段不得自行改义。
- 若后续新增同步、Pro、Apple Reminders 或 AI 提取，应新增模块，不得偷挂到当前五个模块里扩边界。
