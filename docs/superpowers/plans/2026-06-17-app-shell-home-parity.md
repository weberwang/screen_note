# App Shell Home Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore the `app-shell` home surface so it matches the frozen `app-shell.impl.md` structure without adding any new interaction beyond the documented shell responsibilities.

**Architecture:** Keep `app-shell` routing, quick add ownership, and shell boundaries unchanged. Rebuild only the Home presentation structure by locking tests first, then rendering the frozen hierarchy through focused `task_flow` presentation widgets that consume the existing display model.

**Tech Stack:** Flutter, hooks_riverpod, flutter_test, go_router, flutter_screenutil, existing `ScreenNoteTheme` and app localization

---

## File Structure

- `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`
  - 壳层级回归测试入口
  - 固定 Home 结构 key、切页后的可见性、单宿主约束
- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
  - Home 页面数据装配入口
  - 继续只负责读取 provider 并选择 loaded / loading / error 视图
- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart`
  - Home 结构化显示组件
  - 承载 header、priority card、urgent queue 及其内部细分部件

### Task 1: Lock shell and Home hierarchy in widget tests

**Files:**
- Modify: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`

- [ ] **Step 1: Replace the current test body with assertions for the frozen Home structure**

```dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/features/app_shell/presentation/pages/app_shell_page.dart';
import 'package:screen_note/features/settings_center/application/providers/settings_center_runtime_providers.dart';
import 'package:screen_note/features/settings_center/presentation/pages/settings_center_page.dart';
import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/l10n/app_localizations.dart';

/// 验证共享壳层只承载一个宿主，并按冻结结构显示 Home 主层级。
void main() {
  testWidgets(
    '壳层切换分支时保持单宿主，并稳定呈现 Home 主层级',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final TaskFlowDatabase database = TaskFlowDatabase.test(
        NativeDatabase.memory(),
      );
      addTearDown(database.close);

      final ProviderContainer container = ProviderContainer(
        overrides: <Override>[
          taskFlowDatabaseProvider.overrideWithValue(database),
          settingsSharedPreferencesProvider.overrideWith(
            (Ref ref) async => preferences,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ScreenNoteApp(),
        ),
      );
      await tester.pumpAndSettle();

      final AppLocalizations localizations = AppLocalizations.of(
        tester.element(find.byType(AppShellPage)),
      );

      expect(find.byType(AppShellPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-nav-surface')), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(
        find.byKey(const Key('task-flow-home-shell-top-action')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-priority-card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-priority-meta-row')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-priority-status-chip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-queue-row-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-queue-row-1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('task-flow-home-queue-row-2')),
        findsOneWidget,
      );
      expect(find.text(localizations.homeGreetingTitle), findsOneWidget);
      expect(find.text(localizations.homePriorityTitle), findsOneWidget);

      await tester.tap(find.text(localizations.settingsTabLabel));
      await tester.pumpAndSettle();

      expect(find.byType(AppShellPage), findsOneWidget);
      expect(find.byType(SettingsCenterPage), findsOneWidget);
      expect(find.byKey(const Key('app-shell-nav-surface')), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(
        find.byKey(const Key('task-flow-home-shell-top-action')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('task-flow-home-priority-card')),
        findsNothing,
      );
    },
  );
}
```

- [ ] **Step 2: Run the focused widget test and confirm it fails for missing structure if the UI is not aligned yet**

Run:

```powershell
fvm flutter test test/features/app_shell/app_shell_page_test.dart
```

Expected:

```text
FAIL ... Expected: exactly one matching candidate
Actual: _KeyWidgetFinder:<Found 0 widgets with key [<'task-flow-home-priority-card'>]: []>
```

- [ ] **Step 3: Do not edit other tests in this task**

```text
Only the focused app_shell page test should change here.
```

### Task 2: Keep Home page as a thin data entry point

**Files:**
- Modify: `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`

- [ ] **Step 1: Make the page file only assemble state and delegate structure to the loaded view**

