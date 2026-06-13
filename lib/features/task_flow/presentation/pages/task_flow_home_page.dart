import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页占位页负责承接共享壳层下的首屏层级，
/// 当前只建立视觉骨架，不连接真实任务数据。
class TaskFlowHomePage extends HookConsumerWidget {
  /// 创建首页占位页。
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 120.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.homeGreetingTitle,
              style: theme.textTheme.displaySmall,
            ),
            SizedBox(height: 8.h),
            Text(
              localizations.homeGreetingSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5F6762),
              ),
            ),
            SizedBox(height: 28.h),
            ScreenNotePanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDE8D8),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      localizations.homePriorityLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    localizations.homePriorityTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.homePriorityBody,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF5F6762),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              localizations.homeQueueTitle,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),
            ...List<Widget>.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ScreenNotePanel(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  child: Row(
                    children: [
                      const Icon(Icons.radio_button_unchecked_rounded),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          localizations.homeQueuePlaceholder(index + 1),
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
