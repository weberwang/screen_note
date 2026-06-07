# task-flow UI/UX RD

## 模块目标与目标用户

- 目标：承载首页、快速添加、事项详情/编辑与任务状态主流程。
- 目标用户：需要 3 秒记一条、持续看见并可主动处理任务的高频用户。

## 页面范围与导航入口

- 页面范围：首页、快速添加入口、事项详情/编辑页。
- 导航入口：默认首页、壳层底部入口、未来 Widget/通知回流到具体任务。

## 核心用户路径

1. 进入首页看到当前最需要处理的事项。
2. 通过快速添加或详情页创建/编辑事项。
3. 主动完成、删除或更新事项。
4. 变化立即反映到首页排序、历史记录、快照和提醒。

## 状态矩阵

| 状态 | 说明 |
| --- | --- |
| ideal | 列表稳定显示置顶/过期/今日/普通事项 |
| empty | 展示克制空态与快速添加引导 |
| loading | 首次读取使用轻量骨架；系统回流优先保留结构 |
| error | 列表或写操作失败时给出重试与不阻塞回退 |
| permission | 通知未授权时仅弱提示，不阻断编辑 |
| partial_data | 快照仍可显示上一份有效内容 |
| disabled | 保存按钮在必填项缺失时禁用 |
| success | 完成、删除、保存后给出短反馈 |
| locked_or_premium | not_applicable |

## 结构语义

- `scroll_model`: whole-page scroll
- `list_model`: grouped list
- `overlay_model`: bottom action area + modal layer
- `layout_model`: linear
- `sticky_model`: sticky header when filters are visible
- `component_repeatability`: 任务行、快速添加条、属性标签、提醒模式块

## 模块级组件骨架

- `QuickAddBar`：默认仅一条输入焦点，展开后才显示高级选项。
- `TaskListItem`：标题、时间/标签、状态强调、主次动作区域固定。
- `TaskMetaChip`：承载 today/overdue/privacy/reminder 等语义标签。
- `TaskEditorSection`：把时间、隐私、提醒、置顶收敛为分组块。

## 设计来源

- 共享设计包：`docs/rd/02-shared-design-packet.md`
- 共享冻结：`docs/rd/global-design-guidelines.md`
- 主题冻结：`docs/rd/light-theme-freeze.yaml`、`docs/rd/dark-theme-freeze.yaml`
- 视觉证据：
  - `docs/rd/home-page-light-refresh-v2.png`
  - `docs/rd/task-editor-refresh-v1.png`
  - 模块内复制图：`docs/rd/modules/task-flow/home-page-light-refresh-v2.png`
  - 模块内复制图：`docs/rd/modules/task-flow/task-editor-refresh-v1.png`
  - 运行态截图仅作实现复核参考：`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c001/runtime-pack/home.png`、`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c001/runtime-pack/task-editor.png`

## 设计冻结卡

- 冻结目标：首页首屏层级、快速添加条、任务行信息顺序、编辑页主次操作关系
- 不可变项：过期任务显著性高于普通任务；隐私任务不得在锁屏型上下文露正文
- 允许调整：列表分隔形式、骨架样式、编辑页控件实现细节
- 审批记录：`workflow-orchestrator --auto` 于 2026-06-04 自动确认
- 当前返工补充：首页与编辑页现在分别绑定到现有共享图与模块复制图，禁止继续引用任何已废弃的旧占位图名。

## 接受门禁

- UI/UX：3 秒内可完成一条最小录入；列表扫描顺序稳定
- 模块冻结：任务行、快速添加条、编辑页操作优先级已固定
- 代码交接：状态流转、快照刷新、提醒调度只能经应用层用例触发
