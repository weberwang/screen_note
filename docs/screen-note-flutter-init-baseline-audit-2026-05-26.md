# Screen Note Flutter Init 基线审计

## 当前事实

- 当前真实运行代码根为 `lib/src`，并不是 `lib/app`、`lib/core`、`lib/features`。
- `lib/src/app` 已承担应用入口、路由装配与系统回流处理。
- `lib/src/shared` 已承担主题、通用 Scaffold、共享展示组件与通用展示工具。
- `lib/src/tasks`、`history`、`settings`、`quick_add`、`widget_bridge` 已按业务边界拆分。
- 项目已接入 `go_router`、`hooks_riverpod`、`freezed`、`json_serializable`、`drift` 与 Flutter 官方国际化链路。

## 目标基线

- 目标结构为 `lib/app`、`lib/core`、`lib/shared`、`lib/features`。
- 目标状态组织优先采用 Riverpod 注解生成链路。
- 目标网络基线为 `dio + retrofit`。
- 目标安全存储基线为 `flutter_secure_storage`。
- 目标日志基线为统一的 `logger` 或等价日志入口。

## 差距清单

| Area | 当前状态 | 目标状态 | 本轮处理 |
| --- | --- | --- | --- |
| 目录结构 | `lib/src` 为真实运行根 | `lib/app/core/shared/features` | `仅建立说明性占位，不迁移代码` |
| Riverpod | `手写 Provider` | `@riverpod + riverpod_generator` | `仅记录差距` |
| 网络 | `暂无 dio/retrofit 运行时入口` | `dio + retrofit` | `仅记录差距` |
| 安全存储 | `未接入 flutter_secure_storage` | `secure storage 基线` | `仅记录差距` |
| 日志 | `未形成统一 logger 入口` | `logger 或等价统一入口` | `仅记录差距` |

## 本轮仅记录不落地项

- 不把现有 `lib/src` 下的业务代码搬到 `lib/app`、`lib/core`、`lib/features`。
- 不为了对齐清单而强行引入 `dio`、`retrofit`、`flutter_secure_storage` 或 `logger` 的运行时代码。
- 不改动现有 `go_router` 路由树、Riverpod Provider、数据库实现或原生桥接入口。
- 不制造“目录已经迁移完成”的假象；本轮只补齐表达、约束与未来结构说明。

## 后续收敛建议

1. 后续只有在某个 feature 被实质性重做时，才把它迁入 `lib/features/...`，避免纯目录搬运。
2. 如果引入远程接口，再补入 `dio + retrofit`，不要为清单而预埋假代码。
3. Riverpod 注解化迁移应按 feature 分批推进，避免一次性全仓改造。
4. 一旦出现敏感信息存储需求，再引入 `flutter_secure_storage`，不要继续扩大 `shared_preferences` 的职责。
5. 如果未来要统一日志入口，优先先定义 ownership，再落具体实现，避免多个 feature 各自接一套日志能力。
