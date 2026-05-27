import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';

/// 阶段二隐私设置页。
class PrivacySettingsPage extends StatefulWidget {
  /// 创建阶段二隐私设置页。
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _hideOutsidePreview = true;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNoteScaffold(
      title: Text(localizations.privacySettingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.privacySettingsTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.privacySettingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _hideOutsidePreview,
              contentPadding: EdgeInsets.zero,
              title: Text(localizations.privacySettingsMaskTitle),
              subtitle: Text(localizations.privacySettingsMaskBody),
              onChanged: (bool value) {
                setState(() {
                  _hideOutsidePreview = value;
                });
              },
            ),
            const SizedBox(height: 16),
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
                    localizations.privacySettingsSafeTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(localizations.privacySettingsSafeBody),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
