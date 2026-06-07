import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/domain/entities/settings_preferences.dart';
import 'package:screen_note/features/settings_center/domain/entities/widget_display_mode.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 设置中心正式页，统一管理隐私、通知和锁屏展示相关偏好。
class SettingsCenterPage extends ConsumerWidget {
  /// 创建设置中心页。
  const SettingsCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<SettingsPreferences> preferencesAsync = ref.watch(
      settingsCenterControllerProvider,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ScreenNoteSpacing.pageHorizontal,
        12,
        ScreenNoteSpacing.pageHorizontal,
        112,
      ),
      children: <Widget>[
        _HeaderCard(
          title: localizations.settingsPageTitle,
          subtitle: localizations.settingsPageHelperText,
        ),
        const SizedBox(height: ScreenNoteSpacing.sectionGap),
        preferencesAsync.when(
          data: (SettingsPreferences preferences) {
            return _SettingsContent(preferences: preferences);
          },
          loading: () => const _LoadingCard(),
          error: (Object _, StackTrace __) => _ErrorCard(
            onRetry: () => ref.invalidate(settingsCenterControllerProvider),
          ),
        ),
      ],
    );
  }
}

/// 设置页头部卡片，保留冻结设计要求的简洁层级和留白节奏。
class _HeaderCard extends StatelessWidget {
  /// 创建头部卡片。
  const _HeaderCard({required this.title, required this.subtitle});

  /// 标题。
  final String title;

  /// 副标题。
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 12),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// 设置页主体内容，按展示、隐私和未来能力三个层级组织设置项。
class _SettingsContent extends ConsumerWidget {
  /// 创建主体内容。
  const _SettingsContent({required this.preferences});

