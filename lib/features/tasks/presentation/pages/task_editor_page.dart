import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/features/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/overlays/discard_changes_dialog.dart';
import 'package:screen_note/features/tasks/presentation/overlays/due_time_sheet.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';

/// 完整新建页。
///
/// 该页直接对齐冻结后的产品级效果图：
/// 顶部保留低干扰返回，正文先读事项，再读时间与提醒，最后才进入隐私与保存。
class TaskEditorPage extends HookConsumerWidget {
  /// 创建完整新建页。
  const TaskEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final TextEditingController titleController = useTextEditingController();
    final TextEditingController noteController = useTextEditingController();
    final ValueNotifier<DateTime?> dueAt = useState<DateTime?>(null);
    final ValueNotifier<bool> isPrivate = useState<bool>(false);
    final ValueNotifier<bool> isSaving = useState<bool>(false);
    final ValueNotifier<TaskReminderMode> reminderMode =
        useState<TaskReminderMode>(TaskReminderMode.normal);

    useListenable(titleController);
    useListenable(noteController);

    final bool canSave = !isSaving.value && titleController.text.trim().isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        await _handleBackNavigation(
          context: context,
          title: titleController.text,
          note: noteController.text,
          dueAt: dueAt.value,
          isPrivate: isPrivate.value,
          reminderMode: reminderMode.value,
          result: result,
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              palette.backgroundTop,
              palette.backgroundBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 144),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _EditorTopBar(
                    onBackPressed: () => _handleBackNavigation(
                      context: context,
                      title: titleController.text,
                      note: noteController.text,
                      dueAt: dueAt.value,
                      isPrivate: isPrivate.value,
                      reminderMode: reminderMode.value,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations.taskEditorTitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.inkSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.appTitle,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: palette.accentAmber,
                      fontSize: 52,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _EditorTitleCard(
                    controller: titleController,
                    hintText: localizations.taskTitleLabel,
                  ),
                  const SizedBox(height: 16),
                  _EditorSectionCard(
                    child: Column(
                      children: <Widget>[
                        _EditorSettingRow(
                          icon: Icons.schedule_rounded,
                          iconColor: palette.accentAmber,
                          title: localizations.taskDueLabel,
                          value: dueAt.value == null
                              ? localizations.taskDueEmpty
                              : ScreenNoteDateTimeFormatter.formatDateTime(
                                  dueAt.value!,
                                ),
                          onTap: () => _pickDueTime(
                            context: context,
                            initialValue: dueAt.value,
                            onChanged: (DateTime? value) {
                              dueAt.value = value;
                            },
                          ),
                        ),
                        _SectionDivider(color: palette.lineSoft),
                        _EditorSettingRow(
                          icon: Icons.notifications_none_rounded,
                          iconColor: palette.accentTerracotta,
                          title: localizations.taskReminderModeLabel,
                          value: reminderMode.value == TaskReminderMode.normal
                              ? localizations.taskReminderModeNormal
                              : localizations.taskReminderModePersistent,
                          onTap: () {
                            reminderMode.value =
                                reminderMode.value == TaskReminderMode.normal
                                ? TaskReminderMode.persistent
                                : TaskReminderMode.normal;
                          },
                        ),
                        _SectionDivider(color: palette.lineSoft),
                        _EditorSettingRow(
                          icon: Icons.sticky_note_2_outlined,
                          iconColor: palette.accentTerracotta,
                          title: localizations.taskNoteLabel,
                          value: noteController.text.trim().isEmpty
                              ? localizations.taskNoteEmpty
                              : noteController.text.trim(),
                          onTap: () => _editNote(
                            context: context,
                            controller: noteController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TaskEditorPrivacyPreviewCard(
                    title: titleController.text,
                    dueAt: dueAt.value,
                    isPrivate: isPrivate.value,
                  ),
                  const SizedBox(height: 16),
                  _EditorPrivateCard(
                    value: isPrivate.value,
                    onChanged: (bool value) {
                      isPrivate.value = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: FilledButton(
              onPressed: canSave
                  ? () => _saveTask(
                      context: context,
                      ref: ref,
                      titleController: titleController,
                      noteController: noteController,
                      dueAt: dueAt.value,
                      isPrivate: isPrivate.value,
                      reminderMode: reminderMode.value,
                      isSaving: isSaving,
                    )
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(72),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                disabledBackgroundColor: palette.accentAmber.withValues(
                  alpha: 0.5,
                ),
              ),
              child: isSaving.value
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(localizations.taskSaveAction),
            ),
          ),
        ),
      ),
    );
  }
}

/// 处理截止时间选择，保持页面主区只承载稳定结果而不承载复杂选择器。
Future<void> _pickDueTime({
  required BuildContext context,
  required DateTime? initialValue,
  required ValueChanged<DateTime?> onChanged,
}) async {
  final DateTime? selectedTime = await showModalBottomSheet<DateTime?>(
    context: context,
    builder: (BuildContext context) => DueTimeSheet(selectedTime: initialValue),
  );

  if (selectedTime != null || initialValue != null) {
    onChanged(selectedTime);
  }
}

/// 备注通过轻量底部弹层录入，避免主页面退化成长表单。
Future<void> _editNote({
  required BuildContext context,
  required TextEditingController controller,
}) async {
  final TextEditingController draftController = TextEditingController(
    text: controller.text,
  );
  final String? result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      final AppLocalizations localizations = AppLocalizations.of(sheetContext);
      final ScreenNoteThemePalette palette = sheetContext.screenNotePalette;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 16,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceCard,
            borderRadius: ScreenNoteRadii.sheet,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.shadowSoft,
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  localizations.taskNoteLabel,
                  style: Theme.of(sheetContext).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: draftController,
                  minLines: 4,
                  maxLines: 8,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: localizations.taskNoteEmpty,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: Text(localizations.cancelAction),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.of(
                        sheetContext,
                      ).pop(draftController.text),
                      child: Text(localizations.taskSaveChanges),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  draftController.dispose();
  if (result != null) {
    controller.text = result;
  }
}

/// 保存成功后直接回流首页，维持“新建完成即回看首页”的主链路体验。
Future<void> _saveTask({
  required BuildContext context,
  required WidgetRef ref,
  required TextEditingController titleController,
  required TextEditingController noteController,
  required DateTime? dueAt,
  required bool isPrivate,
  required TaskReminderMode reminderMode,
  required ValueNotifier<bool> isSaving,
}) async {
  final AppLocalizations localizations = AppLocalizations.of(context);
  isSaving.value = true;

  try {
    await ref.read(createTaskUseCaseProvider).call(
          CreateTaskInput(
            title: titleController.text,
            note: noteController.text,
            dueAt: dueAt,
            isPinned: false,
            isPrivate: isPrivate,
            reminderMode: reminderMode,
          ),
        );
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskCreateSuccess)));
    context.go(RoutePaths.home);
  } on StateError {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.taskTitleRequired)),
    );
  } catch (_) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.taskCreateFailed)));
  } finally {
    isSaving.value = false;
  }
}

