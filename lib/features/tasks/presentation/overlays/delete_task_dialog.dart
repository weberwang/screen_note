import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';

/// 删除确认对话框。
class DeleteTaskDialog extends StatelessWidget {
  /// 创建删除确认对话框。
  const DeleteTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.deleteDialogTitle),
      content: Text(localizations.deleteDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(localizations.cancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(localizations.taskDeleteAction),
        ),
      ],
    );
  }
}
