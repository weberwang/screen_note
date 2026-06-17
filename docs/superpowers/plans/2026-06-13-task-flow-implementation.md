# Task Flow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `task-flow` 从首页占位模块推进为真实事项真源模块，完成首页主事项快照、编辑页主链路、关键状态流转与共享壳层接入。

**Architecture:** 先建立 `task-flow` 的领域实体、仓储接口、`drift` 存储和应用层用例，再用 Riverpod Provider 把稳定快照装配到首页与编辑页。显示层只消费快照和表单状态，不直接改库、不直接推导主事项或状态流转。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, drift, freezed, go_router, flutter_test

---

## 文件结构

### 新建文件

- `lib/features/task_flow/domain/entities/task_status.dart`
  - 三态持久状态枚举，只保留 `active / completed / deleted`
- `lib/features/task_flow/domain/entities/task_reminder_mode.dart`
  - 当前最小提醒模式枚举
- `lib/features/task_flow/domain/entities/task_entity.dart`
  - 事项聚合根
- `lib/features/task_flow/domain/entities/task_event_entity.dart`
  - 状态变更日志实体
- `lib/features/task_flow/domain/entities/task_feed_snapshot.dart`
  - 首页稳定快照
- `lib/features/task_flow/domain/repositories/task_repository.dart`
  - 任务真源仓储接口
- `lib/features/task_flow/application/ports/task_flow_side_effect_port.dart`
  - 通知 / Widget / 降级反馈的副作用端口抽象
- `lib/features/task_flow/application/use_cases/create_task_use_case.dart`
  - 创建事项用例
- `lib/features/task_flow/application/use_cases/load_task_feed_use_case.dart`
  - 首页快照装配用例
- `lib/features/task_flow/application/use_cases/update_task_status_use_case.dart`
  - 完成 / 删除 / 恢复状态流转用例
- `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
  - 数据库、仓储、用例与首页快照 Provider 装配
- `lib/features/task_flow/application/providers/task_flow_runtime_providers.g.dart`
  - Riverpod 生成文件
- `lib/features/task_flow/infrastructure/task_flow_database.dart`
  - `drift` 表结构与数据库入口
- `lib/features/task_flow/infrastructure/task_flow_database.g.dart`
  - Drift 生成文件
- `lib/features/task_flow/infrastructure/task_flow_database_connection.dart`
  - 数据库连接抽象
- `lib/features/task_flow/infrastructure/task_flow_database_connection_native.dart`
  - 原生平台数据库连接
- `lib/features/task_flow/infrastructure/task_flow_database_connection_stub.dart`
  - 非支持平台 stub
- `lib/features/task_flow/infrastructure/task_flow_repository_impl.dart`
  - `drift` 仓储实现
- `lib/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart`
  - 最小无副作用实现
- `lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
  - 创建 / 编辑页
- `lib/features/task_flow/presentation/widgets/priority_task_card.dart`
  - 首页主事项卡片
- `lib/features/task_flow/presentation/widgets/task_queue_row.dart`
  - 首页任务行
- `test/features/task_flow/application/task_flow_use_cases_test.dart`
  - 真源与用例测试
- `test/features/task_flow/presentation/task_flow_home_page_test.dart`
  - 首页真实展示测试
- `test/features/task_flow/presentation/task_flow_editor_page_test.dart`
  - 编辑页与快速添加入口测试

### 修改文件

- `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
  - 从占位页改成真实首页
- `lib/app/router/route_paths.dart`
  - 增加 `task-flow` 编辑路由
- `lib/app/router/app_router.dart`
  - 把首页卡片 / 列表 / quick add 接到编辑页
- `lib/features/app_shell/presentation/pages/app_shell_page.dart`
  - 收口 quick add 占位反馈，改为进入 task editor 新建态
- `lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart`
  - 把纯说明占位改成进入 task editor 的轻入口
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`
  - 补齐首页、编辑页、quick add 与状态文案

## Task 1: 建立任务真源、存储与应用层用例

