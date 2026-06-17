# Task Flow Design Source Packet

## 1. Scope

本包只覆盖 `task-flow`：

- 首页主任务卡片结构
- 首页紧急队列节奏
- 新建/编辑任务表单主路径
- 优先级、状态、隐私安全与备注编辑区域
- 保存动作与快速新增入口的承接关系

本包不覆盖：

- 历史恢复页结构
- 设置页分区与能力配置
- Widget 投影结构

## 2. Consumed Sources

- [DESIGN.md](/E:/Projects/flutter/screen_note/DESIGN.md)
- [global-design-guidelines.md](/E:/Projects/flutter/screen_note/docs/project/global-design-guidelines.md)
- [light-theme-freeze.yaml](/E:/Projects/flutter/screen_note/docs/project/light-theme-freeze.yaml)
- [dark-theme-freeze.yaml](/E:/Projects/flutter/screen_note/docs/project/dark-theme-freeze.yaml)
- [02-product-design-clarification-packet.md](/E:/Projects/flutter/screen_note/docs/project/02-product-design-clarification-packet.md)
- [03-shared-html-prototype-packet.md](/E:/Projects/flutter/screen_note/docs/project/03-shared-html-prototype-packet.md)
- [task-flow.impl.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow.impl.md)
- [task-flow-home.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-home.png)
- [task-flow-editor.png](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-editor.png)
- [task-flow-prototype-playback.md](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/task-flow-prototype-playback.md)
- [prototype/index.html](/E:/Projects/flutter/screen_note/docs/project/modules/task-flow/prototype/index.html)

## 3. Structure Semantics

- `surface_model`: `one dominant home reminder plus one compact urgent queue`
- `editor_model`: `single-path task editor with save-first closure`
- `interaction_model`: `home to edit, queue to edit, quick add to create, save back to home`
- `state_model`: `active_today / active_overdue / private_safe / long_title / short_title`
- `density_model`: `lean home, standard editor`
- `navigation_entry`: `shared Home tab and global quick add`
- `core_path`: `home priority -> editor -> save -> home`
- `return_loop`: `cancel or save returns to home shell without breaking shared navigation posture`

## 4. State Matrix

- `active_today`: 首页主任务以单卡片形式承载今日到期提醒，状态强调存在但不压倒标题。
- `active_overdue`: 紧急队列允许用珊瑚色到期提示强调风险，但不重写整套视觉语言。
- `private_safe`: 编辑页保留隐私安全开关，后续实现必须支持隐藏敏感正文。
- `long_title`: 主任务标题允许两行扩展，但必须保持元信息与主动作可见。
- `short_title`: 标题较短时仍需维持大留白与主任务主导地位，不能被次级内容稀释。
- `ideal`: 首页与编辑页都能完整展示主任务、次级队列和保存主链路。
- `empty`: 首页无任务时，必须保留 calm empty state，并把注意力导向快速新增。
- `loading`: 首页加载中仍保留与真实结构一致的层级骨架，不闪烁成全新布局。
- `error`: 数据加载失败只能降级为 calm error copy，不得让主路径消失。
- `permission`: 提醒或截图相关权限不足时，只能作为能力降级提示，不能阻断编辑与保存主链路。
- `partial_data`: 无到期时间、无备注或仅有标题时，仍需保持卡片结构稳定，不制造版面塌缩。
- `disabled`: 保存中或暂不可操作时，主保存按钮可降级，但字段组织不变。
- `success`: 保存成功后直接回到首页主链路，不插入夸张庆祝反馈。
- `locked`: 隐私安全开启时，正文与外显内容必须可切换到安全展示，不得泄露敏感文本。

## 5. High-Fidelity Visual Contract

### Fidelity-Critical Regions

- `home_priority_card`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-home.png`, `prototype/index.html`
  - locked_details: 单主任务优先、暖白纸感表面、状态胶囊、底部元信息与直达编辑动作
- `home_urgent_queue`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-home.png`, `prototype/index.html`
  - locked_details: 行式轻队列、稀疏分隔、到期时间右对齐、不得回退成多卡面板
- `editor_primary_form`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 标题、到期时间、优先级、状态、隐私安全、备注的单卡集中编排
- `editor_support_rows`
  - classification: `flutterize`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 附件与提醒下沉为次级支持项，不得抢主编辑区层级
- `save_action`
  - classification: `preserve_faithfully`
  - evidence: `task-flow-editor.png`, `prototype/index.html`
  - locked_details: 底部单一主保存动作，必须显著但不营销化

### Allowed Simplifications

- 原型中的头像、系统状态栏与轻图标可由工程端用原生资源近似，不要求额外位图资产。
- 轻纸感可通过暖色表面与弱渐层近似，不要求强纹理资产。
- 优先级与状态选项允许用 Flutter 原生按钮组近似，但必须保留单选节奏与层级对比。

## 6. Component Freeze

- `priority_reminder_card`
  - states: `today`, `overdue`, `private-safe`
  - immutable: 单主任务定位、暖白主卡、底部元信息带与主动作入口
- `urgent_queue_row`
  - states: `overdue`, `today`, `upcoming`
  - immutable: 行式结构、轻分隔、右侧时间节奏、不得抬升为大卡片
- `task_editor_form`
  - states: `create`, `edit`
  - immutable: 核心字段首屏可见、次级支持项下沉、保存动作独立固定
- `privacy_safe_toggle`
  - states: `on`, `off`
  - immutable: 安全展示语义明确，不能被替换成抽象文案

## 7. Implementation-Facing Notes

- Flutter 首页应继续复用 `TaskFlowHomeDisplayModel` 驱动单主任务与轻队列，不把排序与状态推导搬进页面层。
- 编辑页的保存成功应以主链路闭环为先，首页刷新失败只能降级提示，不能回滚已保存结果。
- 隐私安全开关后续实现必须同时约束截图、Widget 与其他外显渠道，不得只做页面内视觉开关。
- 若实现阶段想把首页压缩为更多首屏队列项，必须回到设计控制链路，而不是直接在代码中挤压留白。

## 8. Flutter Parity Acceptance

- 首页必须保持“单主任务卡片先于紧急队列”的首屏层级，不得把次级任务抬升到同级视觉重量。
- 主任务卡片的标题、状态胶囊、到期信息和进入编辑动作必须同时可见，长标题也不能挤掉主动作。
- 紧急队列必须保持行式列表节奏与轻分隔，不能在实现时回退为卡片堆叠。
- 编辑页必须在首屏暴露标题、到期时间、优先级、状态、隐私安全和保存动作，不得把核心字段下沉到折叠区。
- 共享三栏壳层、全局快速新增入口和 `ios_device / 390 x 844 px` 冻结视口基线不得在实现中被重写。
