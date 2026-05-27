import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 首页快速输入卡片。
class QuickInputCard extends HookWidget {
  /// 创建首页快速输入卡片。
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

  /// 次动作，阶段二首页用于进入完整新建页。
  final VoidCallback? onSecondaryAction;

  /// 取消或清空当前草稿的动作。
  final VoidCallback? onCancel;

  /// 错误文案。
  final String? errorText;

  /// 初始值。
  final String? initialValue;

  /// 次按钮文案，留空时回退到通用取消。
  final String? secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController controller = useTextEditingController(
      text: initialValue,
    );
    useEffect(() {
      final String nextValue = initialValue ?? '';
      if (controller.text == nextValue) {
        return null;
      }

      // 让外部草稿和 Hook 控制器保持一致，避免保存成功后输入框残留旧值。
      controller.value = TextEditingValue(
        text: nextValue,
        selection: TextSelection.collapsed(offset: nextValue.length),
      );
      return null;
    }, <Object?>[controller, initialValue]);

    Future<void> handleSubmit() async {
      await onSubmit(controller.text);
    }

    void handleCancel() {
      controller.clear();
      onCancel?.call();
    }

    void handleSecondaryAction() {
      if (onSecondaryAction != null) {
        onSecondaryAction!();
        return;
      }

      handleCancel();
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
          Text(
            localizations.quickInputPlaceholder,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            localizations.quickInputHelperText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ScreenNoteColors.surfaceMuted,
              borderRadius: ScreenNoteRadii.card,
              border: Border.all(color: ScreenNoteColors.lineSoft),
            ),
            child: TextField(
              controller: controller,
              enabled: !isSubmitting,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: localizations.quickInputPlaceholder,
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (errorText case final String message) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ScreenNoteColors.statusOverdue,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _QuickInputHintChip(
                label: localizations.statusToday,
                color: ScreenNoteColors.accentAmber,
              ),
              _QuickInputHintChip(
                label: localizations.statusPinned,
                color: ScreenNoteColors.statusDone,
              ),
              _QuickInputHintChip(
                label: localizations.statusPrivate,
                color: ScreenNoteColors.statusPrivate,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
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
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: isSubmitting ? null : handleSecondaryAction,
                child: Text(secondaryActionLabel ?? localizations.cancelAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 快速输入卡中的静态提示标签。
class _QuickInputHintChip extends StatelessWidget {
  const _QuickInputHintChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: ScreenNoteRadii.small,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
