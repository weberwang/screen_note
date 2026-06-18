# Widget Bridge Prototype Playback

## 1. Scope

本播放稿覆盖 `widget-bridge` 的两类展示面：

- App 内安装与预览页
- iOS `accessoryRectangular` Widget 稳定快照本体
- `fullContent` 主提醒态
- `previewOnly / private-safe` 安全预览态
- 空态与最近一次有效快照的降级提示

本稿不覆盖：

- `task-flow` 首页与编辑页
- `history-center` 历史恢复列表
- `settings-center` 设置分区主体

## 2. Playback Goals

- 让 `widget-bridge` 同时承担“安装引导页”和“Widget 本体预览”的完整设计证据，而不是只留下入口文案。
- 保持 Widget 只消费稳定快照，不在原生层重新承载排序、状态推导或复杂操作。
- 让 App 内页面优先表达当前快照、手动同步、添加到桌面和隐私边界，而不是演化成说明书式长文档。

## 3. Structure Playback

### install_guide_page

1. 首屏先给出页面标题与一句短说明，明确这是“预览 + 安装 + 同步”页面。
2. 顶部指标卡只显示当前展示模式、可见条目数量和私密条目数量，用于快速判断快照状态。
3. 中段主卡展示 Widget 预览本体，让用户先看到实际会投影到桌面的内容。
4. 紧接着展示手动同步与“添加到桌面”动作卡，保持下一步操作清晰直达。
5. 页面底部用两张信息卡说明安装方式与隐私保护，不把说明文字塞进主操作区域。

### fullContent_widget

1. 头部只保留低噪音的产品身份与 Widget 类型提示。
2. 主体只展示一条最高优先级事项。
3. 信息只包含标题、状态、时间和序号，不扩展成迷你任务列表。
4. 底部回流提示只表达“点按后回到应用查看”。

### previewOnly_or_private_safe_widget

1. 头部继续展示稳定的展示模式与系统附属感。
2. 主体不暴露事项正文。
3. 只保留“Protected / Tap to view in app”这一类安全回流语义。
4. 目标是保护隐私，而不是在 Widget 内完成任务。

### empty_widget

1. 标题保持平静，不制造错误感。
2. 主体说明当前没有可投影事项，并明确下一次稳定快照会在有内容后出现。

## 4. Fidelity Notes

- App 内安装页必须看起来像成熟产品里的辅助操作页，而不是临时说明页。
- 页面里的长说明只能出现在次级信息卡里，不能压过预览和主操作。
- Widget 预览卡与真实 Widget 效果图要保持同一套暖白底、低噪音绿橙状态语义和轻边框语言。
- `previewOnly` 与 `private-safe` 都必须明确避免正文泄露。
- Widget 本体依然不能引入额外按钮堆叠或复杂交互。
