# 屏记共享设计包

## primary_taste_source

- `design-taste-frontend`

## selected_supporting_skills

- `gpt-image-2-generator`

## design_packet

### design_brief

- 产品属于轻量高频待办，不做项目管理气质。
- 视觉目标不是“效率工具压迫感”，而是“低负担、持续可见、值得信任的锁屏便签”。
- 共享方向必须优先服务阅读顺序、状态辨识与 CTA 明确度，而不是装饰性。

### platform_baseline

- `ios_hig`
- 默认遵循 iOS 安全区、44pt 触达区、底部导航节奏、分组列表可读性和系统级轻反馈。

### primary_taste_source

- 主导风格：温和编辑感的 iOS 生产力界面。
- 关键词：轻雾白底、深墨层级、克制圆角、低彩度辅助色、重点动作高对比但不刺眼。

### art_direction

- 共享视觉采用“柔和纸面 + 精准数据密度”的方向。
- 标题区可以宽松、留白充足，但任务列表与状态标签必须精确、稳定、强扫描性。
- 页面不依赖大插画；视觉记忆点来自字重对比、卡片节奏和少量语义色。

### taste_constraints

- 禁止紫色默认渐变、厚重玻璃拟态、过量阴影和工具面板堆叠。
- 主要内容层尽量维持单主列，不使用卡片套卡片的层叠。
- 强调“少输入、多看见”，复杂设置默认折叠，主要 CTA 永远位于首屏清晰可见区域。
- 过期、删除、危险行为可见但不惊吓，避免大面积高饱和红。

### information_hierarchy

- 一级：当前最需要处理的任务与快速添加入口。
- 二级：近期完成/近期删除等辅助回看入口。
- 三级：时间、标签、隐私、提醒等属性信息。
- 同屏只能有一个最强 CTA；其余操作收敛为次按钮、图标按钮或列表尾操作。

### cta_posture

- 首页主 CTA 为快速添加。
- 编辑页主 CTA 为保存；删除属于危险尾部操作，不与保存并列争夺注意力。
- 恢复动作在历史页应明确出现，但不盖过记录本身。

### visual_system

- 字体层级：超大标题用于首页与历史页页首；正文和说明文案保持明显对比。
- 表面体系：背景、卡片、轻分隔、选中态四层即可，不做炫技深度。
- 语义色：主色偏深海蓝/蓝绿，成功偏鼠尾草绿，警示偏暖珊瑚/琥珀。
- 图标姿态：线性优先，局部实心仅用于当前激活或关键状态。

### state_matrix

| 状态 | 共享表达 |
| --- | --- |
| ideal | 主任务清晰、列表节奏稳定、CTA 明确 |
| empty | 克制、安静，不制造焦虑 |
| loading | 轻量骨架或占位，避免大面积旋转器 |
| error | 提供可恢复动作，不放大失败感 |
| permission | 给出能力说明与继续使用主链路的方式 |
| partial_data | 优先展示已有快照/最近有效内容 |
| disabled | 通过对比度和填充下降表达不可操作 |
| success | 用低饱和绿色和简短反馈体现完成 |
| locked_or_premium | 允许出现权益入口，但不能打断主任务 |

### component_freeze_scope

- 全局共享组件：主按钮、次按钮、列表卡片、输入框、分组页头、状态标签、设置项行、底部导航宿主。
- 模块私有组件：
  - `task-flow`：任务行、快速添加条、提醒模式区块
  - `history-center`：恢复操作行、空态庆祝卡
  - `widget-bridge`：Widget 布局卡与隐私占位
  - `settings-center`：权益卡、展示样式选择器

### allowed_engineering_adjustments

- 可调整：阴影半径、细粒度间距、系统控件具体实现、动画时长微调。
- 不可调整：主次 CTA 层级、字体梯度、语义色角色、隐私遮挡规则、过期任务在列表中的显著性。

### visual_evidence

- 已生成共享预览：
  - `docs/rd/home-overview.png`
  - `docs/rd/recent-completed.png`
- 缺失但不阻塞模块冻结的页面预览：
  - `task-editor`
  - `recent-deleted`
  - `settings`
- 缺失原因：图像端点在串行重试中出现超时；当前共享文本包与已有预览已足以支持冻结与模块准备。
- 共享参考基准：`home-overview.png`
- 证据模式：`light-mode`

### acceptance_gates

- 共享冻结前必须保留：平台基线、信息层级、视觉系统、全局共享组件定义、Light/Dark 主题冻结文件。
- 模块冻结前必须保留：模块私有组件边界、结构语义、状态矩阵、可调/不可调项。
- 实施前必须保留：Flutter token 映射、显示层决策表、Widget 与通知降级规则。

## freeze_readiness

- `shared_freeze_ready`
- 说明：已有首页与历史页共享视觉证据，文本归一化已覆盖层级、CTA、状态和组件边界，足以进入全局冻结。

## missing_items

- `task-editor`、`recent-deleted`、`settings` 页面静态预览未全部生成
- 这些缺口已记录为补充证据，不阻塞当前 `--auto` 模块准备

## next_skill

- `design-preview-to-global-guidelines`
