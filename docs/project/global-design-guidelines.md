---
artifact_type: global_design_guidelines
freeze_status: frozen
source_type: preview_comp
platform_identifier: ios_device
module_preview_policy:
  module_refinement_default: no_generate
  generated_module_preview_paths:
    - docs/project/modules/task-flow/task-flow-home.png
    - docs/project/modules/task-flow/task-flow-editor.png
    - docs/project/modules/history-center/history-center-history.png
    - docs/project/modules/settings-center/settings-center-settings.png
    - docs/project/modules/widget-bridge/widget-bridge-priority-widget.png
    - docs/project/modules/widget-bridge/widget-bridge-private-widget.png
theme_freeze_files:
  light: light-theme-freeze.yaml
  dark: dark-theme-freeze.yaml
---

## design_position

屏记是一款锁屏优先的轻量防忘事项产品，不是复杂任务管理平台。它的体验承诺是：用最低进入成本记录一件重要小事，并在最容易被用户看见的位置持续提醒，直到被完成或主动处理。共享设计应让“当前最重要事项”成为视觉与交互中心，而不是让用户先理解系统结构。当前冻结方向允许主事项卡片带有轻微温和纸感，以增强亲近感与记忆锚点，但不允许滑向强便签隐喻。

## product_personality

产品人格应当克制、可信、柔和、有秩序。视觉上偏向安静的 iOS 原生工具气质，同时允许主卡片区域带一点点触感温度。避免企业后台感、花哨生产力工具感或便签玩具感。它需要稳定的留白、明确的层级、低噪音状态表达和可预测的反馈节奏。

## target_users_and_core_scenarios

目标用户是高频看手机、容易被打断、依赖持续可见提醒而不是一次性通知的人。核心场景包括：快速记下一件不能忘的小事、在首页或锁屏风格界面一眼确认当前最重要任务、在过期或通知失败时仍保有清晰的任务去向与处理路径。共享设计必须优化“3 秒内看懂当前最重要事项”。

## global_experience_principles

- 先看见，再管理。
- 先可靠，再丰富。
- 先轻量，再个性化。
- 任何能力失败都优先表达为“降级”，而不是“事项消失”。
- 当前冻结目标验证平台为 `ios_device`，下游实现和验证必须按 iPhone 实际交互心智维护安全区、点击密度、导航方式与反馈节奏。

## information_hierarchy_principles

- 首页第一阅读层只属于主事项卡片。
- 第二阅读层属于紧急任务或当前队列。
- 第三阅读层才属于历史入口、设置入口和低优先级系统信息。
- 任务标题优先级高于装饰、统计、说明性文案。
- 快速添加是全局高频动作，但其显著性必须低于主事项标题带来的任务指向。

## layout_and_page_structure_principles

- 冻结基线视口为 `390 x 844 px`，不得向下压缩。
- 页面以纵向单主轴组织。
- 优先使用留白、分组、字号和轻表面分离，而不是多层卡片堆叠。
- 首页固定骨架为：顶部轻量品牌区、主事项卡片区、任务队列区、底部共享导航、全局快速添加。
- 历史与设置都继承同一壳层与节奏，不另起视觉体系。
- 主事项卡片可以比列表更温暖、更柔和，但这类触感只能局限在主任务层级。

## component_system_principles

共享组件族必须少而稳定，优先围绕任务处理链路而非视觉花样扩张：

- `priority_reminder_card`
- `task_row`
- `status_chip`
- `bottom_nav_shell`
- `global_quick_add`
- `section_header`
- `empty_state_panel`
- `degradation_notice_inline`

允许的全局变体必须围绕状态和密度变化，而不是主题风格漂移。

## global_public_component_freeze

冻结的全局公共组件集合：

- `priority_reminder_card`
  - 允许状态：normal / today / overdue / private-safe
  - 不可变项：大标题优先级、宽松内边距、单主任务定位、轻微温和纸感只作用于该卡片
  - 允许工程调整：超长标题换行、元信息折行细调、轻纹理强度弱化
- `task_row`
  - 允许状态：normal / today / overdue / completed-preview / deleted-preview
  - 不可变项：行式结构、轻量分隔、左侧动作起点
  - 允许工程调整：日期行二级排版
- `status_chip`
  - 允许状态：today / overdue / tomorrow / neutral / private-safe
  - 不可变项：轻胶囊结构、语义色优先级
  - 允许工程调整：文案长度适配
- `bottom_nav_shell`
  - 允许项：Home / History / Settings
  - 不可变项：三目的地结构
  - 允许工程调整：图标线宽、选中态微动效
- `global_quick_add`
  - 不可变项：全局可发现性、脱离列表独立存在
  - 允许工程调整：与底栏的相对悬浮距离

明确不属于全局共享层的内容：

- 模块级详情页局部组件
- 会员专属展示变体
- 同步或 Reminders 协同专属配置块

## interaction_behavior_principles

- 主事项卡片点击后进入事项详情或编辑主链路。
- 列表行应支持快速完成与进入详情两类意图。
- 历史入口不抢首页主任务路径。
- 删除、恢复、隐私、提醒、刷新失败等行为的反馈必须清楚说明“状态变化”而不是“任务消失”。
- 破坏性动作必须克制、可识别、可恢复。

