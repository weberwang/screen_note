import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';

/// 恢复确认对话框。
class RestoreTaskDialog extends StatelessWidget {
  /// 创建恢复确认对话框。
  const RestoreTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.restoreDialogTitle),
      content: Text(localizations.restoreDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.cancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(localizations.taskRestoreAction),
        ),
      ],
    );
  }
}
