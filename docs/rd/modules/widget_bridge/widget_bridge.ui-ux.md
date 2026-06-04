# Widget Bridge 模块 UI/UX RD

## 0. 文档信息

- 模块名称：`widget_bridge`
- 文档成熟度：`implementation_final`
- 设计冻结状态：`frozen`
- 对应实现文档：[widget_bridge.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget_bridge/widget_bridge.impl.md)

## 1. 模块目标与目标用户

- 目标：把应用内最重要事项稳定映射到锁屏 / Widget 展示，且在失败时可解释降级。
- 目标用户：频繁看锁屏、依赖持续可见提醒的人。

## 2. 页面范围与导航入口

- 锁屏 / Widget 预览卡
- 展示模式选择
- 刷新说明与能力降级说明

## 3. 核心用户路径

1. 用户在设置或详情页查看当前锁屏预览。
2. 切换展示模式或隐私状态时，预览立即反馈。
3. 刷新失败时保留最后有效快照，并解释边界。

## 4. 页面结构与模块组件骨架

- 结构：
  - 预览主卡
  - 展示模式选择器
  - 刷新状态说明
  - 安装引导 / 能力说明
- 模块私有组件：
  - `widget_preview_frame`
  - `display_mode_selector`
  - `snapshot_status_hint`
- 复用边界：
  - 预览主卡需继承共享 `focus_note_card` 语言
  - 展示模式与刷新说明属于模块私有

## 5. 状态矩阵

| 状态 | 页面 | 规则 |
| --- | --- | --- |
| ideal | 预览页 | 预览卡与应用内主事项视觉同源 |
| loading | 读取展示模式 | 仅局部骨架，不阻断页面 |
| error | 刷新失败 | 保留最后有效内容并解释失败 |
| partial_data | 仅快照可读 | 强调展示降级，不暗示数据丢失 |
| permission | 系统能力受限 | 用说明卡解释而非报错页 |
| success | 更新展示模式成功 | 预览即时变更 |

## 6. 设计源

- 共享设计包：[03-global-uiux-design-packet.md](D:/Projects/Flutter/screen_note/docs/rd/03-global-uiux-design-packet.md)
- 全局冻结规约：[global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
- 视觉证据：
  - [preview-home.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-home.png)
  - [preview-detail-privacy.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-detail-privacy.png)

## 7. 设计冻结卡

- 冻结结论：`frozen_module_for_architecture`
- 模块私有组件冻结：
  - `widget_preview_frame`
  - `display_mode_selector`
  - `snapshot_status_hint`
- 不可变项：
  - 预览卡必须可识别为应用内主事项卡同一家族
  - 隐私模式切换必须直接体现在预览反馈中
  - 刷新失败只能降级展示，不得表现为数据消失
- 允许工程化调整：
  - 预览框可用 Flutter 原生绘制替代真实设备壳
  - 刷新说明可折叠为次级提示区

## 8. UI/UX 验收门

- 用户能直接看懂当前锁屏会显示什么。
- 展示模式切换前后差异必须立即可见。
- 降级提示必须建立信任，而不是制造恐慌。
