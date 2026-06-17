# Task Flow Prototype Playback

## Page Structure Playback

### 1. Home Priority Layer

- 页面继续继承已冻结的 `app-shell` 共享壳层：顶部轻品牌区、底部 `Home / History / Settings` 三栏导航、独立悬浮快速添加入口。
- 首页第一阅读层只属于一张绝对主导的主事项卡片。
- 主事项卡片承载单一最高优先级 `active` 事项，包含标题、简短说明、到期信息和一个清晰继续动作。
- 主卡片继续沿用共享方向中的温和暖白纸感，但不扩散到整页其他区域。

### 2. Home Queue Layer

- 主卡片下方是紧急或次级事项队列。
- 队列保持行式结构与轻分隔，不改成堆叠卡片。
- 过期事项用受控橙红语义突出，但不压过主事项卡片。
- 今日事项继续保持更安静的绿色语义，优先服务快速扫读。

### 3. Editor Primary Layer

- 编辑页是单任务单主轴页面，不混入列表或多列布局。
- 顶部保留返回与保存动作，标题明确为当前编辑任务。
- 主编辑区优先展示任务标题输入，保持大字号和充足留白，突出“当前要编辑的就是这一件事”。
- 中段依次承载到期日期、到期时间、分类、隐私等结构化字段。
- 备注区放在更下层，只作为补充，不抢主字段层级。
- 页面底部保留明确的主保存动作，保证编辑闭环稳定可见。

### 4. State Coverage Intent

- 首页必须能表达：`active_today`、`active_overdue`、`long_title`、`short_title`、`private_safe`。
- 编辑页必须能表达：新建、编辑、保存前修改、隐私项开启、备注为空。
- 后续 HTML 原型需要在结构上预留 `loading / empty / degradation / error` 的一致状态语言，但不改变当前共享视觉体系。

## Interaction Checklist

- 点击首页主事项卡片进入事项详情或编辑主链路。
- 点击队列行可进入事项详情，并为后续快速完成预留交互位。
- 全局快速添加继续作为独立动作入口，后续应能拉起新建事项路径。
- 首页 `Home / History / Settings` 三栏导航继承共享壳层，不在 `task-flow` 内重定义。
- 编辑页返回动作不应吞掉已有输入；保存动作为当前页最明确的主 CTA。
- 日期、时间、分类、隐私字段都应保持可点击和可修改的表单行为。
- 长标题必须保持可读，不允许因追求单屏容纳而压缩到破坏层级。
- 隐私相关事项在首页和编辑链路都不能泄露正文到不该出现的位置。
- 降级反馈如通知权限失败、Widget 刷新失败不应打断事项创建、编辑、完成和删除主链路。

## Please confirm before high-fidelity prototype build

- 当前播放稿覆盖 `task-flow` 的两个核心页面族：`home` 与 `task_editor`。
- 若确认无误，下一步将进入模块 HTML 高保真原型构建，并以 `task-flow-home.png` 与 `task-flow-editor.png` 作为视觉基线。
