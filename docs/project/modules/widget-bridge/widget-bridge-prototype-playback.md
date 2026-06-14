# Widget Bridge Prototype Playback

## 1. Scope

本播放稿只覆盖 `widget-bridge`：

- iOS `accessoryRectangular` Widget 的稳定快照结构
- `fullContent` 主提醒态
- `previewOnly / private-safe` 安全预览态
- 空态与最近一次有效快照降级提示

本稿不覆盖：

- `task-flow` 首页与编辑页
- `history-center` 历史恢复列表
- `settings-center` 设置分区本体

## 2. Playback Goals

- 保持 Widget 只消费稳定快照，不在原生层重排业务优先级
- 让主提醒态和安全预览态都继承共享视觉世界，但不伪装成完整 App 页面
- 点击 Widget 时只表达“安全回到应用查看”，不在 Widget 内承担复杂操作

## 3. Structure Playback

### fullContent

1. 顶部显示当前展示模式标题。
2. 中段显示单条最高优先级事项。
3. 条目只包含标题、状态、到期信息和序号。
4. 若存在回退快照，底部补充降级提示。

### previewOnly / private-safe

1. 顶部继续显示展示模式标题。
2. 主体不暴露事项正文。
3. 只保留“安全预览 / 受保护”状态与“点按后回到应用查看”提示。
4. 行为目标是安全回流，不是直接完成事项。

### empty

1. 标题保持稳定。
2. 主体显示空态标题与空态说明。
3. 不制造错误感，也不暗示数据丢失。

## 4. Fidelity Notes

- Widget 必须看起来像系统附属面板，而不是压缩版首页卡片。
- `previewOnly` 与 `private-safe` 都要明显避免正文泄露。
- `fullContent` 态允许展示真实标题，但仍要保持低噪音、轻量、可扫读。
- 所有状态都不引入额外按钮堆叠，只保留安全回流语义。