  /// 当前偏好。
  final SettingsPreferences preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    Future<void> save(SettingsPreferences next) async {
      await ref.read(settingsCenterControllerProvider.notifier).save(next);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SettingsGroupCard(
          title: localizations.settingsDisplayGroupTitle,
          children: <Widget>[
            _SettingInfoRow(
              icon: Icons.widgets_outlined,
              title: localizations.widgetSettingsTitle,
              subtitle: localizations.widgetSettingsSubtitle,
              trailing: _DisplayModeValueChip(mode: preferences.widgetDisplayMode),
            ),
            const Divider(height: 28),
            _SettingToggleRow(
              icon: Icons.notifications_none_rounded,
              title: localizations.notificationSettingsTitle,
              subtitle: localizations.notificationSettingsSubtitle,
              value: preferences.notificationsEnabled,
              switchKey: const Key('settings-notifications-switch'),
              activeLabel: localizations.notificationSettingsEnabled,
              inactiveLabel: localizations.notificationSettingsDisabled,
              onChanged: (bool value) {
                save(preferences.copyWith(notificationsEnabled: value));
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsGroupCard(
          title: localizations.widgetStyleSelectorTitle,
          children: <Widget>[
            Text(
              localizations.widgetSettingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: WidgetDisplayMode.values.map((WidgetDisplayMode mode) {
                return ChoiceChip(
                  key: Key('settings-widget-mode-${mode.name}'),
                  selected: preferences.widgetDisplayMode == mode,
                  onSelected: (_) {
                    save(preferences.copyWith(widgetDisplayMode: mode));
                  },
                  label: Text(_labelForMode(localizations, mode)),
                );
              }).toList(growable: false),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsGroupCard(
          title: localizations.privacySettingsTitle,
          children: <Widget>[
            _SettingToggleRow(
              icon: Icons.lock_outline_rounded,
              title: localizations.privacySettingsMaskTitle,
              subtitle: localizations.privacySettingsMaskBody,
              value: preferences.maskPrivateContent,
              switchKey: const Key('settings-privacy-switch'),
              activeLabel: localizations.widgetPreviewPrivateState,
              inactiveLabel: localizations.privacyExplainTitle,
              onChanged: (bool value) {
                save(preferences.copyWith(maskPrivateContent: value));
              },
            ),
            const Divider(height: 28),
            _SettingInfoRow(
              icon: Icons.shield_outlined,
              title: localizations.privacySettingsSafeTitle,
              subtitle: localizations.privacySettingsSafeBody,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsGroupCard(
          title: localizations.syncPlaceholderTitle,
          children: <Widget>[
            _SettingInfoRow(
              icon: Icons.cloud_outlined,
              title: localizations.syncPlaceholderTitle,
              subtitle: localizations.syncPlaceholderBody,
              trailing: _StatusLabel(text: localizations.syncPlaceholderStatus),
            ),
            const Divider(height: 28),
            _SettingInfoRow(
              icon: Icons.refresh_rounded,
              title: localizations.settingsFallbackTitle,
              subtitle: localizations.settingsFallbackBody,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProEntryCard(),
      ],
    );
  }

  /// 把展示模式枚举映射为国际化标签，避免页面散落 switch 文案。
  String _labelForMode(AppLocalizations localizations, WidgetDisplayMode mode) {
    return switch (mode) {
      WidgetDisplayMode.single => localizations.widgetDisplayModeSingle,
      WidgetDisplayMode.list3 => localizations.widgetDisplayModeList3,
      WidgetDisplayMode.today => localizations.widgetDisplayModeToday,
      WidgetDisplayMode.private => localizations.widgetDisplayModePrivate,
      WidgetDisplayMode.empty => localizations.widgetDisplayModeEmpty,
    };
  }
}

/// 设置分组卡片，统一承接行级设置与卡片留白。
class _SettingsGroupCard extends StatelessWidget {
  /// 创建设置分组卡片。
  const _SettingsGroupCard({required this.title, required this.children});

  /// 分组标题。
  final String title;

  /// 分组内容。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// 只读设置项，用于样式、同步和降级说明等非开关行。
class _SettingInfoRow extends StatelessWidget {
  /// 创建只读设置项。
  const _SettingInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  /// 图标。
  final IconData icon;

  /// 标题。
  final String title;

  /// 说明文案。
  final String subtitle;

  /// 右侧附加内容。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useStackedTrailing =
            trailing != null && constraints.maxWidth < 320;

        // 窄屏时把状态标签压到说明文案下方，避免设置行在手机宽度横向溢出。
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: palette.accentAmber),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: useStackedTrailing
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        trailing!,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        if (trailing != null) ...<Widget>[
                          const SizedBox(width: 12),
                          trailing!,
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// 开关型设置项，保证切换后立即更新本地偏好。
class _SettingToggleRow extends StatelessWidget {
  /// 创建开关型设置项。
  const _SettingToggleRow({
    this.switchKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.onChanged,
  });

  /// 图标。
  final IconData icon;

  /// 标题。
  final String title;

  /// 说明。
  final String subtitle;

  /// 当前值。
  final bool value;

  /// 开关 key，供测试与稳定交互定位使用。
  final Key? switchKey;

  /// 启用状态文案。
  final String activeLabel;

  /// 关闭状态文案。
  final String inactiveLabel;

  /// 切换回调。
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _SettingInfoRow(
            icon: icon,
            title: title,
            subtitle: subtitle,
            trailing: _StatusLabel(text: value ? activeLabel : inactiveLabel),
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(key: switchKey, value: value, onChanged: onChanged),
      ],
    );
  }
}

/// 展示模式值标签，弱化显示当前样式而不是把它做成抢焦点操作。
class _DisplayModeValueChip extends StatelessWidget {
  /// 创建展示模式值标签。
  const _DisplayModeValueChip({required this.mode});

  /// 当前模式。
  final WidgetDisplayMode mode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final String label = switch (mode) {
      WidgetDisplayMode.single => localizations.widgetDisplayModeSingle,
      WidgetDisplayMode.list3 => localizations.widgetDisplayModeList3,
      WidgetDisplayMode.today => localizations.widgetDisplayModeToday,
      WidgetDisplayMode.private => localizations.widgetDisplayModePrivate,
      WidgetDisplayMode.empty => localizations.widgetDisplayModeEmpty,
    };
    return _StatusLabel(text: label);
  }
}

/// 右侧状态标签，统一承接弱化状态文案。
class _StatusLabel extends StatelessWidget {
  /// 创建状态标签。
  const _StatusLabel({required this.text});

  /// 文案。
  final String text;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

/// 未来会员入口卡片，保持弱化呈现，不压过基础设置。
class _ProEntryCard extends StatelessWidget {
  /// 创建会员入口卡片。
  const _ProEntryCard();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      backgroundColor: palette.surfaceRaised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.workspace_premium_outlined),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      localizations.proEntryTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizations.proEntryBody,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _StatusLabel(text: localizations.proBenefitUnlimitedList),
              _StatusLabel(text: localizations.proBenefitCustomReminder),
              _StatusLabel(text: localizations.proBenefitDataBackup),
            ],
          ),
        ],
      ),
    );
  }
}

/// 加载态卡片，避免设置页首屏闪跳。
class _LoadingCard extends StatelessWidget {
  /// 创建加载态卡片。
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const ScreenNotePanel(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// 错误态卡片，允许用户留在当前页重试读取偏好。
class _ErrorCard extends StatelessWidget {
  /// 创建错误态卡片。
  const _ErrorCard({required this.onRetry});

  /// 重试回调。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.settingsFallbackTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.settingsFallbackBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: Text(localizations.retryAction),
          ),
        ],
      ),
    );
  }
}