/// 返回前统一检查草稿，避免页面上和系统返回手势产生不同的离开行为。
Future<void> _handleBackNavigation({
  required BuildContext context,
  required String title,
  required String note,
  required DateTime? dueAt,
  required bool isPrivate,
  required TaskReminderMode reminderMode,
  Object? result,
}) async {
  final NavigatorState navigator = Navigator.of(context);
  final bool shouldPop = await _confirmDiscardIfNeeded(
    context: context,
    title: title,
    note: note,
    dueAt: dueAt,
    isPrivate: isPrivate,
    reminderMode: reminderMode,
  );
  if (shouldPop && context.mounted) {
    navigator.pop(result);
  }
}

/// 新建页没有原始实体，因此按本地草稿状态判断是否拦截返回。
Future<bool> _confirmDiscardIfNeeded({
  required BuildContext context,
  required String title,
  required String note,
  required DateTime? dueAt,
  required bool isPrivate,
  required TaskReminderMode reminderMode,
}) async {
  final bool hasDraft =
      title.trim().isNotEmpty ||
      note.trim().isNotEmpty ||
      dueAt != null ||
      isPrivate ||
      reminderMode != TaskReminderMode.normal;
  if (!hasDraft) {
    return true;
  }

  final bool? discard = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) => const DiscardChangesDialog(),
  );
  return discard ?? false;
}

/// 顶部返回栏。
class _EditorTopBar extends StatelessWidget {
  /// 创建顶部返回栏。
  const _EditorTopBar({required this.onBackPressed});

  /// 返回动作。
  final Future<void> Function() onBackPressed;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final String backTooltip = MaterialLocalizations.of(context).backButtonTooltip;

    return Row(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceRaised,
            borderRadius: ScreenNoteRadii.circular,
            border: Border.all(color: palette.lineSoft),
          ),
          child: IconButton(
            tooltip: backTooltip,
            onPressed: () => onBackPressed(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
      ],
    );
  }
}

/// 页面主标题输入卡。
class _EditorTitleCard extends StatelessWidget {
  /// 创建主标题输入卡。
  const _EditorTitleCard({
    required this.controller,
    required this.hintText,
  });

  /// 标题控制器。
  final TextEditingController controller;

