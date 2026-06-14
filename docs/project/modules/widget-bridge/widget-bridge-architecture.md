# Widget Bridge Architecture

## 1. input_summary

- active_module: `widget-bridge`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开视觉方向的前提下，把稳定快照合同、共享存储写入与 iOS Widget 消费链路翻译成 Flutter / Swift 可直接落地的桥接实现。
- architecture_scope:
  - 稳定快照投影
  - 共享 JSON 合同
  - App Group 写入
  - Widget 刷新触发
  - 事项与设置变更后的自动同步
- out_of_scope:
  - Widget 深层导航矩阵
  - Android Glance 真正展示层
  - 复杂多事项列表 Widget

## 2. consumed_design_artifacts

- [widget-bridge.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge.impl.md)
- [widget-bridge-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-design-source-packet.md)
- [widget-bridge-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-freeze-decision.md)
- [widget-bridge-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-prototype-playback.md)
- [widget-bridge-priority-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-priority-widget.png)
- [widget-bridge-private-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-private-widget.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)

## 3. display_evidence_pack

- main_preview:
  - path: `docs/project/modules/widget-bridge/widget-bridge-priority-widget.png`
  - coverage: 主提醒态、低噪音头部、系统附属面板节奏
- privacy_preview:
  - path: `docs/project/modules/widget-bridge/widget-bridge-private-widget.png`
  - coverage: 私密遮罩态、安全回流语义
- structure_preview:
  - path: `docs/project/modules/widget-bridge/prototype/index.html`
  - coverage: 三种状态的结构复演
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前模块不是完整 App 页面，现有效果图 + HTML 原型足以支撑合同、存储与原生消费边界映射。

## 4. high_fidelity_display_contract

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `widget_header` | `preserve_faithfully` | `widget-bridge-priority-widget.png` | 头部低噪音、系统附属感 | SwiftUI 文本即可 |
| `priority_item` | `preserve_faithfully` | `widget-bridge-priority-widget.png`, `prototype/index.html` | 只展示一条最高优先级事项 | Flutter 投影后 SwiftUI 直接消费 |
| `safe_preview_item` | `preserve_faithfully` | `widget-bridge-private-widget.png`, `prototype/index.html` | 遮罩正文，保留安全回流语义 | 由投影器统一决定遮罩 |
| `fallback_hint` | `flutterize` | `widget-bridge-design-source-packet.md` | 只表达“最近一次有效快照”降级 | 作为可选文案展示 |

## 5. theme_token_mapping

| design_role | frozen_value | implementation_mapping | note |
| --- | --- | --- | --- |
| `surface` | `#FBFAF7 / #FFFFFF` | SwiftUI `.containerBackground` + Flutter JSON contract | Widget 表面轻暖白 |
| `primary` | `#4D8B52` | 状态与安全提示强调色 | 用于安全回流与轻量正向语义 |
| `warning` | `#F08A32` | 今日/紧急标签语义色 | 用于 `Today` 状态 |
| `outline` | `#E4E8E0` | 原生描边与轻分隔 | 维持系统附属面板清晰度 |

## 6. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| Widget 表面 | `native_swiftui` | `none` | 系统附属组件更适合原生实现 |
| 状态文本与标题 | `native_flutter + native_swiftui` | `none` | Flutter 负责投影文本，Swift 负责消费 |
| JSON 快照 | `shared_contract` | `screen_note.widget_snapshot.current` | 这是模块核心资产 |

## 7. component_decomposition

- `WidgetSnapshot`
- `WidgetSnapshotItem`
- `WidgetSnapshotProjector`
- `WidgetSnapshotSyncService`
- `WidgetSnapshotAutoSyncCoordinator`
- `WidgetSnapshotTaskFlowSideEffectPort`
- `WidgetSnapshotSettingsSideEffectPort`
- `HomeWidgetSnapshotStore`
- `WidgetSnapshotLoader.swift`
- `WidgetEntryView.swift`

## 8. state_architecture

- `task_feed_snapshot`
- `settings_center_preferences`
- `widget_snapshot_json`
- `last_valid_widget_snapshot_json`

### cross_feature_boundaries

- 输入：`task-flow` 稳定快照、`settings-center` 偏好
- 输出：App Group 中的稳定 JSON 合同，供 iOS Widget 仅读取消费

## 9. display_layer_decision_table

| region_id | layout_decision | text_overflow_rule | asset_decision | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- |
| `widget_header` | 单行轻头部 | 截断 | `native_swiftui` | `no` | `preserve_faithfully` |
| `priority_item` | 单条卡片化条目 | 标题最多 2 行 | `shared_json_contract` | `yes` | `preserve_faithfully` |
| `safe_preview_item` | 单条遮罩条目 | 文案最多 2 行 | `shared_json_contract` | `yes` | `preserve_faithfully` |
| `empty_state` | 文本空态 | 正文最多 2 行 | `shared_json_contract` | `no` | `flutterize` |

## 10. implementation_boundaries

- Flutter 侧负责生成与写入共享快照，不直接驱动 Widget UI 状态机。
- Swift 侧只读取 JSON 并按固定结构渲染，不重新查询数据库、不重新排序。
- 事项创建/状态变更与设置变更都通过副作用端口触发自动同步，失败只降级不阻断主链路。
- App Group 标识以当前 iOS 原生工程中的 `group.com.example.screenNote.shared` 为准。

## 11. risks_and_open_questions

- 风险：若后续把 Widget 扩展成多事项列表，当前单条快照合同需要升级。
- 风险：若点击回流需要定位到更细粒度页面，当前安全回到 App 的最小合同需要扩展。
- 风险：Android 真实 Widget 还未实现消费层，目前模块完成度以 Flutter 投影与 iOS 消费链路为主。
