import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_theme_mode_preference.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/features/settings_center/presentation/widgets/settings_degradation_notice.dart';
import 'package:screen_note/features/settings_center/presentation/widgets/settings_option_row.dart';
import 'package:screen_note/features/settings_center/presentation/widgets/settings_section_header.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 设置中心页面只消费稳定快照与设置意图，不直接感知插件或本地偏好存储细节。
class SettingsCenterPage extends HookConsumerWidget {
  /// 创建设置中心页面。
  const SettingsCenterPage({super.key, this.openAppSettingsOverride});

  final Future<bool> Function()? openAppSettingsOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final AsyncValue<SettingsCenterSnapshot> snapshotAsync = ref.watch(
      settingsCenterControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
          child: ScreenNotePanel(
            child: Text(
              localizations.settingsLoadFailed,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        data: (SettingsCenterSnapshot snapshot) => CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              // 外层 SafeArea 已处理底部安全区，这里只保留轻量留白避免尾部空洞。
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
              sliver: SliverList.list(
                children: <Widget>[
                  Text(
                    localizations.settingsTitle,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 28.sp,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 22.h),
                  SettingsSectionHeader(
                    title: localizations.settingsNotificationsSection,
                  ),
                  SizedBox(height: 10.h),
                  _buildNotificationsGroup(
                    context: context,
                    ref: ref,
                    snapshot: snapshot,
                    localizations: localizations,
                  ),
                  SizedBox(height: 20.h),
                  SettingsSectionHeader(
                    title: localizations.settingsPrivacySection,
                  ),
                  SizedBox(height: 10.h),
                  _buildPrivacyGroup(
                    context: context,
                    ref: ref,
                    snapshot: snapshot,
                    localizations: localizations,
                  ),
                  SizedBox(height: 20.h),
                  SettingsSectionHeader(
                    title: localizations.settingsDisplaySection,
                  ),
                  SizedBox(height: 10.h),
                  _buildDisplayGroup(
                    context: context,
                    ref: ref,
                    snapshot: snapshot,
                    localizations: localizations,
                  ),
                  SizedBox(height: 20.h),
                  SettingsSectionHeader(
                    title: localizations.settingsSyncSection,
                  ),
                  SizedBox(height: 10.h),
                  _buildSyncGroup(
                    snapshot: snapshot,
                    localizations: localizations,
                  ),
                  SizedBox(height: 20.h),
                  SettingsSectionHeader(
                    title: localizations.settingsMembershipSection,
                  ),
                  SizedBox(height: 10.h),
                  _buildMembershipGroup(
                    snapshot: snapshot,
                    localizations: localizations,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 通知分区优先表达当前权限状态，并在降级时提供轻量启用入口。
  Widget _buildNotificationsGroup({
    required BuildContext context,
    required WidgetRef ref,
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: Column(
        children: <Widget>[
          SettingsOptionRow(
            icon: Icons.notifications_none_rounded,
            title: localizations.settingsNotificationsSection,
            trailing: Switch.adaptive(
              key: const Key('settings-notification-switch'),
              value:
                  snapshot.notificationPermissionStatus ==
                  NotificationPermissionStatus.enabled,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool enabled) async {
                if (enabled) {
                  await ref
                      .read(settingsCenterControllerProvider.notifier)
                      .reviewNotificationPermission(
                        grantedFeedbackText:
                            localizations.settingsNotificationGrantedFeedback,
                        deferredFeedbackText:
                            localizations.settingsNotificationDeferredFeedback,
                      );
                  return;
                }

                // 系统通知权限不能在应用内直接关闭，关闭动作只给出真实反馈，避免做成假切换。
                final bool shouldOpenSettings =
                    await _confirmOpenNotificationSettings(
                      context: context,
                      localizations: localizations,
                    );
                if (!shouldOpenSettings) {
                  return;
                }
                await _openSystemSettings(ref, localizations);
              },
            ),
          ),
          if (snapshot.notificationPermissionStatus !=
              NotificationPermissionStatus.enabled)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: SettingsDegradationNotice(
                title: localizations.settingsPermissionDowngradedTitle,
                body: localizations.settingsPermissionDowngradedBody,
                actionLabel: localizations.settingsReviewAction,
                onAction: () => ref
                    .read(settingsCenterControllerProvider.notifier)
                    .reviewNotificationPermission(
                      grantedFeedbackText:
                          localizations.settingsNotificationGrantedFeedback,
                      deferredFeedbackText:
                          localizations.settingsNotificationDeferredFeedback,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  /// 隐私分区只保留状态行，避免把已知状态再次展开成解释卡片。
  Future<bool> _confirmOpenNotificationSettings({
    required BuildContext context,
    required AppLocalizations localizations,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.settingsNotificationDisableDialogTitle),
          content: Text(localizations.settingsNotificationDisableDialogBody),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                localizations.settingsNotificationDisableDialogCancel,
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                localizations.settingsNotificationDisableDialogConfirm,
              ),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _openSystemSettings(
    WidgetRef ref,
    AppLocalizations localizations,
  ) async {
    final bool opened = await (openAppSettingsOverride ?? openAppSettings)();
    if (!opened) {
      ref
          .read(settingsCenterControllerProvider.notifier)
          .showInfoFeedback(
            localizations.settingsNotificationOpenSettingsFailed,
          );
    }
  }

  Widget _buildPrivacyGroup({
    required BuildContext context,
    required WidgetRef ref,
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: SettingsOptionRow(
        icon: Icons.shield_outlined,
        title: localizations.settingsPrivacyModeTitle,
        trailing: Switch.adaptive(
          key: const Key('settings-privacy-switch'),
          value: snapshot.preferences.privacyModeEnabled,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool enabled) => ref
              .read(settingsCenterControllerProvider.notifier)
              .updatePrivacyMode(
                enabled: enabled,
                feedbackText: localizations.settingsPrivacyFeedback,
              ),
        ),
      ),
    );
  }

  /// 显示分区保留必要入口，不再堆叠额外解释块。
  Widget _buildDisplayGroup({
    required BuildContext context,
    required WidgetRef ref,
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: Column(
        children: <Widget>[
          SettingsOptionRow(
            icon: Icons.add_home_outlined,
            title: localizations.settingsWidgetInstallTitle,
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // 小组件能力集中收口到独立页，避免设置首页继续堆叠安装说明和同步逻辑。
              context.push(RoutePaths.widgetBridge);
            },
          ),
          SettingsOptionRow(
            icon: Icons.widgets_outlined,
            title: localizations.settingsWidgetDisplayModeTitle,
            trailing: _ValueTrailing(
              valueText: _widgetDisplayModeText(
                snapshot.preferences.widgetDisplayMode,
                localizations,
              ),
            ),
            onTap: () async {
              final WidgetDisplayMode? selection = await _pickWidgetDisplayMode(
                context: context,
                currentMode: snapshot.preferences.widgetDisplayMode,
                localizations: localizations,
              );
              if (selection == null || !context.mounted) {
                return;
              }
              await ref
                  .read(settingsCenterControllerProvider.notifier)
                  .updateWidgetDisplayMode(
                    mode: selection,
                    feedbackText: localizations.settingsWidgetDisplayFeedback,
                  );
            },
          ),
          SettingsOptionRow(
            icon: Icons.palette_outlined,
            title: localizations.settingsThemeModeTitle,
            trailing: _ValueTrailing(
              valueText: _themeModeText(
                snapshot.preferences.themeModePreference,
                localizations,
              ),
            ),
            onTap: () async {
              final SettingsThemeModePreference? selection =
                  await _pickThemeModePreference(
                    context: context,
                    currentMode: snapshot.preferences.themeModePreference,
                    localizations: localizations,
                  );
              if (selection == null || !context.mounted) {
                return;
              }
              await ref
                  .read(settingsCenterControllerProvider.notifier)
                  .updateThemeModePreference(
                    mode: selection,
                    feedbackText: localizations.settingsThemeModeFeedback,
                  );
            },
          ),
          SettingsOptionRow(
            icon: Icons.translate_rounded,
            title: localizations.settingsLanguageTitle,
            trailing: _ValueTrailing(
              valueText: _languagePreferenceText(
                snapshot.preferences.languagePreference,
                localizations,
              ),
            ),
            onTap: () async {
              final SettingsLanguagePreference? selection =
                  await _pickLanguagePreference(
                    context: context,
                    currentLanguage: snapshot.preferences.languagePreference,
                    localizations: localizations,
                  );
              if (selection == null || !context.mounted) {
                return;
              }
              await ref
                  .read(settingsCenterControllerProvider.notifier)
                  .updateLanguagePreference(
                    language: selection,
                    feedbackText: localizations.settingsLanguageFeedback,
                  );
            },
          ),
        ],
      ),
    );
  }

  /// 同步分区只保留当前状态，不再附加额外解释组件。
  Widget _buildSyncGroup({
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: SettingsOptionRow(
        icon: Icons.cloud_outlined,
        title: localizations.settingsSyncStatusTitle,
        trailing: _ValueTrailing(
          valueText: _syncStatusText(snapshot.syncStatus, localizations),
        ),
      ),
    );
  }

  /// 会员分区只保留主入口，避免感谢型说明长期占据首屏空间。
  Widget _buildMembershipGroup({
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: SettingsOptionRow(
        icon: Icons.workspace_premium_outlined,
        title: localizations.settingsMembershipTitle,
        trailing: _ValueTrailing(
          valueText: _membershipStateText(
            snapshot.membershipState,
            localizations,
          ),
        ),
      ),
    );
  }

  /// 通过底部面板承接显示模式切换，避免设置页行内挤入过多控件破坏分区节奏。
  Future<WidgetDisplayMode?> _pickWidgetDisplayMode({
    required BuildContext context,
    required WidgetDisplayMode currentMode,
    required AppLocalizations localizations,
  }) {
    return showModalBottomSheet<WidgetDisplayMode>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.settingsWidgetDisplayPickerTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12.h),
                _ModeSheetTile(
                  title: localizations.settingsWidgetDisplayPreviewOnly,
                  selected: currentMode == WidgetDisplayMode.previewOnly,
                  onTap: () =>
                      Navigator.of(context).pop(WidgetDisplayMode.previewOnly),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsWidgetDisplayFullContent,
                  selected: currentMode == WidgetDisplayMode.fullContent,
                  onTap: () =>
                      Navigator.of(context).pop(WidgetDisplayMode.fullContent),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 主题切换沿用底部面板承接少量枚举选择，保持设置页行内密度稳定。
  Future<SettingsThemeModePreference?> _pickThemeModePreference({
    required BuildContext context,
    required SettingsThemeModePreference currentMode,
    required AppLocalizations localizations,
  }) {
    return showModalBottomSheet<SettingsThemeModePreference>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.settingsThemeModePickerTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12.h),
                _ModeSheetTile(
                  title: localizations.settingsThemeModeSystem,
                  selected: currentMode == SettingsThemeModePreference.system,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(SettingsThemeModePreference.system),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsThemeModeLight,
                  selected: currentMode == SettingsThemeModePreference.light,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(SettingsThemeModePreference.light),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsThemeModeDark,
                  selected: currentMode == SettingsThemeModePreference.dark,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(SettingsThemeModePreference.dark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 语言切换当前只有中英两项，复用底部面板即可覆盖 MVP 选择场景。
  Future<SettingsLanguagePreference?> _pickLanguagePreference({
    required BuildContext context,
    required SettingsLanguagePreference currentLanguage,
    required AppLocalizations localizations,
  }) {
    return showModalBottomSheet<SettingsLanguagePreference>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.settingsLanguagePickerTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12.h),
                _ModeSheetTile(
                  title: localizations.settingsLanguageZh,
                  selected: currentLanguage == SettingsLanguagePreference.zh,
                  onTap: () =>
                      Navigator.of(context).pop(SettingsLanguagePreference.zh),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsLanguageEn,
                  selected: currentLanguage == SettingsLanguagePreference.en,
                  onTap: () =>
                      Navigator.of(context).pop(SettingsLanguagePreference.en),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 通知权限状态文案统一收口在页面层解析，避免业务层承载最终展示文本。
  String _notificationStatusText(
    NotificationPermissionStatus status,
    AppLocalizations localizations,
  ) {
    return switch (status) {
      NotificationPermissionStatus.enabled =>
        localizations.settingsNotificationEnabled,
      NotificationPermissionStatus.disabled =>
        localizations.settingsNotificationDisabled,
      NotificationPermissionStatus.unknown =>
        localizations.settingsNotificationUnknown,
    };
  }

  /// 展示模式文案统一在页面层映射，保持业务层只承载枚举事实。
  String _widgetDisplayModeText(
    WidgetDisplayMode mode,
    AppLocalizations localizations,
  ) {
    return switch (mode) {
      WidgetDisplayMode.single =>
        localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.list3 => localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.today => localizations.settingsWidgetDisplayFullContent,
      WidgetDisplayMode.private =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.empty => localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.previewOnly =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.fullContent =>
        localizations.settingsWidgetDisplayFullContent,
    };
  }

  /// 主题偏好文案统一在页面层映射，避免领域层直接承载最终展示文本。
  String _themeModeText(
    SettingsThemeModePreference mode,
    AppLocalizations localizations,
  ) {
    return switch (mode) {
      SettingsThemeModePreference.system =>
        localizations.settingsThemeModeSystem,
      SettingsThemeModePreference.light => localizations.settingsThemeModeLight,
      SettingsThemeModePreference.dark => localizations.settingsThemeModeDark,
    };
  }

  /// 语言偏好文案统一在页面层映射，保证设置行和值面板使用同一套显示文本。
  String _languagePreferenceText(
    SettingsLanguagePreference language,
    AppLocalizations localizations,
  ) {
    return switch (language) {
      SettingsLanguagePreference.zh => localizations.settingsLanguageZh,
      SettingsLanguagePreference.en => localizations.settingsLanguageEn,
    };
  }

  /// 隐私模式文案统一在页面层映射，保证显示层和截图中的状态短语保持一致。
  String _privacyModeText({
    required bool enabled,
    required AppLocalizations localizations,
  }) {
    return enabled
        ? localizations.settingsPrivacyModeOn
        : localizations.settingsPrivacyModeOff;
  }

  /// 同步状态文案统一在页面层映射，确保截图批准后的状态值只在显示层解释。
  String _syncStatusText(
    SettingsSyncStatus status,
    AppLocalizations localizations,
  ) {
    return switch (status) {
      SettingsSyncStatus.localOnly => localizations.settingsSyncLocalOnly,
      SettingsSyncStatus.synced => localizations.settingsSyncSynced,
    };
  }

  /// 会员状态文案统一在页面层映射，避免领域枚举直接承载最终展示语言。
  String _membershipStateText(
    SettingsMembershipState state,
    AppLocalizations localizations,
  ) {
    return switch (state) {
      SettingsMembershipState.available =>
        localizations.settingsMembershipAvailable,
      SettingsMembershipState.active => localizations.settingsMembershipActive,
    };
  }
}

/// 右侧值组件统一维持当前值加进入箭头的次级结构，避免每个设置行重复手写。
final class _ValueTrailing extends StatelessWidget {
  const _ValueTrailing({
    required this.valueText,
    this.valueColor = const Color(0xFF4D8B52),
  });

  final String valueText;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 132.w),
            child: Text(
              valueText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Icon(
          Icons.chevron_right_rounded,
          color: const Color(0xFF98A09B),
          size: 22.sp,
        ),
      ],
    );
  }
}

/// 设置底部面板选项行只服务于展示模式切换，避免额外拆出公用组件污染范围。
final class _ModeSheetTile extends StatelessWidget {
  const _ModeSheetTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: ScreenNoteRadii.queueIcon),
      tileColor: selected ? palette.surfaceMuted : theme.cardTheme.color,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
