import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/src/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/src/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/src/settings/presentation/widgets/widget_install_guide_card.dart';
import 'package:screen_note/src/settings/presentation/widgets/widget_mode_selector.dart';
import 'package:screen_note/src/settings/presentation/widgets/widget_preview_card.dart';
import 'package:screen_note/src/widget_bridge/domain/enums/widget_display_mode.dart';
import 'package:screen_note/src/widget_bridge/presentation/providers/widget_bridge_providers.dart';

/// 锁屏小组件设置页。
///
/// 这里负责 App 内预览、展示模式切换和系统安装说明，
/// 但不直接承载数据库查询或原生 Widget 状态管理，保证阶段三边界清晰。
class WidgetSettingsPage extends ConsumerStatefulWidget {
  /// 创建锁屏小组件设置页。
  const WidgetSettingsPage({super.key});

  @override
  ConsumerState<WidgetSettingsPage> createState() => _WidgetSettingsPageState();
}

class _WidgetSettingsPageState extends ConsumerState<WidgetSettingsPage> {
  WidgetDisplayMode? _selectedMode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<WidgetDisplayMode> modeAsync = ref.watch(
      widgetDisplayModeProvider,
    );
    final WidgetDisplayMode selectedMode =
        _selectedMode ?? modeAsync.value ?? WidgetDisplayMode.single;

    return ScreenNoteScaffold(
      title: Text(localizations.widgetSettingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.widgetSettingsTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              localizations.widgetSettingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            WidgetModeSelector(
              selectedMode: selectedMode,
              onChanged: (WidgetDisplayMode mode) async {
                setState(() {
                  _selectedMode = mode;
                });
                // 展示模式只写本地偏好，后续刷新链路统一从仓储读取，避免页面直接操心原生侧状态。
                await ref.read(widgetDisplayModeRepositoryProvider).save(mode);
                ref.invalidate(widgetDisplayModeProvider);
              },
            ),
            const SizedBox(height: 24),
            WidgetPreviewCard(displayMode: selectedMode),
            const SizedBox(height: 24),
            WidgetInstallGuideCard(
              title: localizations.widgetInstallGuideTitle,
              body: localizations.widgetInstallGuideBody,
            ),
          ],
        ),
      ),
    );
  }
}
