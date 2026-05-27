# Feature Map

## Primary Features

- `tasks`: `任务生命周期、列表、详情、编辑、排序与状态推导`
- `history`: `已完成与已删除历史视图`
- `settings`: `设置、隐私设置、Widget 设置`
- `quick_add`: `系统快捷添加、草稿恢复与桥接`
- `widget_bridge`: `小组件快照、显示模式、刷新调度`

## Ownership Rules

- `presentation` owns pages, widgets, and UI interaction only.
- `application` owns use cases, orchestration, and provider exposure.
- `infrastructure` owns DTOs, data sources, repository implementations, and external SDK integration.
- `domain` owns entities, value objects, and repository contracts.

## Extension Rules

- Prefer extending an existing feature when the new task shares the same business language and lifecycle.
- Create a new bounded feature only when the task introduces a distinct business capability, ownership boundary, or dependency cluster.
- 新增功能默认优先落在 `lib/features` 下既有 feature；不要重新引入 `lib/src` 或平铺顶层业务目录。
- Document cross-feature collaboration explicitly instead of creating hidden imports.
