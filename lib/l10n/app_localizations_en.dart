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
      'Open the task editor first, then save with a minimal title, note, and privacy setup.';

  @override
  String get quickAddSheetContinue => 'Continue adding';

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
  String get taskFlowHomeLoadFailed => 'Home snapshot failed to load.';

  @override
  String get taskFlowEmptyTitle => 'Nothing needs attention right now.';

  @override
  String get taskFlowEmptyBody =>
      'Create or restore a task, and your focus list will appear here.';

  @override
  String get taskFlowPrivateTaskHint =>
      'This private task is hidden on the home surface.';

  @override
  String get taskFlowPriorityFallbackBody =>
      'Keep moving on the next meaningful step.';

  @override
  String get taskFlowPinnedLabel => 'Pinned task';

  @override
  String get taskFlowNoDueDate => 'No due date';

  @override
  String taskFlowDueAtLabel(String dateTime) {
    return 'Due $dateTime';
  }

  @override
  String taskFlowOverdueAtLabel(String dateTime) {
    return 'Overdue since $dateTime';
  }

  @override
  String get taskEditorTitle => 'Edit task';

  @override
  String get taskEditorHelperText =>
      'Capture the core task first, then keep the remaining fields minimal before saving.';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskTitleHint => 'For example: Connect the editor save flow';

  @override
  String get taskNoteLabel => 'Note';

  @override
  String get taskNoteHint => 'Add context or the next step for this task.';

  @override
  String get taskPinnedLabel => 'Pin as current focus';

  @override
  String get taskPrivateLabel => 'Mark as private';

  @override
  String get taskSaveAction => 'Save task';

  @override
  String get taskTitleRequired => 'Enter a task title first.';

  @override
  String get taskCreateFailed => 'Save failed. Try again shortly.';

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
  String get historyTitle => 'History';

  @override
  String get historySubtitle =>
      'Nothing disappears without a trace. Review what was completed or restore what was deleted.';

  @override
  String get historyCompletedSectionTitle => 'Recently completed';

  @override
  String get historyDeletedSectionTitle => 'Recently deleted';

  @override
  String get historyEmptyTitle => 'Your history is clear for now.';

  @override
  String get historyEmptyBody =>
      'Completed and deleted tasks will appear here so you can trust that nothing vanished unexpectedly.';

  @override
  String get historyLoadFailed => 'History failed to load. Try again shortly.';

  @override
  String historyCompletedAtLabel(String dateTime) {
    return 'Completed $dateTime';
  }

  @override
  String historyDeletedAtLabel(String dateTime) {
    return 'Deleted $dateTime';
  }

  @override
  String get historyRestoreAction => 'Restore';

  @override
  String get historyRestoreSuccess => 'Task restored to active.';

  @override
  String get settingsPlaceholderTitle => 'Settings center';

  @override
  String get settingsPlaceholderBody =>
      'Notification, privacy, display, and future membership settings will land here in later module work.';

  @override
  String get settingsTitle => 'Settings Center';

  @override
  String get settingsSubtitle =>
      'Manage how Screen Note behaves across reminders, privacy, widgets, and recovery-safe system surfaces.';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsPrivacySection => 'Privacy';

  @override
  String get settingsDisplaySection => 'Display';

  @override
  String get settingsSyncSection => 'Sync & Backup';

  @override
  String get settingsMembershipSection => 'Membership';

  @override
  String get settingsNotificationStatusTitle => 'Notification Status';

  @override
  String get settingsNotificationStatusBody =>
      'Stay updated on reminders and task changes.';

  @override
  String get settingsPrivacyModeTitle => 'Privacy Mode';

  @override
  String get settingsPrivacyModeBody =>
      'Protect task content in previews and widgets.';

  @override
  String get settingsWidgetDisplayModeTitle => 'Widget Display Mode';

  @override
  String get settingsWidgetDisplayModeBody =>
      'Choose whether widgets show full content or a safe preview.';

  @override
  String get settingsSyncStatusTitle => 'Sync Status';

  @override
  String get settingsSyncStatusBody =>
      'This build keeps a safe local source of truth while later sync entry points stay visible here.';

  @override
  String get settingsMembershipTitle => 'Premium';

  @override
  String get settingsMembershipBody =>
      'Membership stays visible but secondary to permissions, privacy, and display safety.';

  @override
  String get settingsNotificationEnabled => 'Enabled';

  @override
  String get settingsNotificationDisabled => 'Disabled';

  @override
  String get settingsNotificationUnknown => 'Unknown';

  @override
  String get settingsPermissionDowngradedTitle => 'Permission downgraded';

  @override
  String get settingsPermissionDowngradedBody =>
      'Notifications are off. Task creation still works, but reminders are reduced.';

  @override
  String get settingsReviewAction => 'Review';

  @override
  String get settingsWidgetDisplayPreviewOnly => 'Preview Only';

  @override
  String get settingsWidgetDisplayFullContent => 'Full Content';

  @override
  String get settingsSyncLocalOnly => 'Local Only';

  @override
  String get settingsMembershipAvailable => 'Available';

  @override
  String get settingsWidgetDisplayPickerTitle => 'Choose a widget display mode';

  @override
  String get settingsPrivacyFeedback => 'Privacy setting updated.';

  @override
  String get settingsWidgetDisplayFeedback => 'Widget display setting updated.';

  @override
  String get settingsNotificationGrantedFeedback =>
      'Notification access is now available.';

  @override
  String get settingsNotificationDeferredFeedback =>
      'Notification access is still limited.';

  @override
  String get settingsLoadFailed =>
      'Settings failed to load. Try again shortly.';

  @override
  String get widgetSnapshotEmptyTitle =>
      'No reminder is ready for the widget yet';

  @override
  String get widgetSnapshotEmptyBody =>
      'Create or restore a task and the next stable snapshot will appear here.';

  @override
  String get widgetSnapshotFallbackHint =>
      'Showing the last valid widget snapshot.';

  @override
  String get widgetSnapshotPreviewTitle => 'Preview is hidden';

  @override
  String get widgetSnapshotPrivateTitle => 'Private reminder is hidden';

  @override
  String get widgetSnapshotStatusPreview => 'Safe Preview';

  @override
  String get widgetSnapshotStatusPrivate => 'Protected';

  @override
  String get widgetSnapshotStatusToday => 'Today';

  @override
  String get widgetSnapshotStatusOverdue => 'Overdue';

  @override
  String get widgetSnapshotStatusPinned => 'Pinned';

  @override
  String get widgetSnapshotOpenInApp => 'Open in app';
}
