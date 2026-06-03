import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 首页快速输入条。
class QuickInputCard extends HookWidget {
  /// 创建首页快速输入条。
  const QuickInputCard({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
    this.onSecondaryAction,
    this.onCancel,
    this.errorText,
    this.initialValue,
    this.secondaryActionLabel,
  });

  /// 是否正在提交。
  final bool isSubmitting;

  /// 提交动作。
  final Future<void> Function(String value) onSubmit;

  /// 次动作，首页用于进入完整新建页。
  final VoidCallback? onSecondaryAction;

  /// 取消或清空当前草稿的动作。
  final VoidCallback? onCancel;

  /// 错误文案。
  final String? errorText;

  /// 初始值。
  final String? initialValue;

  /// 次按钮文案。
  final String? secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final TextEditingController controller = useTextEditingController(
      text: initialValue,
    );

    useEffect(() {
      final String nextValue = initialValue ?? '';
      if (controller.text == nextValue) {
        return null;
      }

      // 让外部草稿与输入控制器同步，避免快速添加回流后还显示旧草稿。
      controller.value = TextEditingValue(
        text: nextValue,
        selection: TextSelection.collapsed(offset: nextValue.length),
      );
      return null;
    }, <Object?>[controller, initialValue]);

    Future<void> handleSubmit() async {
      await onSubmit(controller.text);
    }

    void handleSecondaryAction() {
      if (onSecondaryAction != null) {
        onSecondaryAction!.call();
        return;
      }

      controller.clear();
      onCancel?.call();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.surfaceCard,
            borderRadius: ScreenNoteRadii.input,
            border: Border.all(color: palette.lineSoft),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  borderRadius: ScreenNoteRadii.small,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_rounded,
                  color: palette.accentAmber,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isSubmitting,
                  minLines: 1,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => handleSubmit(),
                  decoration: InputDecoration(
                    hintText: localizations.quickInputPlaceholder,
                    filled: false,
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: palette.inkPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            localizations.quickInputHelperText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (errorText case final String message) ...<Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: palette.statusOverdue,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            FilledButton(
              onPressed: isSubmitting ? null : handleSubmit,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (isSubmitting)
                    SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.inkOnFocus,
                      ),
                    )
                  else
                    const Icon(Icons.arrow_forward_rounded),
                  const SizedBox(width: 8),
                  Text(localizations.quickInputSubmit),
                ],
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: isSubmitting ? null : handleSecondaryAction,
              child: Text(secondaryActionLabel ?? localizations.cancelAction),
            ),
          ],
        ),
      ],
    );
  }
}
