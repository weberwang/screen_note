# 屏记阶段一 Pencil 映射文档

## 1. 文档目的

本文档用于补齐阶段一 Task 2 在当前仓库内可落地的设计源标准，作为后续 Flutter 显示层实现的唯一设计依据。

适用范围：

- `designs/screen_note_stage1.pen`
- 阶段一主 App 页面、弹层、历史页、Widget 预览卡
- 与 `docs/screen-note-page-overlay-implementation-2026-05-22.md` 的页面拆分边界对齐

不包含：

- Dart 代码实现
- 面向开发交付的切图、尺寸标注图和交互标注文档
- 其他阶段的 `.pen` 设计源

## 2. 当前仓库现状与本次约定

当前仓库的阶段一设计源已经落到真实 `Pencil` 文档 [screen_note_stage1.pen](/E:/Projects/flutter/screen_note/designs/screen_note_stage1.pen) 中，不再使用“文本化设计源占位”口径。

本次落地结果如下：

- 顶层画布已按 `Foundations`、`Components`、`Pages`、`Overlays` 四个分区组织。
- 阶段一所需 10 个可复用组件已建立为 reusable 节点。
- `TaskCard.*`、`QuickInputCard.*`、`WidgetPreviewCard.*` 状态分支已作为真实设计节点落库。
- `HomePage`、`TaskDetailPage`、`CompletedHistoryPage`、`DeletedHistoryPage` 的页面状态稿，以及 `DeleteTaskDialog`、`RestoreTaskDialog`、`DiscardChangesDialog`、`DueTimeSheet`、`PrivacyExplainSheet` 的弹层稿已落库。

当前 `Pencil` 画布使用约定如下：

- 颜色、字号、间距、圆角全部通过变量定义，不以内联字面值替代设计语义。
- 页面状态稿与组件状态稿使用计划中冻结的节点命名，避免 Flutter 实现层二次命名。
- 验收图统一从 `.pen` 文档导出到 [docs/design_exports/screen_note_stage1](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1)。

字体说明：

- 按视觉设计指导，真实实现仍应优先使用 `PingFang SC` 与 `SF Pro`。
- 当前 `Pencil` 运行环境缺少上述系统字体，因此画布内统一使用 `Inter` 作为设计编辑态回退字体；这不改变 Flutter 侧的最终字体策略。

## 3. 阶段一设计 Token

### 3.1 颜色 Token

| Token | 建议值 | 设计语义 |
| --- | --- | --- |
| `surfacePaper` | `#F8F3EA` | 页面主背景，纸面底色 |
| `surfaceCard` | `#FFFBF4` | 一级卡片背景 |
| `surfaceMuted` | `#EFE7DA` | 二级卡片或弱化区块背景 |
| `inkPrimary` | `#211B14` | 主文案、主标题 |
| `inkSecondary` | `#6F6254` | 次级说明、时间、副标题 |
| `lineSoft` | `#E2D6C7` | 轻分隔线、描边 |
| `accentAmber` | `#D9822B` | 重点强调、主 CTA、置顶提示 |
| `statusOverdue` | `#B94A3A` | 已过期状态强调 |
| `statusDone` | `#4F8A62` | 已完成状态强调 |
| `statusPrivate` | `#6D6A75` | 隐私状态强调 |
| `actionBlue` | `#3366CC` | 次要动作、系统跳转动作 |

### 3.2 字号 Token

| Token | 数值 | 用途 |
| --- | --- | --- |
| `fontDisplay` | `32` | 首页日期、强标题 |
| `fontTitle` | `24` | 页面标题 |
| `fontSection` | `18` | 区块标题 |
| `fontBody` | `16` | 卡片正文、输入正文 |
| `fontBodySmall` | `14` | 次级正文、说明文字 |
| `fontCaption` | `12` | 标签、提示、补充说明 |

### 3.3 间距 Token

| Token | 数值 | 用途 |
| --- | --- | --- |
| `space4` | `4` | 最小内间距 |
| `space8` | `8` | 紧凑元素间距 |
| `space12` | `12` | 控件间距 |
| `space16` | `16` | 卡片内边距 |
| `space20` | `20` | 页面左右边距 |
| `space24` | `24` | 分组间距 |
| `space32` | `32` | 大块留白 |

### 3.4 圆角 Token

| Token | 数值 | 用途 |
| --- | --- | --- |
| `radius12` | `12` | 次级按钮、小型控件 |
| `radius18` | `18` | 事项卡片 |
| `radius20` | `20` | 快速输入卡 |
| `radius28` | `28` | 底部弹层 |
| `radiusPill` | `999` | 状态标签 |

## 4. 组件节点冻结清单

阶段一必须以以下节点名作为设计与实现映射基线：

- `QuickInputCard`
- `TaskCard`
- `TaskStatusChip`
- `TaskEmptyState`
- `TaskErrorState`
- `HistoryTaskCard`
- `DeletedTaskCard`
- `WidgetPreviewCard`
- `PrimaryActionButton`
- `SecondaryActionButton`

这些节点名后续进入 Flutter 时，应优先对应独立 Widget 或明确的共享构件，不允许被页面文件内联吞并。

## 5. 关键状态分支冻结清单

### 5.1 TaskCard

- `TaskCard.active`
- `TaskCard.activePinned`
- `TaskCard.activeOverdue`
- `TaskCard.activePrivate`
- `TaskCard.completed`
- `TaskCard.deleted`

说明：

