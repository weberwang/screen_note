# history-center UI/UX RD

## 模块目标与目标用户

- 目标：提供最近完成、最近删除与恢复入口，让用户对“已处理”和“误删找回”有明确预期。
- 目标用户：需要回看历史、撤销误操作、建立产品信任的用户。

## 页面范围与导航入口

- 页面范围：最近完成页、最近删除页。
- 导航入口：首页二级入口、未来设置入口。

## 核心用户路径

1. 从首页进入最近完成或最近删除。
2. 浏览记录、查看时间信息。
3. 对误删项执行恢复，对最近完成项进行回看。

## 状态矩阵

| 状态 | 说明 |
| --- | --- |
| ideal | 列表按时间倒序稳定展示 |
| empty | 展示柔和、鼓励性的空态 |
| loading | 轻量骨架，不打断壳层 |
| error | 提供重试与回退 |
| permission | not_applicable |
| partial_data | 可先展示最近有效记录 |
| disabled | 恢复按钮在不满足条件时禁用 |
| success | 恢复后给出短反馈并回流主列表 |
| locked_or_premium | not_applicable |

## 结构语义

- `scroll_model`: whole-page scroll
- `list_model`: repeated list
- `overlay_model`: none
- `layout_model`: linear
- `sticky_model`: sticky header
- `component_repeatability`: 历史记录行、恢复动作行、空态卡

## 模块级组件骨架

- `HistoryRecordRow`：标题、时间、来源提示、尾部动作
- `RestoreActionSlot`：最近删除中的恢复按钮与说明
- `HistoryEmptyCard`：最近完成/最近删除共用空态骨架

## 设计来源

- 共享设计包：`docs/rd/02-shared-design-packet.md`
- 共享冻结：`docs/rd/global-design-guidelines.md`
- 主题冻结：`docs/rd/light-theme-freeze.yaml`、`docs/rd/dark-theme-freeze.yaml`
- 视觉证据策略：
  - 模块级效果图：`docs/rd/modules/history-center/history-center-refresh-v1.png`
  - 模块图用于补充最近完成/最近删除并列节奏、恢复按钮显著性与柔和空态姿态；共享设计包继续约束列表和 CTA 语义。
  - 运行态证据只作实现复核参考：`test/parity/goldens/runtime_pack_history_deleted.png`、`test/parity/goldens/runtime_edge_history_completed_empty.png`、`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c003/history-empty.png`

## 设计冻结卡

- 冻结目标：历史记录行节奏、恢复动作显著性、空态姿态
- 不可变项：恢复动作用清晰按钮或尾部动作，不得隐藏在长按手势
- 允许调整：图标具体风格、分隔线轻重
- 审批记录：`workflow-orchestrator --auto` 于 2026-06-04 自动确认
- 当前返工补充：在缺少模块私有页面图的情况下，冻结依据回到文本设计包与共享冻结，不再伪装存在独立 `recent-completed` 设计图。

## 接受门禁

- UI/UX：恢复入口清晰；空态不制造焦虑
- 模块冻结：历史记录行与空态卡边界固定
- 代码交接：恢复行为必须返回应用层用例，不做页面直改
