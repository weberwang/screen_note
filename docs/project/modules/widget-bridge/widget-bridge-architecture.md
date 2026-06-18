# Widget Bridge Architecture

## 1. input_summary

- active_module: `widget-bridge`
- workflow_stage_at_consumption: `module_design_frozen`
- target_platform_identifier: `ios_device`
- target_validation_surface: `iPhone real device`
- architecture_goal: 在不重开视觉方向的前提下，把 App 内安装引导页、稳定快照合同、共享存储写入与 iOS Widget 消费链路翻译成 Flutter / Swift 可直接落地的桥接实现。
- architecture_scope:
  - App 内安装与预览页
  - 稳定快照投影
  - 共享 JSON 合同
  - App Group 写入
  - Widget 刷新触发
  - 事项与设置变更后的自动同步
- out_of_scope:
  - Widget 深层导航矩阵
  - Android Glance 真实展示层
  - 复杂多事项列表 Widget

## 2. consumed_design_artifacts

- [widget-bridge.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge.impl.md)
- [widget-bridge-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-design-source-packet.md)
- [widget-bridge-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-freeze-decision.md)
- [widget-bridge-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-prototype-playback.md)
- [widget-bridge-install-guide.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-install-guide.png)
- [widget-bridge-priority-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-priority-widget.png)
- [widget-bridge-private-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-private-widget.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/prototype/index.html)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/project/01-global-technical-baseline.md)

## 3. display_evidence_pack

- install_guide_page:
  - path: `docs/project/modules/widget-bridge/widget-bridge-install-guide.png`
  - coverage: 页面标题、指标概览、Widget 预览卡、同步动作、添加到桌面动作、安装说明与隐私说明
- main_preview:
  - path: `docs/project/modules/widget-bridge/widget-bridge-priority-widget.png`
  - coverage: 主提醒态、低噪音头部、系统附属面板节奏
- privacy_preview:
  - path: `docs/project/modules/widget-bridge/widget-bridge-private-widget.png`
  - coverage: 私密遮罩态、安全回流语义
- structure_preview:
  - path: `docs/project/modules/widget-bridge/prototype/index.html`
  - coverage: 安装引导页与三种 Widget 状态的结构复演
- evidence_assessment:
  - result: `sufficient_for_architecture`
  - reason: 当前模块已同时具备页面级证据和 Widget 本体证据，足以支撑 Flutter 页面、共享合同与原生消费边界映射。

## 4. high_fidelity_display_contract

| region_id | classification | evidence_source | locked_details | implementation_note |
| --- | --- | --- | --- | --- |
| `install_page_header` | `preserve_faithfully` | `widget-bridge-install-guide.png`, `prototype/index.html` | 首屏必须先表达“预览 + 安装 + 同步” | Flutter 页面直接还原 |
| `install_page_preview_card` | `preserve_faithfully` | `widget-bridge-install-guide.png`, `prototype/index.html` | 预览卡是页面视觉中心，优先级高于说明文案 | 复用快照展示模型 |
| `install_page_action_card` | `preserve_faithfully` | `widget-bridge-install-guide.png`, `prototype/index.html` | `Sync Now / Add to Home Screen` 是主动作 | 动作调用应用层用例 |
| `install_page_info_cards` | `flutterize` | `widget-bridge-install-guide.png` | 安装说明与隐私说明只做次级辅助 | 保持轻量卡片排版 |
| `widget_header` | `preserve_faithfully` | `widget-bridge-priority-widget.png` | 头部低噪音、系统附属感 | SwiftUI 文本即可 |
| `priority_item` | `preserve_faithfully` | `widget-bridge-priority-widget.png`, `prototype/index.html` | 只展示一条最高优先级事项 | Flutter 投影后 SwiftUI 直接消费 |
| `safe_preview_item` | `preserve_faithfully` | `widget-bridge-private-widget.png`, `prototype/index.html` | 遮罩正文，保留安全回流语义 | 由投影器统一决定遮罩 |
| `fallback_hint` | `flutterize` | `widget-bridge-design-source-packet.md` | 只表达“最近一次有效快照”降级 | 作为可选文案展示 |

