# Quick Add 模块实现 RD

## 0. 文档信息

- 模块名称：`quick_add`
- 文档成熟度：`implementation_final`
- 对应 UI/UX：[quick_add.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/quick_add/quick_add.ui-ux.md)
- 继承技术基线：[01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/rd/01-global-technical-baseline.md)

## 1. 边界与业务职责

- 承接 App 内快捷录入与系统快捷入口回流。
- 管理快速添加草稿、默认选项、入口来源与回流结果。
- 最终创建动作仍走 `tasks` 模块创建用例。

## 2. 数据与应用层

- 核心对象：
  - `QuickAddDraft`
  - `QuickAddDefaults`
  - `QuickAddEntrySource`
  - `QuickAddFlowResult`
- 核心服务：
  - `QuickAddFlowService`
  - `QuickAddDraftStore`
- 持久化：
  - 草稿与轻量默认值可落 `shared_preferences`

## 3. 状态协调

- 输入内容、默认时间、隐私开关与入口来源应组成独立局部状态。
- 提交成功后清理草稿；提交失败保留草稿。
- 系统入口回流失败只影响入口结果提示，不影响 App 内继续录入。

## 4. 集成边界

- 创建事项时调用 `CreateTaskUseCase`。
- 回流后可触发 `widget_bridge` 快照刷新。
- 路由回流统一通过 `go_router`。

## 5. 测试与埋点

- 测试：
  - 草稿保留
  - 提交成功回流
  - 系统入口失败降级
- 埋点：
  - 快速添加入口曝光
  - 快速添加提交
  - 系统入口来源分布

## 6. 实现约束

- 不得把快速添加做成冗长多段表单。
- 模块只负责“更快输入”，不重新定义任务排序、详情结构或历史规则。
- 本文档已达到实现前粒度，可直接进入架构映射与编码准备。
