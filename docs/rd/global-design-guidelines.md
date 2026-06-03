```yaml
artifact_type: global_design_guidelines
freeze_status: frozen
source_type: multi_screen_pack
theme_freeze_files:
  light: light-theme-freeze.yaml
  dark: dark-theme-freeze.yaml
```

## design_position

- 产品姿态：`Screen Note` 是一个面向高频锁屏场景的轻量提醒工具，核心不是管理大量任务，而是让最重要的一句话在最需要的时刻持续被看见。
- 体验承诺：界面必须同时传达“持续可见”“记录无负担”“隐私可控”“恢复可信”四件事。
- 风格定位：暖纸感效率工具。它不是系统设置页，不是科技仪表盘，也不是装饰化便签品牌页。

## product_personality

- 语气：安静、可信、克制、温和。
- 密度：偏稀疏，留白显著大于常规效率 App。
- 信心感：重点动作明确，但不高声叫卖。
- 稳定记忆点：
  - 暖米白纸面背景
  - 深橄榄主卡片 / 主操作
  - 陶土色局部强调
  - 衬线大标题 + 无衬线功能文字
  - 纸边、票据、手写感缩略图带来的轻生活物件感

## target_users_and_core_scenarios

- 目标用户：
  - 容易忘事、但不愿维护复杂待办系统的人
  - 高频查看锁屏、需要被动看见提醒的人
  - 在公开场景里重视隐私降级的人
- 核心场景：
  - 出门前核对证件、资料、快递
  - 临时写下一件必须完成的小事
  - 在锁屏与 Widget 上持续看见当前最高优先级事项
  - 打开隐私模式后仍确认“有提醒存在”，而不是完全丢失感知
- 优化目标：
  - 3 秒内读懂当前最重要事项
  - 1 次主动作完成新增或保存
  - 在权限降级、快照失败、通知失败时仍保留信任

## global_experience_principles

- 任何页面都要优先回答“现在最重要的那件事是什么”。
- 新增、保存、完成这些主动作必须安静但明确，不允许和删除、更多操作竞争。
- 隐私模式只降低暴露，不降低用户对事项状态的掌控感。
- 锁屏、小组件、应用内详情要属于同一体验闭环，不允许割裂成两套产品。
- 降级能力必须可解释：通知失败、快照失败、权限未开都只能影响增强能力，不能表现得像数据丢失。

## information_hierarchy_principles

- 第一阅读层永远是事项正文或当前事项摘要。
- 第二阅读层是时间、重复信息、状态标签与隐私说明。
- 第三阅读层是历史入口、辅助操作、系统解释和非阻断提示。
- 首页与锁屏必须只允许一个绝对主焦点，不做多卡片同权重争抢。
- 历史页可以有列表，但每一行仍以一句正文为主，不得退化为表格化任务管理界面。
- 主 CTA 必须始终比次级文字动作更先被看见，且保持足够点击面积。

## layout_and_page_structure_principles

- 页面骨架：
  - 顶部保留明显呼吸感的大标题区
  - 中段用纸面卡片或面板承载主任务内容
  - 底部放置主 CTA、底栏或轻量导航，但视觉权重要低于主内容卡
- 首页结构：
  - 快速录入条在主卡片前，用于承接“立即记下”
  - 主事项卡占据首屏最大视觉面积
  - 次级事项以轻列表方式衔接
- 历史页结构：
  - 顶部标题 + 过滤分段
  - 中段用纸边分隔完成与删除区块
  - 每个历史卡带缩略图、时间、弱化操作与状态动作
- 详情 / 隐私页结构：
  - 先确认事项内容与时间
  - 再确认锁屏预览与隐私模式
  - 最后落到底部强主 CTA
- 设置类页面必须延续纸面容器语言，不能回退成系统原生白底分组列表。

## component_system_principles

- 全局组件家族：
  - `focus_note_card`
  - `quick_capture_bar`
  - `history_note_row`
  - `privacy_preview_card`
  - `primary_cta_button`
  - `segmented_filter_group`
  - `settings_toggle_row`
  - `top_icon_action`
  - `bottom_navigation_shell`
