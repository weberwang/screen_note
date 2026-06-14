import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';

/// 设置副作用实现，把 Widget 展示模式和隐私偏好自动联动到最新共享快照。
final class WidgetSnapshotSettingsSideEffectPort
    implements SettingsSideEffectPort {
  /// 创建设置副作用实现。
  const WidgetSnapshotSettingsSideEffectPort({
    required WidgetSnapshotAutoSyncCoordinator coordinator,
    required AppLogger logger,
  }) : _coordinator = coordinator,
       _logger = logger;

  final WidgetSnapshotAutoSyncCoordinator _coordinator;
  final AppLogger _logger;

  @override
  Future<void> onPreferencesChanged(SettingsCenterPreferences preferences) async {
    try {
      await _coordinator.syncPreferences(preferences);
    } catch (_) {
      _logger.warning('widget_snapshot_sync_after_settings_change_failed');
    }
  }
}
