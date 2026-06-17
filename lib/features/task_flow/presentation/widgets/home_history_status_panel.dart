import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页历史状态概览面板，只承接轻量计数与历史入口，不把完整历史列表重新塞回首页。
class HomeHistoryStatusPanel extends StatelessWidget {
  /// 创建首页历史状态概览面板。
  const HomeHistoryStatusPanel({
    required this.completedCount,
    required this.deletedCount,
    this.onTap,
    super.key,
  });

  /// 最近完成计数，供首页快速感知历史积累。
  final int completedCount;

  /// 最近删除计数，供首页快速感知可恢复事项规模。
  final int deletedCount;

  /// 点击后交给页面层切换到历史中心，组件本身不直接持有路由规则。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final bool isEmpty = completedCount == 0 && deletedCount == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32.r),
        child: ScreenNotePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: <Widget>[
                  _HistoryStatusChip(
                    icon: Icons.check_circle_outline_rounded,
                    label: localizations.homeHistoryCompletedCount(
                      completedCount,
                    ),
                    foregroundColor: theme.colorScheme.primary,
                    backgroundColor: palette.surfaceMuted,
                  ),
                  _HistoryStatusChip(
                    icon: Icons.delete_outline_rounded,
                    label: localizations.homeHistoryDeletedCount(
                      deletedCount,
                    ),
                    foregroundColor: const Color(0xFFB95C4C),
                    backgroundColor: const Color(0xFFF7E5DE),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                isEmpty
                    ? localizations.homeHistoryEmptyBody
                    : localizations.homeHistorySummaryBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: palette.inkSecondary,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    localizations.homeHistoryAction,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18.sp,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 首页历史状态胶囊，只负责渲染单个语义计数，避免页面层手写重复装饰。
final class _HistoryStatusChip extends StatelessWidget {
  /// 创建首页历史状态胶囊。
  const _HistoryStatusChip({
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  /// 胶囊左侧语义图标。
  final IconData icon;

  /// 胶囊主文案。
  final String label;

  /// 胶囊前景色。
  final Color foregroundColor;

  /// 胶囊背景色。
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 16.sp,
              color: foregroundColor,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
