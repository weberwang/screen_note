# Settings 模块 UI/UX RD

## 0. 文档信息

- 模块名称：`settings`
- 文档成熟度：`implementation_final`
- 设计冻结状态：`frozen`
- 对应实现文档：[settings.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings/settings.impl.md)

## 1. 模块目标与目标用户

- 目标：收口隐私、Widget 展示模式、系统能力说明与设置导航，不让设置页退化成系统模板页。
- 目标用户：需要理解权限、隐私和展示模式边界的人。

## 2. 页面范围与导航入口

- 设置首页
- 隐私设置页
- Widget 设置页

## 3. 核心用户路径

1. 用户从首页设置入口进入设置页。
2. 在隐私页查看“锁屏显示什么”与“隐藏后如何表现”。
3. 在 Widget 页调整展示模式、查看安装或刷新说明。

## 4. 页面结构与模块组件骨架

- 设置首页结构：
  - 标题
  - 分组卡片
  - 功能入口行
- 隐私 / Widget 子页结构：
  - 顶部说明
  - 对应设置行
  - 预览或说明面板
- 模块私有组件：
  - `settings_group`
  - `settings_tile`
  - `capability_explain_card`
- 复用边界：
  - `settings_toggle_row` 为共享组件
  - 分组与能力说明卡为模块私有

## 5. 状态矩阵

| 状态 | 页面 | 规则 |
| --- | --- | --- |
| ideal | 设置首页、隐私页、Widget 页 | 信息清晰分组，主任务不埋没 |
| loading | 读取本地配置 | 仅局部占位 |
| error | 保存设置失败 | 内联解释，不丢当前选择 |
| permission | 系统能力不可用 | 解释边界与替代路径 |
| partial_data | 仅部分能力可读 | 继续展示可用设置项 |
| success | 保存成功 | 轻量反馈，不跳页 |

## 6. 设计源

- 共享设计包：[03-global-uiux-design-packet.md](D:/Projects/Flutter/screen_note/docs/rd/03-global-uiux-design-packet.md)
- 全局冻结规约：[global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
- 视觉证据：
  - [preview-home.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-home.png)
  - [preview-detail-privacy.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-detail-privacy.png)

## 7. 设计冻结卡

- 冻结结论：`frozen_module_for_architecture`
- 模块私有组件冻结：
  - `settings_group`
  - `settings_tile`
  - `capability_explain_card`
- 不可变项：
  - 设置页必须继承纸面容器语言，不可退回系统模板列表
  - 隐私设置必须提供可理解的预览或结果说明
  - 权限或能力不足时要解释降级，不得使用阻断恐吓式提示
- 允许工程化调整：
  - 分组卡可在信息较少时简化成统一容器
  - 说明面板可折叠为二级帮助区

## 8. UI/UX 验收门

- 用户必须能读懂设置行为会影响哪里。
- 隐私、Widget 和能力说明需要形成一致的解释语气。
- 子页之间不得脱离主产品视觉系统。