**Files:**
- Create: `lib/features/task_flow/domain/entities/task_status.dart`
- Create: `lib/features/task_flow/domain/entities/task_reminder_mode.dart`
- Create: `lib/features/task_flow/domain/entities/task_entity.dart`
- Create: `lib/features/task_flow/domain/entities/task_event_entity.dart`
- Create: `lib/features/task_flow/domain/entities/task_feed_snapshot.dart`
- Create: `lib/features/task_flow/domain/repositories/task_repository.dart`
- Create: `lib/features/task_flow/application/ports/task_flow_side_effect_port.dart`
- Create: `lib/features/task_flow/application/use_cases/create_task_use_case.dart`
- Create: `lib/features/task_flow/application/use_cases/load_task_feed_use_case.dart`
- Create: `lib/features/task_flow/application/use_cases/update_task_status_use_case.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_database.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_database_connection.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_database_connection_native.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_database_connection_stub.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_repository_impl.dart`
- Create: `lib/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart`
- Test: `test/features/task_flow/application/task_flow_use_cases_test.dart`

- [ ] **Step 1: 写用例级失败测试**

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:screen_note/features/task_flow/application/use_cases/create_task_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/application/use_cases/update_task_status_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_noop_side_effect_port.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

void main() {
  late TaskFlowDatabase database;
  late TaskFlowRepositoryImpl repository;
  late CreateTaskUseCase createTaskUseCase;
  late LoadTaskFeedUseCase loadTaskFeedUseCase;
  late UpdateTaskStatusUseCase updateTaskStatusUseCase;

  setUp(() {
    database = TaskFlowDatabase.test(NativeDatabase.memory());
    repository = TaskFlowRepositoryImpl(database: database);
    createTaskUseCase = CreateTaskUseCase(
      repository: repository,
      sideEffectPort: const TaskFlowNoopSideEffectPort(),
      uuid: const Uuid(),
    );
    loadTaskFeedUseCase = LoadTaskFeedUseCase(repository: repository);
    updateTaskStatusUseCase = UpdateTaskStatusUseCase(
      repository: repository,
      sideEffectPort: const TaskFlowNoopSideEffectPort(),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('createTask 会拒绝空白标题', () async {
    expect(
      () => createTaskUseCase.execute(
        const CreateTaskInput(title: '   ', note: ''),
      ),
      throwsArgumentError,
    );
  });

  test('loadTaskFeed 会按主事项、过期、今日、普通顺序返回 active 事项', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(_task(id: 'normal', title: '普通事项', createdAt: now));
    await repository.createTask(
      _task(
        id: 'today',
        title: '今天事项',
        dueAt: DateTime(2026, 6, 4, 18),
        createdAt: now.subtract(const Duration(hours: 4)),
      ),
    );
    await repository.createTask(
      _task(
        id: 'overdue',
        title: '过期事项',
        dueAt: DateTime(2026, 6, 3, 18),
        createdAt: now.subtract(const Duration(days: 2)),
      ),
    );
    await repository.createTask(
      _task(
        id: 'pinned',
        title: '主事项',
        isPinned: true,
        createdAt: now,
      ),
    );

    final TaskFeedSnapshot snapshot = await loadTaskFeedUseCase.execute(now: now);

    expect(snapshot.pinnedTasks.map((task) => task.id), <String>['pinned']);
    expect(snapshot.overdueTasks.map((task) => task.id), <String>['overdue']);
    expect(snapshot.todayTasks.map((task) => task.id), <String>['today']);
    expect(snapshot.otherTasks.map((task) => task.id), <String>['normal']);
    expect(snapshot.activeCount, 4);
  });

  test('completeTask deleteTask restoreTask 只通过三态持久状态流转', () async {
    final DateTime now = DateTime(2026, 6, 4, 10);
    await repository.createTask(_task(id: 'task-1', title: '恢复链路', createdAt: now));

    await updateTaskStatusUseCase.completeTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 5)),
    );
    await updateTaskStatusUseCase.deleteTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 10)),
    );
    await updateTaskStatusUseCase.restoreTask(
      taskId: 'task-1',
      occurredAt: now.add(const Duration(minutes: 15)),
    );

    final TaskEntity? restored = await repository.findTaskById('task-1');
    expect(restored?.status, TaskStatus.active);
    expect(restored?.deletedAt, isNull);
  });
}

