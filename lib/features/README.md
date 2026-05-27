# lib/features

该目录是未来按业务边界组织 feature 的目标位置。

每个 feature 的目标结构：

- domain
- application
- infrastructure
- presentation

当前真实运行代码已位于 `lib/features/tasks`、`lib/features/history`、`lib/features/settings`、`lib/features/quick_add`、`lib/features/widget_bridge`。后续新增业务模块也默认在此目录下继续扩展。
