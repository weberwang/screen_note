import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screen_note/features/quick_add/application/quick_add_draft.dart';
import 'package:screen_note/features/tasks/presentation/providers/task_feature_providers.dart';

import '../../application/quick_add_flow_service.dart';
import '../../data/quick_add_draft_store.dart';
import '../../data/quick_add_intent_bridge.dart';
import '../../data/quick_add_shared_preferences_driver.dart';

/// 快速添加草稿共享驱动提供器。
final Provider<QuickAddDraftStorageDriver> quickAddDraftStorageDriverProvider =
    Provider<QuickAddDraftStorageDriver>((Ref ref) {
      return const SharedPreferencesQuickAddDraftStorageDriver(
        preferencesLoader: SharedPreferences.getInstance,
      );
    });

/// 快速添加草稿存储提供器。
final Provider<QuickAddDraftStore> quickAddDraftStoreProvider =
    Provider<QuickAddDraftStore>((Ref ref) {
      return QuickAddDraftStoreImpl(
        driver: ref.watch(quickAddDraftStorageDriverProvider),
      );
    });

/// 系统入口待处理草稿桥接提供器。
final Provider<QuickAddIntentBridge> quickAddIntentBridgeProvider =
    Provider<QuickAddIntentBridge>((Ref ref) {
      return QuickAddIntentBridgeImpl(
        driver: const HomeWidgetQuickAddIntentStorageDriver(
          appGroupId: screenNoteQuickAddAppGroupId,
        ),
      );
    });

/// 快速添加统一流程服务提供器。
final Provider<QuickAddFlowService> quickAddFlowServiceProvider =
    Provider<QuickAddFlowService>((Ref ref) {
      return QuickAddFlowService(
        draftStore: ref.watch(quickAddDraftStoreProvider),
        createTask: ref.watch(createTaskUseCaseProvider).call,
        now: ref.watch(nowProvider),
      );
    });

/// 最近一次保留草稿提供器。
final FutureProvider<QuickAddDraft?> quickAddDraftProvider =
    FutureProvider.autoDispose<QuickAddDraft?>((Ref ref) {
      return ref.watch(quickAddFlowServiceProvider).restoreDraft();
    });