  /// 占位文案。
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.lineSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.sticky_note_2_outlined,
              color: palette.accentTerracotta,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 2,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: null,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: palette.inkPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 编辑页分组卡片。
class _EditorSectionCard extends StatelessWidget {
  /// 创建编辑页分组卡片。
  const _EditorSectionCard({required this.child});

  /// 卡片内容。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.lineSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// 编辑页信息行。
class _EditorSettingRow extends StatelessWidget {
  /// 创建编辑页信息行。
  const _EditorSettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onTap,
  });

  /// 左侧图标。
  final IconData icon;

  /// 图标颜色。
  final Color iconColor;

  /// 标题。
  final String title;

  /// 当前值。
  final String value;

  /// 点击动作。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          children: <Widget>[
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.inkSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right_rounded,
              color: palette.inkSecondary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

/// 分组分隔线。
class _SectionDivider extends StatelessWidget {
  /// 创建分组分隔线。
  const _SectionDivider({required this.color});

  /// 分隔线颜色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: color);
  }
}

/// 编辑页隐私预览卡。
class _TaskEditorPrivacyPreviewCard extends StatelessWidget {
  /// 创建编辑页隐私预览卡。
  const _TaskEditorPrivacyPreviewCard({
    required this.title,
    required this.dueAt,
    required this.isPrivate,
  });

  /// 当前事项标题。
  final String title;

  /// 当前截止时间。
  final DateTime? dueAt;

  /// 当前是否开启隐私模式。
  final bool isPrivate;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);
    final String previewTitle = title.trim().isEmpty
        ? localizations.quickInputPlaceholder
        : title.trim();
    final String previewTime = dueAt == null
        ? const TimeOfDay(hour: 6, minute: 30).format(context)
        : TimeOfDay.fromDateTime(dueAt!).format(context);
    final String previewDate = dueAt == null
        ? materialLocalizations.formatMediumDate(DateTime.now())
        : ScreenNoteDateTimeFormatter.formatDateTime(dueAt!);

    return _EditorSectionCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              localizations.taskPreviewTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: null,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: _PreviewVariantCard(
                    title: localizations.taskPreviewHideContentTitle,
                    body: localizations.taskPreviewHideContentBody,
                    selected: isPrivate,
                    phone: _PreviewPhoneCard(
                      appLabel: localizations.appTitle,
                      timeText: previewTime,
                      dateText: previewDate,
                      title: previewTitle,
                      masked: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PreviewVariantCard(
                    title: localizations.taskPreviewShowContentTitle,
                    body: localizations.taskPreviewShowContentBody,
                    selected: !isPrivate,
                    phone: _PreviewPhoneCard(
                      appLabel: localizations.appTitle,
                      timeText: previewTime,
                      dateText: previewDate,
                      title: previewTitle,
                      masked: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 预览模式卡，显式对照隐藏与显示两种外露结果。
class _PreviewVariantCard extends StatelessWidget {
  /// 创建预览模式卡。
  const _PreviewVariantCard({
    required this.title,
    required this.body,
    required this.selected,
    required this.phone,
  });

  /// 模式标题。
  final String title;

  /// 模式说明。
  final String body;

  /// 是否与当前开关状态一致。
  final bool selected;

  /// 内部预览手机图。
  final Widget phone;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? palette.accentAmber : palette.lineSoft,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            phone,
          ],
        ),
      ),
    );
  }
}

/// 锁屏迷你手机预览。
class _PreviewPhoneCard extends StatelessWidget {
  /// 创建锁屏迷你手机预览。
  const _PreviewPhoneCard({
    required this.appLabel,
    required this.timeText,
    required this.dateText,
    required this.title,
    required this.masked,
  });

  /// 应用名称。
  final String appLabel;

  /// 时间文案。
  final String timeText;

  /// 日期文案。
  final String dateText;

  /// 事项标题。
  final String title;

  /// 是否隐藏正文。
  final bool masked;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Container(
            height: 188,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  palette.surfaceFocusCard,
                  Color.lerp(
                    palette.surfaceFocusCard,
                    Colors.black,
                    0.18,
                  )!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 54,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  dateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.inkOnFocusSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeText,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: palette.inkOnFocus,
                    fontSize: 38,
                  ),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surfaceRaised.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: palette.surfaceFocusCard,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.eco_outlined,
                            size: 16,
                            color: palette.inkOnFocus,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                appLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: palette.inkPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                masked ? '•••••••' : title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: palette.inkPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 隐私开关卡。
class _EditorPrivateCard extends StatelessWidget {
  /// 创建隐私开关卡。
  const _EditorPrivateCard({
    required this.value,
    required this.onChanged,
  });

  /// 当前值。
  final bool value;

  /// 切换回调。
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return _EditorSectionCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.lock_outline_rounded,
                color: palette.accentTerracotta,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.taskPrivateLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations.taskPreviewPrivateOnlyBody,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
