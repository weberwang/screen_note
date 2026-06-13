// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Screen Note';

  @override
  String get homeTabLabel => 'Home';

  @override
  String get historyTabLabel => 'History';

  @override
  String get settingsTabLabel => 'Settings';

  @override
  String get quickAddSheetTitle => 'Quick add';

  @override
  String get quickAddSheetHint =>
      'The real quick-add flow will be connected in the task-flow module stage.';

  @override
  String get quickAddSheetDismiss => 'Close';

  @override
  String get quickAddFeedbackPlaceholder =>
      'Quick add will be connected in the task-flow stage.';

  @override
  String get appShellFeedbackDismiss => 'Dismiss';

  @override
  String get homeGreetingTitle => 'Good morning';

  @override
  String get homeGreetingSubtitle => 'Focus on what matters most today.';

  @override
  String get homePriorityLabel => 'PRIORITY';

  @override
  String get homePriorityTitle => 'Bootstrap the shared shell';

  @override
  String get homePriorityBody =>
      'Root routing, theme, and startup wiring now have a stable place to land.';

  @override
  String get homeQueueTitle => 'Urgent queue';

  @override
  String homeQueuePlaceholder(int index) {
    return 'Placeholder item $index';
  }

  @override
  String get historyPlaceholderTitle => 'History center';

  @override
  String get historyPlaceholderBody =>
      'Recent completed and recently deleted flows will connect here after the shared bootstrap is stable.';

  @override
  String get settingsPlaceholderTitle => 'Settings center';

  @override
  String get settingsPlaceholderBody =>
      'Notification, privacy, display, and future membership settings will land here in later module work.';
}
