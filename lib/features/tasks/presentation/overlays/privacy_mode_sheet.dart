import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 隐私模式选择弹层。
class PrivacyModeSheet extends StatelessWidget {
  /// 创建隐私模式选择弹层。
  const PrivacyModeSheet({
    super.key,
    required this.isPrivate,
  });

  /// 当前是否开启隐私模式。
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.privacySettingsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.privacyExplainBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: isPrivate,
              contentPadding: EdgeInsets.zero,
              title: Text(localizations.taskPrivateLabel),
              subtitle: Text(localizations.widgetPreviewMaskPrivateBody),
              onChanged: (bool value) => Navigator.of(context).pop(value),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
