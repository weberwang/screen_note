# Design Source Control Decision

## design_source_decision

- active_selected_source: `docs/project/design-direction-ab-home.png`
- previous_selected_source: `docs/project/design-direction-ab2-home.png`
- decision_summary: 用户明确指定改用已存在的 `design-direction-ab-home.png` 作为当前共享视觉基线；本次不生成新图，不引入新的方向分支。

## source_artifacts

- [design-direction-ab-home.png](D:/Projects/Flutter/screen_note/docs/project/design-direction-ab-home.png)
- [design-direction-ab2-home.png](D:/Projects/Flutter/screen_note/docs/project/design-direction-ab2-home.png)
- [04-shared-design-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/04-shared-design-freeze-decision.md)
- [03-shared-html-prototype-packet.md](D:/Projects/Flutter/screen_note/docs/project/03-shared-html-prototype-packet.md)
- [02-product-design-clarification-packet.md](D:/Projects/Flutter/screen_note/docs/project/02-product-design-clarification-packet.md)
- [global-design-guidelines.md](D:/Projects/Flutter/screen_note/docs/project/global-design-guidelines.md)

## change_classification

- type: `design_change`
- reason: 这是用户对已冻结共享视觉基线的显式替换请求，影响共享视觉证据与后续文档引用，不属于代码保真修复。

## allowed_actions

- 将当前共享视觉基线引用从 `design-direction-ab2-home.png` 切回 `design-direction-ab-home.png`
- 刷新共享冻结输入文档与工作流记录中的当前基线索引
- 保持现有主题冻结、共享壳层和共享组件族不变

## forbidden_actions

- 不得把本次请求解释为重新开启新方向生图
- 不得静默保留 `AB2` 作为当前活跃基线
- 不得在没有明确证据的情况下顺手重写主题值、交互结构或模块边界

## rollback_stage

- `none`
- 说明：本次使用的是已存在的共享方向图，且未改变共享壳层、主题冻结或组件系统，只刷新当前活跃共享视觉基线与下游引用，不回退到新的生图流程。

## document_update_location

- `docs/project/02-product-design-clarification-packet.md`
- `docs/project/03-mobbin-direction-evidence.md`
- `docs/project/03-shared-html-prototype-packet.md`
- `docs/project/04-shared-design-freeze-decision.md`
- `docs/project/modules/app-shell/app-shell.impl.md`
- `docs/project/modules/task-flow/task-flow.impl.md`
- `docs/project/modules/widget-bridge/widget-bridge.impl.md`
- `tmp/flutter-workflow-orchestrator/workflow-record.md`

---

## design_source_decision

- active_module: `settings-center`
- active_selected_source: `docs/project/modules/settings-center/settings-center-settings.png`
- conflicting_sources:
  - `docs/project/modules/settings-center/settings-center-design-source-packet.md`
  - `docs/project/modules/settings-center/settings-center.impl.md`
- decision_summary: 用户于 `2026-06-17` 明确指定本轮 `settings-center` 还原以冻结截图为准；当截图与模块冻结文档在 `Sync / Membership` 当前展示值上冲突时，后续原型与显示层统一按截图落地，即 `Synced / Active`。

## source_artifacts

- [settings-center-settings.png](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-settings.png)
- [settings-center-design-source-packet.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-design-source-packet.md)
- [settings-center.impl.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center.impl.md)
- [settings-center-freeze-decision.md](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/settings-center-freeze-decision.md)
- [prototype/index.html](D:/Projects/Flutter/screen_note/docs/project/modules/settings-center/prototype/index.html)

## change_classification

- type: `design_change`
- reason: 这是用户对模块冻结后视觉事实与文档冲突的显式裁决，影响模块原型、显示层文案和快照状态，不属于代码保真微调。

## allowed_actions

- 以 `settings-center-settings.png` 为准刷新 `settings-center` 模块原型
- 同步修正文档中的 `Sync / Membership` 当前展示值
- 按更新后的设计源恢复 Flutter 显示层与测试

## forbidden_actions

- 不得继续把 `localOnly / available` 作为本轮显示层主标准
- 不得借本次裁决顺手扩大到新的页面结构或新增分区
- 不得把截图优先解释成重新开启新的生图方向

## rollback_stage

- `module_design_frozen`
- 说明：本次不回退共享设计方向，只在模块冻结范围内完成一次用户批准的设计源裁决与同步刷新。

## document_update_location

- `docs/project/modules/settings-center/settings-center-design-source-packet.md`
- `docs/project/modules/settings-center/settings-center.impl.md`
- `docs/project/modules/settings-center/settings-center-freeze-decision.md`
- `docs/project/modules/settings-center/prototype/index.html`
