# Task Flow Architecture

## 1. input_summary

- active_module: `task-flow`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开设计决策的前提下，把已冻结的 `task-flow` 设计源翻译成 Flutter 可直接消费的任务真源架构、显示决策和实现边界。
- architecture_scope:
  - 首页主事项卡片
  - 首页紧急 / 次级事项队列
  - 事项编辑页
  - 事项状态流转、排序与日志写入的实现边界
- out_of_scope:
  - `history-center` 最近完成 / 最近删除展示实现
  - `settings-center` 设置页展示实现
  - `widget-bridge` 快照投影实现
  - 通知调度与小组件桥接的具体接入

## 2. consumed_design_artifacts

- [task-flow.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-design-source-packet.md)
- [task-flow-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-freeze-decision.md)
- [task-flow-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-prototype-playback.md)
- [task-flow-home.png](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-home.png)
- [task-flow-editor.png](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-editor.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. display_evidence_pack

- main_preview:
  - path: `docs/project/modules/task-flow/task-flow-home.png`
  - coverage: 首页完整首屏、主事项卡片、紧急列表、共享底栏与悬浮快速添加
- detail_preview:
  - path: `docs/project/modules/task-flow/task-flow-editor.png`
  - coverage: 编辑页标题输入、字段分组、隐私设置、保存动作
- structure_preview:
  - path: `docs/project/modules/task-flow/prototype/index.html`
  - coverage: 首页到编辑页主链路切换、行点击与继续动作、编辑页返回路径
- semantics_playback:
  - path: `docs/project/modules/task-flow/task-flow-prototype-playback.md`
  - coverage: 页面层级、状态覆盖、交互清单、隐私与降级约束
- state_matrix_source:
  - path: `docs/project/modules/task-flow/task-flow-design-source-packet.md`
  - coverage: `ideal / active_today / active_overdue / private_safe / long_title / empty / loading / error / permission`
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前模块已具备首页主视图、编辑页细节图、交互原型与冻结后的状态矩阵，足以支撑业务真源与显示层的实现边界拆解。
- missing_detail_evidence:
  - 完成态、删除态与恢复态未单独出图，但当前足以先完成架构规划；对应状态后续可沿用同一列表语义扩展
  - 更深层滚动位置尚未补截图，但当前首页与编辑页的关键首屏层级已清楚

## 4. high_fidelity_display_contract

### fidelity_critical_regions

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `home_priority_card` | `preserve_faithfully` | `task-flow-home.png` + `prototype/index.html` | 单一主事项绝对优先、暖白主表面、到期信息与继续动作同屏 | 不能退化成普通列表首行，必须保留独立卡片层级 |
| `home_urgent_queue` | `preserve_faithfully` | `task-flow-home.png` | 逾期事项采用行式结构与受控橙红语义 | 用原生列表实现，但禁止变成多层卡片或网格 |
| `editor_title_surface` | `preserve_faithfully` | `task-flow-editor.png` | 大标题输入优先、编辑态聚焦感、单任务单主轴 | 标题输入区必须是页面第一关注层 |
| `editor_field_groups` | `flutterize` | `task-flow-editor.png` + `prototype/index.html` | 日期、时间、分类、隐私分组顺序固定 | 可用 Flutter 原生分组列表和行点击交互还原 |
| `editor_primary_save` | `preserve_faithfully` | `task-flow-editor.png` | 保存动作必须是唯一主 CTA | 不与次级按钮平权，不拆成多动作工具栏 |
| `shared_shell_attachment` | `flutterize` | `task-flow-home.png` + `app-shell` 冻结包 | `task-flow` 只消费共享壳层，不重定义底栏/FAB | 页面层必须嵌入 app-shell 既有宿主 |

### preserve_rules

- 不得用更密列表压缩首页主事项卡片高度。
- 不得把编辑页改成配置中心式的多区块面板。
- 不得在首页引入搜索、筛选或额外顶部工具抢主任务层级。
- 不得让隐私事项在首页列表或卡片露出不该展示的正文。

### approved_flutterization_rules

- 列表状态图标、Chevron、分组边界统一采用系统化线性图标与原生分隔线。
- 编辑页字段行采用 Flutter 原生点击行与底部按钮即可，无需独立位图资产。
- 主卡片纸感继续弱化为渐变、微高光和轻阴影，不引入重纹理资源。

## 5. theme_token_mapping

### global_theme_roles_to_flutter

| design_role | frozen_value | Flutter mapping | note |
| --- | --- | --- | --- |
| `surface_roles.background` | `#FBFAF7` | `ColorScheme.surface` / page background | 首页与编辑页公共暖白底色 |
| `surface_roles.surface` | `#FFFFFF` | `ColorScheme.surfaceContainerLowest` | 编辑页字段组与普通内容承载面 |
| `surface_roles.surface_subtle` | `#F3F5F0` | `ColorScheme.surfaceContainerLow` | 次级胶囊、表单弱背景 |
| `color_roles.primary` | `#4D8B52` | `ColorScheme.primary` | 主动作、今日语义、编辑重点 |
| `status_roles.error` | `#E96A5A` | `ColorScheme.error` | 逾期与高风险状态 |
| `text_roles.text_primary` | `#1F2328` | `ColorScheme.onSurface` | 主标题与字段名称 |
| `text_roles.text_secondary` | `#5F6762` | `AppText.secondary` | 次级说明与日期元信息 |
| `border_roles.divider` | `#E4E8E0` | `DividerTheme.color` | 列表行与字段组分隔 |
| `shadow_or_overlay_roles.shadow_color` | `rgba(24, 34, 26, 0.08)` | `AppDepth.softShadow` | 主卡片和底部按钮轻深度 |

### typography_mapping

| usage | Flutter token proposal | note |
| --- | --- | --- |
| home greeting | `headlineLarge` override | 首页问候区，大字但低噪音 |
| priority card title | `displaySmall` override | 首页最高优先级标题 |
| queue row title | `titleMedium` | 列表主文案 |
| queue row meta | `bodyMedium` secondary | 到期日期与二级信息 |
| editor title input | `displaySmall` override | 编辑页主输入标题 |
| field label/value | `titleMedium` / `bodyLarge` | 字段行清晰扫读 |
| primary save | `titleMedium` | 底部主 CTA |

### spacing_and_radius_mapping

- page_horizontal_padding: `24`
- home_top_padding: `28`
- priority_card_radius: `36`
- field_group_radius: `36`
- editor_save_radius: `24`
- queue_row_vertical_padding: `20`
- spacing_lock:
  - 主问候区与主卡片之间的呼吸感不得明显压缩
  - 主卡片标题、说明、底部元信息三段间距保持清楚层级
  - 编辑页标题输入区和字段组之间至少保留一个清晰分组空隙

## 6. module_token_overlay

- `TaskFlowPriorityCardTone.background`: alias -> `surface_roles.surface`
- `TaskFlowPriorityCardTone.warmOverlay`: scoped local token，用于首页主事项暖感渐变
- `TaskFlowUrgencyTone.overdue`: alias -> `status_roles.error`
- `TaskFlowFieldTone.trailingValue`: alias -> `color_roles.primary`
- `TaskFlowSaveTone.background`: alias -> `color_roles.primary`

说明：
- 模块 token 只允许做业务语义别名，不覆盖共享主题命名。
- `task-flow` 可定义“主事项卡片”“逾期行”“编辑保存”语义，但不能改写 app-shell 的公共组件角色。

## 7. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 主事项卡片暖感与轻纸感 | `native_flutter` | `none` | 可用渐变、阴影与轻高光稳定复现 |
| 任务行状态图标 | `native_flutter` | `none` | 系统线性图标即可满足质量要求 |
| 编辑页字段组 | `native_flutter` | `none` | 原生容器与分组分隔足够忠实 |
| 编辑页主保存按钮 | `native_flutter` | `none` | 纯色高对比按钮不需要位图 |
| 复杂品牌纹理 / 插画 | `not_needed` | `none` | 当前冻结方向不依赖额外视觉资产 |

## 8. component_decomposition

### domain_and_application_owned_business_widgets

- `PriorityTaskCard`
  - 只消费主事项展示模型
- `UrgentTaskQueueSection`
  - 只消费次级事项列表展示模型
- `UrgentTaskRow`
  - 负责单行事项、状态、到期元信息与点击入口
- `TaskEditorTitleField`
  - 承接标题编辑与长标题换行
- `TaskEditorFieldGroup`
  - 承接日期 / 时间 / 分类 / 隐私等结构化字段
- `TaskEditorPrimarySaveBar`
  - 承接唯一主保存动作

### page_sections

- `TaskFlowHomePage`
  - 挂载在 `app-shell` 的 Home branch 下
- `TaskEditorPage`
  - 独立详情 / 编辑路由页

### state_and_feedback_zones

- `TaskFeedStateZone`
  - 加载、空态、错误、降级反馈边界
- `TaskEditorStateZone`
  - 保存中、字段校验、只读 / 禁用、恢复中边界

## 9. screen_architecture

### route_topology

- shell branch root: `RoutePaths.home`
- editor child route: `task editor detail route under home branch`
- route_entry_rules:
  - 首页继续通过 `app-shell` 的 Home branch 进入
  - 点击主事项卡片或事项行进入编辑 / 详情主链路
  - 快速添加由壳层 FAB 触发，后续接入 task editor 新建态

### page_scaffold_plan

- `TaskFlowHomePage`
  - 不自建底栏或全局 FAB
  - 只负责首页内容滚动区
- `TaskEditorPage`
  - 独立 `Scaffold` 或壳层内子页面承载
  - 顶部返回 / 保存 + 单主轴表单内容

### structure_notes

- 首页采用 `CustomScrollView + SliverList` 优先，主卡片为顶部非列表主块
- 编辑页采用单列纵向表单滚动
- 真实空态、错误态和降级态都只能替换内容区，不替换共享壳层

## 10. state_architecture

### shell_input_boundaries

- `task-flow` 只从 `app-shell` 接收导航上下文与全局快速添加触发入口
- `task-flow` 不拥有底栏状态与全局 feedback host

### business_state

- `TaskFeedSnapshot`
  - owner: `task-flow application`
  - source: 应用层用例聚合后的首页展示快照
- `PriorityTaskSelection`
  - owner: `task-flow application`
  - source: 从 `active` 事项中按规则派生出的主事项
- `TaskEditorDraft`
  - owner: `task-flow presentation/application`
  - source: 当前编辑态草稿
- `TaskMutationStatus`
  - owner: `task-flow application`
  - source: 创建、更新、完成、删除、恢复等用例执行结果

### cross_feature_boundaries

- 输出给 `history-center`：任务日志与状态变更结果
- 输出给 `widget-bridge`：稳定任务快照源
- 输出给 `app-shell`：首页主事项与次级事项展示模型，不输出数据库类型

### non_happy_state_coverage

- `first_use_empty`: 首页无任务时保留主说明与快速添加路径
- `no_urgent_tasks`: 仅剩普通任务时列表弱化但主事项仍清楚
- `notification_permission_denied`: 只表现为降级反馈，不阻断编辑
- `private_safe`: 首页主事项与列表显示安全占位，详情页才进入受控可见范围
- `restore_after_delete`: 恢复后沿用原 ID 并刷新首页 / 历史快照

## 11. scroll_and_motion_architecture

- `home_scroll_decision`: `CustomScrollView`
- `queue_list_decision`: `SliverList`
- `editor_scroll_decision`: `SingleChildScrollView`
- `sticky_decision`:
  - 首页依附 app-shell 的固定底栏与固定 FAB
  - 编辑页底部保存可固定或跟随内容，但主 CTA 必须稳定可见
- `motion_posture`:
  - 主事项与列表切换保持克制
  - 完成 / 删除 / 恢复动作只允许轻量状态反馈
  - 编辑保存不使用夸张成功动效

## 12. display_layer_decision_table

| region_id | visual_priority | scroll_decision | list_decision | layout_decision | sticky_decision | layout_anchor | spacing_lock_rule | text_overflow_rule | responsive_break_rule | z_axis_rule | animation_source_of_truth | pixel_tolerance | asset_decision | must_use_asset | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `home_greeting_header` | `high` | `CustomScrollView` | `not-a-list` | `Column` | `no sticky behavior` | 首页顶部安全区与主卡片前的固定呼吸区 | 标题与 chip 间距锁定 | wrap | 不允许压缩成单行小标题 | 内容层最低前景层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `flutterize` |
| `home_priority_card` | `fidelity_critical` | `CustomScrollView` | `not-a-list` | `Column + layered decoration` | `no sticky behavior` | 问候区之后首个主块 | 标题、说明、底部元信息三段间距锁定 | wrap，最多 3 行 | 不允许缩成普通列表样式 | 高于背景与列表 | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `home_urgent_queue` | `fidelity_critical` | `CustomScrollView` | `SliverList` | `sliver composition` | `no sticky behavior` | 主卡片之后 | 分区标题与首行列表间距锁定 | 行标题最多 2 行 | 不允许改成网格或卡片堆叠 | 与主内容同层 | explicit no-motion | `tight` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `editor_title_surface` | `fidelity_critical` | `SingleChildScrollView` | `not-a-list` | `Column` | `no sticky behavior` | 顶部工具栏之后首个主输入区 | 标题输入区上下留白锁定 | wrap | 长标题只允许自然换行 | 高于后续字段组 | preview evidence only | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `editor_field_groups` | `high` | `SingleChildScrollView` | `Column` | `grouped container` | `no sticky behavior` | 标题输入区之后 | 每组边距与组内行高锁定 | value wrap, label no-wrap preferred | 可拉高但不改顺序 | 内容层同级 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `flutterize` |
| `editor_notes_region` | `normal` | `SingleChildScrollView` | `not-a-list` | `container` | `no sticky behavior` | 字段组之后 | 与保存按钮保留清晰距离 | wrap | 可加高，不可上提抢层级 | 内容层同级 | explicit no-motion | `moderate` | `native_flutter` | `none` | `no` | `flutterize` |
| `editor_primary_save` | `fidelity_critical` | `SingleChildScrollView` | `not-a-list` | `bottom action bar` | `fixed footer or anchored bottom action` | 页面底部主动作位 | 与表单内容间距锁定 | clip disallowed | 允许在小高度下随滚动贴底，但保持唯一主 CTA | 高于普通内容层 | frozen motion intent | `strict` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |

## 13. non_native_visual_fallbacks

- `none`

说明：
- 当前 `task-flow` 模块没有必须依赖位图的品牌插画或复杂材质。
- 如后续需要真实贴图或插画辅助，只能在设计源控制确认后再引入。

## 14. design_implementation_guardrails

- 层级护栏：首页第一眼必须先读到主事项标题，再读到其到期信息与继续动作，最后再看队列。
- 间距护栏：通过留白和分组建立层级，不靠额外卡片数量堆叠。
- 字体护栏：主事项标题和编辑页标题输入必须维持大字号与稳定阅读节奏。
- 对比护栏：逾期语义清楚但不能盖过主事项卡片与主保存动作。
- 反馈护栏：成功、删除、恢复、权限失败都走轻反馈，不改页面骨架。
- 反模板护栏：首页不能演化为任务管理后台，编辑页不能演化为设置中心。
- premium 护栏：保留温和、可信、低噪音的高保真工具感，不为省实现成本压平关键层级。

## 15. fidelity_vs_flutterization

### preserve_faithfully

- `home_priority_card`
- `home_urgent_queue`
- `editor_title_surface`
- `editor_primary_save`

### flutterize

- `home_greeting_header`
- `editor_field_groups`
- `editor_notes_region`

### simplify

- `none`

## 16. implementation_boundaries

- `task-flow` 拥有事项真源、排序、状态流转、日志写入和首页展示快照组装。
- 页面层只负责展示和输入，不得直接改库或直接推导三态状态。
- 所有关键状态变化必须通过应用层用例统一编排。
- `task-flow` 输出稳定 ViewModel 给 `app-shell`、`history-center` 与 `widget-bridge`，不把数据层类型上抛。
- 后续若要改动主事项卡片层级、队列结构或编辑页主保存路径，必须回到设计控制链。

## 17. flutter_init_inputs

- project_root: `D:/Projects/Flutter/screen_note`
- current_gap: `task-flow` 仍缺少真正的数据真源、应用层用例、表单状态与页面实现
- required_scaffold:
  - `lib/features/task_flow/domain/entities/`
  - `lib/features/task_flow/domain/repositories/`
  - `lib/features/task_flow/application/use_cases/`
  - `lib/features/task_flow/application/providers/`
  - `lib/features/task_flow/infrastructure/`
  - `lib/features/task_flow/presentation/pages/`
  - `lib/features/task_flow/presentation/widgets/`
- bootstrap_critical_inputs:
  - 已存在共享主题、路由壳层、ProviderScope、最小本地存储基线
  - 后续需在既有 bootstrap 之上补齐 `drift` 数据库、任务仓储与首页只读快照装配

## 18. risks_and_open_questions

- 风险：若首页主事项选取逻辑直接塞进页面层，会破坏“页面只负责展示”的约束。
- 风险：若编辑页先做表单外观、后补业务草稿状态，容易出现真实保存链路和 UI 结构脱节。
- 风险：`history-center` 与 `widget-bridge` 都依赖 `task-flow` 的稳定输出，如果当前模块的实体与快照边界不清，会把后续模块全部拖乱。
- 开放问题：当前编辑页是否直接承接“创建”和“编辑”双模态，可在 `@superpowers Spec` 阶段明确，但不阻塞当前架构输出。
