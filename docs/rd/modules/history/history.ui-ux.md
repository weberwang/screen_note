# History 模块 UI/UX RD

## 0. 文档信息

- 模块名称：`history`
- 文档成熟度：`implementation_final`
- 设计冻结状态：`frozen`
- 对应实现文档：[history.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history/history.impl.md)

## 1. 模块目标与目标用户

- 目标：让用户追溯最近完成与最近删除事项，并在需要时安全恢复。
- 目标用户：担心误删、需要回顾完成记录、希望确认系统“没有丢”的用户。

## 2. 页面范围与导航入口

- 历史页首页
- 最近完成区块
- 最近删除区块

## 3. 核心用户路径

1. 用户进入历史页，先通过标题与分段快速理解当前列表类型。
2. 浏览最近完成或最近删除记录，重点看正文和时间。
3. 对删除记录执行恢复，对完成记录执行查看或再次处理。

## 4. 页面结构与模块组件骨架

- 顶部结构：
  - 衬线标题
  - 分段过滤
  - 排序选择
- 内容结构：
  - `completed_section`
  - `deleted_section`
  - 纸边分隔
- 模块私有组件：
  - `history_section_header`
  - `history_thumbnail_stub`
  - `history_row_action_slot`
- 复用边界：
  - `history_note_row` 为共享组件
  - 区块头与动作槽为模块私有

## 5. 状态矩阵

| 状态 | 页面 | 规则 |
| --- | --- | --- |
| ideal | 历史页 | 完成区与删除区层级清楚，正文优先 |
| empty | 完成 / 删除为空 | 用温和空态提示，不制造失败感 |
| loading | 历史页 | 卡片骨架与纸边分隔保留 |
| error | 历史读取失败 | 局部解释失败，可重试 |
| partial_data | 仅一类记录可读 | 保留可读区块，不整页报错 |
| disabled | 恢复按钮不可用 | 仍需清晰表达原因 |
| success | 恢复成功 | 回流到 active 列表并提示 |

## 6. 设计源

- 共享设计包：[03-global-uiux-design-packet.md](D:/Projects/Flutter/screen_note/docs/rd/03-global-uiux-design-packet.md)
- 全局冻结规约：[global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
- 主题冻结：
  - [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/light-theme-freeze.yaml)
  - [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/dark-theme-freeze.yaml)
- 视觉证据：[preview-history.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-history.png)

## 7. 设计冻结卡

- 冻结结论：`frozen_module_for_architecture`
- 模块私有组件冻结：
  - `history_section_header`
  - `history_thumbnail_stub`
  - `history_row_action_slot`
- 不可变项：
  - 完成区与删除区必须以不同语义色和区块头区分
  - 历史项正文优先于缩略图与状态图标
  - 删除动作必须保持弱化并具破坏性语义
- 允许工程化调整：
  - 缩略图可从真实纸片图简化为统一占位风格
  - 纸边细节可简化为分隔线或轻噪点

## 8. UI/UX 验收门

- 用户必须能快速理解“已完成”和“最近删除”不是同一类数据。
- 恢复动作需要明确、可达、且不与删除动作混淆。
- 列表密度不能退化成表格化后台视图。
