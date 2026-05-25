import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';

/// 首页快速输入卡片。
class QuickInputCard extends HookWidget {
  /// 创建首页快速输入卡片。
  const QuickInputCard({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
    this.errorText,
    this.initialValue,
  });

  /// 是否正在提交。
  final bool isSubmitting;

  /// 提交动作。
  final Future<void> Function(String value) onSubmit;

  /// 错误文案。
  final String? errorText;

  /// 初始值。
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController controller = useTextEditingController(
      text: initialValue,
    );

    Future<void> handleSubmit() async {
      await onSubmit(controller.text);
    }

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
          TextField(
            controller: controller,
            enabled: !isSubmitting,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: localizations.quickInputPlaceholder,
              errorText: errorText,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: isSubmitting ? null : handleSubmit,
              child: isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(localizations.quickInputSubmit),
            ),
          ),
        ],
      ),
    );
  }
}
