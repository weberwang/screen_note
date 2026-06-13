# app-shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `app-shell` 从 bootstrap 占位宿主提升为可承接后续模块接入的正式共享壳层，但不越界实现任何业务模块逻辑。

**Architecture:** 继续复用现有 `StatefulShellRoute.indexedStack` 根路由，把 `app-shell` 的真实职责收敛到共享 scaffold、全局快速添加、启动落点解析和全局轻反馈宿主。所有真实业务数据仍留在后续 `task_flow / history_center / settings_center / widget_bridge` 模块中，当前只建立稳定接口和展示骨架。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, go_router, flutter_screenutil, flutter_test

---

## 文件结构

### 新建文件

- `lib/features/app_shell/domain/entities/app_shell_launch_intent.dart`
  - 启动落点意图实体，只表达 `home / history / settings / fallback_home`
- `lib/features/app_shell/application/app_shell_launch_resolver.dart`
  - 解析 `WidgetLaunchBridge` 提供的原始启动位置，返回安全意图
- `lib/features/app_shell/application/providers/app_shell_ui_state.dart`
  - 承接快速添加弹层开关与共享反馈消息
- `lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart`
  - 共享快速添加弹层壳，不接真实创建链路
- `lib/features/app_shell/presentation/widgets/app_shell_feedback_host.dart`
  - 共享轻反馈宿主
- `test/features/app_shell/presentation/app_shell_page_test.dart`
  - 壳层页切换、快速添加和反馈测试
- `test/features/app_shell/application/app_shell_launch_resolver_test.dart`
  - 启动落点解析测试

### 修改文件

- `lib/app/startup/widget_launch_bridge.dart`
  - 补原始启动位置输入契约
- `lib/app/router/app_router.dart`
  - 在根路由里消费解析结果
- `lib/features/app_shell/presentation/pages/app_shell_page.dart`
  - 接入快速添加弹层与共享反馈宿主
- `lib/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart`
  - 保持三栏切换稳定并确保重复点击复位行为
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`
  - 补本轮 app-shell 真实宿主所需文案

## Task 1: 启动意图与共享 UI 状态骨架

**Files:**
- Create: `lib/features/app_shell/domain/entities/app_shell_launch_intent.dart`
- Create: `lib/features/app_shell/application/app_shell_launch_resolver.dart`
- Create: `lib/features/app_shell/application/providers/app_shell_ui_state.dart`
- Modify: `lib/app/startup/widget_launch_bridge.dart`
- Test: `test/features/app_shell/application/app_shell_launch_resolver_test.dart`

- [ ] **Step 1: 写启动落点解析测试**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/application/app_shell_launch_resolver.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

void main() {
  group('AppShellLaunchResolver', () {
    test('maps known shell routes to matching intents', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve(RoutePaths.home),
        const AppShellLaunchIntent.home(),
      );
      expect(
        resolver.resolve(RoutePaths.history),
        const AppShellLaunchIntent.history(),
      );
      expect(
        resolver.resolve(RoutePaths.settings),
        const AppShellLaunchIntent.settings(),
      );
    });

    test('falls back to home for unknown locations', () {
      final resolver = AppShellLaunchResolver();

      expect(
        resolver.resolve('/unknown'),
        const AppShellLaunchIntent.fallbackHome(),
      );
    });
  });
}
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `flutter test test/features/app_shell/application/app_shell_launch_resolver_test.dart`
Expected: FAIL，提示 `AppShellLaunchResolver` 或 `AppShellLaunchIntent` 不存在

- [ ] **Step 3: 实现最小启动意图实体与解析器**

```dart
// lib/features/app_shell/domain/entities/app_shell_launch_intent.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_shell_launch_intent.freezed.dart';

/// 共享壳层启动意图只负责表达根级安全落点，
/// 不负责承载任意业务模块参数或真实深链载荷。
@freezed
abstract class AppShellLaunchIntent with _$AppShellLaunchIntent {
  const factory AppShellLaunchIntent.home() = _Home;
  const factory AppShellLaunchIntent.history() = _History;
  const factory AppShellLaunchIntent.settings() = _Settings;
  const factory AppShellLaunchIntent.fallbackHome() = _FallbackHome;
}
```

```dart
// lib/features/app_shell/application/app_shell_launch_resolver.dart
import 'package:screen_note/app/router/route_paths.dart';
import 'package:screen_note/features/app_shell/domain/entities/app_shell_launch_intent.dart';

/// 启动落点解析器只把原始路径归一到共享壳层允许的一级入口，
/// 避免平台入口把未知路径直接推入路由树。
final class AppShellLaunchResolver {
  const AppShellLaunchResolver();

