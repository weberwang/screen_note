```yaml
artifact_type: global_design_guidelines
freeze_status: frozen
source_type: multi_screen_pack
theme_freeze_files:
  light: light-theme-freeze.yaml
  dark: dark-theme-freeze.yaml
```

## design_position

- 产品姿态：`Screen Note` 是一个面向高频锁屏场景的轻量提醒工具，核心不是管理大量任务，而是让最重要的一句话在最需要的时刻被看见。
- 体验承诺：界面必须同时传达“持续可见”“记录无负担”“隐私可控”三件事。
- 风格定位：暖纸感效率工具，而不是默认系统表单页，也不是高压科技感效率仪表盘。

## product_personality

- 语气：安静、可信、克制、温和。
- 视觉约束：不炫技、不浮夸、不做大面积高饱和渐变。
- 记忆点：
  - 便签纸与图钉的轻拟物化表达
  - 暖米白背景和纸面层次
  - 低饱和橄榄绿主操作与轻陶土提醒色
- 密度：偏稀疏，允许留白明显大于默认设置页。

## target_users_and_core_scenarios

- 目标用户：
  - 容易忘事、但只想快速记一句话的人
  - 高频查看锁屏、希望一眼获得提醒的人
  - 在公开场景里关注隐私暴露风险的人
- 核心场景：
  - 出门前核对证件、快递、资料、合同
  - 临时记录一条需要在锁屏持续可见的提醒
  - 打开隐私模式后仍需确认“有提醒存在”而不是完全失去提醒
- 优化目标：
  - 3 秒内读懂当前最重要事项
  - 1 次操作内完成新增
  - 在权限降级或 Widget 失败时仍保持信任

## global_experience_principles

- 任何页面都要优先回答“现在最重要的那件事是什么”。
- 新增、确认、完成这些主动作必须安静但明确，不允许和删除、更多操作竞争。
- 隐私模式只降低内容暴露，不降低用户对状态的掌控感。
- 锁屏、小组件、应用内详情要属于同一体验闭环，不允许互相割裂。
- 降级能力必须可解释：通知失败、快照失败、权限未开都只能影响增强能力，不能像数据丢失。

## information_hierarchy_principles

- 第一阅读层永远是便签正文或当前事项摘要。
- 第二阅读层是提醒时间、重复信息、状态标签与隐私说明。
- 第三阅读层是辅助操作、入口、帮助文案与系统解释。
- 首页与锁屏必须只允许一个绝对主焦点，不做多卡片同权重争抢。
- 历史页允许多卡片列表，但每张卡片仍需以一句正文为主，不得退化为表格化清单。

## layout_and_page_structure_principles

- 页面骨架：
  - 顶部保留呼吸感足够的标题区
  - 中部以纸面卡片承载主内容
  - 底部放置主操作或底部导航，但视觉权重要低于主卡片
- 留白策略：
  - 外边距与区块间距均宽于默认 iOS 表单页
  - 卡片内部使用大块留白保证一句话内容在远距离下也易读
- 分层策略：
  - 背景是最轻的暖米白底
  - 纸面卡片高于背景
  - 弹层、底部面板、设置分组高于卡片列表层
- 历史页与设置页必须延续纸面语言，不能回退成纯白列表拼接。

## component_system_principles

- 全局组件家族：
  - `sticky_note_card`
  - `history_note_row`
  - `primary_cta_button`
  - `secondary_panel`
  - `setting_toggle_row`
  - `privacy_preview_card`
- 组件复用要求：
  - 锁屏快照卡片与应用内主便签卡必须共享同一视觉比例和文字层级
  - 历史页卡片是主便签卡的降权版，不允许重新发明另一套卡片语言
  - 设置页开关、时间选择、重复选择需复用统一输入容器，而不是裸露系统 cell
- 全局允许变体：
  - `sticky_note_card` 可有 normal、expired、private 三种展示变体
  - `primary_cta_button` 可有 enabled、pressed、disabled 三种交互变体
  - `setting_toggle_row` 可有 default、selected、disabled 三种状态

## interaction_behavior_principles

- 主按钮必须总是比次级文字操作更先被看见，但不能像广告按钮一样跳脱。
- 返回、关闭和更多操作保持线性图标、小尺寸、弱对比，不与主内容争焦点。
- 隐私模式开关切换后，需要立即给出锁屏预览变化作为反馈。
- 删除属于破坏性操作，只能在详情页或明确的上下文里出现，颜色和位置都必须降级。
- 快速添加入口要尽量短路径，优先采用弹层或简洁编辑面板，而不是进入复杂表单。

## state_and_feedback_principles

