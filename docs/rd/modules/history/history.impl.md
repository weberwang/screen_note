# History 模块实现 RD

## 0. 文档信息

- 模块名称：`history`
- 文档成熟度：`implementation_final`
- 对应 UI/UX：[history.ui-ux.md](D:/Projects/Flutter/screen_note/docs/rd/modules/history/history.ui-ux.md)
- 继承技术基线：[01-global-technical-baseline.md](D:/Projects/Flutter/screen_note/docs/rd/01-global-technical-baseline.md)

## 1. 边界与业务职责

- 负责已完成事项、已删除事项的读取、展示与恢复入口。
- 不直接重写任务状态规则，只通过任务应用层用例操作。

## 2. 数据与应用层

- 依赖：
  - `WatchCompletedTasksUseCase`
  - `WatchDeletedTasksUseCase`
  - `RestoreTaskUseCase`
- 数据来源：`tasks` 模块真相源与事件日志。
- 排序：默认按最近动作时间倒序。

## 3. 屏幕级状态协调

- 已完成与已删除列表可共享页面骨架，但状态源分离。
- 恢复动作成功后应立即从删除列表移除并回流到 active 任务列表。
- 失败时仅影响当前记录，不应整页中断。

## 4. 基础设施与边界

- 数据层不新增独立数据库表，直接复用 `tasks` 相关 DAO / repository 查询能力。
- 若需要缩略图或状态徽记，仅在展示层或适配层派生，不新增业务真相字段。

## 5. 测试与埋点

- 测试：
  - 完成记录读取
  - 删除记录读取
  - 恢复事项后的列表联动
- 埋点：
  - 历史页曝光
  - 查看已完成
  - 恢复删除事项

## 6. 实现约束

- 不得将历史页实现成高密度后台列表。
- 恢复、查看、删除的视觉优先级必须继承冻结源，不可在实现时重新排序。
- 本文档已达到实现前粒度，可直接进入架构映射与编码准备。