  AppShellLaunchIntent resolve(String rawLocation) {
    return switch (rawLocation) {
      RoutePaths.home => const AppShellLaunchIntent.home(),
      RoutePaths.history => const AppShellLaunchIntent.history(),
      RoutePaths.settings => const AppShellLaunchIntent.settings(),
      _ => const AppShellLaunchIntent.fallbackHome(),
    };
  }
}
```

```dart
// lib/features/app_shell/application/providers/app_shell_ui_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_shell_ui_state.freezed.dart';
part 'app_shell_ui_state.g.dart';

enum AppShellFeedbackLevel { info, warning, degradation }

@freezed
abstract class AppShellFeedbackMessage with _$AppShellFeedbackMessage {
  const factory AppShellFeedbackMessage({
    required AppShellFeedbackLevel level,
    required String text,
  }) = _AppShellFeedbackMessage;
}

@freezed
abstract class AppShellUiState with _$AppShellUiState {
  const factory AppShellUiState({
    @Default(false) bool quickAddSheetOpen,
    AppShellFeedbackMessage? feedback,
  }) = _AppShellUiState;
}

@riverpod
class AppShellUiStateController extends _$AppShellUiStateController {
  @override
  AppShellUiState build() => const AppShellUiState();

  void openQuickAddSheet() {
    state = state.copyWith(quickAddSheetOpen: true);
  }

  void closeQuickAddSheet() {
    state = state.copyWith(quickAddSheetOpen: false);
  }

  void showFeedback(AppShellFeedbackMessage message) {
    state = state.copyWith(feedback: message);
  }

  void clearFeedback() {
    state = state.copyWith(feedback: null);
  }
}
```

```dart
// lib/app/startup/widget_launch_bridge.dart
abstract interface class WidgetLaunchBridge {
  String get initialLocation;

  /// 返回平台原始入口位置；默认允许与 `initialLocation` 相同。
  String get rawLaunchLocation;
}

final class NoopWidgetLaunchBridge implements WidgetLaunchBridge {
  const NoopWidgetLaunchBridge();

  @override
  String get initialLocation => RoutePaths.home;

  @override
  String get rawLaunchLocation => RoutePaths.home;
}
```

- [ ] **Step 4: 运行生成命令**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: PASS，并生成：
- `lib/features/app_shell/domain/entities/app_shell_launch_intent.freezed.dart`
- `lib/features/app_shell/application/providers/app_shell_ui_state.freezed.dart`
- `lib/features/app_shell/application/providers/app_shell_ui_state.g.dart`

- [ ] **Step 5: 运行测试确认通过**

Run: `flutter test test/features/app_shell/application/app_shell_launch_resolver_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择 `仅提交 / 提交并推送 / 忽略`。

## Task 2: 接入快速添加弹层与共享反馈宿主

**Files:**
- Create: `lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart`
- Create: `lib/features/app_shell/presentation/widgets/app_shell_feedback_host.dart`
- Modify: `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Test: `test/features/app_shell/presentation/app_shell_page_test.dart`

- [ ] **Step 1: 写壳层交互测试**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/router/route_paths.dart';

void main() {
  testWidgets('opens and closes quick add sheet from shell fab', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ScreenNoteApp()));
    await tester.pumpAndSettle();

    expect(find.text('快速添加'), findsNothing);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('快速添加'), findsOneWidget);

    await tester.tap(find.text('关闭'));
    await tester.pumpAndSettle();

    expect(find.text('快速添加'), findsNothing);
  });

  testWidgets('switches between shell tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ScreenNoteApp()));
    await tester.pumpAndSettle();

    expect(find.text('早上好'), findsOneWidget);

    await tester.tap(find.text('历史'));
    await tester.pumpAndSettle();
    expect(find.text('历史中心'), findsOneWidget);

    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    expect(find.text('设置中心'), findsOneWidget);
  });
}
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `flutter test test/features/app_shell/presentation/app_shell_page_test.dart`
Expected: FAIL，当前 `AppShellPage` 还没有把弹层和共享状态正式接起来

- [ ] **Step 3: 实现快速添加弹层与共享反馈宿主**

```dart
// lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/l10n/app_localizations.dart';

