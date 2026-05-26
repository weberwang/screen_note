import 'package:flutter/material.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/widget_bridge/domain/enums/widget_display_mode.dart';

/// 锁屏小组件模式切换器。
///
/// 这里把模式按钮单独拆出来，保证设置页、预览页与未来更多入口共用同一套模式文案和选中反馈，
/// 避免每个页面各自维护一份模式映射。
class WidgetModeSelector extends StatelessWidget {
  /// 创建锁屏小组件模式切换器。
  const WidgetModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  /// 当前选中的展示模式。
  final WidgetDisplayMode selectedMode;

  /// 用户切换模式后的回调。
  final ValueChanged<WidgetDisplayMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WidgetDisplayMode.values.map((WidgetDisplayMode mode) {
        final bool isSelected = mode == selectedMode;
        return ChoiceChip(
          label: Text(_labelForMode(localizations, mode)),
          selected: isSelected,
          onSelected: (_) => onChanged(mode),
          selectedColor: ScreenNoteColors.accentAmber,
          backgroundColor: ScreenNoteColors.surfaceCard,
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : ScreenNoteColors.inkPrimary,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: ScreenNoteRadii.small,
            side: BorderSide(
              color: isSelected
                  ? ScreenNoteColors.accentAmber
                  : ScreenNoteColors.lineSoft,
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  String _labelForMode(
    AppLocalizations localizations,
    WidgetDisplayMode mode,
  ) {
    return switch (mode) {
      WidgetDisplayMode.single => localizations.widgetDisplayModeSingle,
      WidgetDisplayMode.list3 => localizations.widgetDisplayModeList3,
      WidgetDisplayMode.today => localizations.widgetDisplayModeToday,
      WidgetDisplayMode.private => localizations.widgetDisplayModePrivate,
      WidgetDisplayMode.empty => localizations.widgetDisplayModeEmpty,
    };
  }
}
