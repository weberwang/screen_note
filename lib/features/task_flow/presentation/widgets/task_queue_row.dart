import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 首页队列行，只负责渲染单条事项的标题、元信息与进入详情意图。
class TaskQueueRow extends StatelessWidget {
  /// 创建队列行。
  const TaskQueueRow({
    required this.task,
    required this.isOverdue,
    this.onTap,
    super.key,
  });

  /// 行内展示的事项。
  final TaskEntity task;

  /// 是否按逾期高风险样式展示。
  final bool isOverdue;

  /// 点击行后的导航由页面层决定，组件只暴露用户意图。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final Color accentColor = isOverdue
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
          child: Row(
            children: <Widget>[
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: isOverdue
                      ? const Color(0xFFF7E5DE)
                      : palette.surfaceCard,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _buildLeadingIcon(),
                  size: 24.sp,
                  color: accentColor,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.isPrivate
                          ? localizations.taskFlowPrivateTitle
                          : task.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _buildMeta(context, localizations),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 24.sp,
                color: palette.inkSecondary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 队列图标保持语义克制，不把列表行错误地做成多层卡片。
  IconData _buildLeadingIcon() {
    if (task.isPrivate) {
      return Icons.lock_outline_rounded;
    }
    if (isOverdue) {
      return Icons.bug_report_outlined;
    }
    if (task.isPinned) {
      return Icons.push_pin_outlined;
    }
    return Icons.notifications_none_rounded;
  }

  /// 队列元信息只做展示文案拼装，避免页面层重复做状态分组判断。
  String _buildMeta(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    if (task.isPrivate) {
      return localizations.taskFlowPrivateTaskHint;
    }
    final DateTime? dueAt = task.dueAt;
    if (dueAt == null) {
      return localizations.taskEditorNoDueDate;
    }

    final String formatted = DateFormat(
      'MMM d, yyyy',
      localizations.localeName,
    ).format(dueAt);
    return isOverdue
        ? localizations.taskFlowOverdueAtLabel(formatted)
        : localizations.taskFlowDueAtLabel(formatted);
  }
}
