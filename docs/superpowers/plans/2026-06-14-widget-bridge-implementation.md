# Widget Bridge Implementation Plan

1. 恢复稳定快照合同与投影器
验证：`widget_snapshot_sync_service_test.dart` 能覆盖 fullContent / previewOnly / private-safe

2. 接入共享存储与 iOS Widget 合同
验证：`flutter analyze` 不报 Flutter / Swift 共享合同相关错误

3. 把 task-flow 与 settings-center 接到自动同步副作用
验证：`widget_snapshot_auto_sync_integration_test.dart` 覆盖创建事项和切换展示模式

4. 跑全量生成与测试
验证：`rtk flutter gen-l10n`、`rtk dart run build_runner build --delete-conflicting-outputs`、`rtk flutter analyze`、`rtk flutter test`
