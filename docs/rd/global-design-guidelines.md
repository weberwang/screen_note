artifact_type: global_design_guidelines
freeze_status: frozen
source_type: mixed
theme_freeze_files:
  light: light-theme-freeze.yaml
  dark: dark-theme-freeze.yaml

# global-design-guidelines

## design_position

屏记是一款以锁屏持续可见为核心价值的轻量事项产品，UI 必须传达“可靠、安静、可持续回看”，而不是“复杂、忙碌、项目化”的任务管理姿态。

## product_personality

- 气质：克制、干净、有秩序
- 情绪：平静但不冷漠，明确但不强迫
- 密度：列表内容适中偏紧凑，页首与空态保留舒展空间
- 记忆点：超大标题、轻纸感背景、细边分隔、低饱和语义色、干净的任务卡节奏

## target_users_and_core_scenarios

- 目标用户：容易忘小事、频繁点亮手机、不愿维护复杂系统的 iPhone 用户
- 高压场景：出门前、工作切换间隙、睡前提醒、短时高频回看
- 核心优化点：3 秒录入、重要任务高可见、误删可恢复、隐私事项不泄露

## global_experience_principles

- 先可见，后管理
- 先可靠，后丰富
- 先轻量，后个性化
- 隐私高于便利
- 降级不阻断主链路

## information_hierarchy_principles

- 首页首屏只允许一个最高优先级动作位，即快速添加或当前主任务
- 过期且未完成事项必须比普通未来事项更显眼
- 辅助入口如最近完成、最近删除应清晰可达，但不能抢占主任务焦点
- 属性信息采用“标题 -> 时间/标签 -> 辅助动作”的固定扫描顺序

## layout_and_page_structure_principles

- 常规页面使用单主列结构，顶部标题区与内容区层次分明
- 列表页采用轻卡片或分组行，不叠加复杂嵌套面板
- 设置页使用分组面板，但每组只承载一个清晰主题
- 空态采用大留白 + 单一说明，不引入过度插画堆叠

## component_system_principles

- 重复出现的按钮、输入框、设置行、任务卡、状态标签必须遵循统一尺寸与状态规则
- 全局共享组件优先服务可读性与稳定交互，不为单页装饰特殊变体
- 允许模块私有组件存在，但必须明确不提升为全局共享层

## global_public_component_freeze

- 冻结的全局组件族：
  - 主按钮
  - 次按钮
  - 输入框
  - 任务/设置基础卡片
  - 分组标题行
  - 状态标签
  - 底部导航宿主
- 全局允许状态：
  - 默认、按下、禁用、选中、危险、成功反馈
- 不可变项：
  - 主按钮高对比主色
  - 文本层级
  - 卡片圆角区间
  - 任务行的信息顺序
  - 隐私场景的正文遮挡原则
- 允许工程调整：
  - 阴影强度微调
  - 分割线透明度微调
  - iOS 原生控件映射差异
- 明确不属于全局层的组件：
  - Widget 专用布局容器
  - 历史页空态庆祝卡
  - 会员权益卡
  - 提醒模式说明块

## interaction_behavior_principles

- 主 CTA 需始终稳定可定位，不使用漂浮随机位置
- 危险行为采用清晰文案与低频触发，不与主 CTA 同视觉等级
- 历史页恢复动作要直观可达，但不遮蔽记录内容
- 切换、开关和样式选择器应使用系统熟悉交互，不自创复杂手势

## state_and_feedback_principles

- Loading：优先轻骨架或上次有效快照，不使用压迫式遮罩
- Empty：克制、柔和、可鼓励，但不制造生产力羞耻
- Error：给出“继续主链路/稍后重试”的清晰路径
- Permission：强调“能力增强缺失”而非“功能不可用”
- Success：完成反馈短促、低饱和、不过度庆祝

## content_and_copy_principles

- 文案短、准、可扫读
- 首页与历史页标题可带一点温度，但交互按钮保持功能导向
- 辅助说明只解释当前操作后果，不写冗长教育文案
- 危险提示强调结果边界，如“仅软删除，可在最近删除中恢复”

## visual_system_rules

- 字体梯度：超大标题 > 分组标题 > 列表标题 > 属性文案 > 辅助说明
- 对比策略：正文与背景始终保证高可读比；次级文字可柔和但不可发灰失读
- CTA 策略：主 CTA 使用深蓝/蓝绿高对比实底；次 CTA 以描边或浅底承接
- 间距策略：页首宽松，列表节奏均匀，设置页分组内紧外松
- 表面策略：背景、卡片、轻 elevated 面、反色面四层即可
- 图标策略：线性优先，激活或关键状态允许实心强化
- 动效角色：只用于状态确认与层级过渡，不做大幅炫技

## light_theme_rationale

Light 主题选择暖白背景与深墨文本，保证长时间查看锁屏类信息时不刺眼，同时维持足够层级差。主动作使用稳定的深蓝，既像系统可信动作，又能与过期/警示色区分。

## dark_theme_rationale

Dark 主题不做简单反相，而是保留语义分层：深背景、略抬起的表面、受控的高亮主色与柔和文字梯度，避免 OLED 纯黑导致的层级塌陷与眩光。

## shared_visual_evidence_index

- 已确认的全局 light-mode 共享证据：
  - `docs/rd/home-page-light-refresh-v2.png`
  - `docs/rd/task-editor-refresh-v1.png`
  - `docs/rd/settings-center-refresh-v1.png`
- 对应模块侧证据：
  - `docs/rd/modules/task-flow/home-page-light-refresh-v2.png`
  - `docs/rd/modules/task-flow/task-editor-refresh-v1.png`
  - `docs/rd/modules/settings-center/settings-center-refresh-v1.png`
- 证据使用规则：
  - `home-page-light-refresh-v2.png` 继续作为全局方向锚点。
  - `task-editor-refresh-v1.png` 与 `settings-center-refresh-v1.png` 仅用于补齐冻结所需的表单、分组设置和共享组件证据，不重新定义视觉世界。

## design_prohibitions

- 不得把主 CTA 改成低对比文本按钮
- 不得把过期任务的显著性弱化到与普通任务同级
- 不得在隐私模式下展示事项正文
- 不得用高饱和渐变替代语义主色
- 不得把全局共享组件变体无限扩张为页面特例

## engineering_guardrails

- 必须忠实保留：字体层级、任务行信息顺序、主次 CTA 层级、隐私遮挡规则、语义色角色
- 可 Flutter 化：阴影、模糊、轻材质、切换反馈、部分列表分隔实现
- 需要设计回滚后才能改：主题主色家族、空态姿态、底部导航结构、Widget 隐私占位表达

## downstream_reference_index

- `flutter-design-freeze-gate`
  - 必引：`information_hierarchy_principles`、`global_public_component_freeze`、`visual_system_rules`、两份 theme freeze 文件
- `flutter-rd-module-splitter`
  - 必引：`layout_and_page_structure_principles`、`component_system_principles`、`interaction_behavior_principles`
- `flutter-uiux-to-architecture`
  - 必引：`visual_system_rules`、`engineering_guardrails`、两份 theme freeze 文件
- `flutter-design-source-control`
  - 必引：整份 guideline 与两份 theme freeze 文件
- `flutter-design-parity-reviewer`
  - 必引：`information_hierarchy_principles`、`state_and_feedback_principles`、`design_prohibitions`
