import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';

part 'settings_center_snapshot.freezed.dart';

/// 设置中心快照，统一聚合页面渲染所需的稳定事实。
@freezed
abstract class SettingsCenterSnapshot with _$SettingsCenterSnapshot {
  /// 创建设置中心快照。
  const factory SettingsCenterSnapshot({
    required NotificationPermissionStatus notificationPermissionStatus,
    required SettingsCenterPreferences preferences,
    required SettingsSyncStatus syncStatus,
    required SettingsMembershipState membershipState,
  }) = _SettingsCenterSnapshot;
}
