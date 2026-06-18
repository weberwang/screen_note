# Widget Bridge Design Source Packet

## 1. Scope

本包只覆盖 `widget-bridge`：

- App 内安装与预览页
- Widget 共享快照结构
- `fullContent` 主提醒态
- `previewOnly` 安全预览态
- `private-safe` 私密遮罩态
- 空态与回退提示

本包不覆盖：

- 首页完整任务队列
- `settings-center` 设置分区主体
- Widget 点击后的深链二级路由

## 2. Consumed Sources

- [DESIGN.md](D:/Projects/Flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [widget-bridge.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge.impl.md)
- [widget-bridge-install-guide.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-install-guide.png)
- [widget-bridge-priority-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-priority-widget.png)
- [widget-bridge-private-widget.png](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-private-widget.png)
- [widget-bridge-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-prototype-playback.md)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/widget-bridge/prototype/index.html)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. Structure Semantics

- `page_surface_model`: `single helper page with preview + actions + privacy notes`
- `widget_surface_model`: `single accessory widget surface`
- `content_model`: `single priority item or safe placeholder`
- `interaction_model`: `manual sync / request pin / tap-to-open-app`
- `state_model`: `install_guide / fullContent / previewOnly / private-safe / empty / fallback`
- `data_model`: `stable snapshot only`

## 4. State Matrix

- `install_guide`: App 内页面展示当前稳定快照、手动同步动作、添加到桌面动作与安装说明。
- `fullContent`: Widget 只展示一条最高优先级事项，允许显示真实标题。
- `previewOnly`: Widget 不展示正文，只展示安全预览与回流提示。
- `private_safe`: 私密事项无条件遮罩，不受展示模式放宽。
- `empty`: 无可投影事项时给出平静空态，不制造故障感。
- `fallback`: 原生层回退到最近一次有效快照时，继续展示轻量降级提示。

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `install_page_header`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-install-guide.png`, `prototype/index.html`
  - locked_details: 标题、短说明与首屏任务必须直接表达“预览 + 安装 + 同步”，不能退化成说明文档。
- `install_page_preview_card`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-install-guide.png`, `prototype/index.html`
  - locked_details: 预览卡是页面视觉中心，必须先于说明文案被看见。
- `install_page_action_card`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-install-guide.png`, `prototype/index.html`
  - locked_details: “Sync Now / Add to Home Screen” 作为主动作存在，说明文案只能做辅助。
- `widget_header`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-priority-widget.png`, `prototype/index.html`
  - locked_details: 头部必须低噪音，只表达模式与系统附属面板身份。
- `priority_item`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-priority-widget.png`, `prototype/index.html`
  - locked_details: 只保留一条主提醒，不退化成列表。
- `safe_preview_item`
  - classification: `preserve_faithfully`
  - evidence: `widget-bridge-private-widget.png`, `prototype/index.html`
  - locked_details: 必须明确隐藏正文，同时保留安全回流语义。
- `fallback_hint`
  - classification: `flutterize`
  - evidence: `widget-bridge-install-guide.png`, `widget-bridge.impl.md`
  - locked_details: 只做降级说明，不制造错误告警感。

### Allowed Simplifications

- App 内页面的分组表面与阴影可用 Flutter 原生圆角卡片与轻边框近似。
- Widget 表面可用系统原生浅底、圆角和轻描边近似。
- 不要求额外位图纹理资产，优先保留文本层级与轻量图标。

## 6. Component Freeze

- `widget_bridge_page`
  - states: `install_guide`, `loading`, `error`
  - immutable: 首屏标题、指标概览、预览卡、同步动作、安装说明、隐私说明
- `widget_snapshot_surface`
  - states: `fullContent`, `previewOnly`, `private-safe`, `empty`
  - immutable: 单表面、单主事项、低噪音头部
- `widget_snapshot_item`
  - states: `readable`, `masked`
  - immutable: 标题、状态、到期信息或安全提示三段式结构
- `widget_fallback_hint`
  - states: `hidden`, `visible`
  - immutable: 只表达“最近一次有效快照”的降级语义

## 7. Implementation-Facing Notes

- Flutter 侧负责生成稳定 JSON 快照，并承载 App 内安装与预览页；Swift 侧只消费快照，不重新推导业务状态。
- `previewOnly` 与 `private-safe` 都必须避免正文泄露。
- `settings-center` 只负责把用户带到 `widget-bridge`，不再重复持有这张页面级效果图。
- 点击回流当前收敛为安全回到 App 查看，不在 Widget 内承接复杂动作。
- 原生读取顺序必须优先当前快照，失败时回退最后一次有效快照。
