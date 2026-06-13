import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 设置中心占位页只承接共享宿主下的基础入口位置，
/// 真正的通知、隐私和展示偏好逻辑留到模块实现阶段。
class SettingsCenterPage extends HookConsumerWidget {
  /// 创建设置中心占位页。
  const SettingsCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 120.h),
        child: ScreenNotePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.settingsPlaceholderTitle,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                localizations.settingsPlaceholderBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF5F6762),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
