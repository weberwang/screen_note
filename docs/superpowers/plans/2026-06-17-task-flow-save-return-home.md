# Task Flow Save Return Home Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 让 `task-flow` 编辑页在保存成功后总是自动刷新首页任务数据，并自动回到首页主链路。

**Architecture:** 延续现有 `task-flow` 分层，不新增新的业务抽象。先用聚焦 Widget 测试锁定“深链进入编辑页后保存仍会回到首页并展示刷新后的主任务”这一行为，再最小化修改编辑页保存成功后的导航与刷新顺序，最后跑聚焦验证与静态检查。

**Tech Stack:** Flutter, hooks_riverpod, go_router, flutter_test, drift, 现有 `task-flow` providers/use cases

---

## File Structure

- `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`
  - 锁定保存后刷新首页并回到首页的真实回归用例，特别是直接进入编辑页时的返回行为
- `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
  - 只调整保存成功后的导航闭环与首页刷新顺序，不改业务字段边界
- `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_home_page_test.dart`
  - 复用现有首页显示断言，确认保存后的首页刷新结果能被看到

### Task 1: 锁定保存后自动回首页并刷新首页的失败测试

**Files:**
- Modify: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: 在编辑页测试中新增“直接进入 editor 后保存仍回到首页”的失败用例**

```dart
    testWidgets('深链进入 editor 后保存会自动回到首页并刷新任务列表', (WidgetTester tester) async {
      final _TestRuntime runtime = _TestRuntime.create();
      addTearDown(runtime.dispose);

      await _pumpEditorRouteApp(
        tester,
        runtime: runtime,
        initialLocation: '/${RoutePaths.taskEditor}',
      );

      await tester.enterText(find.byType(TextField).first, '深链保存后回首页');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final List<TaskEntity> tasks = await runtime.repository.loadTasksByStatus(
        TaskStatus.active,
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.text('深链保存后回首页'), findsOneWidget);
      expect(tasks, hasLength(1));
      expect(tasks.single.title, '深链保存后回首页');
    });
```

- [ ] **Step 2: 为新用例补一个最小 router pump helper，允许直接从 editor 路由起步**

```dart
Future<void> _pumpEditorRouteApp(
  WidgetTester tester, {
  required _TestRuntime runtime,
  required String initialLocation,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1170, 2532);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final GoRouter router = GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.home,
        builder: (BuildContext context, GoRouterState state) =>
            const Scaffold(body: TaskFlowHomePage()),
        routes: <RouteBase>[
          GoRoute(
            path: RoutePaths.taskEditor,
            builder: (BuildContext context, GoRouterState state) =>
                const TaskFlowEditorPage(),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        taskFlowDatabaseProvider.overrideWithValue(runtime.database),
        taskFlowMutationRepositoryProvider.overrideWithValue(runtime.repository),
        taskFlowRepositoryProvider.overrideWithValue(runtime.repository),
      ],
      child: ScreenNoteScreenUtilContract(
        designSize: screenNoteDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? _) {
          return MaterialApp.router(
            locale: const Locale('zh'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ScreenNoteTheme.light(),
            darkTheme: ScreenNoteTheme.dark(),
            routerConfig: router,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}
```

- [ ] **Step 3: 运行聚焦编辑页测试，确认新用例先失败**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

```text
FAIL ... Expected: exactly one matching candidate
Actual: _TextWidgetFinder:<Found 0 widgets with text "深链保存后回首页": []>
```

### Task 2: 最小化修改保存成功后的导航闭环

**Files:**
- Modify: `E:/Projects/flutter/screen_note/lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: 给编辑页补齐首页路由依赖，避免继续只靠 `Navigator.pop()` 返回**

```dart
import 'package:go_router/go_router.dart';
import 'package:screen_note/app/router/route_paths.dart';
```

- [ ] **Step 2: 把保存成功后的返回逻辑改成“先尝试刷新首页，再强制回到首页”**

```dart
        try {
          // 写库成功就视为保存成功；首页刷新失败只能降级，不能把已保存结果误报成失败。
          await ref.read(taskFlowHomeControllerProvider.notifier).refresh();
        } catch (_) {}

        if (context.mounted) {
          context.go(RoutePaths.home);
        }
```

- [ ] **Step 3: 保留空标题校验和保存失败提示，不改动其他编辑页职责**

```dart
      if (normalizedTitle.isEmpty) {
        _showMessage(context, localizations.taskTitleRequired);
        return;
      }
```

- [ ] **Step 4: 重新运行编辑页聚焦测试，确认回首页与刷新链路通过**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

```text
00:00 +6: All tests passed!
```

### Task 3: 做首页联动与静态验证，确认没有破坏既有壳层契约

**Files:**
- Test: `E:/Projects/flutter/screen_note/test/features/task_flow/presentation/task_flow_home_page_test.dart`
- Test: `E:/Projects/flutter/screen_note/test/features/app_shell/app_shell_page_test.dart`
- Modify: `none`

- [ ] **Step 1: 运行首页聚焦测试，确认刷新后的首页结构仍然符合冻结约束**

Run:

```powershell
fvm flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
```

Expected:

```text
00:00 +9: All tests passed!
```

- [ ] **Step 2: 运行壳层聚焦测试，确认“保存后回首页”没有破坏共享导航壳层**

Run:

```powershell
fvm flutter test test/features/app_shell/app_shell_page_test.dart
```

Expected:

```text
00:00 +1: All tests passed!
```

- [ ] **Step 3: 运行静态检查，确认新增路由调用没有引入 lint 或类型问题**

Run:

```powershell
fvm flutter analyze
```

Expected:

```text
No issues found!
```

- [ ] **Step 4: 如果上述验证全部通过，记录本次实现已满足“保存后自动刷新首页任务、保存后自动回到首页”**

```text
验证通过后，不额外扩展字段、页面或交互；直接进入后续收尾或更大范围实现。
```
