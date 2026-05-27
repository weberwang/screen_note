import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/app/route_paths.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';
import 'package:screen_note/shared/presentation/widgets/screen_note_scaffold.dart';
import 'package:screen_note/shared/utils/date_time_formatter.dart';
import 'package:screen_note/features/tasks/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/tasks/domain/entities/task.dart';
import 'package:screen_note/features/tasks/presentation/overlays/discard_changes_dialog.dart';
import 'package:screen_note/features/tasks/presentation/overlays/due_time_sheet.dart';
import 'package:screen_note/features/tasks/presentation/overlays/privacy_mode_sheet.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

/// 阶段二完整新建页。
class TaskEditorPage extends ConsumerStatefulWidget {
  /// 创建阶段二完整新建页。
  const TaskEditorPage({super.key});

  @override
  ConsumerState<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends ConsumerState<TaskEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isPinned = false;
  bool _isPrivate = false;
  bool _isSaving = false;
  DateTime? _dueAt;
  TaskReminderMode _reminderMode = TaskReminderMode.normal;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final bool canSave = !_isSaving && _titleController.text.trim().isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        final NavigatorState navigator = Navigator.of(context);
        final bool shouldPop = await _confirmDiscardIfNeeded();
        if (shouldPop && mounted) {
          navigator.pop(result);
        }
      },
      child: ScreenNoteScaffold(
        title: Text(localizations.taskEditorTitle),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(ScreenNoteSpacing.pageHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.taskEditorHelperText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _buildFieldCard(context),
              const SizedBox(height: 16),
              _buildOptionsCard(context),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: _isSaving ? null : () => context.go(RoutePaths.home),
                      child: Text(localizations.cancelAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: canSave ? _saveTask : null,
                      child: _isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(localizations.taskSaveAction),
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

  /// 编辑表单统一承载标题与备注，避免页面散落多个输入容器。
  Widget _buildFieldCard(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: localizations.taskTitleLabel),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(labelText: localizations.taskNoteLabel),
          ),
        ],
      ),
    );
  }

  /// 复杂配置保持在底部弹层或轻量开关，不在页面主体直接展开系统能力细节。
  Widget _buildOptionsCard(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(ScreenNoteSpacing.cardPadding),
      decoration: BoxDecoration(
        color: ScreenNoteColors.surfaceCard,
        borderRadius: ScreenNoteRadii.card,
        border: Border.all(color: ScreenNoteColors.lineSoft),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(localizations.taskDueLabel),
            subtitle: Text(
              _dueAt == null
                  ? localizations.taskDueEmpty
                  : ScreenNoteDateTimeFormatter.formatDateTime(_dueAt!),
            ),
            onTap: _pickDueTime,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(localizations.privacySettingsTitle),
            subtitle: Text(
              _isPrivate
                  ? localizations.widgetPreviewPrivateState
                  : localizations.valueDisabled,
            ),
            onTap: _pickPrivacyMode,
          ),
          SwitchListTile(
            value: _isPinned,
            contentPadding: EdgeInsets.zero,
            title: Text(localizations.taskPinnedLabel),
            onChanged: (bool value) => setState(() => _isPinned = value),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(localizations.taskReminderModeLabel),
            subtitle: Text(
              _reminderMode == TaskReminderMode.normal
                  ? localizations.taskReminderModeNormal
                  : localizations.taskReminderModePersistent,
            ),
            onTap: _toggleReminderMode,
          ),
        ],
      ),
    );
  }

  /// 截止时间通过底部弹层选择，保持表单主区简洁。
  Future<void> _pickDueTime() async {
    final DateTime? selectedTime = await showModalBottomSheet<DateTime?>(
      context: context,
      builder: (BuildContext context) => DueTimeSheet(selectedTime: _dueAt),
    );

    if (selectedTime != null || _dueAt != null) {
      setState(() {
        _dueAt = selectedTime;
      });
    }
  }

  /// 隐私模式同样通过弹层切换，避免把外露规则写成页面内长表单。
  Future<void> _pickPrivacyMode() async {
    final bool? nextValue = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) => PrivacyModeSheet(isPrivate: _isPrivate),
    );
    if (nextValue == null) {
      return;
    }

    setState(() {
      _isPrivate = nextValue;
    });
  }

  /// 阶段二只保留提醒模式语义，不接真实通知调度。
  void _toggleReminderMode() {
    setState(() {
      _reminderMode = _reminderMode == TaskReminderMode.normal
          ? TaskReminderMode.persistent
          : TaskReminderMode.normal;
    });
  }

  /// 保存成功后回到首页，保持“新建完成即回流首页”的主链路体验。
  Future<void> _saveTask() async {
    final AppLocalizations localizations = AppLocalizations.of(context);
    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(createTaskUseCaseProvider).call(
            CreateTaskInput(
              title: _titleController.text,
              note: _noteController.text,
              dueAt: _dueAt,
              isPinned: _isPinned,
              isPrivate: _isPrivate,
              reminderMode: _reminderMode,
            ),
          );
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.taskCreateSuccess)));
      context.go(RoutePaths.home);
    } on StateError {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.taskTitleRequired)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// 新建页没有原始实体时，只按本地草稿是否有内容来决定是否拦截返回。
  Future<bool> _confirmDiscardIfNeeded() async {
    final bool hasDraft =
        _titleController.text.trim().isNotEmpty ||
        _noteController.text.trim().isNotEmpty ||
        _dueAt != null ||
        _isPinned ||
        _isPrivate ||
        _reminderMode != TaskReminderMode.normal;
    if (!hasDraft) {
      return true;
    }

    final bool? discard = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => const DiscardChangesDialog(),
    );
    return discard ?? false;
  }
}
