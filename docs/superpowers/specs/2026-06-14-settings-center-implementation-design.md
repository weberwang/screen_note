# settings-center 实现设计说明

## 1. 目标

本设计说明用于约束 `settings-center` 模块的首轮真实实现范围。目标是在共享壳层、模块效果图、模块原型、冻结决议和架构映射都已完成的前提下，把当前占位页推进为真实的设置中心页面，让用户能查看通知权限状态、更新隐私模式和 Widget 展示模式，并在不阻断主链路的前提下理解同步与会员入口的当前边界。

本轮实现成功标准：

- 设置页能读取真实偏好并展示通知、隐私、展示模式、同步和会员五个分区
- 通知权限状态通过现有 `flutter_local_notifications` 能力查询，失败时按降级处理
- 隐私模式与 Widget 展示模式可更新，并通过应用层规则保证 Widget 展示不会绕开隐私模式
- 页面以分区列表承载系统能力边界，不演化为营销页或功能广场
- 空平台能力、权限失败和后续未接入能力都表达为“降级”，而不是阻断访问

## 2. 当前输入

当前实现必须严格遵循以下已冻结输入：

- [settings-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center.impl.md)
- [settings-center-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-design-source-packet.md)
- [settings-center-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-freeze-decision.md)
- [settings-center-architecture.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-architecture.md)
- [07-bootstrap-code-summary.md](D:/Projects/Flutter/screen_note/docs/project/07-bootstrap-code-summary.md)

其中最关键的实现约束是：

- 通知状态和权限降级必须先于会员入口被看见
- 所有权限失败都按降级提示处理，不阻断设置页访问
- Widget 展示模式必须受隐私模式约束，不能出现更宽松的泄露路径
- 页面继续继承共享壳层与全局 quick add，不另起新导航语义
- 会员入口存在但必须保持次级权重

## 3. 本轮范围

### 3.1 范围内

- 建立 `settings-center` 偏好实体、快照实体和基础枚举
- 建立本地偏好仓储，使用 `shared_preferences` 保存隐私模式与 Widget 展示模式
- 建立通知权限查询仓储，优先复用 `flutter_local_notifications`
- 建立设置页快照用例、隐私模式更新用例、展示模式更新用例、通知权限复查用例
- 建立设置页运行时 Provider 与页面控制器
- 把设置 branch 从占位页切到真实 `settings-center` 页面
- 补齐权限降级、偏好更新、Widget 展示保护规则和页面展示测试

### 3.2 范围外

- 真实会员支付与权益购买流程
- 云同步后端接入与账号体系
- Widget 真正渲染实现
- 复杂通知日历、提醒策略与多时区设置面板
- 多级设置子路由体系

## 4. 设计决策

### 4.1 偏好写入统一走应用层

隐私模式和 Widget 展示模式都不是页面直接写 `shared_preferences`。页面只表达用户意图，真正的偏好更新必须经过应用层用例统一编排。

### 4.2 Widget 展示模式默认受隐私模式约束

若隐私模式已开启：

- 用户不能把 Widget 展示模式落为 `fullContent`
- 若开启隐私时当前模式是 `fullContent`，用例要自动收敛为 `previewOnly`

这样后续 `widget-bridge` 可以直接消费稳定边界，而不是二次猜测泄露风险。

### 4.3 通知权限查询走现有通知插件，失败按降级表达

通知状态优先复用 `flutter_local_notifications` 的平台权限查询能力。若当前平台不支持、未初始化或查询失败：

- 不把设置页判为失败
- 只把通知分区显示为降级或未知状态
- 保持用户可以继续访问和更新其他设置

### 4.4 同步和会员先做真实占位，不抢主链路

本轮同步状态和会员入口不接后端真能力，但也不继续做纯静态空白：

- 同步状态明确展示为 `localOnly`
- 会员入口明确展示为 `available`

这样既符合页面结构，也不虚构未落地能力。

## 5. 文件边界

本轮实现建议优先集中在这些文件：

- `lib/features/settings_center/domain/entities/`
- `lib/features/settings_center/domain/repositories/`
- `lib/features/settings_center/application/use_cases/`
- `lib/features/settings_center/application/providers/`
- `lib/features/settings_center/infrastructure/`
- `lib/features/settings_center/presentation/pages/settings_center_page.dart`
- `lib/features/settings_center/presentation/widgets/`

直接复用但不应大改：

- `lib/features/app_shell/application/providers/app_shell_ui_state.dart`
- `lib/features/app_shell/presentation/pages/app_shell_page.dart`

可能需要轻改：

- `test/features/app_shell/presentation/app_shell_page_test.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`

不应触碰：

- `task-flow` 真源规则本身
- `history-center` 恢复链路
- `widget-bridge` 真实桥接实现

## 6. 测试策略

本轮至少补齐以下测试：

- 设置页快照装配测试
- 隐私模式更新测试
- Widget 展示模式受隐私模式约束的规则测试
- 通知权限降级测试
- 设置页分区展示测试
- 页面交互更新测试

测试目标是证明系统能力边界与偏好规则稳定，而不是补大量视觉截图。

## 7. 风险与控制

### 风险 1：页面重新吸收系统能力规则

如果页面直接判断权限、直接写偏好、直接兜底泄露规则，后续 `widget-bridge` 和通知链路都会分裂。

控制方式：

- 页面只读稳定快照
- 偏好更新和权限复查都走应用层用例

### 风险 2：隐私模式与展示模式脱节

如果隐私模式已开但仍允许 Widget 展示完整内容，会直接打破产品隐私承诺。

控制方式：

- 在更新展示模式时强制校验隐私模式
- 在开启隐私模式时自动收敛不安全展示模式

### 风险 3：会员入口反客为主

如果实现时给会员入口更强的视觉权重，会直接偏离冻结设计。

控制方式：

- 会员入口只做次级分区
- 不引入营销头图、强 CTA 和大卡片

## 8. 实现后预期状态

完成本轮后，项目应满足：

- `settings-center` 不再是占位页，而是可用的真实设置页
- 用户能看到通知权限、隐私模式和 Widget 展示模式的当前状态
- 用户能更新隐私模式与 Widget 展示模式
- `widget-bridge` 后续能直接复用稳定偏好边界
- 通知能力未接通或权限未给时，设置页仍保持可访问和可理解

## 9. 非目标声明

本轮不是要完成完整会员体系，也不是要做真实云同步。核心目的只有一个：在不破坏共享壳层、冻结设计和隐私承诺的前提下，让设置中心真正承担系统能力边界与偏好配置入口的职责。
