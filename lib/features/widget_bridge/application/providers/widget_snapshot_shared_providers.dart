import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/widget_bridge/application/ports/widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/home_widget_snapshot_store.dart';
import 'package:screen_note/features/widget_bridge/infrastructure/widget_snapshot_projector.dart';

part 'widget_snapshot_shared_providers.g.dart';

/// Widget 快照存储 Provider，统一暴露真实平台实现与测试替换入口。
@riverpod
WidgetSnapshotStore widgetSnapshotStore(Ref ref) {
  return createWidgetSnapshotStore(logger: ref.watch(appLoggerProvider));
}

/// Widget 快照投影器 Provider。
@riverpod
WidgetSnapshotProjector widgetSnapshotProjector(Ref ref) {
  return const WidgetSnapshotProjector();
}
