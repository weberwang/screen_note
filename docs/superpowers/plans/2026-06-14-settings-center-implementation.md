# Settings Center Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 `settings-center` 从占位页推进为真实设置页，完成通知权限状态展示、隐私模式和 Widget 展示模式更新、同步与会员次级入口表达。

**Architecture:** 先建立 `settings-center` 的偏好实体、通知权限仓储和应用层用例，再用 Riverpod Provider 把稳定快照装配到设置页。显示层只负责展示分区与触发设置意图，不直接写 `shared_preferences`，也不直接处理通知权限查询细节。

**Tech Stack:** Flutter, hooks_riverpod, riverpod_annotation, freezed, shared_preferences, flutter_local_notifications, flutter_test

---

## 文件结构

### 新建文件

- `lib/features/settings_center/domain/entities/notification_permission_status.dart`
  - 通知权限状态枚举
- `lib/features/settings_center/domain/entities/widget_display_mode.dart`
  - Widget 展示模式枚举
- `lib/features/settings_center/domain/entities/settings_sync_status.dart`
  - 同步状态枚举
- `lib/features/settings_center/domain/entities/settings_membership_state.dart`
  - 会员入口状态枚举
- `lib/features/settings_center/domain/entities/settings_center_preferences.dart`
  - 本地偏好实体
- `lib/features/settings_center/domain/entities/settings_center_preferences.freezed.dart`
  - `freezed` 生成文件
- `lib/features/settings_center/domain/entities/settings_center_snapshot.dart`
  - 设置页稳定快照
- `lib/features/settings_center/domain/entities/settings_center_snapshot.freezed.dart`
  - `freezed` 生成文件
- `lib/features/settings_center/domain/repositories/settings_preferences_repository.dart`
  - 偏好仓储接口
- `lib/features/settings_center/domain/repositories/notification_permission_repository.dart`
  - 通知权限仓储接口
- `lib/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart`
  - 设置页快照加载用例
- `lib/features/settings_center/application/use_cases/update_privacy_mode_use_case.dart`
  - 隐私模式更新用例
- `lib/features/settings_center/application/use_cases/update_widget_display_mode_use_case.dart`
  - Widget 展示模式更新用例
- `lib/features/settings_center/application/use_cases/review_notification_permission_use_case.dart`
  - 通知权限复查用例
- `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
  - 设置页 Provider 和页面控制器
- `lib/features/settings_center/application/providers/settings_center_runtime_providers.g.dart`
  - Riverpod 生成文件
- `lib/features/settings_center/infrastructure/shared_preferences_settings_preferences_repository.dart`
  - 偏好仓储实现
- `lib/features/settings_center/infrastructure/flutter_local_notifications_permission_repository.dart`
  - 通知权限仓储实现
- `lib/features/settings_center/presentation/widgets/settings_section_header.dart`
  - 设置分区头组件
- `lib/features/settings_center/presentation/widgets/settings_option_row.dart`
  - 设置行组件
- `lib/features/settings_center/presentation/widgets/settings_degradation_notice.dart`
  - 降级提示组件
- `test/features/settings_center/application/settings_center_use_cases_test.dart`
  - 设置页用例测试
- `test/features/settings_center/presentation/settings_center_page_test.dart`
  - 设置页展示与交互测试

### 修改文件

- `lib/features/settings_center/presentation/pages/settings_center_page.dart`
  - 从占位页切到真实设置页
- `test/features/app_shell/presentation/app_shell_page_test.dart`
  - 更新 Settings 分支断言
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`
  - 补齐设置页标题、状态值、反馈文案

## Task 1: 建立偏好真源、权限仓储与快照用例

