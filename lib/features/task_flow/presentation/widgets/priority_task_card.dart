import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 首页主事项卡片，只负责按冻结稿层级呈现当前最重要的一条事项。
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
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final bool isEmpty = task == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.r),
            border: Border.all(color: palette.lineSoft),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                palette.surfaceRaised,
                palette.surfaceCard,
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBadge(context, localizations.homePriorityLabel),
                SizedBox(height: 22.h),
                Text(
                  _buildTitle(localizations),
                  maxLines: isEmpty ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 28.sp,
                    height: 1.14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  _buildSummary(localizations),
                  maxLines: isEmpty ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: palette.inkSecondary,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 24.h),
                Divider(height: 1, color: palette.lineSoft),
                SizedBox(height: 18.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _PriorityMetaIcon(task: task),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: _PriorityMetaCopy(
                        title: localizations.taskEditorDueDateLabel,
                        value: _buildDueLabel(context, localizations),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    FilledButton(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        minimumSize: Size(132.w, 52.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                      ),
                      child: Text(
                        isEmpty
                            ? localizations.taskFlowPriorityEmptyAction
                            : localizations.taskFlowPriorityContinueAction,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 主卡片标题优先保护私密事项，不在首页暴露任务正文。
  String _buildTitle(AppLocalizations localizations) {
    final TaskEntity? currentTask = task;
    if (currentTask == null) {
      return localizations.taskFlowEmptyTitle;
    }
    if (currentTask.isPrivate) {
      return localizations.taskFlowPrivateTitle;
    }
    return currentTask.title;
  }

  /// 主卡片说明优先保护隐私任务，避免首页直接泄露备注正文。
  String _buildSummary(AppLocalizations localizations) {
    final TaskEntity? currentTask = task;
    if (currentTask == null) {
      return localizations.taskFlowEmptyBody;
    }
    if (currentTask.isPrivate) {
      return localizations.taskFlowPrivateTaskHint;
    }
    if (currentTask.note.trim().isNotEmpty) {
      return currentTask.note.trim();
    }
    return localizations.taskFlowPriorityFallbackBody;
  }

  /// 到期信息只做展示格式化，不在页面层引入新的业务排序或状态推导。
  String _buildDueLabel(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final TaskEntity? currentTask = task;
    if (currentTask == null) {
      return localizations.taskEditorNoDueDate;
    }
    final DateTime? dueAt = currentTask.dueAt;
    if (dueAt == null) {
      return currentTask.isPinned
          ? localizations.taskFlowPinnedLabel
          : localizations.taskEditorNoDueDate;
    }

    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);
    return materialLocalizations.formatMediumDate(dueAt);
  }

  /// 小标签维持首页主卡片的第一视觉锚点，避免主事项层级被削弱。
  Widget _buildBadge(BuildContext context, String label) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

/// 主事项卡片底部图标块，只负责表达当前截止信息的视觉锚点。
final class _PriorityMetaIcon extends StatelessWidget {
  /// 创建底部图标块。
  const _PriorityMetaIcon({required this.task});

  /// 当前主事项。
  final TaskEntity? task;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final ThemeData theme = Theme.of(context);
    final IconData icon = switch (task) {
      null => Icons.add_task_rounded,
      TaskEntity(:final isPinned, :final dueAt)
          when isPinned && dueAt == null =>
        Icons.push_pin_rounded,
      _ => Icons.calendar_today_rounded,
    };

    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(14.r),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 20.sp,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

/// 主事项卡片底部文案块，只负责展示当前截止信息，不承接交互。
final class _PriorityMetaCopy extends StatelessWidget {
  /// 创建底部文案块。
  const _PriorityMetaCopy({
    required this.title,
    required this.value,
  });

  /// 元信息标题。
  final String title;

  /// 元信息值。
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: palette.inkSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
