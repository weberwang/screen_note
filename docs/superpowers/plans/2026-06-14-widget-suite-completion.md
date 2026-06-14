# Widget Suite Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 补齐标准版小组件能力：保留 iOS 锁屏小组件，新增 iOS 桌面小组件小/中尺寸，新增 Android 桌面小组件 1 个尺寸，并让条目点击能安全回流到对应事项或首页。

**Architecture:** 继续以 `widget_bridge` 作为唯一稳定快照真源。Flutter 负责排序、隐私投影、点击目标生成与共享存储写入；iOS 和 Android 只读取共享 JSON，按各自 family/尺寸裁剪前 N 条并触发回流，不直接查库、不重做业务推导。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, freezed, json_serializable, home_widget 0.9.1, SwiftUI WidgetKit, Android AppWidgetProvider + RemoteViews

**Git 规则说明：** 按项目约束，本计划执行期间不在任务中途提交；所有 `git add` / `git commit` / `git push` 统一等全部实现完成后再等待用户选择 `仅提交`、`提交并推送` 或 `忽略`。

---

### Task 1: 扩展共享快照合同并先补失败测试

**Files:**
- Modify: `lib/features/widget_bridge/domain/entities/widget_snapshot_item.dart`
- Modify: `lib/features/widget_bridge/infrastructure/widget_snapshot_projector.dart`
- Modify: `test/features/widget_bridge/application/widget_snapshot_sync_service_test.dart`
- Modify: `test/features/widget_bridge/application/widget_snapshot_auto_sync_integration_test.dart`

- [ ] **Step 1: 先写失败测试，锁定条目点击字段与最多 3 条输出**

```dart
test('共享快照会输出按优先级排序的前三条事项和回流字段', () async {
  final DateTime now = DateTime(2026, 6, 6, 8);
  await repository.createTask(
    _task(id: 'other', title: '普通事项', createdAt: now),
  );
  await repository.createTask(
    _task(
      id: 'pinned',
      title: '置顶事项',
      createdAt: now,
      isPinned: true,
    ),
  );
  await repository.createTask(
    _task(
      id: 'today',
      title: '今日事项',
      createdAt: now,
      dueAt: DateTime(2026, 6, 6, 20),
    ),
  );
  await repository.createTask(
    _task(
      id: 'overdue',
      title: '过期事项',
      createdAt: now,
      dueAt: DateTime(2026, 6, 5, 20),
    ),
  );

  final WidgetSnapshot snapshot = await syncService.loadSnapshot(now: now);

  expect(snapshot.items, hasLength(3));
  expect(snapshot.items.map((item) => item.taskId), ['pinned', 'overdue', 'today']);
  expect(snapshot.items.map((item) => item.launchTarget), ['task', 'task', 'task']);
  expect(snapshot.items.map((item) => item.rank), [1, 2, 3]);
});

test('自动同步写入的快照会保留 taskId 与 launchTarget', () async {
  await container.read(createTaskUseCaseProvider).execute(
    const CreateTaskInput(title: '来自 Widget 的目标事项', note: ''),
    now: DateTime.utc(2026, 6, 6, 9),
  );

  expect(snapshotStore.savedSnapshots.last.items.single.taskId, isNotEmpty);
  expect(snapshotStore.savedSnapshots.last.items.single.launchTarget, 'task');
});
```

- [ ] **Step 2: 运行定向测试，确认它们先因为缺少字段而失败**

Run: `rtk flutter test test/features/widget_bridge/application/widget_snapshot_sync_service_test.dart test/features/widget_bridge/application/widget_snapshot_auto_sync_integration_test.dart`

Expected: FAIL，报错类似 `The getter 'taskId' isn't defined`、`The getter 'launchTarget' isn't defined` 或条目数量不匹配。

- [ ] **Step 3: 写最小实现，只扩合同与投影逻辑**

```dart
/// lib/features/widget_bridge/domain/entities/widget_snapshot_item.dart
@freezed
abstract class WidgetSnapshotItem with _$WidgetSnapshotItem {
  /// Widget 单条快照项只暴露展示和点击回流所需的稳定字段。
  const factory WidgetSnapshotItem({
    required String taskId,
    required String launchTarget,
    required String title,
    required String statusLabel,
    required String dueLabel,
    required bool isPinned,
    required bool isOverdue,
    required bool isPrivate,
    required int rank,
  }) = _WidgetSnapshotItem;
}
```