**Files:**
- Create: `lib/features/settings_center/domain/entities/notification_permission_status.dart`
- Create: `lib/features/settings_center/domain/entities/widget_display_mode.dart`
- Create: `lib/features/settings_center/domain/entities/settings_sync_status.dart`
- Create: `lib/features/settings_center/domain/entities/settings_membership_state.dart`
- Create: `lib/features/settings_center/domain/entities/settings_center_preferences.dart`
- Create: `lib/features/settings_center/domain/entities/settings_center_snapshot.dart`
- Create: `lib/features/settings_center/domain/repositories/settings_preferences_repository.dart`
- Create: `lib/features/settings_center/domain/repositories/notification_permission_repository.dart`
- Create: `lib/features/settings_center/application/use_cases/load_settings_center_snapshot_use_case.dart`
- Create: `lib/features/settings_center/application/use_cases/update_privacy_mode_use_case.dart`
- Create: `lib/features/settings_center/application/use_cases/update_widget_display_mode_use_case.dart`
- Create: `lib/features/settings_center/application/use_cases/review_notification_permission_use_case.dart`
- Create: `lib/features/settings_center/infrastructure/shared_preferences_settings_preferences_repository.dart`
- Create: `lib/features/settings_center/infrastructure/flutter_local_notifications_permission_repository.dart`
- Test: `test/features/settings_center/application/settings_center_use_cases_test.dart`

- [ ] **Step 1: 写用例级失败测试**

```dart
test('开启隐私模式时会把 fullContent 的 Widget 展示模式收敛为 previewOnly', () async {
  final repository = InMemorySettingsPreferencesRepository(
    initial: const SettingsCenterPreferences(
      privacyModeEnabled: false,
      widgetDisplayMode: WidgetDisplayMode.fullContent,
    ),
  );
  final useCase = UpdatePrivacyModeUseCase(repository: repository);

  final updated = await useCase.execute(enabled: true);

  expect(updated.privacyModeEnabled, isTrue);
  expect(updated.widgetDisplayMode, WidgetDisplayMode.previewOnly);
});
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `rtk flutter test test/features/settings_center/application/settings_center_use_cases_test.dart`
Expected: FAIL，提示 `SettingsCenterPreferences`、`UpdatePrivacyModeUseCase` 等类型不存在

- [ ] **Step 3: 实现最小实体、仓储和用例**

```dart
@freezed
abstract class SettingsCenterPreferences with _$SettingsCenterPreferences {
  const factory SettingsCenterPreferences({
    @Default(true) bool privacyModeEnabled,
    @Default(WidgetDisplayMode.previewOnly)
    WidgetDisplayMode widgetDisplayMode,
  }) = _SettingsCenterPreferences;
}
```

```dart
final class UpdatePrivacyModeUseCase {
  const UpdatePrivacyModeUseCase({
    required SettingsPreferencesRepository repository,
  }) : _repository = repository;

  final SettingsPreferencesRepository _repository;

  Future<SettingsCenterPreferences> execute({required bool enabled}) async {
    final current = await _repository.loadPreferences();
    final next = current.copyWith(
      privacyModeEnabled: enabled,
      widgetDisplayMode: enabled &&
              current.widgetDisplayMode == WidgetDisplayMode.fullContent
          ? WidgetDisplayMode.previewOnly
          : current.widgetDisplayMode,
    );
    await _repository.savePreferences(next);
    return next;
  }
}
```

- [ ] **Step 4: 运行代码生成**

Run: `rtk dart run build_runner build --delete-conflicting-outputs`
Expected: PASS，并生成 `freezed` 与 `riverpod` 文件

- [ ] **Step 5: 运行设置用例测试确认通过**

Run: `rtk flutter test test/features/settings_center/application/settings_center_use_cases_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 2: 接入设置页运行时 Provider 与真实页面

**Files:**
- Create: `lib/features/settings_center/application/providers/settings_center_runtime_providers.dart`
- Create: `lib/features/settings_center/application/providers/settings_center_runtime_providers.g.dart`
- Create: `lib/features/settings_center/presentation/widgets/settings_section_header.dart`
- Create: `lib/features/settings_center/presentation/widgets/settings_option_row.dart`
- Create: `lib/features/settings_center/presentation/widgets/settings_degradation_notice.dart`
- Modify: `lib/features/settings_center/presentation/pages/settings_center_page.dart`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Test: `test/features/settings_center/presentation/settings_center_page_test.dart`

- [ ] **Step 1: 写设置页失败测试**

