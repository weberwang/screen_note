import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/notification_permission_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_center_snapshot.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_membership_state.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_sync_status.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_language_preference.dart';
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
                  SizedBox(height: 8.h),
                  Text(
                    localizations.settingsSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xFF5F6762),
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
                    context: context,
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
            title: localizations.settingsNotificationStatusTitle,
            description: localizations.settingsNotificationStatusBody,
            trailing: _ValueTrailing(
              valueText: _notificationStatusText(
                snapshot.notificationPermissionStatus,
                localizations,
              ),
              valueColor:
                  snapshot.notificationPermissionStatus ==
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

  /// 隐私分区保持“状态值行 + 说明块”结构，避免原生开关破坏冻结稿的行式节奏。
  Widget _buildPrivacyGroup({
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
            icon: Icons.shield_outlined,
            title: localizations.settingsPrivacyModeTitle,
            description: localizations.settingsPrivacyModeBody,
            onTap: () => ref
                .read(settingsCenterControllerProvider.notifier)
                .updatePrivacyMode(
                  enabled: !snapshot.preferences.privacyModeEnabled,
                  feedbackText: localizations.settingsPrivacyFeedback,
                ),
            trailing: _ValueTrailing(
              valueText: _privacyModeText(
                enabled: snapshot.preferences.privacyModeEnabled,
                localizations: localizations,
              ),
            ),
          ),
          if (snapshot.preferences.privacyModeEnabled)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: _buildSupportNotice(
                context: context,
                icon: Icons.visibility_off_outlined,
                title: localizations.settingsPrivacyProtectionTitle,
                body: localizations.settingsPrivacyProtectionBody,
                surfaceColor: const Color(0xFFF1F8F0),
                iconSurfaceColor: const Color(0xFFE5F3E5),
                accentColor: const Color(0xFF4D8B52),
                trailing: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4D8B52),
                    side: const BorderSide(color: Color(0x334D8B52)),
                  ),
                  child: Text(localizations.settingsPrivacyProtectionAction),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 小组件分区只保留冻结稿里的单一展示模式入口，避免继续堆叠额外设置项。
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
          SettingsOptionRow(
            icon: Icons.palette_outlined,
            title: localizations.settingsThemeModeTitle,
            description: localizations.settingsThemeModeBody,
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

  /// 同步分区当前跟随冻结截图展示已同步状态，但仍不在当前模块扩展真实账号链路。
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
          valueText: _syncStatusText(snapshot.syncStatus, localizations),
        ),
      ),
    );
  }

  /// 会员分区保留主入口 + 次级感谢说明，但整体权重必须低于系统能力设置主链路。
  Widget _buildMembershipGroup({
    required BuildContext context,
    required SettingsCenterSnapshot snapshot,
    required AppLocalizations localizations,
  }) {
    return ScreenNotePanel(
      padding: EdgeInsets.all(0.w),
      child: Column(
        children: <Widget>[
          SettingsOptionRow(
            icon: Icons.workspace_premium_outlined,
            title: localizations.settingsMembershipTitle,
            description: localizations.settingsMembershipBody,
            trailing: _ValueTrailing(
              valueText: _membershipStateText(
                snapshot.membershipState,
                localizations,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
            child: _buildSupportNotice(
              context: context,
              icon: Icons.verified_rounded,
              title: localizations.settingsMembershipSupportTitle,
              body: localizations.settingsMembershipSupportBody,
              surfaceColor: const Color(0xFFFFFAF1),
              iconSurfaceColor: const Color(0xFFF8F0D9),
              accentColor: const Color(0xFF4D8B52),
              trailing: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0x224D8B52),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.military_tech_rounded,
                  color: const Color(0xFF4D8B52),
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
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

  /// 截图中的绿色和暖色说明块共用同一结构，这里只抽布局骨架，不改变各自的语义归属。
  Widget _buildSupportNotice({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String body,
    required Color surfaceColor,
    required Color iconSurfaceColor,
    required Color accentColor,
    required Widget trailing,
  }) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: iconSurfaceColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(icon, color: accentColor, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11.sp,
                    color: accentColor.withValues(alpha: 0.86),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          trailing,
        ],
      ),
    );
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
