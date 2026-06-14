# Widget Bridge Implementation Spec

## 目标

为 `widget-bridge` 落一条真实可运行的稳定快照桥接链路，让 `task-flow` 与 `settings-center` 的变化可以自动同步到 Widget 共享存储，并让 iOS Widget 只消费稳定 JSON 合同。

## 成功标准

- 新增 `widget-bridge` 领域、应用、基础设施最小实现，能生成稳定快照。
- 创建 / 状态变更 / 设置偏好变更后会自动触发 Widget 快照同步。
- 共享快照会写入当前快照与最后一次有效快照两个 key。
- iOS Widget 原生层合同与 Flutter 侧当前两档展示模式保持一致。
- `flutter analyze` 与 `flutter test` 全量通过。

## 非目标

- 不扩展 Android 真正的 Widget 展示层。
- 不在 Widget 内承接复杂交互与深链矩阵。
- 不重开共享视觉方向。
