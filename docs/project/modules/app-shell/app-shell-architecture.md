# App Shell Architecture

## 1. input_summary

- active_module: `app-shell`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开设计决策的前提下，把已冻结的 `app-shell` 设计源翻译成 Flutter 可直接消费的壳层架构、显示决策和实现边界。
- architecture_scope:
  - 三栏共享壳层
  - 首页共享宿主
  - 全局快速添加入口与轻量 sheet
  - 系统回流落点与失败回退
  - 共享降级反馈承载位
- out_of_scope:
  - `task-flow` 业务真源与详情页
  - `history-center`、`settings-center` 模块内最终排版
  - Widget 快照渲染
  - 通知调度与数据库实现

## 2. consumed_design_artifacts

- [app-shell.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell.impl.md)
- [app-shell-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-design-source-packet.md)
- [app-shell-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-freeze-decision.md)
- [app-shell-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-prototype-playback.md)
- [app-shell-effect-home-v2.png](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-effect-home-v2.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. display_evidence_pack

- main_preview:
  - path: `docs/project/modules/app-shell/app-shell-effect-home-v2.png`
  - coverage: 首页完整首屏、主卡片、紧急队列、底栏与悬浮快速添加
- structure_preview:
  - path: `docs/project/modules/app-shell/prototype/index.html`
  - coverage: 三栏导航切换、快速添加 sheet、占位页宿主关系
- semantics_playback:
  - path: `docs/project/modules/app-shell/app-shell-prototype-playback.md`
  - coverage: 默认落点、交互路径、回流失败回退、反馈不遮挡原则
- state_matrix_source:
  - path: `docs/project/modules/app-shell/app-shell-design-source-packet.md`
  - coverage: `ideal / empty / loading / error / permission / disabled / success`
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前共享壳层是高保真但结构相对单一的页面，已有完整首屏图、交互原型和状态矩阵，足以支撑架构分解与显示层决策。
- missing_detail_evidence:
  - `history-center` 与 `settings-center` 在当前模块仅为壳层占位，不阻塞 `app-shell` 架构输出
  - 长列表滚动到深层后的视觉证据暂未提供，但 `app-shell` 不依赖该证据决定共享壳层架构

## 4. high_fidelity_display_contract

### fidelity_critical_regions

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `shell_toolbar` | `preserve_faithfully` | `app-shell-effect-home-v2.png` | 问候区必须轻、净、可快速扫读，不能被运营化或塞入多余统计 | 用原生排版实现，保留大标题与轻副标题节奏 |
| `home_priority_card` | `preserve_faithfully` | `app-shell-effect-home-v2.png` | 单一主任务绝对优先、暖白表面、宽松留白、轻深度 | 卡片结构和层级必须锁定，不能退化成普通列表项 |
| `bottom_nav_shell` | `preserve_faithfully` | `prototype/index.html` + 冻结决议 | 只能有 `Home / History / Settings` 三目的地，选中态低噪音 | 采用 `StatefulShellRoute` 对应三分支，视觉不加第四入口 |
| `global_quick_add_fab` | `preserve_faithfully` | `app-shell-effect-home-v2.png` + `prototype/index.html` | 必须独立悬浮，不并入底栏，不变成行内输入框 | 作为共享浮层触发器，位置与层级需要稳定 |
| `feedback_host` | `preserve_faithfully` | `app-shell-prototype-playback.md` | 降级反馈不能遮挡主事项区 | 采用顶部/底部轻提示承载，禁用全屏阻断 |
| `urgent_queue_rows` | `flutterize` | `app-shell-effect-home-v2.png` + `prototype/index.html` | 维持行式扫读、轻分隔、右侧进入详情引导 | 可用 Flutter 原生列表与分隔线稳定复现 |
| `history_settings_placeholder_host` | `simplify` | `prototype/index.html` | 当前仅验证壳层关系，不锁最终内容细节 | 允许先做结构占位，不预埋业务视觉决策 |

### preserve_rules

- 不得压缩 `390 x 844 px` 冻结视口下的首屏留白来容纳更多内容。
- 不得把主事项卡片与队列项拉到同一对比层级。
- 不得把快速添加当作第四个 tab 或导航目的地。
- 不得用高噪音阴影、重玻璃、重纹理覆盖当前浅色温和基线。

### approved_flutterization_rules

- 主卡片轻纸感允许用暖色表面、双层渐变和极弱噪点近似，不要求重位图纹理。
- 队列图标、Chevron、底栏图标统一使用系统化线性图标，避免额外插画资产。
- History / Settings 占位页在 `app-shell` 实现期只需保持壳层结构与节奏一致，不需要先造最终业务内容。

## 5. theme_token_mapping

### global_theme_roles_to_flutter

| design_role | frozen_value | Flutter mapping | note |
| --- | --- | --- | --- |
| `surface_roles.background` | `#FBFAF7` | `ColorScheme.surface` / app scaffold background | 首页整体暖白背景基线 |
| `surface_roles.surface` | `#FFFFFF` | `ColorScheme.surfaceContainerLowest` | 主要卡片与底栏承载面 |
| `surface_roles.surface_subtle` | `#F3F5F0` | `ColorScheme.surfaceContainerLow` | 次级填充、禁用态、轻胶囊底色 |
| `color_roles.primary` | `#4D8B52` | `ColorScheme.primary` | 选中态、快速添加、主语义强调 |
| `color_roles.accent` | `#F08A32` | `AppAccent.warning` | 当天到期与提醒强调，避免误作主 CTA |
| `status_roles.error` | `#E96A5A` | `ColorScheme.error` | 真正错误或高风险提醒 |
| `text_roles.text_primary` | `#1F2328` | `ColorScheme.onSurface` | 主标题与一级正文 |
| `text_roles.text_secondary` | `#5F6762` | `AppText.secondary` | 二级说明与元信息 |
| `border_roles.divider` | `#E8ECE5` | `DividerTheme.color` | 行分隔与底栏顶部分隔 |
| `shadow_or_overlay_roles.shadow_color` | `rgba(24, 34, 26, 0.08)` | `AppDepth.softShadow` | 主卡片与 FAB 柔和深度 |
| `shadow_or_overlay_roles.overlay_scrim` | `rgba(31, 35, 40, 0.24)` | `AppOverlay.scrim` | 快速添加 sheet 打开时的背景遮罩 |

### typography_mapping

| usage | Flutter token proposal | note |
| --- | --- | --- |
| hero greeting | `displaySmall` override | 大标题，紧字距，墨色 |
| primary card title | `headlineLarge` override | 必须支持 2-3 行内高密度阅读 |
| section header | `titleLarge` | 队列区标题 |
| queue row title | `titleMedium` | 行式任务标题 |
| queue metadata | `bodyMedium` secondary | 时间与二级提示 |
| nav label | `labelLarge` | 底栏标签，需稳定可扫读 |

### spacing_and_radius_mapping

- page_horizontal_padding: `24`
- shell_top_padding: `28`
- priority_card_radius: `36`
- sheet_radius: `26`
- fab_diameter: `84`
- nav_height: `108`
- queue_row_vertical_padding: `18`
- spacing_lock:
  - 标题区到底部主卡片前留白不得小于 `20`
  - 主卡片内容区上下内边距不得小于 `24`
  - FAB 与底栏之间的相对悬浮距离保持视觉独立，不可贴边

## 6. module_token_overlay

- `AppShellPriorityCardTone.background`: alias -> `surface_roles.surface`
- `AppShellPriorityCardTone.warmOverlay`: scoped local token，用于主卡片暖感渐变，不得升级为全局主题色
- `AppShellFabTone.background`: alias -> `color_roles.primary`
- `AppShellNavTone.active`: alias -> `icon_roles.icon_primary`
- `AppShellNavTone.inactive`: alias -> `icon_roles.icon_secondary`
- `AppShellQueueTone.urgent`: alias -> `status_roles.error`
- `AppShellFeedbackTone.degradation`: alias -> `status_roles.info`

说明：
- 模块 token 只做语义别名或局部实现辅助，不覆盖全局 token 名称。
- 主卡片暖感渐变仅属于 `app-shell` 的共享首页语义，不应被提升为全局所有卡片默认样式。

## 7. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 主卡片暖白表面与轻纸感 | `native_flutter` | `none` | 用渐变、透明高光和轻阴影即可稳定表达，不值得引入位图资产 |
| 底栏与普通列表图标 | `native_flutter` | `none` | 系统化线性图标可高质量复现 |
| 快速添加 FAB | `native_flutter` | `none` | 圆形、描边、阴影完全适合原生实现 |
| History / Settings 占位插图 | `simplify` | `none` | 当前阶段不需要插图或品牌位图 |
| 复杂品牌纹理 / 插画 | `not_needed` | `none` | 当前冻结方向明确禁止强装饰视觉 |

## 8. component_decomposition

### shared_shell_layer

- `AppShellRoot`
  - 负责共享 `Scaffold`、底栏、FAB、全局反馈层和系统回流分发
- `AppShellScaffold`
  - 负责底部导航布局与安全区处理
- `AppShellBodyHost`
  - 挂载当前 branch 页面宿主，不承载业务判断

### home_branch_components

- `HomeGreetingHeader`
- `PriorityReminderCard`
- `PriorityCardMetaRow`
- `UrgentQueueSection`
- `UrgentTaskRow`

### overlay_and_feedback_components

- `GlobalQuickAddFab`
- `GlobalQuickAddSheet`
- `AppShellFeedbackHost`
- `LaunchRouteFallbackBanner`

### navigation_components

- `BottomNavShell`
- `BottomNavItem`

## 9. screen_architecture

### route_topology

- root: `StatefulShellRoute.indexedStack`
- branches:
  - `home`
  - `history`
  - `settings`
- route_entry_rules:
  - 默认入口落到 `home`
  - 系统回流命中失败时安全回退到 `home`
  - 快速添加不是独立顶级 branch，而是壳层内共享 overlay

### page_scaffold_plan

- `AppShellRoot` 作为最外层路由宿主
- `Scaffold` 承载：
  - `body`: 当前 branch 内容
  - `bottomNavigationBar`: 三栏底部导航
  - `floatingActionButton`: 全局快速添加
- `history` 与 `settings` 先使用结构占位页，后续分别由各自 feature 接管内容

### structure_notes

- `home` 分支使用单主轴纵向结构
- 主卡片与队列共用滚动语义，但底栏和 FAB 固定
- 快速添加 sheet 走壳层级 overlay，不侵入分支路由树

## 10. state_architecture

### shell_state

- `activeTab`
  - owner: `app-shell presentation`
  - source: 路由当前 branch
- `quickAddSheetVisibility`
  - owner: `app-shell presentation`
  - source: 局部 UI 状态
- `launchRouteResolution`
  - owner: `app-shell application`
  - source: 系统入口参数解析结果
- `globalDegradationFeedback`
  - owner: `app-shell application`
  - source: 通知拒绝、回流失败、Widget 刷新失败等降级事件

### cross_feature_boundaries

- `task-flow` 提供首页主事项与紧急队列的只读展示 ViewModel
- `history-center` 提供历史页 branch 内容
- `settings-center` 提供设置页 branch 内容
- `widget-bridge` 只通过系统回流参数触发壳层分发，不直接改壳层视觉结构

### non_happy_state_coverage

- `first_use_empty`: Home 仍展示快速添加与清晰空态
- `notification_permission_denied`: 以轻降级提示呈现，不抢主任务视觉
- `widget_refresh_failed`: 只给出次级反馈，不替代首页主体
- `launch_route_fallback`: 回退 Home 并记录事件，不中断壳层渲染

## 11. scroll_and_motion_architecture

- `home_scroll_decision`: `CustomScrollView`
- `history_scroll_decision`: 由后续模块接管，当前仅保留壳层宿主
- `settings_scroll_decision`: 由后续模块接管，当前仅保留壳层宿主
- `sticky_decision`:
  - 底栏固定
  - FAB 固定悬浮
  - Home 内容区不需要额外粘性头
- `motion_posture`:
  - 底栏切换保持克制
  - FAB 按压与 sheet 展开允许轻量过渡
  - 禁止夸张弹跳、长时动画或抢主任务注意力的动效

## 12. display_layer_decision_table

| region_id | visual_priority | scroll_decision | list_decision | layout_decision | sticky_decision | layout_anchor | spacing_lock_rule | text_overflow_rule | responsive_break_rule | z_axis_rule | animation_source_of_truth | pixel_tolerance | asset_decision | must_use_asset | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `shell_toolbar` | `high` | `CustomScrollView` | `not-a-list` | `Column/Row` | `no sticky behavior` | 顶部安全区与页面左边距 | 标题与副标题间距保持轻但明确 | wrap | 小宽度下只允许文案换行，不压缩外边距 | 在正文内容之下、卡片之上 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `home_priority_card` | `fidelity_critical` | `CustomScrollView` | `not-a-list` | `Column + layered decoration` | `no sticky behavior` | 顶部摘要后首个主区域 | 卡片内外边距、标题到元信息距离锁定 | wrap，超长时最多 3 行 | 不允许在冻结视口下压缩卡片层级 | 高于页面背景，低于全局 overlay | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `urgent_queue_section` | `high` | `CustomScrollView` | `SliverList` | `sliver composition` | `no sticky behavior` | 主卡片之后 | 分区标题与首行队列间距锁定 | 标题 wrap，任务行单标题最多 2 行 | 仅允许文本换行，不允许改成双列 | 与页面内容同层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `flutterize` |
| `bottom_nav_shell` | `fidelity_critical` | `fixed layout` | `not-a-list` | `Row` | `fixed footer` | 页面底部安全区 | 三项等分与标签间距锁定 | clip disallowed，优先文本保真 | 不允许增减目的地数量 | 高于页面滚动层，低于 FAB | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `global_quick_add_fab` | `fidelity_critical` | `fixed layout` | `not-a-list` | `Stack` | `fixed footer` | 底栏上方右侧锚点 | 与底栏垂直距离锁定 | not applicable | 小宽度下只允许轻微偏移，不允许并入底栏 | 高于底栏和页面内容 | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `quick_add_sheet` | `high` | `fixed layout` | `not-a-list` | `Overlay + Column` | `no sticky behavior` | 依附 FAB 打开，底部安全区上方 | 内边距与操作按钮间距锁定 | input wrap | 可在高度不足时内部滚动，但不改为全屏页 | 高于 scrim，高于内容层 | preview evidence only | `tight` | `native_flutter` | `none` | `no` | `flutterize` |
| `feedback_host` | `high` | `mixed` | `not-a-list` | `Overlay` | `mixed` | 避开主卡片首屏热区 | 反馈与主任务区至少保持一段安全距离 | wrap | 可随设备安全区做位移，不改成模态阻断 | 最高层之一，但低于系统对话框 | explicit no-motion | `moderate` | `native_flutter` | `none` | `no` | `flutterize` |

## 13. non_native_visual_fallbacks

- `none`

说明：
- 当前 `app-shell` 没有必须依赖位图的高保真品牌视觉。
- 如果后续实现发现某一局部纸感必须依赖噪点贴图，需先回到 `flutter-design-source-control` 确认，再决定是否引入轻位图资产。

## 14. design_implementation_guardrails

- 层级护栏：首页第一眼必须先读到主事项标题，再读到队列，再读到底栏。
- 间距护栏：优先靠留白组织结构，不用额外卡片堆叠补层级。
- 字体护栏：主标题要大、稳、紧凑，不能退回通用列表字号。
- 对比护栏：主 CTA、选中 tab、当天/错误状态必须可区分，但不能变成营销噪音。
- 反馈护栏：成功与降级反馈都要轻量，不能抢占首页首屏。
- 反模板护栏：禁止把首页改成多块均权卡片瀑布流。
- 动效护栏：仅保留短、轻、目的明确的过渡，不做装饰性运动。

## 15. fidelity_vs_flutterization

### preserve_faithfully

- `shell_toolbar`
- `home_priority_card`
- `bottom_nav_shell`
- `global_quick_add_fab`

### flutterize

- `urgent_queue_section`
- `quick_add_sheet`
- `feedback_host`

### simplify

- `history_settings_placeholder_host`

## 16. implementation_boundaries

- `app-shell` 只拥有共享导航、共享宿主、快速添加入口与回流分发。
- `app-shell` 不拥有事项排序、状态流转、日志写入、快照刷新或通知调度业务。
- `app-shell` 只消费上游 feature 暴露的展示模型，不直接查库。
- `app-shell` 可以定义共享壳层组件，但不得吸走 `task-flow`、`history-center`、`settings-center` 的业务状态机。
- 若后续实现需要改动三栏壳层结构、快速添加位置或首页主任务层级，必须回到设计控制链而不是直接改代码。

## 17. flutter_init_inputs

- project_root: `D:/Projects/Flutter/screen_note`
- current_gap: `lib/` 目录尚未形成工作流要求的初始化骨架
- required_scaffold:
  - `lib/app/`
  - `lib/core/`
  - `lib/shared/`
  - `lib/features/app_shell/`
  - `lib/features/task_flow/`
  - `lib/features/history_center/`
  - `lib/features/settings_center/`
  - `lib/features/widget_bridge/`
- bootstrap_critical_inputs:
  - 根路由采用 `go_router` 的 `StatefulShellRoute.indexedStack`
  - 共享壳层必须有固定底栏与独立 FAB 宿主
  - 未来首页滚动结构优先 `CustomScrollView + SliverList`
  - 主题基线直接映射自 `light-theme-freeze.yaml` / `dark-theme-freeze.yaml`
  - Provider 体系必须采用 `hooks_riverpod + riverpod_annotation`

## 18. risks_and_open_questions

- 风险：当前仓库仍缺少 `flutter-init` 级别的 `lib` 骨架，若直接跳到功能代码实现，会让后续 DDD 分层与路由宿主落点失控。
- 风险：`pubspec.yaml` 当前未体现 guardrails 中要求的 `flutter_screenutil` 初始化基线，后续初始化阶段需要统一补齐并验证。
- 风险：History / Settings 仅有壳层占位，后续模块实现不能把这些占位样式误当成最终视觉冻结。
- 开放问题：如果后续确认首页需要下拉刷新或系统回流后自动打开快速添加，需在 `app-shell` 实现前补充到 `@superpowers Spec`，而不是在显示层临时发明交互。

