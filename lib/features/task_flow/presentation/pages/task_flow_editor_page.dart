import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_panel.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';

/// 事项完整编辑页，统一收口标题、备注、置顶、隐私与提醒模式的真实录入。
class TaskFlowEditorPage extends HookConsumerWidget {
  /// 创建事项编辑页。
  const TaskFlowEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingController noteController = useTextEditingController();
    final ValueNotifier<bool> isPinned = useState(false);
    final ValueNotifier<bool> isPrivate = useState(false);
    final ValueNotifier<TaskReminderMode> reminderMode = useState(
      TaskReminderMode.normal,
    );
    final ValueNotifier<bool> isSaving = useState(false);

    Future<void> saveTask() async {
      final String title = titleController.text.trim();
      if (title.isEmpty) {
        _showMessage(context, localizations.taskTitleRequired);
        return;
      }

      isSaving.value = true;
      try {
        await ref.read(taskFlowHomeControllerProvider.notifier).createQuickTask(
          CreateTaskInput(
            title: title,
            note: noteController.text,
            isPinned: isPinned.value,
            isPrivate: isPrivate.value,
            reminderMode: reminderMode.value,
          ),
        );
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

    return ScreenNoteScaffold(
      title: Text(localizations.taskEditorTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          ScreenNoteSpacing.pageHorizontal,
          12,
          ScreenNoteSpacing.pageHorizontal,
          ScreenNoteSpacing.pageVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScreenNotePanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.taskEditorTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.taskEditorHelperText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: ScreenNoteSpacing.sectionGap),
            ScreenNotePanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: localizations.taskTitleLabel,
                      hintText: localizations.quickInputPlaceholder,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: localizations.taskNoteLabel,
                      hintText: localizations.taskNoteEmpty,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: isPinned.value,
                    onChanged: (bool value) => isPinned.value = value,
                    title: Text(localizations.taskPinnedLabel),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: isPrivate.value,
                    onChanged: (bool value) => isPrivate.value = value,
                    title: Text(localizations.taskPrivateLabel),
                    subtitle: Text(localizations.privacyExplainBody),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations.taskReminderModeLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<TaskReminderMode>(
                    selected: <TaskReminderMode>{reminderMode.value},
                    onSelectionChanged: (Set<TaskReminderMode> value) {
                      reminderMode.value = value.first;
                    },
                    segments: <ButtonSegment<TaskReminderMode>>[
                      ButtonSegment<TaskReminderMode>(
                        value: TaskReminderMode.normal,
                        label: Text(localizations.taskReminderModeNormal),
                      ),
                      ButtonSegment<TaskReminderMode>(
                        value: TaskReminderMode.persistent,
                        label: Text(localizations.taskReminderModePersistent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      footer: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ScreenNoteSpacing.pageHorizontal,
            12,
            ScreenNoteSpacing.pageHorizontal,
            ScreenNoteSpacing.pageVertical,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: isSaving.value
                      ? null
                      : () => Navigator.of(context).maybePop(),
                  child: Text(localizations.cancelAction),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: isSaving.value ? null : saveTask,
                  child: Text(localizations.taskSaveAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 统一展示表单页短反馈，避免页面内散落不同 SnackBar 配置。
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
