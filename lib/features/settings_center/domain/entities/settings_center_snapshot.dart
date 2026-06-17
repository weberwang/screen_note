import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';

part 'settings_center_snapshot.freezed.dart';

/// 设置页稳定快照统一收口系统能力状态、偏好和值得展示的次级入口状态。
@freezed
abstract class SettingsCenterSnapshot with _$SettingsCenterSnapshot {
  /// 创建设置页快照。
  const factory SettingsCenterSnapshot({
    required NotificationPermissionStatus notificationPermissionStatus,
    required SettingsCenterPreferences preferences,
    required SettingsSyncStatus syncStatus,
    required SettingsMembershipState membershipState,
  }) = _SettingsCenterSnapshot;
}
