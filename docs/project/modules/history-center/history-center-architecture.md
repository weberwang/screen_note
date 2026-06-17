# History Center Architecture

## 1. input_summary

- active_module: `history-center`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开设计决策的前提下，把已冻结的 `history-center` 设计源翻译成 Flutter 可直接消费的历史分区架构、恢复动作边界和显示决策。
- architecture_scope:
  - 最近完成分区
  - 最近删除分区
  - 恢复动作
  - 空历史与加载 / 错误表达
- out_of_scope:
  - 任务真源本身
  - 设置偏好页
  - 小组件桥接
  - 通知调度

## 2. consumed_design_artifacts

- [history-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center.impl.md)
- [history-center-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-design-source-packet.md)
- [history-center-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-freeze-decision.md)
- [history-center-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-prototype-playback.md)
- [history-center-history.png](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-history.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. display_evidence_pack

- main_preview:
  - path: `docs/project/modules/history-center/history-center-history.png`
  - coverage: 整页分区层级、恢复动作位置、共享底栏与全局快速添加
- structure_preview:
  - path: `docs/project/modules/history-center/prototype/index.html`
  - coverage: 最近完成 / 最近删除分区顺序、行结构与恢复动作
- semantics_playback:
  - path: `docs/project/modules/history-center/history-center-prototype-playback.md`
  - coverage: 分区逻辑、恢复动作、空历史态与信任恢复目标
- state_matrix_source:
  - path: `docs/project/modules/history-center/history-center-design-source-packet.md`
  - coverage: `ideal / recently_completed / recently_deleted / empty / restore_success / loading / error`
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前页面结构以分区列表和恢复动作语义为主，现有整页效果图、原型和状态矩阵足以支撑实现边界拆解。

## 4. high_fidelity_display_contract

### fidelity_critical_regions

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `history_title` | `preserve_faithfully` | `history-center-history.png` | 页面标题必须清楚、克制、直接表达“历史” | 原生排版实现即可 |
| `completed_section_header` | `preserve_faithfully` | `history-center-history.png`, `prototype/index.html` | 绿色完成语义清楚但不喧宾夺主 | 用轻条带 + 图标实现 |
| `deleted_section_header` | `preserve_faithfully` | `history-center-history.png`, `prototype/index.html` | 恢复分区要清楚可辨，语义上比完成分区更可操作 | 用橙红轻条带实现 |
| `history_row_structure` | `preserve_faithfully` | `history-center-history.png` | 行式结构、标题、时间元信息、右侧动作位 | 统一列表模型实现 |
| `restore_action` | `flutterize` | `history-center-history.png`, `prototype/index.html` | 恢复按钮清楚但克制 | Flutter 原生描边按钮即可 |

## 5. theme_token_mapping

### global_theme_roles_to_flutter

| design_role | frozen_value | Flutter mapping | note |
| --- | --- | --- | --- |
| `surface_roles.background` | `#FBFAF7` | `ColorScheme.surface` | 历史页暖白背景 |
| `color_roles.primary` | `#4D8B52` | `ColorScheme.primary` | 完成态与恢复动作主色 |
| `status_roles.error` | `#E96A5A` | `ColorScheme.error` | 已删除分区语义色 |
| `text_roles.text_primary` | `#1F2328` | `ColorScheme.onSurface` | 标题与主文案 |
| `text_roles.text_secondary` | `#5F6762` | `AppText.secondary` | 时间与二级说明 |
| `border_roles.divider` | `#E4E8E0` | `DividerTheme.color` | 列表分隔 |

## 6. module_token_overlay

- `HistoryCompletedTone.header`: alias -> `color_roles.primary`
- `HistoryDeletedTone.header`: alias -> `status_roles.error`
- `HistoryRestoreTone.action`: alias -> `color_roles.primary`

## 7. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 分区条带 | `native_flutter` | `none` | 原生浅底与边界足够 |
| 列表图标 | `native_flutter` | `none` | 系统线性图标即可 |
| 恢复按钮 | `native_flutter` | `none` | 原生描边按钮足够 |

## 8. component_decomposition

- `HistoryCenterPage`
- `HistorySectionHeader`
- `HistoryRow`
- `RestoreTaskButton`
- `HistoryEmptyStatePanel`

## 9. screen_architecture

### route_topology

- shell branch root: `RoutePaths.history`
- route_entry_rules:
  - 历史中心通过共享壳层 History branch 进入
  - 当前模块不新增二级详情路由
  - 恢复动作留在当前页内完成

### page_scaffold_plan

- `HistoryCenterPage`
  - 只负责内容滚动区
  - 不自建底栏或全局 FAB

## 10. state_architecture

- `completedHistorySnapshot`
- `deletedHistorySnapshot`
- `restoreTaskMutationStatus`
- `historyEmptyState`

### cross_feature_boundaries

- 输入：`task-flow` 的任务状态与操作日志
- 输出：恢复结果反馈给共享壳层或任务真源刷新链路

## 11. scroll_and_motion_architecture

- `history_scroll_decision`: `CustomScrollView`
- `section_list_decision`: `SliverList`
- `sticky_decision`: `shared shell footer only`
- `motion_posture`: 恢复成功只做轻反馈，不做夸张动效

## 12. display_layer_decision_table

| region_id | visual_priority | scroll_decision | list_decision | layout_decision | sticky_decision | layout_anchor | spacing_lock_rule | text_overflow_rule | responsive_break_rule | z_axis_rule | animation_source_of_truth | pixel_tolerance | asset_decision | must_use_asset | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `history_title` | `high` | `CustomScrollView` | `not-a-list` | `Column` | `no sticky behavior` | 页面顶部安全区 | 标题到首分区间距锁定 | wrap | 不压缩成小标题 | 内容层顶层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `completed_section` | `fidelity_critical` | `CustomScrollView` | `SliverList` | `sliver composition` | `no sticky behavior` | 历史标题之后 | 分区头与首行间距锁定 | 行标题最多 2 行 | 不改成卡片网格 | 内容层同级 | explicit no-motion | `tight` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `deleted_section` | `fidelity_critical` | `CustomScrollView` | `SliverList` | `sliver composition` | `no sticky behavior` | 完成分区之后 | 分区头与首行间距锁定 | 行标题最多 2 行 | 不改成仪表盘或统计块 | 内容层同级 | explicit no-motion | `tight` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `restore_action` | `high` | `CustomScrollView` | `not-a-list` | `row trailing action` | `no sticky behavior` | 已删除行右侧动作位 | 恢复按钮与标题信息保持明确分离 | label wrap disallowed | 小宽度下可缩短按钮宽度，但不隐藏动作 | 高于行背景 | preview evidence only | `moderate` | `native_flutter` | `none` | `no` | `flutterize` |

## 13. non_native_visual_fallbacks

- `none`

## 14. design_implementation_guardrails

- 历史中心的第一目标是恢复信任，不是展示分析能力。
- 最近删除分区必须比最近完成分区更清楚可操作。
- 不得把历史中心做成多卡片统计页。
- 恢复动作要清楚，但不能像营销按钮一样高噪音。

## 15. fidelity_vs_flutterization

### preserve_faithfully

- `history_title`
- `completed_section`
- `deleted_section`

### flutterize

- `restore_action`

### simplify

- `none`

## 16. implementation_boundaries

- `history-center` 不拥有任务真源，只消费 `task-flow` 的状态与日志。
- 恢复动作必须通过应用层用例统一编排，不允许页面直接改库。
- 最近完成保持只读，避免并发承担更多状态流转职责。

## 17. flutter_init_inputs

- project_root: `D:/Projects/Flutter/screen_note`
- current_gap: `history-center` 仍缺少真实 Provider、恢复用例和页面实现
- required_scaffold:
  - `lib/features/history_center/application/`
  - `lib/features/history_center/domain/`
  - `lib/features/history_center/infrastructure/`
  - `lib/features/history_center/presentation/pages/`

## 18. risks_and_open_questions

- 风险：若历史中心直接查 `task-flow` 数据表而不经过应用层快照，会把恢复语义和分区排序散落到页面。
- 风险：若恢复反馈做成重弹窗，会打断“信任恢复”的轻量节奏。
