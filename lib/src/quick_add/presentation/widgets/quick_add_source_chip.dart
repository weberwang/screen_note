import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/quick_add/application/quick_add_entry_source.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 快速添加入口来源标签。
class QuickAddSourceChip extends StatelessWidget {
  /// 创建快速添加入口来源标签。
  const QuickAddSourceChip({
    super.key,
    required this.source,
  });

  /// 当前入口来源。
  final QuickAddEntrySource source;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceMuted,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Text(
        _label(context),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  String _label(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return switch (source) {
      QuickAddEntrySource.home => localizations.quickAddSourceHome,
      QuickAddEntrySource.appIntent => localizations.quickAddSourceAppIntent,
      QuickAddEntrySource.controlCenter =>
        localizations.quickAddSourceControlCenter,
      QuickAddEntrySource.lockScreen => localizations.quickAddSourceLockScreen,
      QuickAddEntrySource.actionButton =>
        localizations.quickAddSourceActionButton,
      QuickAddEntrySource.deepLink => localizations.quickAddSourceDeepLink,
      QuickAddEntrySource.fallback => localizations.quickAddSourceFallback,
    };
  }
}