- `activeOverdue` 是展示派生状态，不是第四种持久状态。
- `activePrivate` 只影响列表与 Widget 等外露场景的正文显隐，不改变事项业务状态。

### 5.2 QuickInputCard

- `QuickInputCard.idle`
- `QuickInputCard.submitting`
- `QuickInputCard.error`

### 5.3 WidgetPreviewCard

- `WidgetPreviewCard.single`
- `WidgetPreviewCard.list`
- `WidgetPreviewCard.private`
- `WidgetPreviewCard.empty`

## 6. Flutter 映射关系

### 6.1 Token 到 Flutter 主题层

| 设计源 | Flutter 建议落点 | 约束 |
| --- | --- | --- |
| 颜色 token | 共享主题常量或主题扩展 | 命名沿用设计 token，不改成业务别名 |
| 字号 token | 文本样式层 | 标题、正文、标签层级不可混用 |
| 间距 token | 间距常量层 | 页面和组件统一复用 |
| 圆角 token | Shape/BorderRadius 常量层 | 相同语义不重复定义新半径 |

### 6.2 组件到 Flutter Widget 边界

| 设计节点 | Flutter 建议落点 | 备注 |
| --- | --- | --- |
| `QuickInputCard` | 首页共享输入卡 Widget | 不并入首页页面文件 |
| `TaskCard` | 当前事项列表卡片 Widget | 通过入参切换状态分支 |
| `TaskStatusChip` | 标签 Widget | 列表态与详情态共用一套节点语义 |
| `TaskEmptyState` | 列表空态 Widget | 不与错误态混用 |
| `TaskErrorState` | 列表错误态 Widget | 只表达失败，不兼做空态 |
| `HistoryTaskCard` | 最近完成卡片 Widget | 与当前事项卡分开 |
| `DeletedTaskCard` | 最近删除卡片 Widget | 必须保留剩余天数区 |
| `WidgetPreviewCard` | 设置页与引导页预览卡 Widget | 仅用于预览，不等同真 Widget |
| `PrimaryActionButton` | 共享主按钮 Widget | 主 CTA 统一样式 |
| `SecondaryActionButton` | 共享次按钮 Widget | 次动作统一样式 |

### 6.3 页面与弹层边界

必须遵守以下边界约束：

- 主页不内联事项卡片。主页负责拼装区块，不负责在页面文件内直接展开 `TaskCard` 结构。
- 详情页不内联时间弹层、删除弹层、恢复弹层。这些弹层必须保持为独立 overlay 节点。
- 最近删除卡必须保留剩余天数区，不能为了压缩卡片信息而删除。
- `TaskStatusChip` 在列表态最多显示 2 个标签；完整标签集合只允许在详情态展开。

## 7. 页面/弹层边界约束

### 7.1 页面边界

- 首页只承载快速输入、当前事项列表、引导入口，不吞并卡片内部结构。
- 最近完成页只使用 `HistoryTaskCard`，不复用当前事项列表态布局。
- 最近删除页只使用 `DeletedTaskCard`，并显式展示删除时间与剩余天数区。
- 设置页只做入口编排；Widget 预览、隐私说明、通知说明等保持独立节点和独立状态。

### 7.2 弹层边界

- 时间选择类交互保持独立弹层，不下沉成详情页内联区块。
- 删除确认与恢复确认保持独立弹层，不以内联危险按钮替代。
- Widget 安装说明、通知说明、隐私说明未来应各自保持独立 overlay，不混为单一“说明弹层”。

## 8. 状态与信息裁剪规则

### 8.1 TaskCard

- `active`：默认未完成卡片。
- `activePinned`：在 `active` 基础上增加置顶强调，不改变卡片总体布局。
- `activeOverdue`：仅增强时间与状态提示，不允许整卡变为高饱和警报底色。
- `activePrivate`：列表外露场景默认不显示敏感正文。
- `completed`：弱化正文，保留完成标识。
- `deleted`：弱化卡片，转入恢复语义。

### 8.2 QuickInputCard

- `idle`：允许输入与提交。
- `submitting`：输入锁定，主按钮进入提交态。
- `error`：保留原输入内容，并展示短错误反馈。

### 8.3 WidgetPreviewCard

- `single`：单条重点展示。
- `list`：列表型展示。
- `private`：仅展示隐私文案或数量，不泄露正文。
- `empty`：展示温和空态，不制造压力。

## 9. 阶段一验收物

本次已经导出以下阶段一验收图：

- [component-library-overview.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/component-library-overview.png)：组件库总览
- [component-state-variants.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/component-state-variants.png)：组件状态分支总览
- [page-home-states.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/page-home-states.png)：首页状态稿
- [page-task-detail-states.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/page-task-detail-states.png)：详情页状态稿
- [page-completed-history-states.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/page-completed-history-states.png)：最近完成页状态稿
- [page-deleted-history-states.png](/E:/Projects/flutter/screen_note/docs/design_exports/screen_note_stage1/page-deleted-history-states.png)：最近删除页状态稿

本次仍未覆盖的后续验收物：

- 开发尺寸标注图
- 交互流程标注图
- Widget 真机截图与系统安装引导图
- 如后续需要的切图或设计审阅截图

## 10. 本文档对后续实现的约束结论

- Flutter 显示层不得把本文件未定义的结构视为默认自由发挥空间。
- 若实现中发现设计缺口，应先补 `designs/screen_note_stage1.pen`，再更新实现。
- 若后续真实 Pencil 工具接手，应保持 token 名、组件节点名、状态分支名不变，避免设计源和实现层出现二次命名。
