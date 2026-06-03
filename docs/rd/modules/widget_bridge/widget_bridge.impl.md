# Widget Bridge 模块实现 RD

## 0. 文档信息

- 模块名称：`widget_bridge`
- 文档成熟度：`implementation_final`
- 对应 UI/UX：[widget_bridge.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/widget_bridge/widget_bridge.ui-ux.md)
- 继承技术基线：[01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/rd/01-global-technical-baseline.md)

## 1. 边界与业务职责

- 负责稳定快照构建、展示模式持久化、Widget 刷新调度与失败降级。
- 不直接管理任务真相源，只消费 `tasks` 产出的排序结果与受控 DTO。

## 2. 数据与应用层

- 核心对象：
  - `WidgetSnapshot`
  - `WidgetSnapshotItem`
  - `WidgetDisplayMode`
- 核心服务：
  - `WidgetSnapshotBuilder`
  - `WidgetSnapshotRefresher`
  - `WidgetRefreshScheduler`
  - `WidgetRefreshGuard`
- 数据存储：
  - 快照写入 `home_widget`
  - 展示模式可存储在模块仓储中

## 3. 状态协调

- 任务变化、快速添加成功、隐私切换都应触发快照刷新尝试。
- 刷新失败保留最后有效快照，并上报轻量结果状态给设置 / 详情页。
- 展示模式修改必须与预览页即时同步。

## 4. 集成边界

- 依赖 `tasks` 提供稳定排序结果。
- 依赖 `quick_add` 成功提交后的刷新触发。
- 对外只暴露展示模式和快照状态，不暴露底层插件类型。

## 5. 测试与埋点

- 测试：
  - 快照构建
  - 隐私模式摘要降级
  - 刷新失败保留最后有效内容
- 埋点：
  - Widget 展示模式切换
  - 快照刷新成功 / 失败

## 6. 实现约束

- Widget / 锁屏侧只读稳定快照，不得重算业务排序。
- 私密事项正文不得直接写入系统侧展示。
- 本文档已达到实现前粒度，可直接进入架构映射与编码准备。
