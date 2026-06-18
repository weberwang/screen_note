# Widget Bridge Display Restoration Blueprint

## 1. Blueprint Scope

本蓝图只服务 `widget-bridge` 的 App 内安装与预览页还原，不重新解释 Widget 本体冻结设计，也不重开 `settings-center` 的入口归属。

适用前提：

- 当前模块状态：`module_design_frozen`
- 冻结视觉证据：
  - `widget-bridge-install-guide.png`
  - `widget-bridge-priority-widget.png`
  - `widget-bridge-private-widget.png`
  - `prototype/index.html`

## 2. Design Source Control Decision

- `design_source_decision`: `restore_fidelity`
- `change_classification`: `restore_fidelity`
- 结论：当前 [widget_bridge_page.dart](/E:/Projects/flutter/screen_note/lib/features/widget_bridge/presentation/pages/widget_bridge_page.dart) 已具备大部分信息块，但页面层级、标题语义、动作聚焦和信息卡排序尚未完全贴齐冻结效果图，应在代码中按冻结证据还原，而不是重新设计。

## 3. Source Artifacts

- [widget-bridge-design-source-packet.md](/E:/Projects/flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-design-source-packet.md)
- [widget-bridge-architecture.md](/E:/Projects/flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-architecture.md)
- [widget-bridge-freeze-decision.md](/E:/Projects/flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-freeze-decision.md)
- [widget-bridge-install-guide.png](/E:/Projects/flutter/screen_note/docs/project/modules/widget-bridge/widget-bridge-install-guide.png)

## 4. Allowed Actions

- 保留当前页面的信息块组成：标题、指标卡、预览卡、动作卡、两张信息卡。
- 调整标题与副标题文案语气，使其更接近“安装引导页”而不是泛预览页。
- 调整卡片顺序、卡片内标题层级、标签位置和按钮显著性，以贴齐冻结图。
- 在不改变业务链路的前提下复用现有同步与请求添加小组件动作。

## 5. Forbidden Actions

- 不得把 `settings-center` 重新扩成安装引导页持有者。
- 不得删除 Widget 预览主体，只保留说明文案。
- 不得把页面改成长文档式说明页。
- 不得借实现便利改写隐私优先级或回流语义。

## 6. Current Code Gap Summary

### gap_01_title_posture

- 现状：页面头部使用 `widgetSettingsTitle / widgetSettingsSubtitle`，语义更偏“Widget 预览”。
- 冻结要求：首屏必须先表达“预览 + 安装 + 同步”。
- 还原动作：保留本地化来源，但页面级标题语气要升级为更强安装导向；若现有国际化 key 不足，需新增专用于 `widget-bridge` 页面头部的文案 key。

### gap_02_preview_card_hierarchy

- 现状：预览卡存在，但视觉权重与动作卡、信息卡接近。
- 冻结要求：预览卡是页面视觉中心。
- 还原动作：提高预览卡内部标题、模式标签和预览框的对比与留白，确保其高于说明卡。

### gap_03_action_card_emphasis

- 现状：同步卡与按钮存在，但说明文案仍偏“fallback”语义；安装按钮只在 Android 显示。
- 冻结要求：主动作区域应明显表达 `Sync Now` 与 `Add to Home Screen`。
- 还原动作：保持 Android 平台条件分支不变，但在支持平台上将“添加到桌面”按钮提升为动作卡核心元素；在不支持平台时保留说明卡承接。

### gap_04_info_card_copy_weight

- 现状：两张信息卡已经存在。
- 冻结要求：信息卡只能是次级辅助，不能压过预览与动作。
- 还原动作：继续保留双信息卡，但控制其文字长度、图标权重和上下间距。

## 7. Region Mapping

| region_id | Flutter ownership | Current widget path | Required restoration |
| --- | --- | --- | --- |
| `install_page_header` | page root content | `_HeaderCard` | 升级标题姿态与副标题长度控制 |
| `install_page_metrics` | content summary | `_WidgetBridgeContent` + `ScreenNoteStatTile` | 保持 3 张指标卡，但收紧标题和数值层级 |
| `install_page_preview_card` | primary visual card | `_WidgetBridgeContent` + `_WidgetPreviewFrame` | 提升为页面视觉主卡 |
| `install_page_action_card` | primary action zone | `_ActionCard` | 调整标题、说明、按钮显著性和间距 |
| `install_page_install_info` | supporting info | `_InfoCard` | 保留为次级安装说明卡 |
| `install_page_privacy_info` | supporting info | `_InfoCard` | 保留为次级隐私说明卡 |

## 8. Scroll And Layout Ownership

- page scaffold: `ListView`
- header ownership: 页面顶部固定内容块
- metric ownership: 页面内第一组卡片
- preview ownership: 页面视觉中心主卡
- action ownership: 预览卡之后的主操作卡
- bottom spacing ownership: 当前由页面 `ListView` padding 承担；后续代码还原时不得额外手工叠加无来源底部留白

## 9. State Presentation Rules

### loading

- 使用现有 `_LoadingCard`
- 只替换主内容区，不替换整个页面头部和说明卡结构

### error

- 使用现有 `_ErrorCard`
- 保留重试入口
- 不要把错误页扩成全屏异常页面

### data

- 保留三段式：指标 -> 预览 -> 动作

## 10. Interaction Ownership

- `sync_now`
  - owner: `_ActionCard`
  - behavior: 继续复用 `widgetBridgeControllerProvider.notifier.syncSnapshot()`
- `request_pin_widget`
  - owner: `_ActionCard`
  - behavior: 继续复用 `settingsCenterControllerProvider.notifier.requestPinWidget(...)`
- `preview_read_only`
  - owner: `_WidgetPreviewFrame`
  - behavior: 只做展示，不新增点击分支

## 11. Fidelity Checkpoints

- checkpoint_01：首屏读感必须先让用户理解“这是安装引导页”，而不是单纯预览页。
- checkpoint_02：预览卡必须明显强于两张信息卡。
- checkpoint_03：动作卡里的主按钮必须成为第二视觉焦点。
- checkpoint_04：隐私说明仍然存在，但只能作为辅助说明出现。
- checkpoint_05：平台能力差异只能影响按钮是否可点，不改变整体页面层级。

## 12. Implementation Boundaries

- 这里只产出还原蓝图，不直接重写页面代码。
- 若后续实现需要变更全局文案、主题值或冻结层级，必须先回到 `flutter-design-source-control`。
