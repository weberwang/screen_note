import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';

void main() {
  group('AppShellUiStateController', () {
    test('opens and closes quick add sheet', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appShellUiStateControllerProvider.notifier);

      notifier.openQuickAddSheet();
      expect(
        container.read(appShellUiStateControllerProvider).quickAddSheetOpen,
        isTrue,
      );

      notifier.closeQuickAddSheet();
      expect(
        container.read(appShellUiStateControllerProvider).quickAddSheetOpen,
        isFalse,
      );
    });

    test('shows and clears feedback', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(appShellUiStateControllerProvider.notifier);
      const message = AppShellFeedbackMessage(
        level: AppShellFeedbackLevel.warning,
        text: 'bridge degraded',
      );

      notifier.showFeedback(message);
      expect(container.read(appShellUiStateControllerProvider).feedback, message);

      notifier.clearFeedback();
      expect(container.read(appShellUiStateControllerProvider).feedback, isNull);
    });
  });
}
