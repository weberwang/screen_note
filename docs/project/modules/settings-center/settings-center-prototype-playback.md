# Settings Center Prototype Playback

## Page Structure Playback

### 1. Shared Shell Layer

- 页面继承已冻结的 `app-shell` 共享壳层：底部 `Home / History / Settings` 三栏导航与独立全局快速添加入口继续存在。
- `Settings` 是当前选中目的地，但设置内容本身仍应是首要阅读对象，不能让壳层动作抢走页面层级。

### 2. Notifications Group

- 第一主区块是通知与权限状态。
- 该分区必须清楚表达“当前能力可用 / 不可用 / 已降级”，而不是把权限信息藏在二级页面深处。
- 当通知未开启或部分能力不可用时，需要用低噪音降级提示承接，而不是全屏告警。

### 3. Privacy And Widget Group

- 第二主区块先展示隐私模式，再展示 Widget 展示模式。
- 隐私设置优先级高于展示花样，因为它直接影响锁屏、小组件和预览的安全边界。
- Widget 展示模式负责说明“展示完整内容 / 安全预览 / 模糊预览”等可见策略，但不应演化成复杂编辑器。

### 4. Sync And Membership Group

- 第三主区块承接同步状态与会员入口。
- 同步状态优先级高于会员入口，必须先说明当前数据是否安全、是否已同步。
- 会员入口只能是克制的次级内容，不允许盖过通知、隐私和展示模式。

### 5. Empty And Degradation States

- 设置页不存在“完全空白”的核心场景，但存在权限降级、同步未开启和会员入口未激活等次级状态。
- 所有失败或未开启状态都应表达为“能力降级”，而不是“主链路不可访问”。

## Interaction Checklist

- 点击底栏 `Home / History / Settings` 仍可切换一级目的地。
- 通知状态行可进入权限说明或系统设置引导。
- 隐私模式可切换，且应明确影响锁屏与 Widget 预览。
- Widget 展示模式可切换，但不能绕开隐私规则。
- 同步状态只说明当前状态与后续入口，不在当前模块实现复杂账号流。
- 会员入口保留存在，但必须维持克制次级权重。

## Please confirm before high-fidelity prototype build

- 当前播放稿覆盖 `settings-center` 的单一页面族：`settings_center`。
- 下一步将以 `settings-center-settings.png` 为视觉基线，生成模块 HTML 高保真原型和冻结包。
