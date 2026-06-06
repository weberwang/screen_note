import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/home_widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_projector.dart';

part 'widget_snapshot_shared_providers.g.dart';

/// 小组件快照存储提供器，统一复用真实平台实现与测试替换入口。
@riverpod
WidgetSnapshotStore widgetSnapshotStore(Ref ref) {
  return createWidgetSnapshotStore(logger: AppLogger.instance);
}

/// 小组件快照投影器提供器。
@riverpod
WidgetSnapshotProjector widgetSnapshotProjector(Ref ref) {
  return const WidgetSnapshotProjector();
}