TaskEntity _task({
  required String id,
  required String title,
  required DateTime createdAt,
  DateTime? dueAt,
  bool isPinned = false,
}) {
  return TaskEntity(
    id: id,
    title: title,
    note: '',
    dueAt: dueAt,
    reminderAt: null,
    isPinned: isPinned,
    isPrivate: false,
    status: TaskStatus.active,
    reminderMode: TaskReminderMode.normal,
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: null,
    deletedAt: null,
  );
}
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `flutter test test/features/task_flow/application/task_flow_use_cases_test.dart`
Expected: FAIL，提示 `TaskFlowDatabase`、`TaskRepository`、`CreateTaskUseCase` 等类型不存在

- [ ] **Step 3: 实现最小领域模型、数据库与用例**

```dart
// lib/features/task_flow/domain/entities/task_status.dart
/// 事项持久状态只保留 active/completed/deleted 三态，expired 只能是展示派生。
enum TaskStatus { active, completed, deleted }
```

```dart
// lib/features/task_flow/domain/entities/task_reminder_mode.dart
/// 当前提醒模式先保持最小语义，避免提前发明复杂提醒协议。
enum TaskReminderMode { normal, silent }
```

```dart
// lib/features/task_flow/domain/entities/task_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

part 'task_entity.freezed.dart';

/// 事项聚合根统一承载标题、时间、隐私和持久状态事实。
@freezed
abstract class TaskEntity with _$TaskEntity {
  /// 创建事项实体。
  const factory TaskEntity({
    required String id,
    required String title,
    required String note,
    required DateTime? dueAt,
    required DateTime? reminderAt,
    required bool isPinned,
    required bool isPrivate,
    required TaskStatus status,
    required TaskReminderMode reminderMode,
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime? completedAt,
    required DateTime? deletedAt,
  }) = _TaskEntity;
}
```

```dart
// lib/features/task_flow/domain/repositories/task_repository.dart
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_event_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';

/// 任务仓储接口统一屏蔽页面层对持久化细节的感知。
abstract interface class TaskRepository {
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<TaskEntity?> findTaskById(String id);
  Future<List<TaskEntity>> loadTasksByStatus(TaskStatus status);
  Future<int> countTasksByStatus(TaskStatus status);
  Future<void> appendEvent(TaskEventEntity event);
}
```

```dart
// lib/features/task_flow/infrastructure/task_flow_database.dart
import 'package:drift/drift.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection.dart';

part 'task_flow_database.g.dart';

class TaskRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get dueAtEpochMs => integer().nullable()();
  IntColumn get reminderAtEpochMs => integer().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  TextColumn get status => textEnum<TaskStatus>()();
  TextColumn get reminderMode => textEnum<TaskReminderMode>()();
  IntColumn get createdAtEpochMs => integer()();
  IntColumn get updatedAtEpochMs => integer()();
  IntColumn get completedAtEpochMs => integer().nullable()();
  IntColumn get deletedAtEpochMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TaskEventRecords extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get type => text()();
  IntColumn get occurredAtEpochMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [TaskRecords, TaskEventRecords])
class TaskFlowDatabase extends _$TaskFlowDatabase {
  TaskFlowDatabase(super.executor);

  factory TaskFlowDatabase.test(QueryExecutor executor) => TaskFlowDatabase(executor);

  @override
  int get schemaVersion => 1;
}
```

