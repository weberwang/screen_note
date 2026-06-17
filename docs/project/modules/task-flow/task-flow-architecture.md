# Task Flow Architecture

## 1. input_summary

- active_module: `task-flow`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开设计决策的前提下，把已冻结的 `task-flow` 设计源翻译成 Flutter 可直接消费的页面结构、组件分层、状态边界与实现约束。
- architecture_scope:
  - 首页主任务卡片
  - 首页紧急队列
  - 新建/编辑任务页
  - 优先级、状态、隐私安全与备注输入区
  - 保存回首页的主闭环
- out_of_scope:
  - `history-center` 的恢复链路
  - `settings-center` 的能力配置页
  - `widget-bridge` 的稳定快照投影
  - 远程同步或网络 API

## 2. consumed_design_artifacts

- [task-flow.impl.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-design-source-packet.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-design-source-packet.md)
- [task-flow-freeze-decision.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-freeze-decision.md)
- [task-flow-prototype-playback.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-prototype-playback.md)
- [task-flow-home.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-home.png)
- [task-flow-editor.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-editor.png)
- [prototype/index.html](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/prototype/index.html)
- [global-design-guidelines.md](/E:/Projects/flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](/E:/Projects/flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](/E:/Projects/flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [01-global-technical-baseline.md](/E:/Projects/flutter/screen_note/docs/project/01-global-technical-baseline.md)
- [02-product-design-clarification-packet.md](/E:/Projects/flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. display_evidence_pack

- main_home_preview:
  - path: `docs/project/modules/task-flow/task-flow-home.png`
  - coverage: 首页完整首屏、主任务卡片、紧急队列、共享底栏与快速新增入口
- main_editor_preview:
  - path: `docs/project/modules/task-flow/task-flow-editor.png`
  - coverage: 编辑页标题、时间、优先级、状态、隐私安全、备注、支持项与保存动作
- structure_preview:
  - path: `docs/project/modules/task-flow/prototype/index.html`
  - coverage: 首页到编辑页的主路径、新建态与编辑态切换、轻交互反馈
- semantics_playback:
  - path: `docs/project/modules/task-flow/task-flow-prototype-playback.md`
  - coverage: 页面层级、核心路径、交互清单、保真约束
- state_matrix_source:
  - path: `docs/project/modules/task-flow/task-flow-design-source-packet.md`
  - coverage: `ideal / empty / loading / error / permission / partial_data / disabled / success / locked`
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前模块同时具备首页图、编辑页图、原型交互与冻结设计包，足以支持高保真显示层决策与状态边界拆分。

## 4. high_fidelity_display_contract

### fidelity_critical_regions

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `home_priority_card` | `preserve_faithfully` | `task-flow-home.png`, `prototype/index.html` | 单主任务优先、暖白主卡、状态胶囊、底部元信息带与直达编辑动作 | 必须保持为首页第一阅读层，不得压缩成普通列表项 |
| `home_urgent_queue` | `preserve_faithfully` | `task-flow-home.png`, `prototype/index.html` | 轻行式队列、右侧到期信息、稀疏分隔、次级视觉重量 | 用原生列表实现，但不能回退成卡片堆叠 |
| `editor_primary_form` | `preserve_faithfully` | `task-flow-editor.png`, `prototype/index.html` | 核心字段首屏可见、单卡集中编排、顶部轻操作 + 底部单主保存动作 | 结构必须先于字段装饰，不能被改造成设置页式密集表单 |
| `privacy_safe_row` | `preserve_faithfully` | `task-flow-editor.png`, `prototype/index.html` | 安全语义明确、主文案 + 辅文案 + 开关同组出现 | 后续实现必须联动其他外显渠道，而不是纯视觉开关 |
| `support_rows` | `flutterize` | `task-flow-editor.png`, `prototype/index.html` | 附件与提醒是次级支持区，不可抢占主表单层级 | 可按原生列表语义落地 |

### preserve_rules

- 不得把首页压缩成“多任务同时争抢首屏注意力”的高密度面板。
- 不得让队列行视觉重量接近主任务卡片。
- 不得把编辑页的标题、到期时间、优先级、状态、隐私安全与保存动作拆散到多个层级里。
- 不得把隐私安全语义弱化成抽象开关文案。
- 不得在 `390 x 844 px` 冻结视口下用压缩留白换取更多首屏内容。

### approved_flutterization_rules

- 主卡轻纸感允许用暖色表面、弱渐层、轻阴影与圆角近似，不要求额外位图纹理。
- 队列图标、状态圆点、Chevron 和轻表单边框均可用 Flutter 原生控件实现。
- 编辑页附件与提醒支持行可以使用通用列表单元节奏，但必须保持次级层级。

## 5. theme_token_mapping

### global_theme_roles_to_flutter

| design_role | frozen_value | Flutter mapping | note |
| --- | --- | --- | --- |
| `surface_roles.background` | `#FBFAF7` | `ColorScheme.surface` / page scaffold background | 首页与编辑页的统一暖白背景 |
| `surface_roles.surface` | `#FFFFFF` | `ColorScheme.surfaceContainerLowest` | 表单面、次级容器、底部支持行 |
| `surface_roles.surface_subtle` | `#F3F5F0` | `ColorScheme.surfaceContainerLow` | 开关背景、弱胶囊、禁用态 |
| `color_roles.primary` | `#4D8B52` | `ColorScheme.primary` | 主 CTA、选中态、积极状态与隐私安全强调 |
| `status_roles.warning` | `#F08A32` | `AppAccent.warning` | 今日到期与中等级别强调 |
| `status_roles.error` | `#E96A5A` | `ColorScheme.error` | 逾期与高风险状态强调 |
| `text_roles.text_primary` | `#1F2328` | `ColorScheme.onSurface` | 主标题与一线信息 |
| `text_roles.text_secondary` | `#5F6762` | `AppText.secondary` | 说明文案、备注提示、元信息 |
| `border_roles.divider` | `#E4E8E0` | `DividerTheme.color` | 队列分隔线与表单边框 |

### typography_mapping

| usage | Flutter token proposal | note |
| --- | --- | --- |
| home greeting | `displaySmall` override | 首页问候语需要大、稳、低噪音 |
| priority card title | `headlineLarge` override | 主任务标题允许两行扩展但必须保持主导 |
| queue title | `titleMedium` | 队列行标题需要清晰但不能抢主任务 |
| section heading | `titleLarge` | 紧急队列标题 |
| form heading | `headlineMedium` | 编辑页标题与首屏语义焦点 |
| form labels | `labelLarge` / `labelMedium` | 表单标签统一 uppercase 轻标识 |

### spacing_and_radius_mapping

- page_horizontal_padding: `24`
- priority_card_radius: `36`
- editor_card_radius: `36`
- field_radius: `22`
- chip_radius: `18`
- save_button_radius: `999`
- spacing_lock:
  - 首页问候区到主任务卡片前留白不得小于 `24`
  - 主任务卡片内部标题到正文、正文到元信息的节奏不得被压扁
  - 编辑页字段分组间距必须保持清晰段落，不得堆成长表单墙

## 6. module_token_overlay

- `TaskFlowPriorityTone.background`: alias -> `surface_roles.surface`
- `TaskFlowPriorityTone.warmOverlay`: scoped local token，仅用于主任务卡片暖感表面
- `TaskFlowQueueTone.overdue`: alias -> `status_roles.error`
- `TaskFlowQueueTone.today`: alias -> `status_roles.warning`
- `TaskFlowEditorTone.safe`: alias -> `color_roles.primary`
- `TaskFlowEditorTone.support`: alias -> `surface_roles.surface_subtle`

说明：

- 模块 token 只做局部语义别名，不得覆盖全局 token 定义。
- 主任务卡片的暖感只能留在 `task-flow`，不能升格为所有页面卡片通用默认值。

## 7. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 首页主任务卡片纸感 | `native_flutter` | `none` | 渐层、圆角与轻阴影足以稳定表达 |
| 队列状态圆点与轻图标 | `native_flutter` | `none` | Flutter 原生可高保真复现 |
| 编辑页图标与开关 | `native_flutter` | `none` | 系统化轻控件更稳定 |
| 头像或品牌头像占位 | `simplify` | `none` | 非模块主职责，可使用轻占位 |

## 8. component_decomposition

### page_layer

- `TaskFlowHomePage`
- `TaskFlowEditorPage`

### home_components

- `TaskFlowHomeHeader`
- `TaskFlowHomePriorityCard`
- `TaskFlowHomeUrgentQueue`
- `TaskFlowUrgentQueueRow`

### editor_components

- `TaskEditorHeaderBar`
- `TaskEditorPrimaryCard`
- `TaskEditorDateRow`
- `TaskEditorPrioritySelector`
- `TaskEditorStatusSelector`
- `TaskEditorPrivacyRow`
- `TaskEditorNotesField`
- `TaskEditorSupportRow`
- `TaskEditorSaveBar`

### supporting_primitives

- `ScreenNotePanel`
- `TaskStatusChip`
- `TaskMetaRow`
- `TaskFieldSection`

## 9. screen_architecture

### route_topology

- entry:
  - `home` 由 `app-shell` Home 分支承接
  - `editor` 由 `task-flow` 内部路由承接新建态与编辑态
- route_entry_rules:
  - 点击主任务卡片进入编辑态
  - 点击队列行进入对应任务编辑态
  - 点击共享快速新增进入新建态

### page_scaffold_plan

- `home`
  - `SafeArea + SingleChildScrollView` 或 `CustomScrollView`
  - 单列垂直结构
  - 共享底栏与共享快速新增由 `app-shell` 提供
- `editor`
  - `Scaffold`
  - 顶部轻操作栏
  - 中间滚动表单区
  - 底部固定保存条

## 10. state_architecture

### home_state

- `taskFlowHomeControllerProvider`
  - owner: `task-flow application`
  - source: `TaskFeedSnapshot`
- `TaskFlowHomeDisplayModel`
  - owner: `task-flow presentation`
  - source: `TaskFeedSnapshot -> display model adapter`

### editor_state

- `taskFlowTaskByIdProvider`
  - owner: `task-flow application`
  - source: repository query by task id
- local field state:
  - `titleController`
  - `noteController`
  - `isPinned`
  - `isPrivate`
  - `isSaving`

### non_happy_state_coverage

- `empty`: 首页空态必须仍保留快速新增入口
- `loading`: 首页保持结构骨架，不重排成别的布局
- `error`: 首页加载失败降级为 calm copy，不影响页面主结构
- `permission`: 权限不足只做能力降级提示
- `disabled`: 保存进行中时禁用保存按钮，但不重排表单
- `success`: 保存成功后返回首页
- `locked`: 隐私安全开启时，后续实现必须限制外显正文

## 11. scroll_and_motion_architecture

- `home_scroll_decision`: `SingleChildScrollView` for current lean home surface
- `editor_scroll_decision`: `ListView` or `SingleChildScrollView` with bottom inset-safe save bar
- `sticky_decision`:
  - 首页无额外 sticky header
  - 编辑页底部保存条固定
- `motion_posture`:
  - 页面切换与保存反馈保持轻量
  - 禁止夸张弹跳或重动画

## 12. display_layer_decision_table

| region_id | visual_priority | scroll_decision | list_decision | layout_decision | sticky_decision | layout_anchor | spacing_lock_rule | text_overflow_rule | responsive_break_rule | z_axis_rule | animation_source_of_truth | pixel_tolerance | asset_decision | must_use_asset | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `home_priority_card` | `fidelity_critical` | `SingleChildScrollView` | `not-a-list` | `Column + layered decoration` | `no sticky behavior` | 首页问候区之后的第一主区域 | 标题、正文、元信息节奏锁定 | wrap, max 3 lines | 小宽度下只允许文本换行 | 高于背景、低于共享 overlay | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `home_urgent_queue` | `high` | `SingleChildScrollView` | `Column` or `ListView.separated` | `Column/Row` | `no sticky behavior` | 主任务卡片之后 | 队列标题与首行距离锁定 | title wrap, meta single line preferred | 不允许升级成双列 | 与正文同层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `editor_primary_form` | `fidelity_critical` | `ListView` | `not-a-list` | `Column` | `fixed footer` | 顶部标题区之后 | 字段组段落间距锁定 | wrap, no clipping | 仅允许纵向延展，不改结构 | 低于保存条 | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `priority_status_selectors` | `high` | `ListView` | `Wrap/Grid` | `Wrap` | `no sticky behavior` | 依附主表单字段顺序 | 选项组横向间距锁定 | no ellipsis preferred | 小宽度可换行但不换语义 | 与表单同层 | preview evidence only | `tight` | `native_flutter` | `none` | `no` | `flutterize` |
| `privacy_safe_row` | `high` | `ListView` | `not-a-list` | `Row` | `no sticky behavior` | 状态选择区之后 | 图标、文案、开关的对齐关系锁定 | body wrap allowed | 不允许拆成两个独立块 | 与表单同层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `editor_support_rows` | `normal` | `ListView` | `Column` | `Column/Row` | `no sticky behavior` | 主卡之后 | 保持次级节奏，不抢主表单 | title single line preferred | 可轻微压缩但不换层级 | 与正文同层 | explicit no-motion | `moderate` | `native_flutter` | `none` | `no` | `flutterize` |
| `save_bar` | `fidelity_critical` | `fixed layout` | `not-a-list` | `Stack/Align` | `fixed footer` | 编辑页底部安全区 | 与底部安全区距离锁定 | no wrap preferred | 小宽度下仅允许内边距微调 | 最高交互层之一 | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |

## 13. non_native_visual_fallbacks

- `none`

说明：

- 当前 `task-flow` 的核心视觉都适合用 Flutter 原生实现，不需要新增位图回退。

## 14. design_implementation_guardrails

- 层级护栏：首页首屏必须先读到主任务标题，再读到到期状态，再读到次级队列。
- 间距护栏：靠留白建立层级，不靠更多边框或卡片堆叠。
- 字体护栏：主任务标题必须保持大而稳，不能退化成普通列表字号。
- CTA 护栏：保存按钮与主任务进入动作都必须明显，但不能营销化。
- 隐私护栏：隐私安全相关状态必须始终优先于展示便利。
- 反模板护栏：禁止把首页改造成通用任务面板、看板或设置页式信息墙。

## 15. fidelity_vs_flutterization

### preserve_faithfully

- `home_priority_card`
- `home_urgent_queue`
- `editor_primary_form`
- `privacy_safe_row`
- `save_bar`

### flutterize

- `priority_status_selectors`
- `editor_support_rows`

### simplify

- `avatar_or_non_task_branding`

## 16. implementation_boundaries

- 页面层只负责展示、输入与导航，不直接承载排序、状态流转与日志写入。
- `task-flow` 的创建、编辑、完成、删除、恢复仍必须通过用例层编排。
- 首页主任务与紧急队列由稳定快照与展示模型驱动，不把复杂推导塞回 Widget。
- 编辑页保存成功后的首页刷新失败只能降级提示，不能回滚持久化结果。
- 若后续实现试图提高首页首屏队列密度、弱化主任务卡片或改变隐私安全语义，必须回到设计控制链路。

## 17. flutter_init_inputs

- project_root: `E:/Projects/flutter/screen_note`
- required_features:
  - `lib/features/task_flow/domain/`
  - `lib/features/task_flow/application/`
  - `lib/features/task_flow/presentation/`
  - `lib/features/task_flow/infrastructure/`
- required_dependencies:
  - `hooks_riverpod`
  - `flutter_hooks`
  - `go_router`
  - `drift`
  - `freezed`

## 18. risks_and_open_questions

- 风险：首页空态、加载态和错误态虽然已写入状态矩阵，但当前视觉证据仍以理想态和编辑态为主，后续实现前需要在 `Spec` 中明确这些状态的最终文案与触发条件。
- 风险：编辑页若后续接入更多字段，容易破坏“核心字段首屏可见”的冻结约束，必须在实现时控制新增范围。
- 风险：隐私安全目前已冻结语义，但跨 Widget、通知和截图的联动实现仍要在后续实现设计中严格收口。