```dart
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
        error: (_, __) => TaskFlowHomeLoadedView(
          model: TaskFlowHomeDisplayModel.placeholder(
            localizations,
            priorityBodyOverride: localizations.taskFlowHomeLoadFailed,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run the same focused test to verify the page still wires the Home surface correctly**

Run:

```powershell
fvm flutter test test/features/app_shell/app_shell_page_test.dart
```

Expected:

```text
Either the same structure-related FAIL remains, or the test progresses to the next missing widget assertion in Task 3.
```

### Task 3: Rebuild the frozen Home hierarchy in focused presentation widgets

**Files:**
- Modify: `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/widgets/task_flow_home_sections.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`

- [ ] **Step 1: Keep a single loaded view with the frozen vertical order**

```dart
class TaskFlowHomeLoadedView extends StatelessWidget {
  /// 首页加载完成后的组合视图，统一承接头部、主卡片和紧急队列区域。
  const TaskFlowHomeLoadedView({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TaskFlowHomeHeader(model: model),
          SizedBox(height: 28.h),
          TaskFlowHomePriorityCard(model: model),
          SizedBox(height: 36.h),
          TaskFlowHomeUrgentQueue(model: model),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Rebuild the header with greeting, metrics, and the top-right shell action key**

```dart
class TaskFlowHomeHeader extends StatelessWidget {
  /// 创建首页头部。
  const TaskFlowHomeHeader({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.homeGreetingTitle,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    localizations.homeGreetingSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: palette.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Container(
              key: const Key('task-flow-home-shell-top-action'),
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: palette.surfaceRaised,
                shape: BoxShape.circle,
                border: Border.all(color: palette.lineSoft),
              ),
              child: Icon(
                Icons.more_horiz_rounded,
                color: palette.inkPrimary,
                size: 26.sp,
              ),
            ),
          ],
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
              text: localizations.homeHistoryDeletedCount(model.deletedCount),
            ),
          ],
        ),
      ],
    );
  }
}
```

- [ ] **Step 3: Rebuild the priority card with the frozen shell hierarchy and stable keys**

```dart
class TaskFlowHomePriorityCard extends StatelessWidget {
  /// 创建首页主任务卡片。
  const TaskFlowHomePriorityCard({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final TaskEntity? task = model.priorityTask;
    final String title = task?.title ?? localizations.homePriorityTitle;
    final String body =
        model.priorityBodyOverride ??
        _visiblePriorityBody(task, localizations) ??
        localizations.homePriorityBody;
    final String dueLabel = _priorityDueLabel(task, localizations);
    final String secondaryMeta = task?.isPinned == true
        ? localizations.taskFlowPinnedLabel
        : localizations.appTitle;
    final String statusLabel = task?.isPinned == true
        ? localizations.taskFlowPinnedLabel
        : localizations.homePriorityLabel;

    return ScreenNotePanel(
      key: const Key('task-flow-home-priority-card'),
      padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _PriorityLabelChip(
                  text: localizations.homePriorityLabel,
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 68.w,
                height: 68.w,
                decoration: BoxDecoration(
                  color: palette.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 26.h),
          Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.06,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: palette.inkSecondary,
              height: 1.55,
            ),
          ),
          SizedBox(height: 28.h),
          Divider(color: palette.lineSoft, height: 1),
          SizedBox(height: 18.h),
          Row(
            key: const Key('task-flow-home-priority-meta-row'),
            children: <Widget>[
              Expanded(
                child: _MetaItem(icon: Icons.event_outlined, text: dueLabel),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _MetaItem(
                  icon: Icons.view_list_rounded,
                  text: secondaryMeta,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                key: const Key('task-flow-home-priority-status-chip'),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: palette.surfaceMuted.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
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

- [ ] **Step 4: Replace pill-like placeholders with row-style urgent queue items**

```dart
class TaskFlowHomeUrgentQueue extends StatelessWidget {
  /// 创建首页紧急队列。
  const TaskFlowHomeUrgentQueue({required this.model, super.key});

  /// 当前首页显示模型。
  final TaskFlowHomeDisplayModel model;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScreenNoteThemePalette palette = context.screenNotePalette;
    final AppLocalizations localizations = AppLocalizations.of(context);
    final List<TaskEntity?> displayTasks = model.queueTasks.isEmpty
        ? List<TaskEntity?>.filled(3, null)
        : <TaskEntity?>[
            ...model.queueTasks,
            ...List<TaskEntity?>.filled(3 - model.queueTasks.length, null),
          ].take(3).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                localizations.homeQueueTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(color: palette.lineSoft, height: 1),
        ...List<Widget>.generate(displayTasks.length, (int index) {
          final TaskEntity? task = displayTasks[index];
          return _QueueRow(
            key: Key('task-flow-home-queue-row-$index'),
            task: task,
            index: index,
          );
        }),
      ],
    );
  }
}
```

- [ ] **Step 5: Keep helper widgets private and focused**

```text
Retain private helpers only for:
- _HeaderMetricChip
- _PriorityLabelChip
- _MetaItem
- _QueueRow
- _formatDateTime
```

- [ ] **Step 6: Run the focused widget test again**

Run:

```powershell
fvm flutter test test/features/app_shell/app_shell_page_test.dart
```

Expected:

```text
00:00 +1: All tests passed!
```

### Task 4: Verify no scope drift and summarize blockers if verification fails

**Files:**
- Test: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`
- Modify: `E:/Projects/flutter/screen_note/docs/project/00-workflow-record.md` (only if verification is blocked and the blocker must be recorded)

- [ ] **Step 1: Re-run the exact focused command once more as the final verification pass**

Run:

```powershell
fvm flutter test test/features/app_shell/app_shell_page_test.dart
```

Expected:

```text
00:00 +1: All tests passed!
```

- [ ] **Step 2: If Flutter environment resolution blocks the run, record the blocker instead of claiming green**

```text
If the command fails because fvm/flutter/test environment is unavailable,
update docs/project/00-workflow-record.md blockers section with the exact
command failure and stop before claiming success.
```

- [ ] **Step 3: Keep implementation inside spec scope**

```text
Do not add pull-to-refresh.
Do not auto-open quick add on launch return.
Do not change bottom navigation destinations.
Do not expand History or Settings into final feature content.
```
