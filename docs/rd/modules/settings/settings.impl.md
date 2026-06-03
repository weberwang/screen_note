# Settings 模块实现 RD

## 0. 文档信息

- 模块名称：`settings`
- 文档成熟度：`implementation_final`
- 对应 UI/UX：[settings.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/settings/settings.ui-ux.md)
- 继承技术基线：[01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/rd/01-global-technical-baseline.md)

## 1. 边界与业务职责

- 管理隐私设置、Widget 展示模式入口、权限说明与设置导航。
- 收口用户可配置项，但不重写任务真相源和快照真相源。

## 2. 数据与应用层

- 数据来源：
  - 隐私偏好
  - Widget 展示模式
  - 能力状态摘要
- 建议边界：
  - 轻量偏好使用 `shared_preferences`
  - Widget 展示模式通过 `widget_bridge` 仓储适配

## 3. 状态协调

- 设置保存失败时保留用户当前选择。
- 权限未开或 Widget 未安装只影响说明区，不阻断设置页进入。
- 隐私切换成功后应联动预览反馈与快照刷新。

## 4. 导航与集成边界

- 设置首页导航到隐私页、Widget 页。
- 隐私与展示模式变更后回写到 `tasks` / `widget_bridge` 所需的受控入口。

## 5. 测试与埋点

- 测试：
  - 隐私开关保存
  - Widget 展示模式切换
  - 权限降级说明展示
- 埋点：
  - 设置页曝光
  - 隐私模式切换
  - Widget 模式变更

## 6. 实现约束

- 设置页不得直接持有三方插件实例，统一经仓储 / 服务适配。
- 所有用户可见文案必须接入国际化，不允许长期硬编码。
- 本文档已达到实现前粒度，可直接进入架构映射与编码准备。
