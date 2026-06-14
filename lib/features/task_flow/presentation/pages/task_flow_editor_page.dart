import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 事项编辑页统一承接新建态输入与保存主链路，不在页面层直接碰持久化细节。
class TaskFlowEditorPage extends HookConsumerWidget {
  /// 创建事项编辑页。
  const TaskFlowEditorPage({
    super.key,
    this.taskId,
  });

  /// 传入既有事项 ID 时进入编辑态；为空时走新建态。
  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TextEditingController titleController = useTextEditingController();
    final TextEditingController noteController = useTextEditingController();
    final ValueNotifier<bool> isPinned = useState(false);
    final ValueNotifier<bool> isPrivate = useState(false);
    final ValueNotifier<bool> isSaving = useState(false);
    final ValueNotifier<bool> didHydrateExistingTask = useState(false);
    final AsyncValue<TaskEntity?> existingTaskAsync = taskId == null
        ? const AsyncData<TaskEntity?>(null)
        : ref.watch(taskFlowTaskByIdProvider(taskId!));
    final TaskEntity? existingTask = existingTaskAsync.asData?.value;
    final bool isEditingExistingTask = taskId != null;

    useEffect(() {
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
      didHydrateExistingTask.value = true;
      return null;
    }, <Object?>[
      isEditingExistingTask,
      existingTask,
      didHydrateExistingTask.value,
    ]);

    Future<void> saveTask() async {
      final String normalizedTitle = titleController.text.trim();
      if (normalizedTitle.isEmpty) {
        _showMessage(context, localizations.taskTitleRequired);
        return;
      }

      isSaving.value = true;
      try {
        if (isEditingExistingTask) {
          await ref.read(updateTaskUseCaseProvider).execute(
            UpdateTaskInput(
              taskId: taskId!,
              title: normalizedTitle,
              note: noteController.text,
              isPinned: isPinned.value,
              isPrivate: isPrivate.value,
            ),
          );
        } else {
          await ref.read(createTaskUseCaseProvider).execute(
            CreateTaskInput(
              title: normalizedTitle,
              note: noteController.text,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.taskEditorTitle),
      ),
      body: SafeArea(
        child: existingTaskAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Text(localizations.taskCreateFailed),
          ),
          data: (TaskEntity? task) {
            if (isEditingExistingTask && task == null) {
              return Center(
                child: Text(localizations.taskCreateFailed),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: <Widget>[
                Text(
                  localizations.taskEditorTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.taskEditorHelperText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: localizations.taskTitleLabel,
                    hintText: localizations.taskTitleHint,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: localizations.taskNoteLabel,
                    hintText: localizations.taskNoteHint,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: isPinned.value,
                  onChanged: isSaving.value
                      ? null
                      : (bool value) {
                          isPinned.value = value;
                        },
                  title: Text(localizations.taskPinnedLabel),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: isPrivate.value,
                  onChanged: isSaving.value
                      ? null
                      : (bool value) {
                          isPrivate.value = value;
                        },
                  title: Text(localizations.taskPrivateLabel),
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
            child: Text(localizations.taskSaveAction),
          ),
        ),
      ),
    );
  }

  /// 统一展示表单页短反馈，避免输入校验和保存失败散落不同提示样式。
  void _showMessage(BuildContext context, String message) {
    _TaskFlowCupertinoToast.show(context, message);
  }
}

/// 编辑页短提示统一走 iOS 风格居中 HUD，避免校验反馈再回退到底部 SnackBar 语义。
final class _TaskFlowCupertinoToast {
  _TaskFlowCupertinoToast._();

  static OverlayEntry? _activeEntry;
  static Timer? _dismissTimer;

  /// 展示居中轻提示；新提示会覆盖旧提示，避免连续点击时叠出多层浮层。
  static void show(BuildContext context, String message) {
    final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    _dismissCurrent();
    _activeEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        final Color backgroundColor = CupertinoDynamicColor.resolve(
          CupertinoColors.systemGrey6,
          overlayContext,
        ).withValues(alpha: 0.94);
        final Color textColor = CupertinoDynamicColor.resolve(
          CupertinoColors.label,
          overlayContext,
        );

        return IgnorePointer(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: CupertinoPopupSurface(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_activeEntry!);
    _dismissTimer = Timer(const Duration(seconds: 2), _dismissCurrent);
  }

  /// 统一清理当前轻提示，避免旧定时器在下一条提示出现后误删新浮层。
  static void _dismissCurrent() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _activeEntry?.remove();
    _activeEntry = null;
  }
}