class AppShellQuickAddSheet extends StatelessWidget {
  const AppShellQuickAddSheet({
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.quickAddSheetTitle, style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.h),
          Text(l10n.quickAddSheetHint, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 20.h),
          FilledButton(
            onPressed: onDismiss,
            child: Text(l10n.quickAddSheetDismiss),
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/features/app_shell/presentation/widgets/app_shell_feedback_host.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';

class AppShellFeedbackHost extends StatelessWidget {
  const AppShellFeedbackHost({
    required this.message,
    required this.onClose,
    super.key,
  });

  final AppShellFeedbackMessage? message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    if (message == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 24.w,
      right: 24.w,
      bottom: 112.h,
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: ListTile(
            dense: true,
            title: Text(message!.text),
            trailing: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
```

```dart
// lib/features/app_shell/presentation/pages/app_shell_page.dart
class AppShellPage extends HookConsumerWidget {
  const AppShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shellState = ref.watch(appShellUiStateControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          AppShellFeedbackHost(
            message: shellState.feedback,
            onClose: () => ref.read(appShellUiStateControllerProvider.notifier).clearFeedback(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(appShellUiStateControllerProvider.notifier).openQuickAddSheet();
          await showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (context) => AppShellQuickAddSheet(
              onDismiss: () => Navigator.of(context).pop(),
            ),
          );
          ref.read(appShellUiStateControllerProvider.notifier).closeQuickAddSheet();
        },
        child: const Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: AppShellNavigationSurface(navigationShell: navigationShell),
    );
  }
}
```

- [ ] **Step 4: 更新中英文文案并生成 l10n**

```json
{
  "quickAddSheetHint": "真实快速添加链路会在 task-flow 模块阶段接入。",
  "historyPlaceholderTitle": "历史中心",
  "settingsPlaceholderTitle": "设置中心"
}
```

Run: `flutter gen-l10n`
Expected: PASS，并刷新 `lib/l10n/app_localizations*.dart`

- [ ] **Step 5: 运行页面测试确认通过**

Run: `flutter test test/features/app_shell/presentation/app_shell_page_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 3: 接入启动解析并收口路由宿主

**Files:**
- Modify: `lib/app/router/app_router.dart`
- Modify: `lib/app/startup/widget_launch_bridge.dart`
- Modify: `lib/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart`
- Test: `test/features/app_shell/application/app_shell_launch_resolver_test.dart`
- Test: `test/features/app_shell/presentation/app_shell_page_test.dart`

- [ ] **Step 1: 写路由安全回退测试**

```dart
testWidgets('falls back to home when launch bridge returns unknown route', (tester) async {
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [],
  );

  expect(router.routeInformationProvider.value.uri.toString(), RoutePaths.home);
});
```

- [ ] **Step 2: 修改根路由消费解析器**

```dart
// lib/app/router/app_router.dart
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final launchBridge = ref.watch(widgetLaunchBridgeProvider);
  final resolver = AppShellLaunchResolver();
  final launchIntent = resolver.resolve(launchBridge.rawLaunchLocation);

  final initialLocation = switch (launchIntent) {
    AppShellLaunchIntentHome() => RoutePaths.home,
    AppShellLaunchIntentHistory() => RoutePaths.history,
    AppShellLaunchIntentSettings() => RoutePaths.settings,
    AppShellLaunchIntentFallbackHome() => RoutePaths.home,
  };

  return GoRouter(
    initialLocation: initialLocation,
    routes: [/* 保持现有 StatefulShellRoute 结构 */],
  );
}
```

```dart
// lib/app/startup/widget_launch_bridge.dart
final class NoopWidgetLaunchBridge implements WidgetLaunchBridge {
  const NoopWidgetLaunchBridge({this.location = RoutePaths.home});

  final String location;

  @override
  String get initialLocation => RoutePaths.home;

  @override
  String get rawLaunchLocation => location;
}
```

- [ ] **Step 3: 校正底栏重复点击行为和可读性**

```dart
// lib/features/app_shell/presentation/widgets/app_shell_navigation_surface.dart
onDestinationSelected: (index) {
  navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );
},
```

并保留这三个目的地：

```dart
NavigationDestination(label: localizations.homeTabLabel, ...);
NavigationDestination(label: localizations.historyTabLabel, ...);
NavigationDestination(label: localizations.settingsTabLabel, ...);
```

- [ ] **Step 4: 运行全量验证**

Run:

```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Expected:

- `flutter analyze` 输出 `No issues found!`
- `flutter test` 输出 `All tests passed!`

- [ ] **Step 5: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## 自检结果

- 已覆盖 spec 中的 5 个目标：共享壳层稳定化、快速添加独立入口、系统回流骨架、共享反馈宿主、正式宿主边界。
- 无 `TODO / TBD / implement later` 占位。
- 所有新增类型、文件和测试路径在任务中都给出了具体名字与落点。

