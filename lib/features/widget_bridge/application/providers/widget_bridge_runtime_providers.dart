import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/widget_bridge/application/providers/widget_snapshot_shared_providers.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_sync_service.dart';
import 'package:screen_note/features/widget_bridge/domain/entities/widget_snapshot.dart';
import 'package:screen_note/l10n/app_localizations.dart';

export 'widget_snapshot_shared_providers.dart';

part 'widget_bridge_runtime_providers.g.dart';

/// 小组件快照同步服务提供器，统一复用任务事实源、设置偏好和共享存储。
@riverpod
Future<WidgetSnapshotSyncService> widgetSnapshotSyncService(Ref ref) async {
  final TaskRepository taskRepository = ref.watch(taskRepositoryProvider);
  final SettingsPreferencesRepository settingsRepository = await ref.watch(
    settingsPreferencesRepositoryProvider.future,
  );

  return WidgetSnapshotSyncService(
    taskRepository: taskRepository,
    settingsRepository: settingsRepository,
    snapshotStore: ref.watch(widgetSnapshotStoreProvider),
    projector: ref.watch(widgetSnapshotProjectorProvider),
    locale: _resolveWidgetLocale(),
  );
}

/// 小组件桥接控制器，统一收口预览读取与手动同步动作。
@riverpod
class WidgetBridgeController extends _$WidgetBridgeController {
  /// 构建当前小组件预览快照。
  @override
  Future<WidgetSnapshot> build() async {
    final WidgetSnapshotSyncService service = await ref.watch(
      widgetSnapshotSyncServiceProvider.future,
    );
    return service.loadSnapshot();
  }

  /// 刷新当前预览快照。
  Future<void> refresh() async {
    final WidgetSnapshotSyncService service = await ref.read(
      widgetSnapshotSyncServiceProvider.future,
    );
    state = AsyncData(await service.loadSnapshot());
  }

  /// 手动同步共享快照，并在同步后刷新页面上的预览内容。
  Future<bool> syncSnapshot() async {
    final WidgetSnapshotSyncService service = await ref.read(
      widgetSnapshotSyncServiceProvider.future,
    );
    final bool synced = await service.syncSnapshot();
    state = AsyncData(await service.loadSnapshot());
    return synced;
  }
}

/// 解析系统语言环境；不受支持时统一保守回退到英文，保证后台同步也有稳定文案。
Locale _resolveWidgetLocale() {
  final Locale locale = PlatformDispatcher.instance.locale;
  return AppLocalizations.supportedLocales.any(
        (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      )
      ? Locale(locale.languageCode)
      : AppLocalizations.supportedLocales.first;
}