```dart
/// lib/features/widget_bridge/infrastructure/widget_snapshot_projector.dart
final List<TaskEntity> orderedTasks = <TaskEntity>[
  ...taskFeed.pinnedTasks,
  ...taskFeed.overdueTasks,
  ...taskFeed.todayTasks,
  ...taskFeed.otherTasks,
].take(3).toList(growable: false);

final List<WidgetSnapshotItem> items = orderedTasks.indexed.map((entry) {
  final (int index, TaskEntity task) = entry;
  return _toSnapshotItem(
    task: task,
    preferences: preferences,
    localizations: localizations,
    now: timestamp,
    rank: index + 1,
  );
}).toList(growable: false);

return WidgetSnapshot(
  snapshotId: 'widget_${timestamp.toUtc().millisecondsSinceEpoch}',
  generatedAt: timestamp.toUtc(),
  displayMode: preferences.widgetDisplayMode,
  headerTitle: _buildHeaderTitle(
    localizations: localizations,
    displayMode: preferences.widgetDisplayMode,
  ),
  emptyTitle: localizations.widgetSnapshotEmptyTitle,
  emptyBody: localizations.widgetSnapshotEmptyBody,
  fallbackHint: localizations.widgetSnapshotFallbackHint,
  items: items,
  hasPrivateContent: orderedTasks.any((task) => task.isPrivate),
  hasFallbackContent: hasFallbackContent,
  version: 2,
);
```

```dart
WidgetSnapshotItem _toSnapshotItem({
  required TaskEntity task,
  required SettingsCenterPreferences preferences,
  required AppLocalizations localizations,
  required DateTime now,
  required int rank,
}) {
  final bool isOverdue = _isOverdue(task, now);
  final bool isDueToday = _isDueToday(task, now);
  final bool shouldMask = task.isPrivate ||
      preferences.privacyModeEnabled ||
      preferences.widgetDisplayMode == WidgetDisplayMode.previewOnly;

  if (shouldMask) {
    final bool isPrivate = task.isPrivate || preferences.privacyModeEnabled;
    return WidgetSnapshotItem(
      taskId: task.id,
      launchTarget: 'task',
      title: isPrivate
          ? localizations.widgetSnapshotPrivateTitle
          : localizations.widgetSnapshotPreviewTitle,
      statusLabel: isPrivate
          ? localizations.widgetSnapshotStatusPrivate
          : localizations.widgetSnapshotStatusPreview,
      dueLabel: localizations.widgetSnapshotOpenInApp,
      isPinned: task.isPinned,
      isOverdue: isOverdue,
      isPrivate: task.isPrivate,
      rank: rank,
    );
  }

  return WidgetSnapshotItem(
    taskId: task.id,
    launchTarget: 'task',
    title: task.title,
    statusLabel: _buildStatusLabel(
      task: task,
      localizations: localizations,
      isOverdue: isOverdue,
      isDueToday: isDueToday,
    ),
    dueLabel: _buildDueLabel(
      task: task,
      localizations: localizations,
      isDueToday: isDueToday,
    ),
    isPinned: task.isPinned,
    isOverdue: isOverdue,
    isPrivate: task.isPrivate,
    rank: rank,
  );
}
```

- [ ] **Step 4: 重新运行定向测试，确认 Flutter 合同先变绿**

Run: `rtk flutter test test/features/widget_bridge/application/widget_snapshot_sync_service_test.dart test/features/widget_bridge/application/widget_snapshot_auto_sync_integration_test.dart`

Expected: PASS，且包含新断言的 0 failures。

### Task 2: 补齐 Flutter 侧小组件回流桥与路由落点

