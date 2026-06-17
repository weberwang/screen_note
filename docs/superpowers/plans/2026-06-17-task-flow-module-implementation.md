# Task Flow Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 完成 `task-flow` 模块当前冻结范围内的代码落地，让首页主任务视图、紧急队列、编辑页主链路与关键测试全部闭环。

**Architecture:** 延续现有 `task-flow` 分层，不新增超出冻结范围的业务抽象。先用现有失败测试锁定首页空态、首页进入编辑页、编辑页校验与回填问题，再最小化修正首页展示组件与编辑页保存/回填链路，最后收口 `task_flow` 聚焦测试与静态检查。

**Tech Stack:** Flutter, hooks_riverpod, go_router, flutter_test, drift, 现有 `task-flow` providers/use cases

---

## File Structure

- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart`
  - 首页展示主结构、空态/历史态、主卡片与队列点击入口
- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
  - 首页状态分发入口，仅在必要时补充最小分支
- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
  - 编辑页校验提示、既有事项回填、保存后返回首页主链路
- `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_home_page_test.dart`
  - 首页空态、历史态与进入编辑页链路回归
- `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`
  - 编辑页校验、回填、保存后回首页与刷新链路回归

### Task 1: 修复首页展示层，让空态、历史态和进入编辑页链路全部可测

**Files:**
- Modify: `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_home_page_test.dart`

- [ ] **Step 1: 先运行首页聚焦测试，确认当前失败集合**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected:

```text
FAIL with missing "还没有待处理事项", missing editor navigation TextField, and missing "历史状态"
```

- [ ] **Step 2: 在首页 loaded view 里补一个历史状态区，直接使用现有本地化文案**

```dart
class TaskFlowHomeHistorySummary extends StatelessWidget {
  /// 首页历史状态摘要区只承接完成/删除概览，不抢主任务层级。
  const TaskFlowHomeHistorySummary({required this.model, super.key});

  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return ScreenNotePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.homeHistoryTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            model.completedCount == 0 && model.deletedCount == 0
                ? localizations.homeHistoryEmptyBody
                : localizations.homeHistorySummaryBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.inkSecondary,
            ),
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: <Widget>[
              _HeaderMetricChip(
                text: localizations.homeHistoryCompletedCount(
                  model.completedCount,
                ),
              ),
              _HeaderMetricChip(
                text: localizations.homeHistoryDeletedCount(
                  model.deletedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: 在首页组合视图里，当没有主任务时直接展示空态标题，并把历史区加到页面末尾**

```dart
        children: <Widget>[
          TaskFlowHomeHeader(model: model),
          SizedBox(height: 28.h),
          if (model.priorityTask == null) ...<Widget>[
            Text(
              localizations.taskFlowEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              localizations.taskFlowEmptyBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: context.screenNotePalette.inkSecondary,
              ),
            ),
          ] else ...<Widget>[
            TaskFlowHomePriorityCard(model: model),
            SizedBox(height: 36.h),
            TaskFlowHomeUrgentQueue(model: model),
          ],
          SizedBox(height: 32.h),
          TaskFlowHomeHistorySummary(model: model),
        ],
```

- [ ] **Step 4: 给主任务卡片和队列行补点击入口，直接推入 `task-editor`**

```dart
import 'package:go_router/go_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
```

```dart
    return InkWell(
      borderRadius: BorderRadius.circular(36.r),
      onTap: task == null
          ? null
          : () {
              context.push(
                '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=${task.id}',
              );
            },
      child: ScreenNotePanel(
        key: const Key('task-flow-home-priority-card'),
        padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 24.h),
        child: Column(
```

```dart
    return InkWell(
      onTap: task == null
          ? null
          : () {
              context.push(
                '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=${task.id}',
              );
            },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Column(
```

- [ ] **Step 5: 收窄主卡底部元信息溢出，避免测试时出现 `RenderFlex overflowed by 0.0500 pixels`**

```dart
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20.sp, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.inkSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
```

- [ ] **Step 6: 重新运行首页聚焦测试，确认首页链路通过**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected:

```text
00:00 +9: All tests passed!
```

### Task 2: 修复编辑页校验提示、既有事项回填与编辑态保存链路

**Files:**
- Modify: `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: 先运行编辑页聚焦测试，锁定当前失败集合**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

```text
FAIL with missing centered toast text, existing-task hydrate failure, and existing-task save flow failure
```

- [ ] **Step 2: 把校验提示挂到根 overlay，保证测试和真机都能稳定看到居中 HUD**

```dart
  static void show(BuildContext context, String message) {
    final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }
```

- [ ] **Step 3: 保持既有事项只回填一次，但把依赖收窄到“任务数据真的到位时”**

```dart
    useEffect(() {
      if (!isEditingExistingTask) {
        return null;
      }
      if (existingTask == null || didHydrateExistingTask.value) {
        return null;
      }

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
```

- [ ] **Step 4: 保存成功后继续先刷新首页，再回到首页根分支，编辑态和新建态都走同一闭环**

```dart
import 'package:go_router/go_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
```

```dart
        try {
          await ref.read(taskFlowHomeControllerProvider.notifier).refresh();
        } catch (_) {}

        if (context.mounted) {
          context.go(RoutePaths.home);
        }
```

- [ ] **Step 5: 重新运行编辑页聚焦测试，确认编辑态与回流链路通过**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

```text
00:00 +8: All tests passed!
```

### Task 3: 做 task-flow 模块收口验证

**Files:**
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/application/task_flow_use_cases_test.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_home_page_test.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`
- Modify: `E:/Projects/flutter/screen_note/docs/project/00-workflow-record.md`

- [ ] **Step 1: 运行整个 task_flow 聚焦测试集**

Run:

```powershell
fvm flutter test test/features/task_flow
```

Expected:

```text
All tests passed!
```

- [ ] **Step 2: 运行 task_flow 聚焦静态检查**

Run:

```powershell
fvm flutter analyze lib/features/task_flow test/features/task_flow
```

Expected:

```text
No issues found!
```

- [ ] **Step 3: 测试与分析通过后，把工作流记录推进到代码落地完成**

```markdown
- current_stage: implementing
- current_module: task-flow
- code_status: landed
- next_skill: superpowers:spec for next module
```

- [ ] **Step 4: 如果任一验证仍失败，先把真实阻塞写回工作流记录，不要假装模块完成**

```text
阻塞必须精确写明是哪条测试、哪条 lint 或哪段实现仍未闭环。
```