- 复用要求：
  - 锁屏快照卡片与应用内主事项卡必须共享同一视觉语义
  - 历史页卡片是主事项卡的降权家族成员，不允许重新发明另一套列表系统
  - 预览、隐私和 Widget 相关面板要复用同一圆角、边框和弱阴影规则
- 全局允许变体：
  - `focus_note_card`: `active`、`expired`、`private`
  - `primary_cta_button`: `enabled`、`pressed`、`disabled`
  - `history_note_row`: `completed`、`deleted`
  - `segmented_filter_group`: `selected`、`default`
  - `settings_toggle_row`: `on`、`off`、`disabled`

## global_public_component_freeze

- 属于共享全局系统的组件：
  - `focus_note_card`
  - `quick_capture_bar`
  - `history_note_row`
  - `privacy_preview_card`
  - `primary_cta_button`
  - `segmented_filter_group`
  - `settings_toggle_row`
  - `top_icon_action`
  - `bottom_navigation_shell`
- 全局冻结状态与变体：
  - `focus_note_card` 只允许 `active`、`expired`、`private`
  - `history_note_row` 只允许 `completed`、`deleted`
  - `primary_cta_button` 只允许实底主色按钮，不允许局部改成描边主按钮
  - `privacy_preview_card` 必须同时展示“隐藏内容 / 显示内容”对照或等价降级反馈
  - `segmented_filter_group` 必须保留单选分段语义，不得改成堆叠标签墙
- 不可变项：
  - 暖纸背景 + 深橄榄主焦点 + 陶土强调的语义分工
  - 大标题的衬线识别性
  - 首页单主卡片构图
  - 历史页纸边区块分割
  - 隐私模式的对照式预览反馈
- 允许工程化调整：
  - 弱化纸纹、手写缩略图的颗粒细节
  - 简化极细阴影和环境装饰
  - 基于设备宽度微调间距与字号档位
- 明确不属于共享全局层的内容：
  - 各模块内部的业务表单细节
  - 模块私有的状态提示文案布局
  - 后续为实现需要新增的局部业务控件

## interaction_behavior_principles

- 主按钮必须始终先于更多操作、删除和返回被识别。
- 返回、关闭和更多操作保持小尺寸、线性图标、弱对比，不与主内容争焦点。
- 快速录入优先采用一跳输入或轻量弹层，不进入冗长表单。
- 隐私模式开关切换后，需要立刻反馈锁屏预览变化。
- 删除属于破坏性操作，只能在清楚上下文里出现，且颜色与位置都应降级。
- 历史页的恢复、查看、删除动作必须服务于“回收与追溯”，不能转化成密集操作面板。

## state_and_feedback_principles

- `ideal`：主事项卡清晰、留白充足、时间与状态低位陪衬。
- `loading`：使用低对比暖灰骨架，不做闪烁动画。
- `empty`：维持纸面语言，但把焦点转向“如何添加第一条提醒”。
- `disabled`：通过明确对比下降表达不可用，不能靠过度透明导致不可识别。
- `success`：保存、完成、恢复采用短促轻反馈，不打断阅读节奏。
- `warning`：过期、恢复窗口、权限提醒用陶土或暖橙，不使用高压警报红。
- `error`：以内联说明、轻 toast 或解释面板表达，不允许整屏错误气氛。
- `permission` 与 `partial_data`：必须解释当前降级边界，并强调数据仍在本地或最后快照仍有效。

## content_and_copy_principles

- 文案语气：简短、可信、不说教。
- 标题与按钮文案优先使用动作或结果导向短语，例如“Add reminder”“Save reminder”“Restore”。
- 说明文案只在隐私、权限、刷新失败、通知失败等需要解释边界时出现。
- 空态文案应引导下一步，不描述系统“什么都没有”。
- 警告文案必须解释影响范围，例如“锁屏仅显示摘要，不显示完整内容”。

## visual_system_rules

- 排版：
  - 首页、历史页、详情页的大标题必须保持高识别度衬线气质
  - 功能正文、标签、说明和元信息保持现代无衬线
  - 主事项正文优先级高于所有标签、状态和说明