**Files:**
- Modify: `lib/app/startup/widget_launch_bridge.dart`
- Modify: `lib/app/bootstrap/app_bootstrap.dart`
- Modify: `lib/features/app_shell/domain/entities/app_shell_launch_intent.dart`
- Modify: `lib/features/app_shell/application/app_shell_launch_resolver.dart`
- Modify: `lib/app/router/app_router.dart`
- Modify: `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- Modify: `test/features/app_shell/application/widget_launch_bridge_test.dart`
- Modify: `test/features/app_shell/application/app_shell_launch_resolver_test.dart`
- Modify: `test/features/app_shell/application/app_router_launch_test.dart`

- [ ] **Step 1: 先写失败测试，锁定 HomeWidget 初始回流与任务编辑落点**

```dart
test('HomeWidgetLaunchBridge 会把 task 目标转成任务编辑路由', () async {
  final bridge = await HomeWidgetLaunchBridge.load(
    initialUri: Uri.parse('screennote://launch?source=widget&target=task&taskId=task-42'),
    clickStream: const Stream<Uri?>.empty(),
  );

  expect(bridge.rawLaunchLocation, '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=task-42');
});

test('resolver 会保留任务编辑落点而不是回退首页', () {
  final resolver = AppShellLaunchResolver();

  expect(
    resolver.resolve('/task-editor?taskId=task-42'),
    const AppShellLaunchIntent.taskEditor(taskId: 'task-42'),
  );
});

test('appRouter 会把任务编辑 intent 转成初始任务编辑路由', () {
  expect(
    _buildInitialLocation('/task-editor?taskId=task-42'),
    '/task-editor?taskId=task-42',
  );
});
```

- [ ] **Step 2: 运行这些测试，确认先因为类型和分支缺失而失败**

Run: `rtk flutter test test/features/app_shell/application/widget_launch_bridge_test.dart test/features/app_shell/application/app_shell_launch_resolver_test.dart test/features/app_shell/application/app_router_launch_test.dart`

Expected: FAIL，报错类似 `The method 'load' isn't defined`、`The factory 'taskEditor' isn't defined`。

- [ ] **Step 3: 写最小实现，把 HomeWidget 初始 URI 与运行中点击流接到壳层路由**

```dart
/// lib/app/startup/widget_launch_bridge.dart
import 'dart:async';
import 'package:home_widget/home_widget.dart';
import 'package:screen_note/app/router/route_paths.dart';

abstract interface class WidgetLaunchBridge {
  String get rawLaunchLocation;
  Stream<String> get launchLocations;
}

final class NoopWidgetLaunchBridge implements WidgetLaunchBridge {
  const NoopWidgetLaunchBridge();

  @override
  String get rawLaunchLocation => RoutePaths.home;

  @override
  Stream<String> get launchLocations => const Stream<String>.empty();
}

final class HomeWidgetLaunchBridge implements WidgetLaunchBridge {
  HomeWidgetLaunchBridge._({
    required this.rawLaunchLocation,
    required Stream<String> launchLocations,
  }) : _launchLocations = launchLocations;

  static Future<HomeWidgetLaunchBridge> load({
    Uri? initialUri,
    Stream<Uri?>? clickStream,
  }) async {
    final Uri? initial = initialUri ?? await HomeWidget.initiallyLaunchedFromHomeWidget();
    final Stream<Uri?> clicks = clickStream ?? HomeWidget.widgetClicked;
    return HomeWidgetLaunchBridge._(
      rawLaunchLocation: _normalize(initial),
      launchLocations: clicks
          .where((uri) => uri != null)
          .cast<Uri>()
          .map(_normalize),
    );
  }

  @override
  final String rawLaunchLocation;

  final Stream<String> _launchLocations;

  @override
  Stream<String> get launchLocations => _launchLocations;