- `ideal`：主便签卡清晰、留白充足、提醒信息低位陪衬。
- `loading`：使用低对比暖灰骨架，不做闪烁动画。
- `empty`：维持纸面语言，但焦点从“卡片内容”转为“如何添加第一条提醒”。
- `disabled`：按钮和输入都通过对比度下降体现不可用，不能靠透明度过低导致不可辨认。
- `success`：保存、完成、恢复采用短暂轻提示，不破坏整体安静感。
- `warning`：到期、过期、恢复窗口等使用陶土色或暖橙提示，而不是警报红泛滥。
- `error`：错误反馈以内联说明、轻 toast 或说明卡片表达，不允许全页红底。
- `permission` 与 `partial_data`：必须解释当前降级原因，并强调数据仍在本地、最后快照仍有效。

## content_and_copy_principles

- 文案语气：简短、可信、不说教。
- 标题与按钮文案优先使用动词或结果导向短语，例如“添加提醒”“保存便签”“恢复”。
- 说明文案只在需要解释权限、隐私或降级时出现，平时不堆长段帮助文本。
- 空态文案要强调下一步，而不是描述系统无数据。
- 告警文案要解释影响边界，例如“锁屏仅显示摘要，不显示完整内容”。

## visual_system_rules

- 排版：
  - 主标题与便签正文要形成明显对比，正文优先级高于所有标签和说明
  - 标题区可带轻书写或衬线气质，但功能标签保持现代无衬线
- 间距：
  - 以 8pt 为基底节奏，但主卡片内部采用更大跨度留白
  - 区块之间的垂直节奏要稳定，不能每屏各自漂移
- 表面：
  - 优先使用纸面感、弱阴影和细微材质，而不是玻璃、高反射或强模糊
- 图标：
  - 线性、细描边、尺寸克制
- 动效：
  - 只承担保存反馈、层级切换、开关状态反馈与卡片出现
- 装饰限制：
  - 纸纹和环境光只能服务于温度感，不能盖过内容
  - 禁止把图钉、纸张边缘和背景摆件扩张成主角

## light_theme_rationale

- 亮色主题以暖米白和浅纸面层次为底，是因为产品主要使用场景发生在日间高频查看与短时确认。
- 亮色主背景不能纯白，否则会丢失纸感与安静温度；也不能偏黄过度，否则会让功能页显脏。
- 主色选择橄榄绿，是因为它兼具确认感、稳定感和生活物件感，比饱和蓝更适合该产品的“提醒但不压迫”定位。
- 陶土色只承担提醒、时间、恢复等次强调角色，不抢走主按钮和正文的注意力。

## dark_theme_rationale

- 深色主题不是亮色的反相版，而是把纸感转译为“夜间低照度下仍可信的暖暗纸面”。
- 深色背景必须保持偏橄榄炭黑，而不是冷蓝黑，这样才能维持 `style-01` 的温和属性。
- 深色卡片需要比背景更亮一层，但不能做成高反差悬浮面板，否则会破坏锁屏与夜间查看的安静感。
- 强调色在深色下适度提亮，但不允许出现霓虹化或刺眼橙色。

## design_prohibitions

- 禁止把全局主色替换成任意渐变、荧光色或科技蓝。
- 禁止把主便签卡弱化成普通列表 cell。
- 禁止让首页、锁屏、小组件分别采用不同主视觉语言。
- 禁止把设置页重新做成系统默认白底分组列表。
- 禁止为了实现方便删除隐私预览与降级反馈。
- 禁止在局部页面擅自提高信息密度，破坏“单条重要事项先被看见”的全球原则。

## engineering_guardrails

- 可以工程化简化：
  - 纸面噪点颗粒
  - 极细阴影与环境摆件
  - 展示图里的摄影光影背景
- 必须忠实保留：
  - 主次层级顺序
  - 主卡片比例与留白
  - 橄榄绿 / 暖米白 / 陶土色的语义分工
  - 隐私模式的展示降级原则
- 需要回退设计确认后才能改动：
  - 组件家族新增新的全局主视觉
  - 主题角色值整体换色
  - 首页或锁屏从单主卡片转为多卡片竞争布局

## downstream_reference_index

- `flutter-design-freeze-gate`
  - 必须引用：`design_position`、`state_and_feedback_principles`、`visual_system_rules`
  - 必须验证文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `design-preview-to-pen`
  - 必须引用：`layout_and_page_structure_principles`、`component_system_principles`、`visual_system_rules`、`design_prohibitions`、`engineering_guardrails`
  - 必须继承文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `flutter-pen-to-architecture`
  - 必须引用：`component_system_principles`、`interaction_behavior_principles`、`visual_system_rules`
  - 必须映射文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `flutter-design-source-control`
  - 必须把本文件与两份主题冻结文件加入冻结源优先级
- `flutter-design-parity-reviewer`
  - 必须按本文件相关章节和两份主题冻结文件检查实现一致性
