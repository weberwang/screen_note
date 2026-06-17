# app 全局 edge-to-edge 设计

## 1. 目标

把应用切到全局 `edge-to-edge` 显示模式，让页面背景可以延伸到状态栏和系统导航栏下方，同时保留现有页面正文的 `SafeArea` 保护，不在本次任务里逐页重做内容贴边布局。

本次成功标准：

- 应用启动后统一进入 `SystemUiMode.edgeToEdge`。
- 根应用统一提供系统栏样式，保证浅色背景下图标仍可读。
- 现有页面不需要删除 `SafeArea`，业务交互和路由保持不变。
- 增补最小测试，覆盖全局 `edge-to-edge` 启动装配。

## 2. 现状

- 启动装配收口在 [app_bootstrap.dart](/D:/Projects/Flutter/screen_note/lib/app/bootstrap/app_bootstrap.dart)。
- 根级 `MaterialApp.router` 装配收口在 [app.dart](/D:/Projects/Flutter/screen_note/lib/app/app.dart)。
- 当前项目还没有统一的 `SystemChrome` 或 `SystemUiOverlayStyle` 接线。
- 各页面大多已经使用 `SafeArea`，例如编辑页正文位于 [task_flow_editor_page.dart](/D:/Projects/Flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart:206)。

## 3. 方案

采用“启动阶段开启 edge-to-edge + 根应用统一系统栏样式”方案：

- 在 `bootstrapAndRunApp()` 中调用 `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)`。
- 在根应用层通过统一系统栏样式，把状态栏和导航栏设为透明背景，并按当前主题提供稳定的明暗图标语义。
- 页面层继续保留现有 `SafeArea`，因此本次只改变背景延伸和系统栏宿主行为，不改正文可点击区的安全边界。

## 4. 变更边界

- `lib/app/bootstrap/app_bootstrap.dart`
  - 新增全局系统 UI 模式配置。
- `lib/app/app.dart`
  - 为根应用补统一系统栏样式宿主。
- `test/app/bootstrap/`
  - 新增或扩展测试，验证启动阶段确实切换到 `edge-to-edge`。

## 5. 行为约束

- 不逐页删除 `SafeArea`。
- 不顺带重构主题、页面结构或壳层路由。
- 不引入新的页面级系统栏控制逻辑，避免样式散落到 feature 页面。
- 不为了兼容旧视觉额外引入分平台分支，除非测试或 Flutter API 明确要求。

## 6. 测试策略

- 为 bootstrap 补单测，验证会调用 `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)`。
- 运行受影响测试，确认通知 bootstrap 与根应用装配未被破坏。

## 7. 风险与控制

- 风险：只开 `edge-to-edge` 不补系统栏样式，浅色背景下图标可能发白或对比度不足。
  - 控制：把系统栏样式统一收口在根应用层，不交给页面各自决定。
- 风险：页面正文如果本来依赖默认系统栏 inset，视觉上会更贴边。
  - 控制：保留现有 `SafeArea`，本次只做背景延伸，不改正文布局。
- 风险：测试环境里直接断言平台通道行为不稳定。
  - 控制：用 `SystemChannels.platform.setMockMethodCallHandler` 捕获 `SystemChrome` 调用。

## 8. 非目标

- 不把编辑页正文沉到状态栏下面。
- 不重做底部保存栏与系统导航栏的贴边视觉。
- 不逐页为不同主题或不同页面定制系统栏样式。
