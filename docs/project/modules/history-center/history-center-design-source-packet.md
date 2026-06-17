# History Center Design Source Packet

## 1. Scope

本包只覆盖 `history-center`：

- 最近完成分区
- 最近删除分区
- 恢复动作区
- 空历史与恢复反馈结构

本包不覆盖：

- `task-flow` 首页主事项与编辑页
- `settings-center` 偏好展示
- `widget-bridge` 小组件快照视觉

## 2. Consumed Sources

- [DESIGN.md](D:/Projects/Flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [history-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center.impl.md)
- [history-center-history.png](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-history.png)
- [history-center-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/history-center-prototype-playback.md)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/history-center/prototype/index.html)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. Structure Semantics

- `history_scroll_model`: `single-page grouped list`
- `section_model`: `completed first, deleted second`
- `list_model`: `row-based grouped rows`
- `interaction_model`: `completed read-only, deleted rows restore-capable`
- `overlay_model`: `shared quick-add owned by app-shell`
- `component_repeatability`: `section_header`, `task_row`, `status_chip`, `restore_action`

## 4. State Matrix

- `ideal`: 最近完成与最近删除都存在，用户可快速扫读并在已删除分区恢复
- `recently_completed`: 完成事项只读展示，强调时间线索
- `recently_deleted`: 已删除事项提供清楚恢复动作
- `empty`: 历史记录为空时展示轻量说明，强调事项没有无故消失
- `restore_success`: 恢复后给予轻反馈，不改变页面语义
- `loading`: 分区结构稳定，只在内容区出现骨架
- `error`: 失败以轻量说明表达，不演化成全屏异常页

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `completed_section_header`
  - classification: `preserve_faithfully`
  - evidence: `history-center-history.png`, `prototype/index.html`
  - locked_details: 绿色低噪音语义、标题清楚、完成态是信任表达而不是庆祝
- `deleted_section_header`
  - classification: `preserve_faithfully`
  - evidence: `history-center-history.png`, `prototype/index.html`
  - locked_details: 橙红语义清楚，但不制造恐慌；恢复分区必须一眼可辨
- `history_row_structure`
  - classification: `preserve_faithfully`
  - evidence: `history-center-history.png`, `prototype/index.html`
  - locked_details: 行式结构、标题 + 时间元信息、轻分隔
- `restore_action`
  - classification: `flutterize`
  - evidence: `history-center-history.png`, `prototype/index.html`
  - locked_details: 清楚但克制的恢复按钮，不抢分区层级

### Allowed Simplifications

- 分区条带可用原生浅底和边界近似实现，不依赖位图。
- 恢复按钮可用 Flutter 原生描边按钮实现，不要求独立资产。

## 6. Component Freeze

- `history_section_header`
  - states: `completed`, `deleted`
  - immutable: 分区语义、轻背景带、图标 + 标题结构
- `history_row`
  - states: `completed_preview`, `deleted_preview`
  - immutable: 行式结构、标题、时间元信息、右侧动作位
- `restore_action`
  - states: `idle`, `pressed`, `disabled`
  - immutable: 恢复动作只出现在最近删除分区

## 7. Implementation-Facing Notes

- `history-center` 只消费 `task-flow` 提供的稳定状态和日志，不自建任务真源。
- 恢复动作优先于统计信息，页面不应演化成分析面板。
- 最近完成默认只读，避免在当前模块里并发引入新的状态流转职责。