## state_and_feedback_principles

- ideal：平静、清楚、任务优先
- loading：不闪烁、不重排为完全不同结构
- empty：鼓励快速添加，不制造空洞焦虑
- disabled：说明不可用原因，不让用户误会是数据丢失
- success：轻反馈，不庆祝式打断
- warning：今天到期用温和强调
- error：只在真正失败时使用明确错误表达
- degradation：通知拒绝、Widget 刷新失败、系统入口失败都应被表达为能力降级

## content_and_copy_principles

- 文案必须简短、直接、支持型。
- 标签语气应像可信赖的个人助手，而不是自我激励产品。
- 状态文案优先说明当下任务关系，例如“今天”“已过期”“已恢复”“通知未开启”。
- 不使用空泛口号替代操作指引。

## visual_system_rules

- 视觉系统以浅色温和背景、墨色文字、低饱和绿色主色和克制的橙红状态色构成。
- 字体层级优先靠字号、字重与留白建立，不依赖重装饰。
- CTA 对比必须明显，但不应像营销按钮一样高噪音。
- 列表优先是行，而不是块。
- 深度只做轻微区分，避免通篇浮卡。
- 图标应细致、轻量、系统化。
- 不引入大插画、紫色渐变、复杂玻璃态或厚重纸张拟物。
- 轻纸感只能作为主卡片近景层的弱表达，不能推广为全局拟物风格。

## light_theme_rationale

浅色主题是当前工作流的默认冻结基线，因为它最符合锁屏可见、低压、高可信、快速扫读的使用场景。当前颜色系统保留温和暖白底和自然绿色动作色，是为了让主任务既突出又不制造管理焦虑。

## dark_theme_rationale

深色主题不是浅色反相。它应保持相同层级与同一语义角色，但通过更柔和的深背景、受控高亮和更稳的表面对比来维持阅读性与深度感。深色主题必须继续保证主任务可读、CTA 清楚、状态色不霓虹化。

## design_prohibitions

- 不得把首页改造成复杂项目看板或高密度日程板。
- 不得削弱主事项卡片在首页的绝对优先级。
- 不得把共享列表改成层层叠卡。
- 不得把快速添加做成隐藏入口。
- 不得让状态色与 CTA 色混淆。
- 不得用局部花哨视觉覆盖共享主题节奏。
- 不得把主卡片的轻纸感演化为贴纸、胶带、卷角、手写体或强便签道具。

## engineering_guardrails

- 可工程化简化：
  - 阴影可用原生近似值表达
  - 长标题折行规则可按 Flutter 文本行为细调
  - 图标可用接近的系统线性图标替换
  - 主卡片轻纸感可在实现中弱化为暖色表面与极轻纹理，不要求重资产还原
- 必须忠实保留：
  - 主事项优先级
  - Home / History / Settings 三栏壳层
  - 行式任务队列
  - 全局快速添加的稳定存在
  - 主 CTA 与普通状态的对比层级
  - 主卡片比列表更温暖但仍属于同一共享视觉系统
- 需要设计回滚的情况：
  - 首页首要任务不再一眼可辨
  - 为适配内容压缩关键留白与节奏
  - 列表、卡片或底栏被重构成另一套视觉语言

模块预览策略：

- `module_refinement_default: no_generate`
- 模块阶段默认不生成新的真实设备图
- 若后续显式批准模块图像证据，生成路径必须明确回写
- 当前已按自动工作流显式批准 `task-flow` 模块效果图证据，路径为 `docs/project/modules/task-flow/task-flow-home.png` 与 `docs/project/modules/task-flow/task-flow-editor.png`
- 当前已按自动工作流显式批准 `history-center` 模块效果图证据，路径为 `docs/project/modules/history-center/history-center-history.png`
- 当前已按自动工作流显式批准 `settings-center` 模块效果图证据，路径为 `docs/project/modules/settings-center/settings-center-settings.png`
- 当前已按自动工作流显式批准 `widget-bridge` 模块效果图证据，路径为 `docs/project/modules/widget-bridge/widget-bridge-priority-widget.png` 与 `docs/project/modules/widget-bridge/widget-bridge-private-widget.png`

## downstream_reference_index

- `flutter-design-freeze-gate`
  - 必须引用：`global_public_component_freeze`、`visual_system_rules`、`design_prohibitions`、主题冻结文件
- `flutter-uiux-to-architecture`
  - 必须引用：`layout_and_page_structure_principles`、`component_system_principles`、`engineering_guardrails`、主题冻结文件
- `flutter-design-source-control`
  - 必须引用：全部章节，尤其是 `design_prohibitions`
- `flutter-design-parity-reviewer`
  - 必须引用：`information_hierarchy_principles`、`state_and_feedback_principles`、主题冻结文件
- `flutter-workflow-orchestrator`
  - 必须引用：`global_experience_principles`、`global_public_component_freeze`、`engineering_guardrails`
- `flutter-rd-module-splitter`
  - 必须引用：`information_hierarchy_principles`、`layout_and_page_structure_principles`、`component_system_principles`、`engineering_guardrails`
