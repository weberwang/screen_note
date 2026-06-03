# Tasks 模块 UI/UX RD

## 0. 文档信息

- 模块名称：`tasks`
- 文档成熟度：`implementation_final`
- 设计冻结状态：`frozen`
- 对应实现文档：[tasks.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/tasks/tasks.impl.md)

## 1. 模块目标与目标用户

- 目标：承载首页主事项、事项详情、编辑保存、完成、删除与恢复前确认，是全产品的第一价值面。
- 目标用户：高频看锁屏且只想快速记住一件最重要事项的人。

## 2. 页面范围与导航入口

- 首页 `Home`
- 事项详情页 `Task Detail`
- 事项编辑页 `Task Editor`
- 首页快速添加弹层 `Quick Add Sheet`

## 3. 核心用户路径

1. 用户进入首页，首屏先看到快速录入条和主事项卡。
2. 用户可直接录入一句提醒，或点入详情 / 编辑补充时间、置顶、隐私与提醒信息。
3. 保存后返回首页，主事项卡与锁屏快照同步更新。
4. 用户完成事项后进入已完成记录；删除则进入最近删除。

## 4. 页面结构与模块组件骨架

- 首页结构：
  - 顶部衬线标题与轻量设置入口
  - `quick_capture_bar`
  - `focus_note_card`
  - `up_next_list`
  - 底部轻导航
- 详情 / 编辑结构：
  - 顶部返回与更多操作
  - 事项标题、时间、提醒模式、备注
  - 隐私与锁屏预览面板
  - 底部 `primary_cta_button`
- 模块私有组件：
  - `task_meta_row`：时间、提醒、列表说明
  - `task_status_chip`：focus / due / private / expired
  - `editor_action_footer`：保存、完成、删除的布局框架
- 复用边界：
  - `focus_note_card` 属于全局共享组件
  - `task_meta_row` 与 `editor_action_footer` 属于模块私有组件，但需在模块内统一复用

## 5. 状态矩阵

| 状态 | 页面 | 规则 |
| --- | --- | --- |
| ideal | 首页、详情、编辑 | 主事项正文绝对优先，主 CTA 明确 |
| empty | 首页 | 快速录入条成为首要引导，主卡退为温和空态 |
| loading | 首页 | 主卡与列表使用暖灰骨架，不闪动 |
| error | 保存失败、加载失败 | 以内联说明或轻 toast 解释，不遮蔽已填内容 |
| permission | 通知未授权 | 只提示能力降级，不阻断保存 |
| partial_data | 快照刷新失败 | 首页数据继续可见，附非阻断提示 |
| disabled | 保存按钮、完成按钮 | 通过对比下降表达不可用，不可消失 |
| success | 保存成功、完成成功 | 短促确认后回到稳定视图 |

## 6. 设计源

- 共享设计包：[03-global-uiux-design-packet.md](D:/Projects/Flutter/screen_note/docs/rd/03-global-uiux-design-packet.md)
- 全局冻结规约：[global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
- 主题冻结：
  - [light-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/light-theme-freeze.yaml)
  - [dark-theme-freeze.yaml](D:/Projects/Flutter/screen_note/docs/rd/dark-theme-freeze.yaml)
- 视觉证据：
  - [preview-home.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-home.png)
  - [preview-detail-privacy.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-detail-privacy.png)

## 7. 设计冻结卡

- 冻结结论：`frozen_module_for_architecture`
- 模块私有组件冻结：
  - `task_meta_row`
  - `task_status_chip`
  - `editor_action_footer`
- 不可变项：
  - 首页单主卡片构图
  - 主事项正文优先于所有标签与说明
  - 详情页必须先完成信息确认，再进入隐私 / 预览，再到保存 CTA
- 允许工程化调整：
  - 编辑页在小屏设备上可合并次级说明行
  - 主卡纸纹与弱阴影可简化
  - 列表区项间距可随屏宽微调

## 8. UI/UX 验收门

- 首页首屏 3 秒内能读懂最重要事项与下一步动作。
- 保存、完成、删除三种行为必须保持清晰优先级，不能并列竞争。
- 隐私模式切换后，锁屏预览反馈必须立即变化。
- 本文档与冻结设计源已可直接供架构映射与代码实现消费。