  static String _normalize(Uri? uri) {
    if (uri == null || uri.queryParameters['source'] != 'widget') {
      return RoutePaths.home;
    }
    final String target = uri.queryParameters['target'] ?? 'home';
    if (target == 'task') {
      final String? taskId = uri.queryParameters['taskId'];
      if (taskId != null && taskId.isNotEmpty) {
        return '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=$taskId';
      }
    }
    return RoutePaths.home;
  }
}
```

```dart
/// lib/features/app_shell/domain/entities/app_shell_launch_intent.dart
const factory AppShellLaunchIntent.taskEditor({required String taskId}) = _TaskEditor;
```

```dart
/// lib/features/app_shell/application/app_shell_launch_resolver.dart
if (_matchesShellEntry(rawLocation, '/${RoutePaths.taskEditor}')) {
  final Uri uri = Uri.parse(rawLocation);
  final String? taskId = uri.queryParameters['taskId'];
  if (taskId != null && taskId.isNotEmpty) {
    return AppShellLaunchIntent.taskEditor(taskId: taskId);
  }
  return const AppShellLaunchIntent.home();
}
```

```dart
/// lib/app/router/app_router.dart
final AppShellLaunchIntent initialIntent = launchResolver.resolve(
  launchBridge.rawLaunchLocation,
);
final String initialLocation = initialIntent.map(
  home: (_) => RoutePaths.home,
  history: (_) => RoutePaths.history,
  settings: (_) => RoutePaths.settings,
  taskEditor: (value) =>
      '${RoutePaths.home}${RoutePaths.taskEditor}?taskId=${value.taskId}',
  fallbackHome: (_) => RoutePaths.home,
);
```

```dart
/// lib/app/bootstrap/app_bootstrap.dart
Future<void> bootstrapAndRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureGlobalErrorHandling();
  final WidgetLaunchBridge launchBridge = await HomeWidgetLaunchBridge.load();
  runApp(
    ProviderScope(
      overrides: [
        widgetLaunchBridgeProvider.overrideWithValue(launchBridge),
        // 现有 side-effect overrides 保持原样
      ],
      child: const ScreenNoteApp(),
    ),
  );
}
```

```dart
/// lib/features/app_shell/presentation/pages/app_shell_page.dart
useEffect(() {
  final subscription = ref.read(widgetLaunchBridgeProvider).launchLocations.listen((location) {
    if (!context.mounted) {
      return;
    }
    if (location.startsWith('${RoutePaths.home}${RoutePaths.taskEditor}')) {
      context.push(location);
      return;
    }
    context.go(location);
  });
  return subscription.cancel;
}, const []);
```

- [ ] **Step 4: 重新运行 app_shell 相关测试**

Run: `rtk flutter test test/features/app_shell/application/widget_launch_bridge_test.dart test/features/app_shell/application/app_shell_launch_resolver_test.dart test/features/app_shell/application/app_router_launch_test.dart`

Expected: PASS。

### Task 3: 补齐 iOS 锁屏 + 桌面小组件 family 与条目点击

**Files:**
- Modify: `ios/WidgetExtension/Widget.swift`
- Modify: `ios/WidgetExtension/WidgetSnapshotLoader.swift`
- Modify: `ios/WidgetExtension/WidgetEntryView.swift`
- Modify: `ios/WidgetExtension/WidgetTimelineProvider.swift`

- [ ] **Step 1: 先更新 iOS 共享 payload 结构，兼容新字段**

```swift
/// ios/WidgetExtension/WidgetSnapshotLoader.swift
struct WidgetSnapshotItemPayload: Codable {
  let taskId: String?
  let launchTarget: String?
  let title: String
  let statusLabel: String
  let dueLabel: String
  let isPinned: Bool
  let isOverdue: Bool
  let isPrivate: Bool
  let rank: Int
}
```

- [ ] **Step 2: 扩展 Widget family，保持锁屏并新增系统小/中尺寸**

```swift
/// ios/WidgetExtension/Widget.swift
@main
struct ScreenNoteLockScreenWidget: Widget {
  let kind: String = "ScreenNoteLockScreenWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(
      kind: kind,
      provider: ScreenNoteWidgetTimelineProvider()
    ) { entry in
      ScreenNoteWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Screen Note")
    .description("展示主应用生成的稳定小组件快照。")
    .supportedFamilies([.accessoryRectangular, .systemSmall, .systemMedium])
  }
}
```

- [ ] **Step 3: 重写视图渲染，按 family 裁剪前 N 条，并给条目附上深链**

```swift
/// ios/WidgetExtension/WidgetEntryView.swift
@Environment(\.widgetFamily) private var family

var body: some View {
  VStack(alignment: .leading, spacing: 8) {
    Text(entry.snapshot?.headerTitle ?? " ")
      .font(.caption2.weight(.semibold))
      .foregroundStyle(.secondary)

    if let snapshot = entry.snapshot {
      switch family {
      case .systemSmall:
        smallContent(snapshot)
      case .systemMedium:
        mediumContent(snapshot)
      default:
        accessoryContent(snapshot)
      }
    } else {
      emptyView(title: " ", body: " ")
    }

    if entry.snapshot?.hasFallbackContent == true {
      Text(entry.snapshot?.fallbackHint ?? " ")
        .font(.caption2)
        .foregroundStyle(.secondary)
    }
  }
  .padding(12)
  .containerBackground(.fill.tertiary, for: .widget)
  .widgetURL(URL(string: "screennote://launch?source=widget&target=home"))
}

