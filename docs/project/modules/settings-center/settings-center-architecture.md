# Settings Center Architecture

## 1. input_summary

- active_module: `settings-center`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开设计决策的前提下，把已冻结的 `settings-center` 设计源翻译成 Flutter 可直接消费的偏好分区架构、系统能力降级表达与显示决策。
- architecture_scope:
  - 通知状态与权限降级
  - 隐私模式
  - Widget 展示模式
  - 同步状态
  - 会员入口
- out_of_scope:
  - 任务真源本身
  - 历史恢复列表
  - 真实会员支付流程
  - 云同步后端接入

## 2. consumed_design_artifacts

- [settings-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center.impl.md)
- [settings-center-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-design-source-packet.md)
- [settings-center-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-freeze-decision.md)
- [settings-center-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-prototype-playback.md)
- [settings-center-settings.png](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-settings.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. display_evidence_pack

- main_preview:
  - path: `docs/project/modules/settings-center/settings-center-settings.png`
  - coverage: 整页分区层级、权限降级提示、共享底栏与独立 quick add
- structure_preview:
  - path: `docs/project/modules/settings-center/prototype/index.html`
  - coverage: 分区顺序、行结构、降级提示与会员入口权重
- semantics_playback:
  - path: `docs/project/modules/settings-center/settings-center-prototype-playback.md`
  - coverage: 通知 / 隐私 / 展示模式 / 同步 / 会员的层级与交互边界
- state_matrix_source:
  - path: `docs/project/modules/settings-center/settings-center-design-source-packet.md`
  - coverage: `ideal / notification_permission_denied / private_safe / widget_display_mode / sync_not_enabled / membership_secondary / loading / error`
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前页面结构以分区列表和降级表达为主，现有效果图、原型和状态矩阵足以支撑实现边界拆解。

## 4. high_fidelity_display_contract

### fidelity_critical_regions

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `settings_title` | `preserve_faithfully` | `settings-center-settings.png` | 页面标题必须清楚、克制、直接表达“设置” | 原生排版实现即可 |
| `notifications_group` | `preserve_faithfully` | `settings-center-settings.png`, `prototype/index.html` | 通知状态是第一主分区，权限降级必须清楚表达 | 用设置分组 + 内联降级块实现 |
| `degradation_notice_inline` | `preserve_faithfully` | `settings-center-settings.png`, `prototype/index.html` | 降级提示必须看得见，但不是强告警页 | 用浅橙提示块 + 轻动作实现 |
| `settings_row_structure` | `preserve_faithfully` | `settings-center-settings.png` | 行式结构、标题、说明、右侧当前值 | 统一设置行组件实现 |
| `membership_entry` | `flutterize` | `settings-center-settings.png`, `prototype/index.html` | 会员入口存在但次级 | Flutter 原生暖色表面即可 |

## 5. theme_token_mapping

### global_theme_roles_to_flutter

| design_role | frozen_value | Flutter mapping | note |
| --- | --- | --- | --- |
| `surface_roles.background` | `#FBFAF7` | `ColorScheme.surface` | 设置页暖白背景 |
| `color_roles.primary` | `#4D8B52` | `ColorScheme.primary` | 安全状态、正常值和主切换色 |
| `status_roles.error` | `#E96A5A` | `ColorScheme.error` | 权限降级语义色 |
| `text_roles.text_primary` | `#1F2328` | `ColorScheme.onSurface` | 标题与主文案 |
| `text_roles.text_secondary` | `#5F6762` | `AppText.secondary` | 二级说明与状态副文案 |
| `border_roles.divider` | `#E4E8E0` | `DividerTheme.color` | 分组与行分隔 |

## 6. module_token_overlay

- `SettingsSafeTone.value`: alias -> `color_roles.primary`
- `SettingsDegradationTone.notice`: alias -> `status_roles.error`
- `SettingsMembershipTone.surface`: alias -> `surface_roles.background`

## 7. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 分组表面 | `native_flutter` | `none` | 原生圆角、描边与浅阴影足够 |
| 行内图标 | `native_flutter` | `none` | 系统线性图标即可 |
| 降级提示块 | `native_flutter` | `none` | 原生浅底与描边足够 |
| 会员入口暖色表面 | `native_flutter` | `none` | 无需位图资产 |

## 8. component_decomposition

- `SettingsCenterPage`
- `SettingsSectionHeader`
- `SettingsRow`
- `SettingsDegradationNotice`
- `SettingsMembershipEntryCard`

## 9. screen_architecture

### route_topology

- shell branch root: `RoutePaths.settings`
- route_entry_rules:
  - 设置中心通过共享壳层 Settings branch 进入
  - 当前模块允许保留页内交互，不强制新增二级详情路由
  - 若后续权限说明或会员页需要展开，可再由实现计划决定是否加子路由

### page_scaffold_plan

- `SettingsCenterPage`
  - 只负责内容滚动区
  - 不自建底栏或全局 FAB

## 10. state_architecture

- `notificationPermissionSnapshot`
- `privacyModePreference`
- `widgetDisplayModePreference`
- `syncStatusSnapshot`
- `membershipEntryState`

### cross_feature_boundaries

- 输入：本地偏好、系统通知权限状态、共享壳层反馈宿主
- 输出：隐私与展示模式偏好供 `widget-bridge` 消费

## 11. scroll_and_motion_architecture

- `settings_scroll_decision`: `CustomScrollView`
- `section_list_decision`: `SliverList`
- `sticky_decision`: `shared shell footer only`
- `motion_posture`: 设置切换与降级反馈只做轻反馈，不做夸张动效

## 12. display_layer_decision_table

| region_id | visual_priority | scroll_decision | list_decision | layout_decision | sticky_decision | layout_anchor | spacing_lock_rule | text_overflow_rule | responsive_break_rule | z_axis_rule | animation_source_of_truth | pixel_tolerance | asset_decision | must_use_asset | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `settings_title` | `high` | `CustomScrollView` | `not-a-list` | `Column` | `no sticky behavior` | 页面顶部安全区 | 标题到首分区间距锁定 | wrap | 不压缩成小标题 | 内容层顶层 | explicit no-motion | `tight` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `notifications_group` | `fidelity_critical` | `CustomScrollView` | `SliverList` | `sliver composition` | `no sticky behavior` | 页面首分区 | 分区头与降级提示保持稳定间距 | 行标题最多 2 行 | 不改成营销卡组 | 内容层同级 | explicit no-motion | `tight` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `degradation_notice_inline` | `high` | `CustomScrollView` | `not-a-list` | `inline card` | `no sticky behavior` | 通知分组内 | 降级提示与主状态行保持清晰分离 | 文案最多 3 行 | 小宽度下优先缩短动作宽度 | 高于普通分组底色 | preview evidence only | `moderate` | `native_flutter` | `none` | `no` | `preserve_faithfully` |
| `settings_groups` | `high` | `CustomScrollView` | `SliverList` | `stacked grouped rows` | `no sticky behavior` | 通知分组之后 | 分区间呼吸感锁定 | 行标题最多 2 行 | 不压成密集表格 | 内容层同级 | explicit no-motion | `tight` | `native_flutter` | `none` | `yes` | `preserve_faithfully` |
| `membership_entry` | `medium` | `CustomScrollView` | `not-a-list` | `secondary grouped entry` | `no sticky behavior` | 页面末段 | 必须弱于上游系统能力分组 | 文案最多 3 行 | 小宽度下可弱化副文案 | 低于主系统能力层级 | preview evidence only | `moderate` | `native_flutter` | `none` | `no` | `flutterize` |

## 13. non_native_visual_fallbacks

- `none`

## 14. design_implementation_guardrails

- 设置页第一目标是表达系统能力边界与偏好安全，不是销售或分析。
- 通知状态与权限降级必须比会员入口更清楚可见。
- Widget 展示模式不能绕过隐私规则。
- 不得把设置页做成营销页或多卡片功能广场。

## 15. fidelity_vs_flutterization

### preserve_faithfully

- `settings_title`
- `notifications_group`
- `degradation_notice_inline`
- `settings_groups`

### flutterize

- `membership_entry`

### simplify

- `none`

## 16. implementation_boundaries

- `settings-center` 不拥有任务真源，只消费系统能力状态与本地偏好。
- 所有权限失败都按降级提示处理，不允许阻断设置页访问。
- Widget 展示模式和隐私模式的最终写入应走应用层统一编排。

## 17. flutter_init_inputs

- project_root: `D:/Projects/Flutter/screen_note`
- current_gap: `settings-center` 仍缺少真实偏好 Provider、系统权限快照与页面实现
- required_scaffold:
  - `lib/features/settings_center/application/`
  - `lib/features/settings_center/domain/`
  - `lib/features/settings_center/infrastructure/`
  - `lib/features/settings_center/presentation/pages/`

## 18. risks_and_open_questions

- 风险：若通知权限状态查询散落到页面，会把系统能力判断和降级逻辑分裂到显示层。
- 风险：若 Widget 展示模式不受隐私模式约束，后续 `widget-bridge` 可能泄露正文。
- 风险：若会员入口先于系统设置主链路展示，页面会偏离冻结层级。
