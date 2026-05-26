# lib/features

该目录是未来按业务边界组织 feature 的目标位置。

每个 feature 的目标结构：

- domain
- application
- infrastructure
- presentation

当前真实运行代码仍位于 `lib/src/tasks`、`lib/src/history`、`lib/src/settings`、`lib/src/quick_add`、`lib/src/widget_bridge`。后续只在 feature 被实质性重做时再迁入此目录。
