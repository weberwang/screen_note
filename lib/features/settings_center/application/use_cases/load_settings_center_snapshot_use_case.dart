import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 设置页快照加载用例，统一装配偏好、本地能力状态和次级入口边界。
final class LoadSettingsCenterSnapshotUseCase {
  /// 创建设置页快照加载用例。
  const LoadSettingsCenterSnapshotUseCase({
    required SettingsPreferencesRepository preferencesRepository,
    required NotificationPermissionRepository notificationRepository,
  }) : _preferencesRepository = preferencesRepository,
       _notificationRepository = notificationRepository;

  final SettingsPreferencesRepository _preferencesRepository;
  final NotificationPermissionRepository _notificationRepository;

  /// 加载设置页稳定快照。
  Future<SettingsCenterSnapshot> execute() async {
    final preferences = await _preferencesRepository.loadPreferences();
    final notificationPermissionStatus =
        await _notificationRepository.readStatus();

    return SettingsCenterSnapshot(
      notificationPermissionStatus: notificationPermissionStatus,
      preferences: preferences,
      // 本轮显示层还原已由用户明确指定以冻结截图为准，因此默认快照值同步切到截图中的已同步与已激活表达。
      syncStatus: SettingsSyncStatus.synced,
      membershipState: SettingsMembershipState.active,
    );
  }
}
