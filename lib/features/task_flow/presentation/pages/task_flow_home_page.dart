import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/presentation/models/task_flow_home_display_model.dart';
import 'package:screen_note/features/task_flow/presentation/widgets/task_flow_home_sections.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 首页负责消费 `task-flow` 稳定快照，并把共享壳层下的主任务与紧急队列组织成可验收结构。
class TaskFlowHomePage extends HookConsumerWidget {
  /// 创建首页页面。
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AsyncValue<TaskFeedSnapshot> snapshotAsync = ref.watch(
      taskFlowHomeControllerProvider,
    );

    return SafeArea(
      child: snapshotAsync.when(
        data: (TaskFeedSnapshot snapshot) {
          final TaskFlowHomeDisplayModel model =
              TaskFlowHomeDisplayModel.fromSnapshot(snapshot);
          return TaskFlowHomeLoadedView(model: model);
        },
        loading: () => TaskFlowHomeLoadedView(
          model: TaskFlowHomeDisplayModel.placeholder(localizations),
        ),
        error: (_, _) => TaskFlowHomeLoadedView(
          model: TaskFlowHomeDisplayModel.placeholder(
            localizations,
            priorityBodyOverride: localizations.taskFlowHomeLoadFailed,
          ),
        ),
      ),
    );
  }
}
