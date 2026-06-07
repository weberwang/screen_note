# settings-center UI/UX RD

## 模块目标与目标用户

- 目标：集中管理通知、隐私、Widget 展示偏好与未来同步/权益入口。
- 目标用户：已进入稳定使用期、需要调整展示和提醒策略的用户。

## 页面范围与导航入口

- 页面范围：通知设置、隐私模式、Widget 样式、同步占位、权益入口。
- 导航入口：底部更多/设置入口。

## 核心用户路径

1. 打开设置页。
2. 调整通知、隐私或展示偏好。
3. 设置立即生效到首页、Widget 和提醒能力。

## 状态矩阵

| 状态 | 说明 |
| --- | --- |
| ideal | 分组清晰、选项即时反馈 |
| empty | not_applicable |
| loading | 读取本地偏好时使用轻占位 |
| error | 设置写入失败时给出短反馈 |
| permission | 通知权限拒绝时展示说明与引导 |
| partial_data | 缺少某项能力时仅隐藏增强选项 |
| disabled | 未开放功能以禁用态或占位态呈现 |
| success | 切换后即时反馈 |
| locked_or_premium | 未来权益入口使用，不阻断设置本身 |

## 结构语义

- `scroll_model`: whole-page scroll
- `list_model`: grouped list
- `overlay_model`: none
- `layout_model`: linear
- `sticky_model`: none
- `component_repeatability`: 设置项行、样式选择器、权益卡

## 模块级组件骨架

- `SettingsGroupCard`：分组容器
- `SettingsToggleRow`：开关项
- `DisplayStyleSelector`：Widget 样式选择
- `ProEntryCard`：未来权益入口，占位但不抢焦点

## 设计来源

- 共享设计包：`docs/rd/02-shared-design-packet.md`
- 共享冻结：`docs/rd/global-design-guidelines.md`
- 主题冻结：`docs/rd/light-theme-freeze.yaml`、`docs/rd/dark-theme-freeze.yaml`
- 视觉证据：
  - `docs/rd/settings-center-refresh-v1.png`
  - 模块内复制图：`docs/rd/modules/settings-center/settings-center-refresh-v1.png`
  - 运行态截图仅作实现复核参考：`.omo/ulw-loop/019e9bfa-e6c7-7103-9226-64ff30b72c6e/evidence/c001/runtime-pack/settings.png`

## 设计冻结卡

- 冻结目标：分组节奏、通知/隐私/样式三大设置层级、权益入口弱化处理
- 不可变项：基础隐私能力不是付费门槛；权限拒绝提示不得阻断主链路
- 允许调整：组间留白、开关文案说明长度
- 审批记录：`workflow-orchestrator --auto` 于 2026-06-04 自动确认
- 当前返工补充：设置页已具备模块内静态图，后续分组层级判断以该图和共享设计包共同为准。

## 接受门禁

- UI/UX：设置项能被快速扫描；增强项不压过基础设置
- 模块冻结：分组结构与权限提示姿态固定
- 代码交接：偏好写入后需同步通知与 Widget 表现