## 5. theme_token_mapping

| design_role | frozen_value | implementation_mapping | note |
| --- | --- | --- | --- |
| `surface` | `#FBFAF7 / #FFFFFF` | Flutter 卡片底色 + SwiftUI `.containerBackground` | 页面与 Widget 共用暖白基底 |
| `primary` | `#4D8B52` | 主按钮、正向状态、回流提示 | 用于同步与隐私安全语义 |
| `warning` | `#F08A32` | 今日/紧急状态标签 | 用于 `Today` 状态 |
| `outline` | `#E4E8E0` | 原生描边与轻分隔 | 保持低噪音结构感 |

## 6. asset_strategy

| visual_element | decision | path | reason |
| --- | --- | --- | --- |
| 安装引导页 | `native_flutter` | `none` | 结构清晰，适合直接由 Flutter 还原 |
| Widget 表面 | `native_swiftui` | `none` | 系统附属组件更适合原生实现 |
| 状态文本与标题 | `native_flutter + native_swiftui` | `none` | Flutter 负责投影文本，SwiftUI 负责消费 |
| JSON 快照 | `shared_contract` | `screen_note.widget_snapshot.current` | 这是模块核心资产 |

## 7. component_decomposition

- `WidgetBridgePage`
- `WidgetBridgeController`
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
- `pin_widget_request_result`

### cross_feature_boundaries

- 输入：`task-flow` 稳定快照、`settings-center` 偏好
- 输出：App Group 中的稳定 JSON 合同，供 iOS Widget 只读消费
- 页面动作：同步与请求添加小组件都由 `widget-bridge` 页面触发，但底层能力依然通过应用层统一编排

## 9. display_layer_decision_table

| region_id | layout_decision | text_overflow_rule | asset_decision | must_not_flutterize | fidelity_class |
| --- | --- | --- | --- | --- | --- |
| `install_page_header` | 顶部标题 + 短说明 | 说明最多 2 行 | `native_flutter` | `no` | `preserve_faithfully` |
| `install_page_preview_card` | 页面主卡 | 标题最多 2 行 | `shared_json_contract` | `no` | `preserve_faithfully` |
| `install_page_action_card` | 纵向双动作卡 | 按钮单行 | `native_flutter` | `no` | `preserve_faithfully` |
| `install_page_info_cards` | 次级说明卡 | 正文最多 3 行 | `native_flutter` | `no` | `flutterize` |
| `widget_header` | 单行轻头部 | 截断 | `native_swiftui` | `no` | `preserve_faithfully` |
| `priority_item` | 单条卡片化条目 | 标题最多 2 行 | `shared_json_contract` | `yes` | `preserve_faithfully` |
| `safe_preview_item` | 单条遮罩条目 | 文案最多 2 行 | `shared_json_contract` | `yes` | `preserve_faithfully` |
| `empty_state` | 文本空态 | 正文最多 2 行 | `shared_json_contract` | `no` | `flutterize` |

## 10. implementation_boundaries

- Flutter 侧负责生成与写入共享快照，并实现 App 内安装与预览页，不直接驱动 Widget UI 状态机。
- Swift 侧只读取 JSON 并按固定结构渲染，不重新查询数据库，不重新排序。
- 事项创建、状态变更与设置变更都通过副作用端口触发自动同步，失败只降级不阻断主链路。
- `settings-center` 只负责把用户带到 `widget-bridge`，不重复持有页面级视觉结构。
- App Group 标识以当前 iOS 原生工程中的 `group.com.example.screenNote.shared` 为准。

## 11. risks_and_open_questions

- 风险：若后续把 Widget 扩展成多事项列表，当前单条快照合同需要升级。
- 风险：若点击回流需要定位到更细粒度页面，当前“安全回到 App”的最小合同需要扩展。
- 风险：Android 真实 Widget 仍未实现消费层，目前模块完成度以 Flutter 投影与 iOS 消费链路为主。
