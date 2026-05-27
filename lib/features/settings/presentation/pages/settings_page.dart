import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/features/settings/presentation/widgets/settings_group.dart';
import 'package:screen_note/features/settings/presentation/widgets/settings_tile.dart';

/// 阶段二设置入口页。
class SettingsPage extends StatelessWidget {
  /// 创建阶段二设置入口页。
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNoteScaffold(
      title: Text(localizations.settingsPageTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.settingsPageTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.settingsPageHelperText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SettingsGroup(
              title: localizations.settingsDisplayGroupTitle,
              children: <Widget>[
                SettingsTile(
                  title: localizations.widgetSettingsTitle,
                  subtitle: localizations.widgetSettingsSubtitle,
                  trailingLabel: localizations.settingsOpenAction,
                  onTap: () => context.go(RoutePaths.settingsWidget),
                ),
                const SizedBox(height: 12),
                SettingsTile(
                  title: localizations.privacySettingsTitle,
                  subtitle: localizations.privacySettingsSubtitle,
                  trailingLabel: localizations.settingsOpenAction,
                  onTap: () => context.go(RoutePaths.settingsPrivacy),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
              decoration: BoxDecoration(
                color: ScreenNoteColors.surfaceMuted,
                borderRadius: ScreenNoteRadii.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.settingsFallbackTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(localizations.settingsFallbackBody),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
