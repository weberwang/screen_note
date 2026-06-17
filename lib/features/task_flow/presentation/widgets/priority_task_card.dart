import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';

/// 首页主事项卡片，只负责按既定视觉层级呈现当前最重要的一条事项。
class PriorityTaskCard extends StatelessWidget {
  /// 创建主事项卡片。
  const PriorityTaskCard({
    required this.task,
    this.onTap,
    super.key,
  });

  /// 当前首页主事项；为空时展示最小空态提示。
  final TaskEntity? task;

  /// 点击主事项时交给页面层处理导航，组件本身不直接持有路由规则。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    if (task == null) {
      return ScreenNotePanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBadge(context, localizations.homePriorityLabel),
            SizedBox(height: 20.h),
            Text(
              localizations.taskFlowEmptyTitle,
              style: theme.textTheme.headlineLarge,
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.taskFlowEmptyBody,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32.r),
        child: ScreenNotePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBadge(context, localizations.homePriorityLabel),
              SizedBox(height: 20.h),
              Text(
                task!.title,
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height: 12.h),
              Text(
                _buildSummary(localizations),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: <Widget>[
                  Icon(
                    task!.isPinned
                        ? Icons.push_pin_rounded
                        : Icons.schedule_rounded,
                    size: 18.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _buildDueLabel(localizations),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 主卡片文案优先保护隐私任务，避免首页直接泄露正文。
  String _buildSummary(AppLocalizations localizations) {
    if (task!.isPrivate) {
      return localizations.taskFlowPrivateTaskHint;
    }
    if (task!.note.trim().isNotEmpty) {
      return task!.note.trim();
    }
    return localizations.taskFlowPriorityFallbackBody;
  }

  /// 到期信息只做展示格式化，不在页面层引入新的业务排序或状态推导。
  String _buildDueLabel(AppLocalizations localizations) {
    if (task!.isPinned) {
      return localizations.taskFlowPinnedLabel;
    }
    final DateTime? dueAt = task!.dueAt;
    if (dueAt == null) {
      return localizations.taskFlowNoDueDate;
    }
    final String formatted = DateFormat(
      'M/d HH:mm',
      localizations.localeName,
    ).format(dueAt);
    return localizations.taskFlowDueAtLabel(formatted);
  }

  /// 小标签维持首页主卡片的第一视觉锚点，避免主事项层级被削弱。
  Widget _buildBadge(BuildContext context, String label) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE8D8),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
