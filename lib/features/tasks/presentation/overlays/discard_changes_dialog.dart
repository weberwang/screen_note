import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';

/// 放弃修改确认对话框。
class DiscardChangesDialog extends StatelessWidget {
  /// 创建放弃修改确认对话框。
  const DiscardChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.discardDialogTitle),
      content: Text(localizations.discardDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.cancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(localizations.discardAction),
        ),
      ],
    );
  }
}
