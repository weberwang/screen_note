import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 历史中心占位页只验证共享壳层下的二级宿主关系，
/// 不在 bootstrap 阶段实现真实恢复链路。
class HistoryCenterPage extends HookConsumerWidget {
  /// 创建历史中心占位页。
  const HistoryCenterPage({super.key});

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
                localizations.historyPlaceholderTitle,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                localizations.historyPlaceholderBody,
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
