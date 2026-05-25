import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/utils/date_time_formatter.dart';

/// 截止时间选择弹层。
class DueTimeSheet extends StatelessWidget {
  /// 创建截止时间选择弹层。
  const DueTimeSheet({super.key, required this.selectedTime});

  /// 当前选中的时间。
  final DateTime? selectedTime;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final DateTime now = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.dueTimeDialogTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              selectedTime == null
                  ? localizations.taskDueEmpty
                  : ScreenNoteDateTimeFormatter.formatDateTime(selectedTime!),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: <Widget>[
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    DateTime(
                      now.year,
                      now.month,
                      now.day,
                      now.hour + 1,
                    ),
                  ),
                  child: Text(localizations.dueTimeSetAction),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(localizations.dueTimeClearAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
