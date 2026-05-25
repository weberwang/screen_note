import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/settings/presentation/widgets/widget_preview_card.dart';

/// 阶段二锁屏显示预览页。
class WidgetSettingsPage extends StatefulWidget {
  /// 创建阶段二锁屏显示预览页。
  const WidgetSettingsPage({super.key});

  @override
  State<WidgetSettingsPage> createState() => _WidgetSettingsPageState();
}

class _WidgetSettingsPageState extends State<WidgetSettingsPage> {
  bool _hidePrivateBody = true;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return ScreenNoteScaffold(
      title: Text(localizations.widgetSettingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WidgetPreviewCard(
              title: localizations.widgetSettingsTitle,
              subtitle: localizations.widgetSettingsSubtitle,
              previewTitle: _hidePrivateBody
                  ? localizations.widgetPreviewPrivateState
                  : localizations.quickInputPlaceholder,
              previewBody: _hidePrivateBody
                  ? localizations.taskPrivateMaskedBody
                  : localizations.widgetPreviewDefaultBody,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _hidePrivateBody,
              contentPadding: EdgeInsets.zero,
              title: Text(localizations.widgetPreviewMaskPrivateTitle),
              subtitle: Text(localizations.widgetPreviewMaskPrivateBody),
              onChanged: (bool value) {
                setState(() {
                  _hidePrivateBody = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