```dart
// lib/features/task_flow/application/use_cases/load_task_feed_use_case.dart
import 'package:collection/collection.dart';

import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';

/// 首页任务流加载用例负责把 active/completed/deleted 稳定整理成展示快照。
final class LoadTaskFeedUseCase {
  const LoadTaskFeedUseCase({required TaskRepository repository})
    : _repository = repository;

  final TaskRepository _repository;

  Future<TaskFeedSnapshot> execute({DateTime? now}) async {
    final DateTime timestamp = now ?? DateTime.now();
    final List<TaskEntity> activeTasks = await _repository.loadTasksByStatus(TaskStatus.active);
    final int completedCount = await _repository.countTasksByStatus(TaskStatus.completed);
    final int deletedCount = await _repository.countTasksByStatus(TaskStatus.deleted);

    final List<TaskEntity> pinnedTasks = <TaskEntity>[];
    final List<TaskEntity> overdueTasks = <TaskEntity>[];
    final List<TaskEntity> todayTasks = <TaskEntity>[];
    final List<TaskEntity> otherTasks = <TaskEntity>[];

    for (final TaskEntity task in activeTasks) {
      if (task.isPinned) {
        pinnedTasks.add(task);
      } else if (_isOverdue(task, timestamp)) {
        overdueTasks.add(task);
      } else if (_isDueToday(task, timestamp)) {
        todayTasks.add(task);
      } else {
        otherTasks.add(task);
      }
    }

    return TaskFeedSnapshot(
      pinnedTasks: _sortByDisplayPriority(pinnedTasks),
      overdueTasks: _sortByDisplayPriority(overdueTasks),
      todayTasks: _sortByDisplayPriority(todayTasks),
      otherTasks: _sortByDisplayPriority(otherTasks),
      activeCount: activeTasks.length,
      completedCount: completedCount,
      deletedCount: deletedCount,
    );
  }

  List<TaskEntity> _sortByDisplayPriority(List<TaskEntity> tasks) {
    return tasks.sorted(
      (TaskEntity left, TaskEntity right) =>
          _compareNullableDate(left.dueAt, right.dueAt) != 0
              ? _compareNullableDate(left.dueAt, right.dueAt)
              : right.updatedAt.compareTo(left.updatedAt),
    );
  }

  bool _isOverdue(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    final DateTime startOfToday = DateTime(now.year, now.month, now.day);
    return dueAt.isBefore(startOfToday);
  }

  bool _isDueToday(TaskEntity task, DateTime now) {
    final DateTime? dueAt = task.dueAt?.toLocal();
    if (dueAt == null) {
      return false;
    }

    return dueAt.year == now.year &&
        dueAt.month == now.month &&
        dueAt.day == now.day;
  }

  int _compareNullableDate(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }
    return left.compareTo(right);
  }
}
```

```dart
// lib/features/task_flow/application/use_cases/update_task_status_use_case.dart
/// 状态流转用例统一编排完成、删除、恢复，并保证所有关键变更都写日志。
final class UpdateTaskStatusUseCase {
  // 省略构造器字段定义

  Future<void> completeTask({required String taskId, required DateTime occurredAt}) async {
    await _updateStatus(
      taskId: taskId,
      nextStatus: TaskStatus.completed,
      occurredAt: occurredAt,
      completedAt: occurredAt,
      deletedAt: null,
      eventType: 'completed',
    );
  }

  Future<void> deleteTask({required String taskId, required DateTime occurredAt}) async {
    await _updateStatus(
      taskId: taskId,
      nextStatus: TaskStatus.deleted,
      occurredAt: occurredAt,
      completedAt: null,
      deletedAt: occurredAt,
      eventType: 'deleted',
    );
  }

  Future<void> restoreTask({required String taskId, required DateTime occurredAt}) async {
    await _updateStatus(
      taskId: taskId,
      nextStatus: TaskStatus.active,
      occurredAt: occurredAt,
      completedAt: null,
      deletedAt: null,
      eventType: 'restored',
    );
  }
}
```

- [ ] **Step 4: 运行代码生成**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: PASS，并生成 `freezed`、`riverpod`、`drift` 对应文件

- [ ] **Step 5: 运行用例测试确认通过**

Run: `flutter test test/features/task_flow/application/task_flow_use_cases_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择 `仅提交 / 提交并推送 / 忽略`。

## Task 2: 接入首页真实快照与展示层

**Files:**
- Create: `lib/features/task_flow/application/providers/task_flow_runtime_providers.dart`
- Create: `lib/features/task_flow/application/providers/task_flow_runtime_providers.g.dart`
- Create: `lib/features/task_flow/presentation/widgets/priority_task_card.dart`
- Create: `lib/features/task_flow/presentation/widgets/task_queue_row.dart`
- Modify: `lib/features/task_flow/presentation/pages/task_flow_home_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Test: `test/features/task_flow/presentation/task_flow_home_page_test.dart`

- [ ] **Step 1: 写首页真实展示失败测试**

```dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/features/task_flow/application/providers/task_flow_runtime_providers.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_entity.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_reminder_mode.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_status.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';
import 'package:screen_note/features/task_flow/presentation/pages/task_flow_home_page.dart';
import 'package:screen_note/l10n/app_localizations.dart';
import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

void main() {
  testWidgets('首页会展示主事项与逾期队列', (WidgetTester tester) async {
    final TaskFlowDatabase database = TaskFlowDatabase.test(NativeDatabase.memory());
    final TaskFlowRepositoryImpl repository = TaskFlowRepositoryImpl(database: database);
    addTearDown(database.close);

    await repository.createTask(
      TaskEntity(
        id: 'priority',
        title: '完成 task-flow 真源',
        note: '',
        dueAt: DateTime(2026, 6, 4, 18),
        reminderAt: null,
        isPinned: true,
        isPrivate: false,
        status: TaskStatus.active,
        reminderMode: TaskReminderMode.normal,
        createdAt: DateTime(2026, 6, 4, 8),
        updatedAt: DateTime(2026, 6, 4, 8),
        completedAt: null,
        deletedAt: null,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskFlowDatabaseProvider.overrideWithValue(database),
          taskFlowRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: buildScreenNoteLightTheme(),
          darkTheme: buildScreenNoteDarkTheme(),
          home: const Scaffold(body: TaskFlowHomePage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('完成 task-flow 真源'), findsOneWidget);
    expect(find.text('Overdue'), findsNothing);
  });
}
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart`
Expected: FAIL，当前首页仍展示占位文案，不会从 Provider 读取真实快照

- [ ] **Step 3: 实现运行时 Provider 与首页真实展示**

```dart
// lib/features/task_flow/application/providers/task_flow_runtime_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:screen_note/features/task_flow/application/use_cases/load_task_feed_use_case.dart';
import 'package:screen_note/features/task_flow/domain/entities/task_feed_snapshot.dart';
import 'package:screen_note/features/task_flow/domain/repositories/task_repository.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_database_connection_native.dart';
import 'package:screen_note/features/task_flow/infrastructure/task_flow_repository_impl.dart';

part 'task_flow_runtime_providers.g.dart';

@Riverpod(keepAlive: true)
TaskFlowDatabase taskFlowDatabase(Ref ref) {
  return TaskFlowDatabase(openTaskFlowDatabaseConnection());
}

@Riverpod(keepAlive: true)
TaskRepository taskFlowRepository(Ref ref) {
  return TaskFlowRepositoryImpl(database: ref.watch(taskFlowDatabaseProvider));
}

@riverpod
LoadTaskFeedUseCase loadTaskFeedUseCase(Ref ref) {
  return LoadTaskFeedUseCase(repository: ref.watch(taskFlowRepositoryProvider));
}

@riverpod
Future<TaskFeedSnapshot> taskFlowHomeSnapshot(Ref ref) {
  return ref.watch(loadTaskFeedUseCaseProvider).execute();
}
```

```dart
// lib/features/task_flow/presentation/pages/task_flow_home_page.dart
class TaskFlowHomePage extends HookConsumerWidget {
  const TaskFlowHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(taskFlowHomeSnapshotProvider);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.taskFlowLoadFailed)),
        data: (snapshot) {
          final priorityTask = snapshot.pinnedTasks.firstOrNull ??
              snapshot.overdueTasks.firstOrNull ??
              snapshot.todayTasks.firstOrNull ??
              snapshot.otherTasks.firstOrNull;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PriorityTaskCard(task: priorityTask),
              ),
              SliverList.builder(
                itemCount: snapshot.overdueTasks.length,
                itemBuilder: (context, index) {
                  return TaskQueueRow.overdue(task: snapshot.overdueTasks[index]);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 4: 更新文案并刷新生成文件**

Run: `rtk flutter gen-l10n`
Expected: PASS，并生成首页真实状态、加载失败、编辑动作等文案访问器

- [ ] **Step 5: 运行首页测试确认通过**

Run: `flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 3: 接入编辑页、子路由与保存主链路

