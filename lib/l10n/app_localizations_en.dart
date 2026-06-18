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
  String get homeTodayChip => 'Today';

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
  String get homeHistoryTitle => 'History status';

  @override
  String homeHistoryCompletedCount(int count) {
    return 'Completed $count';
  }

  @override
  String homeHistoryDeletedCount(int count) {
    return 'Deleted $count';
  }

  @override
  String get homeHistorySummaryBody =>
      'Completed and deleted items stay in history.';

  @override
  String get homeHistoryEmptyBody => 'No history yet.';

  @override
  String get homeHistoryAction => 'View history';

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
  String get taskFlowPriorityContinueAction => 'Continue';

  @override
  String get taskFlowPriorityEmptyAction => 'Start task';

  @override
  String get taskFlowPrivateTitle => 'Private task';

  @override
  String get taskFlowPinnedLabel => 'Pinned task';

  @override
  String get taskFlowNoDueDate => 'No due date';

  @override
  String taskFlowDueAtLabel(String dateTime) {
    return 'Due $dateTime';
  }

  @override
  String get taskFlowDueTodayLabel => 'Due today';

  @override
  String taskFlowOverdueAtLabel(String dateTime) {
    return 'Overdue since $dateTime';
  }

  @override
  String get taskFlowOverdueSectionTitle => 'Overdue';

  @override
  String get taskFlowUpNextSectionTitle => 'Up next';

  @override
  String get taskFlowHomeDegradationTitle => 'Some capabilities are degraded';

  @override
  String get taskFlowHomePermissionDegradationBody =>
      'Notification access is currently unavailable, but tasks can still be created, edited, and completed.';

  @override
  String get taskFlowHomeRefreshDegradationBody =>
      'The home page kept the last snapshot. Retry later to restore the latest state.';

  @override
  String get taskEditorTitle => 'Edit task';

  @override
  String get taskEditorTopSaveAction => 'Save';

  @override
  String get taskEditorHelperText =>
      'Capture the core task first, then keep the remaining fields minimal before saving.';

  @override
  String get taskEditorDueDateLabel => 'Due date';

  @override
  String get taskEditorDueTimeLabel => 'Due time';

  @override
  String get taskEditorNoDueDate => 'Not set';

  @override
  String get taskEditorNoDueTime => 'Not set';

  @override
  String get taskEditorFocusLabel => 'Current focus';

  @override
  String get taskEditorFocusPinnedValue => 'Pinned task';

  @override
  String get taskEditorFocusNormalValue => 'Regular task';

  @override
  String get taskEditorPrivacyFieldLabel => 'Privacy';

  @override
  String get taskEditorPrivacyPublicValue => 'Visible';

  @override
  String get taskEditorPrivacyPrivateValue => 'Private';

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
  String get historyEmptyTitle => 'No history yet';

  @override
  String get historyEmptyBody =>
      'Completed or deleted tasks will appear here when you need them.';

  @override
  String get historyEmptyAddAction => 'Create task';

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
      'Manage how Screen Note works across your device and keep your notes safe.';

  @override
  String get settingsNotificationsSection => 'NOTIFICATIONS';

  @override
  String get settingsPrivacySection => 'PRIVACY';

  @override
  String get settingsDisplaySection => 'WIDGET';

  @override
  String get settingsSyncSection => 'SYNC';

  @override
  String get settingsMembershipSection => 'MEMBERSHIP';

  @override
  String get settingsNotificationStatusTitle => 'Notifications';

  @override
  String get settingsNotificationStatusBody =>
      'Stay updated on saves and sync activity.';

  @override
  String get settingsPrivacyModeTitle => 'Privacy Mode';

  @override
  String get settingsPrivacyModeBody => 'Hide sensitive content in previews.';

  @override
  String get settingsWidgetDisplayModeTitle => 'Widget Display Mode';

  @override
  String get settingsWidgetDisplayModeBody =>
      'Choose what shows in your widget.';

  @override
  String get settingsWidgetInstallTitle => 'Add Home Widget';

  @override
  String get settingsWidgetInstallBody =>
      'See how to place Screen Note on the Home Screen, or request a direct add on supported Android launchers.';

  @override
  String get settingsWidgetInstallAndroidGuide =>
      'Add Screen Note to the Home Screen for faster access. On supported Android launchers, you can request the widget directly here. If the launcher declines, long-press the Home Screen, open Widgets, and choose Screen Note.';

  @override
  String get settingsWidgetInstallIosGuide =>
      'Touch and hold the Home Screen, tap Edit, then choose Add Widget and search for Screen Note.';

  @override
  String get settingsWidgetInstallAction => 'Add to Home Screen';

  @override
  String get settingsThemeModeTitle => 'Theme';

  @override
  String get settingsThemeModeBody =>
      'Choose whether the app follows the system appearance or stays in a fixed light or dark theme.';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageBody =>
      'Choose the language used across the app surfaces.';

  @override
  String get settingsSyncStatusTitle => 'Sync Status';

  @override
  String get settingsSyncStatusBody => 'Last synced just now';

  @override
  String get settingsMembershipTitle => 'Screen Note Pro';

  @override
  String get settingsMembershipBody => 'Manage your plan and benefits.';

  @override
  String get settingsNotificationEnabled => 'Enabled';

  @override
  String get settingsNotificationDisabled => 'Disabled';

  @override
  String get settingsNotificationUnknown => 'Unknown';

  @override
  String get settingsPermissionDowngradedTitle =>
      'Notifications are turned off.';

  @override
  String get settingsPermissionDowngradedBody =>
      'You may miss important updates about your notes.';

  @override
  String get settingsReviewAction => 'Enable';

  @override
  String get settingsWidgetDisplayPreviewOnly => 'Blurred Previews';

  @override
  String get settingsPrivacyModeOn => 'On';

  @override
  String get settingsPrivacyModeOff => 'Off';

  @override
  String get settingsWidgetDisplayFullContent => 'Full Content';

  @override
  String get settingsThemeModeSystem => 'Follow System';

  @override
  String get settingsThemeModeLight => 'Light';

  @override
  String get settingsThemeModeDark => 'Dark';

  @override
  String get settingsLanguageZh => 'Simplified Chinese';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSyncLocalOnly => 'Local Only';

  @override
  String get settingsSyncSynced => 'Synced';

  @override
  String get settingsMembershipAvailable => 'Available';

  @override
  String get settingsPrivacyProtectionTitle => 'Privacy mode is on.';

  @override
  String get settingsPrivacyProtectionBody =>
      'Previews are blurred in recents and widgets.';

  @override
  String get settingsPrivacyProtectionAction => 'Learn more';

  @override
  String get settingsMembershipSupportTitle => 'You\'re using Screen Note Pro';

  @override
  String get settingsMembershipSupportBody =>
      'Thank you for supporting a focused and private note-taking experience.';

  @override
  String get settingsMembershipActive => 'Active';

  @override
  String get settingsWidgetDisplayPickerTitle => 'Choose a widget display mode';

  @override
  String get settingsThemeModePickerTitle => 'Choose a theme';

  @override
  String get settingsLanguagePickerTitle => 'Choose a language';

  @override
  String get settingsPrivacyFeedback => 'Privacy setting updated.';

  @override
  String get settingsWidgetDisplayFeedback => 'Widget display setting updated.';

  @override
  String get settingsThemeModeFeedback => 'Theme setting updated.';

  @override
  String get settingsLanguageFeedback => 'Language setting updated.';

  @override
  String get settingsNotificationGrantedFeedback =>
      'Notification access is now available.';

  @override
  String get settingsNotificationDeferredFeedback =>
      'Notification access is still limited.';

  @override
  String get settingsNotificationDisableInSystemFeedback =>
      'Turn off notifications in system settings.';

  @override
  String get settingsNotificationDisableDialogTitle =>
      'Turn off notifications?';

  @override
  String get settingsNotificationDisableDialogBody =>
      'Notifications can only be turned off in system settings. Open settings now?';

  @override
  String get settingsNotificationDisableDialogCancel => 'Cancel';

  @override
  String get settingsNotificationDisableDialogConfirm => 'Open Settings';

  @override
  String get settingsNotificationOpenSettingsFailed =>
      'Couldn\'t open system settings. Try again later.';

  @override
  String get settingsWidgetInstallRequestedFeedback =>
      'Widget request sent to the launcher.';

  @override
  String get settingsWidgetInstallUnsupportedFeedback =>
      'This launcher does not support direct widget pinning.';

  @override
  String get settingsWidgetInstallFailedFeedback =>
      'Widget request failed. Please add it from the system widget picker.';

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

  @override
  String get widgetSettingsTitle => 'Widget Preview';

  @override
  String get widgetSettingsSubtitle =>
      'Preview the current stable snapshot and manually sync it to the system widget when needed.';

  @override
  String get widgetSyncSuccess => 'Latest stable widget snapshot synced.';

  @override
  String get widgetSyncFailed => 'Widget snapshot sync failed.';

  @override
  String get widgetPreviewModeMetric => 'Display mode';

  @override
  String get widgetPreviewVisibleMetric => 'Visible items';

  @override
  String get widgetPreviewPrivateMetric => 'Private items';

  @override
  String get widgetDisplayModeSingle => 'Single Focus';

  @override
  String get widgetDisplayModeList3 => 'Three-item List';

  @override
  String get widgetDisplayModeToday => 'Today First';

  @override
  String get widgetDisplayModePrivate => 'Private Safe';

  @override
  String get widgetDisplayModeEmpty => 'Empty Placeholder';

  @override
  String get widgetFallbackPreviewTitle => 'Manual Sync';

  @override
  String get widgetSyncAction => 'Sync now';

  @override
  String get retryAction => 'Retry';
}
