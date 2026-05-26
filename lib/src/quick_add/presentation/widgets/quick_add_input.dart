import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 快速添加统一输入区域。
class QuickAddInput extends HookWidget {
  /// 创建快速添加统一输入区域。
  const QuickAddInput({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.isSubmitting,
  });

  /// 当前草稿。
  final QuickAddDraft draft;

  /// 草稿变更回调。
  final ValueChanged<QuickAddDraft> onChanged;

  /// 当前是否处于提交中。
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController controller = useTextEditingController(
      text: draft.draftText,
    );
    useEffect(() {
      if (controller.text == draft.draftText) {
        return null;
      }

      controller.value = TextEditingValue(
        text: draft.draftText,
        selection: TextSelection.collapsed(offset: draft.draftText.length),
      );
      return null;
    }, <Object?>[controller, draft.draftText]);

    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.input,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.quickAddInputLabel,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ScreenNoteColors.surfaceMuted,
              borderRadius: ScreenNoteRadii.card,
              border: Border.all(color: ScreenNoteColors.lineSoft),
            ),
            child: TextField(
              controller: controller,
              enabled: !isSubmitting,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: localizations.quickInputPlaceholder,
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (String value) {
                onChanged(
                  draft.applyChanges(
                    draftText: value,
                    timestamp: DateTime.now(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
