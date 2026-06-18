import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_toast.dart';

/// 事项编辑页统一承接新建态输入与保存主链路，不在页面层直接碰持久化细节。
class TaskFlowEditorPage extends HookConsumerWidget {
  /// 创建事项编辑页。
  const TaskFlowEditorPage({super.key, this.taskId});

  /// 传入既有事项 ID 时进入编辑态；为空时走新建态。
  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingController noteController = useTextEditingController();
    final ValueNotifier<bool> isPinned = useState(false);
    final ValueNotifier<bool> isPrivate = useState(false);
    final ValueNotifier<DateTime?> dueAt = useState<DateTime?>(null);
    final ValueNotifier<bool> isSaving = useState(false);
    final ValueNotifier<bool> didHydrateExistingTask = useState(false);
    final AsyncValue<TaskEntity?> existingTaskAsync = taskId == null
        ? const AsyncData<TaskEntity?>(null)
        : ref.watch(taskFlowTaskByIdProvider(taskId!));
    final TaskEntity? existingTask = existingTaskAsync.asData?.value;
    final bool isEditingExistingTask = taskId != null;

    useEffect(
      () {
        if (!isEditingExistingTask ||
            existingTask == null ||
            didHydrateExistingTask.value) {
          return null;
        }

        // 既有事项只在首次进入编辑态时回填一次，避免异步重建覆盖用户正在输入的草稿。
        titleController.text = existingTask.title;
        noteController.text = existingTask.note;
        isPinned.value = existingTask.isPinned;
        isPrivate.value = existingTask.isPrivate;
        dueAt.value = existingTask.dueAt;
        didHydrateExistingTask.value = true;
        return null;
      },
      <Object?>[
        isEditingExistingTask,
        existingTask,
        didHydrateExistingTask.value,
      ],
    );

    Future<void> saveTask() async {
      final String normalizedTitle = titleController.text.trim();
      if (normalizedTitle.isEmpty) {
        _showMessage(context, localizations.taskTitleRequired);
        return;
      }

      isSaving.value = true;
      try {
        if (isEditingExistingTask) {
          await ref
              .read(updateTaskUseCaseProvider)
              .execute(
                UpdateTaskInput(
                  taskId: taskId!,
                  title: normalizedTitle,
                  note: noteController.text,
                  dueAt: dueAt.value,
                  isPinned: isPinned.value,
                  isPrivate: isPrivate.value,
                ),
              );
        } else {
          await ref
              .read(createTaskUseCaseProvider)
              .execute(
                CreateTaskInput(
                  title: normalizedTitle,
                  note: noteController.text,
                  dueAt: dueAt.value,
                  isPinned: isPinned.value,
                  isPrivate: isPrivate.value,
                ),
              );
        }

        try {
          // 写库成功就视为保存成功；后续首页刷新失败只能降级，不能把已保存结果误报成失败。
          await ref.read(taskFlowHomeControllerProvider.notifier).refresh();
        } catch (_) {}

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (_) {
        if (context.mounted) {
          _showMessage(context, localizations.taskCreateFailed);
        }
      } finally {
        isSaving.value = false;
      }
    }

    Future<void> pickDueDate() async {
      final DateTime initialDate =
          dueAt.value ?? DateTime.now().add(const Duration(days: 1));
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
      if (pickedDate == null) {
        return;
      }

      final DateTime base = dueAt.value ?? DateTime.now();
      dueAt.value = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        base.hour,
        base.minute,
      );
    }

    Future<void> pickDueTime() async {
      final DateTime base = dueAt.value ?? DateTime.now();
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(base),
      );
      if (pickedTime == null) {
        return;
      }

      dueAt.value = DateTime(
        base.year,
        base.month,
        base.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }

    Future<void> pickPinnedState() async {
      final bool? pinnedValue = await showModalBottomSheet<bool>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext sheetContext) {
          return _TaskEditorOptionSheet<bool>(
            title: localizations.taskEditorFocusLabel,
            options: <_TaskEditorOption<bool>>[
              _TaskEditorOption<bool>(
                value: true,
                label: localizations.taskEditorFocusPinnedValue,
              ),
              _TaskEditorOption<bool>(
                value: false,
                label: localizations.taskEditorFocusNormalValue,
              ),
            ],
            selectedValue: isPinned.value,
          );
        },
      );
      if (pinnedValue != null) {
        isPinned.value = pinnedValue;
      }
    }

    Future<void> pickPrivacyState() async {
      final bool? privateValue = await showModalBottomSheet<bool>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext sheetContext) {
          return _TaskEditorOptionSheet<bool>(
            title: localizations.taskEditorPrivacyFieldLabel,
            options: <_TaskEditorOption<bool>>[
              _TaskEditorOption<bool>(
                value: false,
                label: localizations.taskEditorPrivacyPublicValue,
              ),
              _TaskEditorOption<bool>(
                value: true,
                label: localizations.taskEditorPrivacyPrivateValue,
              ),
            ],
            selectedValue: isPrivate.value,
          );
        },
      );
      if (privateValue != null) {
        isPrivate.value = privateValue;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: existingTaskAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) =>
              Center(child: Text(localizations.taskCreateFailed)),
          data: (TaskEntity? task) {
            if (isEditingExistingTask && task == null) {
              return Center(child: Text(localizations.taskCreateFailed));
            }

            return Column(
              children: <Widget>[
                _TaskEditorTopBar(
                  title: localizations.taskEditorTitle,
                  saveLabel: localizations.taskEditorTopSaveAction,
                  onBack: () => Navigator.of(context).maybePop(),
                  onSave: isSaving.value || existingTaskAsync.isLoading
                      ? null
                      : saveTask,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _TaskEditorTitleSurface(
                          controller: titleController,
                          hintText: localizations.taskTitleHint,
                        ),
                        const SizedBox(height: 22),
                        ScreenNotePanel(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: <Widget>[
                              _TaskEditorValueRow(
                                icon: Icons.calendar_today_rounded,
                                label: localizations.taskEditorDueDateLabel,
                                value: _formatDueDate(
                                  context,
                                  localizations,
                                  dueAt.value,
                                ),
                                onTap: pickDueDate,
                              ),
                              _TaskEditorRowDivider(),
                              _TaskEditorValueRow(
                                icon: Icons.schedule_rounded,
                                label: localizations.taskEditorDueTimeLabel,
                                value: _formatDueTime(
                                  context,
                                  localizations,
                                  dueAt.value,
                                ),
                                onTap: pickDueTime,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        ScreenNotePanel(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: <Widget>[
                              _TaskEditorValueRow(
                                icon: Icons.local_offer_outlined,
                                label: localizations.taskEditorFocusLabel,
                                value: isPinned.value
                                    ? localizations.taskEditorFocusPinnedValue
                                    : localizations.taskEditorFocusNormalValue,
                                leadingAccent: isPinned.value,
                                onTap: pickPinnedState,
                              ),
                              _TaskEditorRowDivider(),
                              _TaskEditorValueRow(
                                icon: Icons.lock_outline_rounded,
                                label:
                                    localizations.taskEditorPrivacyFieldLabel,
                                value: isPrivate.value
                                    ? localizations
                                          .taskEditorPrivacyPrivateValue
                                    : localizations
                                          .taskEditorPrivacyPublicValue,
                                leadingAccent: isPrivate.value,
                                onTap: pickPrivacyState,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        ScreenNotePanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.notes_rounded,
                                    size: 22,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    localizations.taskNoteLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: noteController,
                                minLines: 4,
                                maxLines: 7,
                                decoration: InputDecoration.collapsed(
                                  hintText: localizations.taskNoteHint,
                                ),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: FilledButton(
            onPressed: isSaving.value || existingTaskAsync.isLoading
                ? null
                : saveTask,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: Text(localizations.taskSaveAction),
          ),
        ),
      ),
    );
  }

  /// 日期字段统一按当前语言格式化，避免表单行各自拼接日期字符串。
  String _formatDueDate(
    BuildContext context,
    AppLocalizations localizations,
    DateTime? dueAt,
  ) {
    if (dueAt == null) {
      return localizations.taskEditorNoDueDate;
    }
    return MaterialLocalizations.of(context).formatMediumDate(dueAt);
  }

  /// 时间字段统一按当前语言格式化，避免表单行各自拼接时间字符串。
  String _formatDueTime(
    BuildContext context,
    AppLocalizations localizations,
    DateTime? dueAt,
  ) {
    if (dueAt == null) {
      return localizations.taskEditorNoDueTime;
    }
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(dueAt),
      alwaysUse24HourFormat: false,
    );
  }

  /// 统一展示表单页短反馈，避免输入校验和保存失败散落不同提示样式。
  void _showMessage(BuildContext context, String message) {
    ScreenNoteToast.show(context, message);
  }
}

/// 编辑页顶部栏统一承接返回与顶部保存动作，避免再回退到默认 AppBar 节奏。
final class _TaskEditorTopBar extends StatelessWidget {
  /// 创建顶部栏。
  const _TaskEditorTopBar({
    required this.title,
    required this.saveLabel,
    required this.onBack,
    required this.onSave,
  });

  /// 页面标题。
  final String title;

  /// 顶部保存文案。
  final String saveLabel;

  /// 返回动作。
  final VoidCallback onBack;

  /// 顶部保存动作。
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: theme.colorScheme.primary,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 22),
            ),
          ),
          TextButton(onPressed: onSave, child: Text(saveLabel)),
        ],
      ),
    );
  }
}

