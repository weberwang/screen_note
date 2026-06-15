import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/repositories/notification_permission_repository.dart';
import 'package:screen_note/features/settings_center/domain/repositories/settings_preferences_repository.dart';

/// 设置中心快照读取用例，统一装配偏好、权限与占位扩展状态。
final class LoadSettingsCenterSnapshotUseCase {
  /// 创建设置中心快照读取用例。
  const LoadSettingsCenterSnapshotUseCase({
    required SettingsPreferencesRepository preferencesRepository,
    required NotificationPermissionRepository notificationRepository,
  }) : _preferencesRepository = preferencesRepository,
       _notificationRepository = notificationRepository;

  final SettingsPreferencesRepository _preferencesRepository;
  final NotificationPermissionRepository _notificationRepository;

  /// 读取设置页所需快照，保持页面只消费稳定聚合结果。
  Future<SettingsCenterSnapshot> execute() async {
    final preferences = await _preferencesRepository.loadPreferences();
    final permissionStatus = await _notificationRepository.readStatus();

    return SettingsCenterSnapshot(
      notificationPermissionStatus: permissionStatus,
      preferences: preferences,
      syncStatus: SettingsSyncStatus.localOnly,
      membershipState: SettingsMembershipState.available,
    );
  }
}
