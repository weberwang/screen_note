# Settings Center Design Source Packet

## 1. Scope

本包只覆盖 `settings-center`：

- 通知与权限状态分区
- 隐私模式分区
- Widget 展示模式分区
- 同步状态分区
- 会员入口分区
- 通往 `widget-bridge` 的安装入口行

本包不覆盖：

- `task-flow` 首页主事项与编辑页
- `history-center` 的恢复列表
- `widget-bridge` 的页面级安装引导页
- `widget-bridge` 的 Widget 本体视觉

## 2. Consumed Sources

- [DESIGN.md](D:/Projects/Flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [settings-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center.impl.md)
- [settings-center-settings.png](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-settings.png)
- [settings-center-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-prototype-playback.md)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/prototype/index.html)
- [widget-bridge-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-design-source-packet.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. Structure Semantics

- `settings_scroll_model`: `single-page grouped list`
- `section_model`: `notifications -> privacy -> display -> sync -> membership`
- `list_model`: `grouped list rows with inline degradation support`
- `interaction_model`: `permission review, privacy toggle, display mode update, widget install entry, sync status review`
- `overlay_model`: `shared quick-add owned by app-shell`
- `component_repeatability`: `section_header`, `settings_row`, `degradation_notice_inline`, `membership_entry`

## 4. State Matrix

- `ideal`: 所有设置分区都存在，通知可用、隐私清晰、展示模式明确、同步状态显示为 `Synced`、会员入口显示为 `Active`。
- `notification_permission_denied`: 通知状态显示为降级，但不阻断设置页访问。
- `private_safe`: 隐私模式开启，锁屏与 Widget 预览继续安全。
- `widget_display_mode`: 可展示不同 Widget 可见策略，但不能绕开隐私规则。
- `widget_install_entry`: 入口行只负责把用户带到 `widget-bridge`，不在设置页内展开完整安装说明。
- `sync_synced`: 同步入口保留，但当前展示值按冻结截图呈现为 `Synced`。
- `membership_active_secondary`: 会员入口存在且当前展示值为 `Active`，同时继续保持次级权重。
- `loading`: 分区骨架稳定，不把设置页重排成另一套结构。
- `error`: 失败以轻量说明呈现，不演化成全屏错误页。

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `settings_title`
  - classification: `preserve_faithfully`
  - evidence: `settings-center-settings.png`, `prototype/index.html`
  - locked_details: 标题必须直接、稳重，不像营销页头图。
- `notifications_group`
  - classification: `preserve_faithfully`
  - evidence: `settings-center-settings.png`, `prototype/index.html`
  - locked_details: 通知状态和降级提示要被优先看见。
- `degradation_notice_inline`
  - classification: `preserve_faithfully`
  - evidence: `settings-center-settings.png`, `prototype/index.html`
  - locked_details: 降级提示低噪音但清晰，不演化成告警页。
- `settings_row_structure`
  - classification: `preserve_faithfully`
  - evidence: `settings-center-settings.png`, `prototype/index.html`
  - locked_details: 行式结构、标题、说明、右侧当前值和进入指示必须稳定。
- `widget_install_entry`
  - classification: `preserve_faithfully`
  - evidence: `settings-center-settings.png`, `prototype/index.html`, `widget-bridge-design-source-packet.md`
  - locked_details: 这里只承担入口归属，不承载页面级安装说明。
- `membership_entry`
  - classification: `flutterize`
  - evidence: `settings-center-settings.png`, `prototype/index.html`
  - locked_details: 存在但必须次级，不得比通知 / 隐私更重。

### Allowed Simplifications

- 分组表面与阴影可用 Flutter 原生圆角卡片与轻边框近似。
- 降级提示可用原生浅色背景和描边按钮实现，不依赖位图资产。
- 会员入口的轻暖色表面可弱化，不要求强纹理资产。

## 6. Component Freeze

- `settings_section_header`
  - states: `notifications`, `privacy`, `display`, `sync`, `membership`
  - immutable: 大写小节标签、低噪音分区结构
- `settings_row`
  - states: `normal`, `degraded`, `secondary-entry`
  - immutable: 左图标、中间说明、右值与进入箭头
- `degradation_notice_inline`
  - states: `warning`, `actionable`
  - immutable: 只表达能力降级，不表达灾难性失败
- `membership_entry`
  - states: `available`, `active`, `secondary`
  - immutable: 权重低于通知 / 隐私 / 展示模式

## 7. Implementation-Facing Notes

- `settings-center` 负责偏好读写与系统能力状态展示，不直接写任务真源。
- 所有权限失败都按降级提示处理，不允许阻断设置页主链路访问。
- Widget 展示模式必须受隐私模式约束，不能出现更宽松的泄露路径。
- “添加桌面小组件”在本模块里只是一条入口；完整页面设计和页面级效果图归 `widget-bridge` 所有。
- 本轮显示层还原中，`Sync / Membership` 的当前值以用户批准的冻结截图为准，分别显示为 `Synced / Active`。