/// 编辑页大标题输入面只服务单任务主轴输入，不承接其他杂项字段。
final class _TaskEditorTitleSurface extends StatelessWidget {
  /// 创建大标题输入面。
  const _TaskEditorTitleSurface({
    required this.controller,
    required this.hintText,
  });

  /// 标题控制器。
  final TextEditingController controller;

  /// 占位文案。
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: ScreenNoteRadii.largeSurface,
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: TextField(
          controller: controller,
          maxLines: 4,
          minLines: 3,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration.collapsed(hintText: hintText),
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 28,
            height: 1.18,
          ),
        ),
      ),
    );
  }
}

/// 编辑页字段行只负责展示当前值与进入修改，不直接承载真实字段逻辑。
final class _TaskEditorValueRow extends StatelessWidget {
  /// 创建字段行。
  const _TaskEditorValueRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.leadingAccent = false,
  });

  /// 左侧图标。
  final IconData icon;

  /// 字段标签。
  final String label;

  /// 当前字段值。
  final String value;

  /// 行点击动作。
  final VoidCallback onTap;

  /// 是否按高亮值展示当前字段。
  final bool leadingAccent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return InkWell(
      onTap: onTap,
      borderRadius: ScreenNoteRadii.largeSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: leadingAccent
                      ? theme.colorScheme.primary
                      : palette.inkSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: palette.inkSecondary),
          ],
        ),
      ),
    );
  }
}

/// 字段组分隔线统一收口，避免每组行都重复硬编码缩进规则。
final class _TaskEditorRowDivider extends StatelessWidget {
  /// 创建字段组分隔线。
  const _TaskEditorRowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Theme.of(context).dividerColor,
    );
  }
}

/// 编辑页底部选项面板只服务简单二选一，不把复杂业务判断下沉到页面。
final class _TaskEditorOptionSheet<T> extends StatelessWidget {
  /// 创建选项面板。
  const _TaskEditorOptionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  /// 面板标题。
  final String title;

  /// 备选项。
  final List<_TaskEditorOption<T>> options;

  /// 当前已选值。
  final T selectedValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final _TaskEditorOption<T> option in options) ...<Widget>[
              _TaskEditorOptionTile<T>(
                option: option,
                selected: option.value == selectedValue,
              ),
              if (option != options.last) const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

/// 编辑页选项数据只承载值和文案，避免页面底部面板手写平行数组。
final class _TaskEditorOption<T> {
  /// 创建选项数据。
  const _TaskEditorOption({required this.value, required this.label});

  /// 实际值。
  final T value;

  /// 展示文案。
  final String label;
}

/// 选项行只负责渲染当前值与选中态，不承接额外业务逻辑。
final class _TaskEditorOptionTile<T> extends StatelessWidget {
  /// 创建选项行。
  const _TaskEditorOptionTile({required this.option, required this.selected});

  /// 当前选项。
  final _TaskEditorOption<T> option;

  /// 是否选中。
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: ScreenNoteRadii.compactSurface,
      ),
      tileColor: selected ? const Color(0xFFEAF4EB) : const Color(0xFFF6F6F2),
      title: Text(option.label),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: Color(0xFF4D8B52))
          : null,
      onTap: () => Navigator.of(context).pop(option.value),
    );
  }
}
