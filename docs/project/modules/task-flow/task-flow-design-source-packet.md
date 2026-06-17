# Task Flow Design Source Packet

## 1. Scope

本包只覆盖 `task-flow`：

- 首页主事项卡片
- 首页紧急 / 次级事项队列
- 事项编辑页
- 任务继续处理主链路

本包不覆盖：

- `app-shell` 的共享底栏与快速添加结构定义
- `history-center` 最近完成 / 最近删除布局
- `settings-center` 设置页最终内容
- `widget-bridge` 小组件快照视觉

## 2. Consumed Sources

- [DESIGN.md](D:/Projects/Flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [task-flow.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-home.png](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-home.png)
- [task-flow-editor.png](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-editor.png)
- [task-flow-prototype-playback.md](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/task-flow-prototype-playback.md)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/task-flow/prototype/index.html)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)

## 3. Structure Semantics

- `home_scroll_model`: `whole-page scroll with fixed shell chrome`
- `home_list_model`: `grouped row list below one dominant hero card`
- `editor_scroll_model`: `single-column form scroll`
- `overlay_model`: `shared quick-add owned by app-shell`
- `layout_model`: `one dominant task surface, then secondary queue, then shell`
- `component_repeatability`: `priority_reminder_card`, `task_row`, `status_chip`, `editor_field_row`

## 4. State Matrix

- `ideal`: 首页显示一条绝对主导主事项 + 若干紧急事项行；编辑页显示完整可编辑字段
- `active_today`: 主事项到期信息为今天，绿色语义保持稳定
- `active_overdue`: 队列项使用橙红状态表达逾期，但仍不压过主事项卡片
- `private_safe`: 首页不泄露私密事项正文；编辑页可见隐私开关而不扩散正文
- `long_title`: 主事项标题允许多行但必须保持主 CTA 与到期信息可见
- `short_title`: 主事项标题较短时保持留白，不人为塞入额外说明
- `empty`: 首页无紧急事项时保留主任务与快速添加可发现性
- `loading`: 首页骨架只在主卡片和队列内部出现，不改变共享壳层
- `error`: 真实失败反馈以轻降级提示表达，不替代任务列表
- `permission`: 通知拒绝或 Widget 失败只表现为能力降级

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `task_home_priority_card`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-home.png`, `prototype/index.html`
  - locked_details: 单一主事项绝对主导、暖白纸感、宽松留白、到期信息与主 CTA 同时可见
- `task_home_urgent_rows`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-home.png`, `prototype/index.html`
  - locked_details: 行式结构、轻分隔、逾期语义克制但明确、不可改成多层卡片
- `task_editor_title_surface`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 大标题输入优先、单任务单主轴、编辑态光标感
- `task_editor_field_groups`
  - classification: `flutterize`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 日期 / 时间 / 分类 / 隐私顺序固定，行级点击语义明确
- `task_editor_save_bar`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 底部主保存动作清晰稳定，不被次级按钮稀释

### Allowed Simplifications

- 首页紧急事项图标允许使用系统线性图标表达，不要求独立位图。
- 编辑页输入光标和真实输入态可用 Flutter 原生输入组件近似，不要求浏览器级文本编辑细节完全一致。
- 主卡片纸感可继续弱化为暖色表面与极轻噪点，不引入重纹理资产。

## 6. Component Freeze

- `priority_reminder_card`
  - states: `active_today`, `active_overdue_summary`, `private_safe`
  - immutable: 主事项绝对优先、大标题、到期信息与继续动作同屏
- `task_row`
  - states: `overdue`, `today`, `normal`, `private_safe`
  - immutable: 行式列表、左侧状态起点、右侧进入详情引导
- `task_editor_field_row`
  - states: `filled`, `empty_optional`, `private_enabled`
  - immutable: 一行一义、值区可点、分组边界清楚
- `task_editor_primary_save`
  - states: `enabled`, `pressed`, `disabled`
  - immutable: 唯一主动作、页面底部稳定可见

## 7. Implementation-Facing Notes

- `task-flow` 是事项业务真源模块，后续真实数据库、仓储和应用层用例都应围绕这里的显示契约组织。
- 首页主事项卡片与列表行不能直接在页面层做状态推导，真实排序与主事项选取逻辑必须下沉应用层。
- 编辑页应优先承接单任务编辑路径，不引入复杂配置中心式结构。
- 若后续实现期需要新增二级字段、更多配置项或复杂提醒规则，应先回到设计控制链，而不是直接挤压当前布局。
