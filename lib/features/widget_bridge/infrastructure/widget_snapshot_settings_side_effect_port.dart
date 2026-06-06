import 'package:screen_note/core/logging/app_logger.dart';
import 'package:screen_note/features/settings_center/application/ports/settings_side_effect_port.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/widget_bridge/application/services/widget_snapshot_auto_sync_coordinator.dart';

/// 设置副作用实现，把锁屏样式和隐私偏好变更自动联动到最新共享快照。
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
  Future<void> handlePreferencesChanged(SettingsPreferences preferences) async {
    try {
      await _coordinator.syncPreferences(preferences);
    } catch (error, stackTrace) {
      // 偏好写入已完成后，锁屏同步失败只能记录并降级，不能反向阻断设置保存。
      _logger.warning(
        'widget_snapshot_sync_after_settings_change_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
