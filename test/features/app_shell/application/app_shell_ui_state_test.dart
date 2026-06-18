import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/features/app_shell/application/providers/app_shell_ui_state.dart';

void main() {
  group('AppShellUiStateController', () {
    test('shows and clears feedback', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(
        appShellUiStateControllerProvider.notifier,
      );
      const message = AppShellFeedbackMessage(
        level: AppShellFeedbackLevel.warning,
        text: 'bridge degraded',
      );

      notifier.showFeedback(message);
      expect(
        container.read(appShellUiStateControllerProvider).feedback,
        message,
      );

      notifier.clearFeedback();
      expect(
        container.read(appShellUiStateControllerProvider).feedback,
        isNull,
      );
    });
  });
}
