# App Shell Design Source Packet

## 1. Scope

本包只覆盖 `app-shell`：

- 共享底部导航
- 全局快速添加
- 首页共享壳层结构
- 系统回流宿主
- 共享轻反馈承载位

本包不覆盖：

- `task-flow` 的最终业务页面细节
- `history-center`、`settings-center` 的模块内最终排版
- Widget 快照视觉

## 2. Consumed Sources

- [DESIGN.md](D:/Projects/Flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [app-shell.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell.impl.md)
- [app-shell-effect-home-v2.png](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/app-shell-effect-home-v2.png)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/app-shell/prototype/index.html)

## 3. Structure Semantics

- `scroll_model`: `whole-page scroll`
- `list_model`: `grouped list`
- `overlay_model`: `floating action + quick-add sheet`
- `layout_model`: `linear with anchored floating action`
- `sticky_model`: `sticky footer shell`
- `component_repeatability`: `bottom_nav_shell`, `global_quick_add`, `task_row`, `priority_reminder_card`

## 4. State Matrix

- `ideal`: Home with one dominant priority card and urgent queue
- `empty`: Home with no urgent tasks, quick add still obvious
- `loading`: shared shell remains stable, content skeleton only inside main regions
- `error`: global feedback host can present failure without replacing shell
- `permission`: notification denied or system-entry failure expressed as downgrade
- `disabled`: unavailable action visible but restrained
- `success`: quick non-blocking confirmation

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `home_priority_card`
  - classification: `preserve_faithfully`
  - evidence: `app-shell-effect-home-v2.png`
  - locked details: single dominant task, large hierarchy, warm paper-soft surface, gentle depth
- `bottom_nav_shell`
  - classification: `preserve_faithfully`
  - evidence: `prototype/index.html`, shared freeze artifacts
  - locked details: exactly three destinations, low-noise selected state
- `global_quick_add`
  - classification: `preserve_faithfully`
  - evidence: `app-shell-effect-home-v2.png`, `prototype/index.html`
  - locked details: independent floating action, not a tab, not an inline field
- `urgent_queue_rows`
  - classification: `flutterize`
  - evidence: `app-shell-effect-home-v2.png`, `prototype/index.html`
  - locked details: line-based list, clear scanning rhythm, low decoration

### Allowed Simplifications

- 主卡片轻纹理可以在实现中弱化为暖色表面与微弱噪点，不要求高成本重纹理素材
- 顶部摘要区可以保留系统化文本表达，不需要加入额外品牌装饰

## 6. Component Freeze

- `bottom_nav_shell`
  - states: `home_active`, `history_active`, `settings_active`
  - immutable: 三栏结构、图标 + 标签、低噪音选中态
- `global_quick_add`
  - states: `rest`, `pressed`, `sheet_open`
  - immutable: 独立悬浮、不并入底栏
- `app_shell_feedback_host`
  - states: `info`, `warning`, `degradation`
  - immutable: 不遮挡首要任务区

## 7. Implementation-Facing Notes

- 壳层只承接导航、共享结构和回流宿主
- 不把业务判断塞回 `app-shell`
- 快速添加默认走轻量浮层 / sheet，不演化为完整独立页面
- 模块冻结通过后，`app-shell` 应可直接进入架构映射