private func smallContent(_ snapshot: WidgetSnapshotPayload) -> some View {
  contentRows(snapshot, limit: 1)
}

private func mediumContent(_ snapshot: WidgetSnapshotPayload) -> some View {
  contentRows(snapshot, limit: 3)
}

private func accessoryContent(_ snapshot: WidgetSnapshotPayload) -> some View {
  contentRows(snapshot, limit: 1)
}
```

```swift
@ViewBuilder
private func contentRows(_ snapshot: WidgetSnapshotPayload, limit: Int) -> some View {
  if snapshot.items.isEmpty {
    emptyView(title: snapshot.emptyTitle, body: snapshot.emptyBody)
  } else {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(Array(snapshot.items.prefix(limit).enumerated()), id: \.offset) { _, item in
        Link(destination: destination(for: item)) {
          itemRow(item)
        }
      }
    }
  }
}

private func destination(for item: WidgetSnapshotItemPayload) -> URL {
  if item.launchTarget == "task", let taskId = item.taskId {
    return URL(string: "screennote://launch?source=widget&target=task&taskId=\(taskId)")!
  }
  return URL(string: "screennote://launch?source=widget&target=home")!
}
```

- [ ] **Step 4: 在本机能跑 iOS 构建时验证；若当前机器不能构建 iOS，则至少保留 Swift 代码可读性和字段一致性检查**

Run on macOS if available: `xcodebuild -project ios/Runner.xcodeproj -scheme WidgetExtension -configuration Debug -sdk iphonesimulator build`

Expected: `BUILD SUCCEEDED`。

### Task 4: 新增 Android 桌面小组件宿主、资源与点击回流

**Files:**
- Modify: `lib/features/widget_bridge/infrastructure/home_widget_snapshot_store_io.dart`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Create: `android/app/src/main/kotlin/com/example/screen_note/ScreenNoteWidgetProvider.kt`
- Create: `android/app/src/main/res/layout/screen_note_widget.xml`
- Create: `android/app/src/main/res/drawable/screen_note_widget_background.xml`
- Create: `android/app/src/main/res/xml/screen_note_widget_info.xml`
- Modify: `android/app/src/main/res/values/strings.xml`
- Modify: `android/app/src/main/res/values-zh/strings.xml`

- [ ] **Step 1: 先让 Flutter 刷新调用同时命中 Android Provider**

```dart
/// lib/features/widget_bridge/infrastructure/home_widget_snapshot_store_io.dart
static const String _iosWidgetName = 'ScreenNoteLockScreenWidget';
static const String _androidWidgetName = 'ScreenNoteWidgetProvider';

try {
  await HomeWidget.updateWidget(
    iOSName: _iosWidgetName,
    androidName: _androidWidgetName,
  );
} on MissingPluginException {
  _logger.warning('widget_snapshot_refresh_missing_plugin');
}
```

- [ ] **Step 2: 新建 Android Provider，从 HomeWidgetPreferences 读当前或最后一次有效快照**

```kotlin
// android/app/src/main/kotlin/com/example/screen_note/ScreenNoteWidgetProvider.kt
package com.example.screen_note

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject

class ScreenNoteWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        appWidgetIds.forEach { appWidgetId ->
            appWidgetManager.updateAppWidget(
                appWidgetId,
                buildRemoteViews(context),
            )
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, ScreenNoteWidgetProvider::class.java))
            onUpdate(context, manager, ids)
        }
    }
}
```

- [ ] **Step 3: 补 RemoteViews 绑定逻辑，只渲染前 2 条并为每条配置 PendingIntent**

```kotlin
private fun buildRemoteViews(context: Context): RemoteViews {
    val views = RemoteViews(context.packageName, R.layout.screen_note_widget)
    val snapshot = loadSnapshot(context)
    val items = snapshot?.optJSONArray("items") ?: JSONArray()

    views.setTextViewText(R.id.widget_header, snapshot?.optString("headerTitle") ?: "")
    bindItem(
        context = context,
        views = views,
        containerId = R.id.item_one_container,
        titleId = R.id.item_one_title,
        metaId = R.id.item_one_meta,
        item = items.optJSONObject(0),
        fallbackDeepLink = "screennote://launch?source=widget&target=home",
    )
    bindItem(
        context = context,
        views = views,
        containerId = R.id.item_two_container,
        titleId = R.id.item_two_title,
        metaId = R.id.item_two_meta,
        item = items.optJSONObject(1),
        fallbackDeepLink = "screennote://launch?source=widget&target=home",
    )

    val rootIntent = Intent(Intent.ACTION_VIEW, Uri.parse("screennote://launch?source=widget&target=home"), context, MainActivity::class.java)
    views.setOnClickPendingIntent(
        R.id.widget_root,
        PendingIntent.getActivity(
            context,
            1000,
            rootIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        ),
    )
    return views
}
```

```kotlin
private fun bindItem(
    context: Context,
    views: RemoteViews,
    containerId: Int,
    titleId: Int,
    metaId: Int,
    item: JSONObject?,
    fallbackDeepLink: String,
) {
    if (item == null) {
        views.setViewVisibility(containerId, View.GONE)
        return
    }
    views.setViewVisibility(containerId, View.VISIBLE)
    views.setTextViewText(titleId, item.optString("title"))
    views.setTextViewText(
        metaId,
        listOf(item.optString("statusLabel"), item.optString("dueLabel"))
            .filter { it.isNotBlank() }
            .joinToString(" · "),
    )
    val deepLink = if (item.optString("launchTarget") == "task" && item.optString("taskId").isNotBlank()) {
        "screennote://launch?source=widget&target=task&taskId=${item.optString("taskId")}"
    } else {
        fallbackDeepLink
    }
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(deepLink), context, MainActivity::class.java)
    views.setOnClickPendingIntent(
        containerId,
        PendingIntent.getActivity(
            context,
            containerId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        ),
    )
}
```

- [ ] **Step 4: 注册 Provider 与资源，并跑 Android 构建验证**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<receiver
    android:name=".ScreenNoteWidgetProvider"
    android:exported="false">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/screen_note_widget_info" />
</receiver>
```

```xml
<!-- android/app/src/main/res/xml/screen_note_widget_info.xml -->
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="180dp"
    android:minHeight="110dp"
    android:updatePeriodMillis="0"
    android:initialLayout="@layout/screen_note_widget"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen" />
```

Run: `rtk flutter build apk --debug`

Expected: Android build success，且 Provider 类能被正确解析。

### Task 5: 代码生成、分析、全量测试与人工检查

**Files:**
- Modify: generated files touched by `freezed` / `json_serializable` / `riverpod_generator`

- [ ] **Step 1: 重新生成本地化和模型代码**

Run: `rtk flutter gen-l10n`

Expected: exit code 0。

Run: `rtk dart run build_runner build --delete-conflicting-outputs`

Expected: exit code 0，`widget_snapshot_item.g.dart`、`app_shell_launch_intent.freezed.dart` 等生成成功。

- [ ] **Step 2: 跑静态检查**

Run: `rtk flutter analyze`

Expected: `No issues found!`

- [ ] **Step 3: 跑全量测试**

Run: `rtk flutter test`

Expected: all tests pass。

- [ ] **Step 4: 做人工验收清单**

```text
1. 创建 3 条 active 事项后，共享快照只输出前 3 条且 rank 正确。
2. 打开 previewOnly 后，小/中尺寸都不泄露正文。
3. 私密事项在 fullContent 下仍被遮罩。
4. iOS 锁屏点击条目时，优先带 taskId 回流。
5. iOS 小尺寸只显示 1 条，中尺寸显示前 2~3 条。
6. Android 小组件显示前 2 条，第二条为空时自动隐藏。
7. 无 taskId 或平台不支持精确点击时，回流降级到首页。
```

- [ ] **Step 5: 全部实现完成后再停下来等用户选择 git 动作**

Run: `rtk git status --short`

Expected: 只看到本次计划覆盖的文件改动；然后等待用户选择 `仅提交`、`提交并推送` 或 `忽略`。
