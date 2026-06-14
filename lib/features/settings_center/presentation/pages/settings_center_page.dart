import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 设置中心页面只消费稳定快照与设置意图，不直接感知插件或本地偏好存储细节。
class SettingsCenterPage extends HookConsumerWidget {
  /// 创建设置中心页面。
  const SettingsCenterPage({super.key});

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
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 120.h),
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
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 120.h),
              sliver: SliverList.list(
                children: <Widget>[
                  Text(
                    localizations.settingsTitle,
                    style: theme.textTheme.displaySmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    localizations.settingsSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF5F6762),
                    ),
                  ),
                  SizedBox(height: 28.h),
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

  /// 通知分区优先表达当前权限状态，并在降级时提供轻量复查入口。
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
            title: localizations.settingsNotificationStatusTitle,
            description: localizations.settingsNotificationStatusBody,
            trailing: _ValueTrailing(
              valueText: _notificationStatusText(
                snapshot.notificationPermissionStatus,
                localizations,
              ),
              valueColor: snapshot.notificationPermissionStatus ==
                      NotificationPermissionStatus.enabled
                  ? const Color(0xFF4D8B52)
                  : const Color(0xFFE96A5A),
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

  /// 隐私分区通过开关直接表达当前安全边界，并把写入逻辑统一回收到控制器。
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
        description: localizations.settingsPrivacyModeBody,
        onTap: () => ref
            .read(settingsCenterControllerProvider.notifier)
            .updatePrivacyMode(
              enabled: !snapshot.preferences.privacyModeEnabled,
              feedbackText: localizations.settingsPrivacyFeedback,
            ),
        trailing: Switch.adaptive(
          value: snapshot.preferences.privacyModeEnabled,
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

  /// 展示模式分区通过底部选项面板切换当前值，但最终安全约束仍由应用层决定。
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
            icon: Icons.widgets_outlined,
            title: localizations.settingsWidgetDisplayModeTitle,
            description: localizations.settingsWidgetDisplayModeBody,
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
          Divider(height: 1, indent: 84.w, endIndent: 18.w),
          SettingsOptionRow(
            icon: Icons.add_to_home_screen_outlined,
            title: localizations.settingsWidgetInstallTitle,
            description: localizations.settingsWidgetInstallBody,
            trailing: const _ChevronTrailing(),
            onTap: () => _showWidgetInstallGuide(
              context: context,
              ref: ref,
              localizations: localizations,
            ),
          ),
          Divider(height: 1, indent: 84.w, endIndent: 18.w),
          SettingsOptionRow(
            icon: Icons.brightness_6_outlined,
            title: localizations.settingsThemeModeTitle,
            description: localizations.settingsThemeModeBody,
            trailing: _ValueTrailing(
              valueText: _themeModePreferenceText(
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
          Divider(height: 1, indent: 84.w, endIndent: 18.w),
          SettingsOptionRow(
            icon: Icons.language_rounded,
            title: localizations.settingsLanguageTitle,
            description: localizations.settingsLanguageBody,
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

  /// 小组件入口统一通过底部引导承接，避免把平台差异说明塞进主列表描述里。
  Future<void> _showWidgetInstallGuide({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
  }) {
    final TargetPlatform platform = Theme.of(context).platform;
    final bool supportsDirectPin = !kIsWeb && platform == TargetPlatform.android;

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.settingsWidgetInstallTitle,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    supportsDirectPin
                        ? localizations.settingsWidgetInstallAndroidGuide
                        : localizations.settingsWidgetInstallIosGuide,
                    style: Theme.of(sheetContext).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF5F6762),
                    ),
                  ),
                  if (supportsDirectPin) ...<Widget>[
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          await ref
                              .read(settingsCenterControllerProvider.notifier)
                              .requestPinWidget(
                                requestedFeedbackText: localizations
                                    .settingsWidgetInstallRequestedFeedback,
                                unsupportedFeedbackText: localizations
                                    .settingsWidgetInstallUnsupportedFeedback,
                                failedFeedbackText: localizations
                                    .settingsWidgetInstallFailedFeedback,
                              );
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                        child: Text(localizations.settingsWidgetInstallAction),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 同步分区当前只表达本地真源边界，不虚构未接入的账号或后端链路。
  Widget _buildSyncGroup({
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: SettingsOptionRow(
        icon: Icons.cloud_outlined,
        title: localizations.settingsSyncStatusTitle,
        description: localizations.settingsSyncStatusBody,
        trailing: _ValueTrailing(
          valueText: snapshot.syncStatus == SettingsSyncStatus.localOnly
              ? localizations.settingsSyncLocalOnly
              : localizations.settingsSyncLocalOnly,
        ),
      ),
    );
  }

  /// 会员分区只保留次级入口表达，避免营销信息盖过系统设置主链路。
  Widget _buildMembershipGroup({
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: SettingsOptionRow(
        icon: Icons.workspace_premium_outlined,
        title: localizations.settingsMembershipTitle,
        description: localizations.settingsMembershipBody,
        trailing: _ValueTrailing(
          valueText: snapshot.membershipState == SettingsMembershipState.available
              ? localizations.settingsMembershipAvailable
              : localizations.settingsMembershipAvailable,
        ),
      ),
    );
  }

  /// 通过底部面板承接展示模式切换，避免设置页行内挤入过多控件破坏分区节奏。
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
                  onTap: () => Navigator.of(
                    context,
                  ).pop(WidgetDisplayMode.previewOnly),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsWidgetDisplayFullContent,
                  selected: currentMode == WidgetDisplayMode.fullContent,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(WidgetDisplayMode.fullContent),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 主题模式通过底部面板切换，保持设置页行结构清爽且不在行内塞入复杂控件。
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
                  onTap: () =>
                      Navigator.of(context).pop(SettingsThemeModePreference.dark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 语言偏好通过底部面板切换，避免设置页主列表直接承载多选逻辑。
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
                  onTap: () => Navigator.of(
                    context,
                  ).pop(SettingsLanguagePreference.zh),
                ),
                SizedBox(height: 8.h),
                _ModeSheetTile(
                  title: localizations.settingsLanguageEn,
                  selected: currentLanguage == SettingsLanguagePreference.en,
                  onTap: () => Navigator.of(
                    context,
                  ).pop(SettingsLanguagePreference.en),
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
      WidgetDisplayMode.previewOnly =>
        localizations.settingsWidgetDisplayPreviewOnly,
      WidgetDisplayMode.fullContent =>
        localizations.settingsWidgetDisplayFullContent,
    };
  }

  /// 主题模式文案统一在页面层映射，保持领域层只承载枚举事实而不承载展示语言。
  String _themeModePreferenceText(
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

  /// 语言偏好文案统一在页面层映射，避免领域层侵入最终展示字符串。
  String _languagePreferenceText(
    SettingsLanguagePreference language,
    AppLocalizations localizations,
  ) {
    return switch (language) {
      SettingsLanguagePreference.zh => localizations.settingsLanguageZh,
      SettingsLanguagePreference.en => localizations.settingsLanguageEn,
    };
  }
}

/// 右侧值组件统一维持当前值 + 进入箭头的次级结构，避免每个设置行重复手写。
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
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 132.w),
          child: Text(
            valueText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
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

/// 纯进入型设置行统一复用箭头尾部，避免为单个入口再复制一份右侧结构。
final class _ChevronTrailing extends StatelessWidget {
  const _ChevronTrailing();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      color: const Color(0xFF98A09B),
      size: 22.sp,
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
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      tileColor: selected ? const Color(0xFFEAF4EB) : const Color(0xFFF6F6F2),
      title: Text(title),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: Color(0xFF4D8B52))
          : null,
      onTap: onTap,
    );
  }
}