```dart
testWidgets('设置页会展示通知、隐私、展示模式、同步与会员分区', (tester) async {
  await tester.pumpWidget(_buildSettingsPage());
  await tester.pumpAndSettle();

  expect(find.text('Settings Center'), findsOneWidget);
  expect(find.text('Notifications'), findsOneWidget);
  expect(find.text('Privacy'), findsOneWidget);
  expect(find.text('Display'), findsOneWidget);
  expect(find.text('Sync & Backup'), findsOneWidget);
  expect(find.text('Membership'), findsOneWidget);
});
```

- [ ] **Step 2: 运行测试，确认当前失败**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`
Expected: FAIL，当前 `SettingsCenterPage` 仍然只显示占位文案

- [ ] **Step 3: 实现运行时装配与页面**

```dart
@Riverpod(keepAlive: true)
class SettingsCenterController extends _$SettingsCenterController {
  @override
  Future<SettingsCenterSnapshot> build() {
    return ref.watch(settingsCenterSnapshotProvider.future);
  }

  Future<void> updatePrivacyMode({
    required bool enabled,
    required String feedbackText,
  }) async {
    await ref.read(updatePrivacyModeUseCaseProvider).execute(enabled: enabled);
    ref.read(appShellUiStateControllerProvider.notifier).showFeedback(
      AppShellFeedbackMessage(
        level: AppShellFeedbackLevel.info,
        text: feedbackText,
      ),
    );
    state = await AsyncValue.guard(_reloadSnapshot);
  }
}
```

```dart
class SettingsCenterPage extends HookConsumerWidget {
  const SettingsCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(settingsCenterControllerProvider);
    return snapshotAsync.when(
      data: (snapshot) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text('Settings Center')),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 4: 更新文案并刷新生成文件**

Run: `rtk flutter gen-l10n`
Expected: PASS，并生成设置页标题、状态值、反馈消息访问器

- [ ] **Step 5: 运行页面测试确认通过**

Run: `rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart`
Expected: PASS

- [ ] **Step 6: 本项目约束下暂不提交**

记录：本任务完成后不要执行 `git commit`，统一等全部任务完成后由用户选择提交方式。

## Task 3: 修正壳层断言并做全量验证

**Files:**
- Modify: `test/features/app_shell/presentation/app_shell_page_test.dart`
- Verify only: `lib/features/settings_center/**`
- Verify only: `test/features/settings_center/**`

- [ ] **Step 1: 更新壳层测试的 Settings 分支断言**

```dart
await tester.tap(find.text(_settingsTabLabel));
await tester.pumpAndSettle();

expect(find.text('Settings Center'), findsOneWidget);
expect(find.text('Notifications'), findsOneWidget);
```

- [ ] **Step 2: 运行 settings-center 相关测试集**

Run:

```bash
rtk flutter test test/features/settings_center/application/settings_center_use_cases_test.dart
rtk flutter test test/features/settings_center/presentation/settings_center_page_test.dart
rtk flutter test test/features/app_shell/presentation/app_shell_page_test.dart
```

Expected:

- 三组测试全部 PASS

- [ ] **Step 3: 运行全量生成与静态检查**

Run:

```bash
rtk flutter gen-l10n
rtk dart run build_runner build --delete-conflicting-outputs
rtk flutter analyze
```

Expected:

- `flutter gen-l10n` PASS
- `build_runner` PASS
- `flutter analyze` 输出 `No issues found!`

- [ ] **Step 4: 运行全量测试**

Run: `rtk flutter test`
Expected: PASS，且不引入 `task-flow` 与 `history-center` 回归

- [ ] **Step 5: 本项目约束下暂不提交**

记录：全部任务完成后不要立即 `git add / git commit / git push`，统一等待用户选择 `仅提交 / 提交并推送 / 忽略`。

## 自检结果

- 已覆盖 spec 中的关键目标：通知权限状态、隐私模式、Widget 展示模式、降级提示和次级会员入口。
- 已保持实现顺序为：偏好真源与用例 -> 页面与交互 -> 壳层回归验证，避免先堆 UI 再补规则。
- 无 `TODO / TBD / implement later` 占位。
- 所有新增路径、测试路径、生成命令和验证命令都给出了具体落点。