**Files:**
- Create: `lib/features/task_flow/presentation/pages/task_flow_editor_page.dart`
- Modify: `lib/app/router/route_paths.dart`
- Modify: `lib/app/router/app_router.dart`
- Modify: `lib/features/app_shell/presentation/pages/app_shell_page.dart`
- Modify: `lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Test: `test/features/task_flow/presentation/task_flow_editor_page_test.dart`

- [ ] **Step 1: 写编辑页与 quick add 路由失败测试**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/app/app.dart';

void main() {
  testWidgets('全局 quick add 会进入 task editor 新建态', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ScreenNoteApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('继续添加'));
    await tester.pumpAndSettle();

    expect(find.text('编辑事项'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart`
Expected: FAIL，当前 quick add 仍是纯占位说明，路由中也没有 task editor 子页面

- [ ] **Step 3: 实现编辑页与路由接入**

```dart
// lib/app/router/route_paths.dart
abstract final class RoutePaths {
  static const String home = '/';
  static const String history = '/history';
  static const String settings = '/settings';

  // task-flow 编辑页只挂在首页分支下，避免绕开共享壳层入口语义。
  static const String taskEditor = 'task-editor';
}
```

```dart
// lib/app/router/app_router.dart
GoRoute(
  path: RoutePaths.home,
  builder: (context, state) => const TaskFlowHomePage(),
  routes: [
    GoRoute(
      path: RoutePaths.taskEditor,
      builder: (context, state) => const TaskFlowEditorPage(),
    ),
  ],
),
```

```dart
// lib/features/task_flow/presentation/pages/task_flow_editor_page.dart
class TaskFlowEditorPage extends HookConsumerWidget {
  const TaskFlowEditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final titleController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskEditorTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: l10n.taskEditorTitleHint,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await ref.read(createTaskUseCaseProvider).execute(
                  CreateTaskInput(title: titleController.text, note: ''),
                );
                if (context.mounted) {
                  context.pop();
                }
              },
              child: Text(l10n.taskEditorSave),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart
// lib/features/app_shell/presentation/widgets/app_shell_quick_add_sheet.dart
class AppShellQuickAddSheet extends StatelessWidget {
  const AppShellQuickAddSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.quickAddSheetTitle),
          const SizedBox(height: 12),
          Text(l10n.quickAddSheetHint),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('${RoutePaths.home}${RoutePaths.taskEditor}');
            },
            child: Text(l10n.quickAddSheetContinue),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: 刷新生成文件并运行编辑页测试**

Run:

```bash
rtk flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

- `flutter gen-l10n` PASS
- `build_runner` PASS
- 编辑页测试 PASS

- [ ] **Step 5: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 4: 全量验证并收口 task-flow 实现准备

**Files:**
- Verify only: `lib/features/task_flow/**`
- Verify only: `lib/app/router/**`
- Verify only: `lib/features/app_shell/**`
- Verify only: `test/features/task_flow/**`

- [ ] **Step 1: 运行 task-flow 相关测试集**

Run:

```bash
flutter test test/features/task_flow/application/task_flow_use_cases_test.dart
flutter test test/features/task_flow/presentation/task_flow_home_page_test.dart
flutter test test/features/task_flow/presentation/task_flow_editor_page_test.dart
```

Expected:

- 三组测试全部 PASS

- [ ] **Step 2: 运行全量生成与静态检查**

Run:

```bash
rtk flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
rtk flutter analyze
```

Expected:

- `flutter gen-l10n` PASS
- `build_runner` PASS
- `flutter analyze` 输出 `No issues found!`

- [ ] **Step 3: 运行全量测试**

Run: `rtk flutter test`
Expected: PASS，且不引入 `app-shell` 回归

- [ ] **Step 4: 本项目约束下暂不提交**

记录：全部任务完成后不要立即 `git add / git commit / git push`，统一等待用户选择 `仅提交 / 提交并推送 / 忽略`。

## 自检结果

- 已覆盖 spec 中的关键目标：任务真源、首页主事项快照、编辑链路、三态流转、软删除恢复、共享壳层接入。
- 已保持实现顺序为：真源与用例 -> 首页快照 -> 编辑页与路由 -> 全量验证，避免先堆 UI 再补业务。
- 无 `TODO / TBD / implement later` 占位。
- 所有新增类型、测试路径、生成命令和验证命令都给出了具体名字与落点。
