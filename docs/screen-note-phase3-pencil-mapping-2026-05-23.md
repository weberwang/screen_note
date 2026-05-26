# Screen Note Phase 3 Pencil 映射

## 目的

本文档用于固定 `designs/screen_note_stage3.pen`、Flutter 预览组件和 iOS 锁屏 Widget 的一一映射关系，避免三个实现面各自发明不同布局或状态语义。

## 模式映射

| Pencil 节点 | Flutter 实现 | iOS Widget 实现 | 说明 |
| --- | --- | --- | --- |
| `WidgetPreviewCard` | `WidgetPreviewCard` | 不直接使用 | App 内统一预览容器，用于展示模式切换后的锁屏效果。 |
| `WidgetSingleMode` | `WidgetDisplayMode.single` | `WidgetDisplayModePayload.single` | 展示单条最重要事项，优先体现置顶和安全到期信息。 |
| `WidgetList3Mode` | `WidgetDisplayMode.list3` | `WidgetDisplayModePayload.list3` | 展示三条稳定快照内容，不在 Widget 侧重新排序。 |
| `WidgetTodayMode` | `WidgetDisplayMode.today` | `WidgetDisplayModePayload.today` | 只展示今天到期的事项，没有数据时退为空态。 |
| `WidgetPrivateMode` | `WidgetDisplayMode.private` | `WidgetDisplayModePayload.private` | 只展示数量汇总和安全状态标签，不泄露正文。 |
| `WidgetEmptyMode` | `WidgetDisplayMode.empty` | `WidgetDisplayModePayload.empty` | 没有可展示内容时展示空态与 fallback 说明。 |

## 组件映射

| Pencil 组件 | Flutter 对应 | iOS Widget 对应 | 说明 |
| --- | --- | --- | --- |
| `WidgetTitle` | `WidgetPreviewCard` 顶部标题区 | `headerTitle(for:)` | 统一模式标题和锁屏上下文文案。 |
| `WidgetItemRow` | `_PreviewRow` | `itemRow(_:)` | 统一单条事项行的标题、状态、时间和 rank 布局。 |
| `WidgetPrivacyBadge` | `_PreviewRow.status` 的隐私态 | `item.statusLabel` | 隐私模式只保留安全标签，不显示正文。 |
| `WidgetDueLabel` | `_PreviewRow.dueLabel` | `item.dueLabel` | 只消费主 App 产出的安全时间文案。 |
| `WidgetEmptyHint` | `_EmptyPreviewCard` | `emptyView(title:body:)` | 统一空态标题与说明。 |
| `WidgetFallbackHint` | `WidgetPreviewCard.footer` | `snapshot.hasFallbackContent` 提示 | 刷新失败时保留最后有效内容，不暴露技术错误。 |

## 状态约束

- `normal`：使用常规标题、状态和时间展示。
- `overdue`：仅通过状态标签强调，不改单条布局结构。
- `today`：使用今日模式标题和到期时间文案。
- `private`：只显示 `widgetPreviewPrivateSummary` 一类安全汇总文案。
- `fallback`：显示最后有效快照，并补充 fallback 提示，不展示错误详情。

## 对齐规则

- Flutter 预览与 iOS Widget 都只消费 `WidgetDisplayMode` 和共享快照字段。
- 锁屏 Widget 不查数据库、不排序、不推导业务状态。
- 隐私模式下不得展示事项正文、备注或可反推敏感信息的时间细节。
- fallback 只表示“保留最后有效内容”，不表示新建额外状态类型。