- 对比：
  - 正文与背景、正文与主卡片、按钮文字与按钮底色必须维持高可读性
  - CTA 对比必须服务操作清晰度，而不是装饰
- 间距：
  - 以 8pt 为基底节奏，但主事项卡与详情预览区必须采用更大跨度留白
  - 页面顶部、大模块间距、卡片内边距要保持稳定
- 表面：
  - 使用暖纸面、弱阴影、轻边框和纸边分隔
  - 禁止玻璃、高模糊、高镜面反射
- 图标：
  - 线性、轻描边、尺寸克制
- 动效：
  - 只承担卡片进入、保存反馈、开关反馈与预览切换
- 装饰限制：
  - 纸纹、缩略图、植物或器物环境只承担温度感，不得压过内容
  - 不允许把小票、图钉、装饰元素扩张成主角

## light_theme_rationale

- 亮色主题采用暖米白与浅纸面层次，是因为产品核心场景是高频短时查看，必须在大多数日间环境下显得轻松可读。
- 首页主卡和底部主按钮都采用深橄榄，是为了把“当前最重要事项”和“立即确认 / 保存”统一到同一稳定语义。
- 陶土色只承担次级强调、风险提示和局部动作高光，避免与主 CTA 抢权重。
- 历史页需要多个列表单元，因此亮色表面要比首页更轻，让卡片、分隔和缩略图自己建立节奏。

## dark_theme_rationale

- 深色主题不是亮色反相，而是把暖纸感转译为夜间低照度下仍可信的暖暗纸面系统。
- 背景要维持偏橄榄炭黑，而不是冷蓝黑，这样才能保留白天体系的温度与生活物件感。
- 深色卡片需要只比背景亮一到两层，不能亮到与主事项卡竞争。
- CTA 与主卡片在深色下适度提亮，但不能霓虹化，也不能让陶土强调变成高压危险色。

## design_prohibitions

- 禁止把全局主色替换成任意渐变、荧光色或科技蓝。
- 禁止把主事项卡弱化成普通列表 cell。
- 禁止让首页、锁屏、小组件分别采用不同主视觉语言。
- 禁止把设置页重新做成系统默认白底分组列表。
- 禁止为了实现方便删除隐私预览与降级反馈。
- 禁止在局部页面擅自提高信息密度，破坏“单条重要事项先被看见”的原则。
- 禁止把衬线标题整体替换成通用系统无衬线，导致识别度消失。

## engineering_guardrails

- 可以工程化简化：
  - 纸面噪点颗粒
  - 缩略图中的装饰性手写细节
  - 极细阴影与环境物件背景
- 必须忠实保留：
  - 主次层级顺序
  - 首页单主卡片构图
  - 橄榄绿 / 暖纸白 / 陶土色的语义分工
  - 标题衬线识别性与正文无衬线的组合
  - 隐私模式的展示降级原则
- 需要回退设计确认后才能改动：
  - 组件家族新增新的全局主视觉
  - 主题角色值整体换色
  - 首页或锁屏从单主卡片转为多卡片竞争布局
  - 隐私预览从对照式反馈改成隐藏式单状态反馈

## downstream_reference_index

- `flutter-design-freeze-gate`
  - 必须引用：`global_public_component_freeze`、`state_and_feedback_principles`、`visual_system_rules`
  - 必须验证文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `flutter-rd-module-splitter`
  - 必须引用：`layout_and_page_structure_principles`、`component_system_principles`、`global_public_component_freeze`
  - 必须继承文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `flutter-uiux-to-architecture`
  - 必须引用：`component_system_principles`、`interaction_behavior_principles`、`visual_system_rules`
  - 必须映射文件：`light-theme-freeze.yaml`、`dark-theme-freeze.yaml`
- `flutter-design-source-control`
  - 必须把本文件与两份主题冻结文件加入冻结源优先级
- `flutter-design-parity-reviewer`
  - 必须按本文件相关章节和两份主题冻结文件检查实现一致性
