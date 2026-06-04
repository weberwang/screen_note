# Quick Add 模块 UI/UX RD

## 0. 文档信息

- 模块名称：`quick_add`
- 文档成熟度：`implementation_final`
- 设计冻结状态：`frozen`
- 对应实现文档：[quick_add.impl.md](D:/Projects/Flutter/screen_note/docs/rd/modules/quick_add/quick_add.impl.md)

## 1. 模块目标与目标用户

- 目标：把新增事项压缩为最短路径，同时承接系统快捷入口回流。
- 目标用户：临时想到一件事时不愿进入完整编辑流程的人。

## 2. 页面范围与导航入口

- 首页快速录入条
- 快速添加页
- 快速添加底部弹层

## 3. 核心用户路径

1. 用户在首页或系统入口触发快速添加。
2. 先输入一句正文，再按需补充默认时间或隐私开关。
3. 保存成功后回流首页或目标详情。

## 4. 页面结构与模块组件骨架

- 主结构：
  - `quick_capture_bar`
  - 草稿输入区域
  - 默认选项行
  - 非阻断错误提示
  - 主 CTA
- 模块私有组件：
  - `quick_add_source_chip`
  - `quick_add_default_option_row`
  - `quick_add_non_blocking_hint`
- 复用边界：
  - 顶部输入条复用共享 `quick_capture_bar`
  - 选项行与来源 chip 为模块私有

## 5. 状态矩阵

| 状态 | 页面 | 规则 |
| --- | --- | --- |
| ideal | 快速添加页 / 弹层 | 一屏完成输入与保存 |
| empty | 初始输入 | 提示立即录入，不堆说明 |
| error | 输入不合法 / 保存失败 | 非阻断提示，不清空草稿 |
| disabled | 保存按钮不可点 | 通过对比下降表达 |
| success | 保存成功 | 立刻关闭并回流 |
| permission | 系统入口回流失败 | 提示能力降级，允许改走 App 内录入 |

## 6. 设计源

- 共享设计包：[03-global-uiux-design-packet.md](D:/Projects/Flutter/screen_note/docs/rd/03-global-uiux-design-packet.md)
- 全局冻结规约：[global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/rd/global-design-guidelines.md)
- 视觉证据：
  - [preview-home.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-home.png)
  - [preview-detail-privacy.png](D:/Projects/Flutter/screen_note/output/design-previews/2026-06-03-screen-note-gpt2/preview-detail-privacy.png)

## 7. 设计冻结卡

- 冻结结论：`frozen_module_for_architecture`
- 模块私有组件冻结：
  - `quick_add_source_chip`
  - `quick_add_default_option_row`
  - `quick_add_non_blocking_hint`
- 不可变项：
  - 快速添加必须比完整编辑更短路径
  - 输入条与保存按钮必须在一屏内建立完整主链路
  - 错误提示不能压过输入本身
- 允许工程化调整：
  - 系统入口回流时可用全屏页替代底部弹层
  - 默认选项行可在小屏折叠为二级展开区

## 8. UI/UX 验收门

- App 内快速添加不得比完整编辑更复杂。
- 保存成功后的回流目标必须稳定可预期。
- 草稿丢失、权限失败或入口失败都只能降级，不能中断新增主链路。
