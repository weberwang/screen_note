# 屏记实施前架构包

## input_summary

- 输入文档：
  - `docs/rd/01-global-technical-baseline.md`
  - `docs/rd/02-shared-design-packet.md`
  - `docs/rd/global-design-guidelines.md`
  - `docs/rd/light-theme-freeze.yaml`
  - `docs/rd/dark-theme-freeze.yaml`
  - `docs/rd/modules/*/*.ui-ux.md`
  - `docs/rd/modules/*/*.impl.md`
- 冻结结果：共享设计已冻结；`app-shell`、`task-flow`、`history-center`、`widget-bridge`、`settings-center` 已达到模块实施前冻结状态。

## consumed_design_artifacts

- 全局视觉规则：`global-design-guidelines.md`
- 主题冻结：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- 静态证据：
  - `docs/rd/home-overview.png`
  - `docs/rd/recent-completed.png`

## theme_token_mapping

- 颜色 token：`primary / accent / success / warning / error / info`
- 表面 token：`background / surface / subtle / elevated / inverse`
- 文本 token：`textPrimary / textSecondary / textTertiary / textInverse`
- 边框 token：`borderSubtle / borderStrong / divider`
- 焦点 token：`focusRing`

## module_token_overlay

- `task-flow`：允许定义 `overdueBadge`、`todayBadge` 的模块语义映射，但不得覆盖全局主色命名
- `history-center`：允许定义 `restoreAction` 语义映射
- `widget-bridge`：允许定义 Widget 容器间距与字号别名
- `settings-center`：允许定义权益占位卡的局部表面层级

## asset_strategy

- `native_flutter`
  - 任务行、设置项、历史记录行、底部宿主、输入区、状态标签
- `existing_asset_reuse`
  - `home-overview.png`、`recent-completed.png` 仅作为视觉参考，不直接进 App
- `project_bitmap_asset`
  - none

## component_decomposition

- 全局 primitives：按钮、输入框、标签、分组标题、卡片容器
- 业务 widgets：
  - `TaskListItem`
  - `QuickAddBar`
  - `HistoryRecordRow`
  - `WidgetSingleCard`
  - `SettingsToggleRow`
- 壳层 widgets：
  - `ShellScaffold`
  - `GlobalFeedbackHost`

## screen_architecture

- `app-shell`
  - 路由宿主 + 底部导航 + 子路由区
- `task-flow`
  - 首页：标题区 + 快速添加 + 任务分组列表
  - 编辑页：分组表单 + 尾部主 CTA
- `history-center`
  - 页首标题 + 历史列表/空态
- `widget-bridge`
  - 系统 Widget 单条/三条/空态模板
- `settings-center`
  - 分组设置列表 + 未来权益弱入口

## state_architecture

- 核心事实源：`TaskRepository`
- 核心派生：
  - `activeFeed`
  - `completedHistory`
  - `deletedHistory`
  - `widgetSnapshot`
- 关键状态只通过应用层用例推进，所有写入伴随事件日志

## scroll_and_motion_architecture

- 首页：`CustomScrollView` 或分组 `SliverList`
- 编辑页：`SingleChildScrollView + fixed bottom action`
- 历史页：`ListView/SliverList`
- 设置页：`ListView` 分组
- 动效：仅保留切换、保存成功、恢复成功的轻反馈

## display_layer_decision_table

| 模块 | 区域 | scroll_decision | list_decision | layout_decision | sticky_decision | asset_decision |
| --- | --- | --- | --- | --- | --- | --- |
| app-shell | 根宿主 | fixed layout | not-a-list | layered | no sticky behavior | native_flutter |
| task-flow | 首页任务流 | CustomScrollView | SliverList | sliver composition | pinned sliver header when filters exist | native_flutter |
| task-flow | 编辑页 | SingleChildScrollView | not-a-list | Column/Row | fixed footer | native_flutter |
| history-center | 历史列表 | ListView | ListView.builder | linear | sticky header | native_flutter |
| widget-bridge | Widget 卡片 | fixed layout | static block | layered | no sticky behavior | native_flutter |
| settings-center | 设置页 | ListView | grouped list | linear | no sticky behavior | native_flutter |

## non_native_visual_fallbacks

- none
- 当前冻结包没有需要强制转成位图资产的复杂纹理或插画效果

## taste_implementation_guardrails

- 维持大标题与列表节奏的明显梯度
- 主 CTA 永远明显强于次动作
- 不得把页面做成卡片套卡片的拥挤信息板
- Loading/Error/Empty 反馈必须克制，不能压过主任务

## fidelity_vs_flutterization

- `preserve_faithfully`
  - 首页首屏层级、快速添加条、过期任务显著性、Widget 隐私占位
- `flutterize`
  - 阴影、模糊、分隔线、系统控件形态
- `simplify`
  - 预览中的装饰性头像、无关标签数量、非关键图标

## implementation_boundaries

- `flutter-init` 需要先落：app bootstrap、router、provider scope、drift baseline、theme/i18n、logging、widget/notification service shells
- 业务模块代码不能越过设计冻结包修改 UI 层级
- Widget 与通知能力必须作为 shared/data service 注入，不直挂页面

## flutter_init_inputs

- 项目根：当前仓库 `screen_note`
- 必要共享基线：
  - `app-shell` 路由宿主
  - Riverpod ProviderScope
  - Drift 数据库与迁移入口
  - Widget 快照桥接服务
  - 通知调度服务
  - 主题与国际化基线
- 目标结构：
  - `lib/app`
  - `lib/shared`
  - `lib/features/app_shell`
  - `lib/features/task_flow`
  - `lib/features/history_center`
  - `lib/features/widget_bridge`
  - `lib/features/settings_center`

## risks_and_open_questions

- `flutter-init` 尚未执行，当前工程仍缺少 project-local `flutter-dev` 技能与 `lib/` 基线代码
- 当前 worktree 已存在大量旧实现与设计资产的删除/修改痕迹；继续执行 `flutter-init` 前需要先确认这些删除是否为用户有意保留
- `task-editor`、`recent-deleted`、`settings` 的静态预览未全部生成，后续如要做高保真显示层对齐，可补图再实施
- Pro/iCloud/Reminders 仍是未来增强，初始化阶段只应预留扩展口
