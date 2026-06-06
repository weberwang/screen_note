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
  String get homePageTitle => 'Today, don\'t forget';

  @override
  String get homePageSubtitle =>
      'Put the important little things where they stay visible.';

  @override
  String get quickInputPlaceholder =>
      'Write down the little thing you can\'t forget';

  @override
  String get quickInputSubmit => 'Add';

  @override
  String get quickInputHelperText =>
      'Keep the title first, then add due time, pinning, and privacy only when needed.';

  @override
  String get quickAddPageTitle => 'Quick add';

  @override
  String get quickAddPageBody =>
      'This page catches drafts from failed system entries so you can finish the note and continue without starting over.';

  @override
  String get quickAddSheetBody =>
      'The home quick add sheet keeps just one line of input and a few defaults so creation stays within a few seconds.';

  @override
  String get quickAddInputLabel => 'Task content';

  @override
  String get quickAddDefaultPinnedTitle => 'Pin by default';

  @override
  String get quickAddDefaultPrivacyTitle => 'Private by default';

  @override
  String get quickAddDefaultEnableAction => 'Enable';

  @override
  String get quickAddDefaultDisableAction => 'Disable';

  @override
  String get quickAddNonBlockingTitle =>
      'Entry failures never block the main flow';

  @override
  String get quickAddNonBlockingBody =>
      'If the system entry can\'t finish creation directly, the app keeps your content and lets you continue here.';

  @override
  String get quickAddSheetHintBody =>
      'This sheet never expands into the full editor. If creation fails, the app still keeps the draft for later.';

  @override
  String get quickAddDraftRestoredBody =>
      'Your previous draft is already restored here, so you can finish it and submit right away.';

  @override
  String get quickAddSourceHome => 'From home';

  @override
  String get quickAddSourceAppIntent => 'From App Intent';

  @override
  String get quickAddSourceControlCenter => 'From Control Center';

  @override
  String get quickAddSourceLockScreen => 'From Lock Screen';

  @override
  String get quickAddSourceActionButton => 'From Action Button';

  @override
  String get quickAddSourceDeepLink => 'From deep link';

  @override
  String get quickAddSourceFallback => 'From fallback recovery';

  @override
  String get taskTitleRequired => 'Write something important first.';

  @override
  String get taskCreateSuccess => 'Added to your lock screen reminder.';

  @override
  String get taskCreateFailed =>
      'Couldn\'t save it yet. Your text is still here.';

  @override
  String get activeTasksSectionTitle => 'Current tasks';

  @override
  String get homeUpNextTitle => 'Up next';

  @override
  String get completedHistoryEntry => 'Recently completed';

  @override
  String get deletedHistoryEntry => 'Recently deleted';

  @override
  String get taskEditorEntry => 'Full editor';

  @override
  String get settingsEntry => 'Settings';

  @override
  String get taskFlowTabLabel => 'Tasks';

  @override
  String get historyCenterTabLabel => 'History';

  @override
  String get widgetBridgeTabLabel => 'Lock Screen';

  @override
  String get settingsCenterTabLabel => 'Settings';

  @override
  String get bootstrapPlaceholderBadge => 'Initialization baseline';

  @override
  String get bootstrapPlaceholderBody =>
      'This screen only ships routing, theming, provider wiring, and module boundaries during flutter-init. Real business behaviors are intentionally deferred to the flutter-dev stage.';

  @override
  String get taskFlowActivePreviewLabel => 'Active preview';

  @override
  String get taskFlowCompletedPreviewLabel => 'Completed handoff';

  @override
  String get taskFlowDeletedPreviewLabel => 'Deleted restore';

  @override
  String get emptyActiveTasksTitle => 'Nothing to remember yet';

  @override
  String get emptyActiveTasksBody =>
      'Write one down and it will stay visible here.';

  @override
  String get emptyCompletedTasksTitle => 'No completed tasks yet';

  @override
  String get emptyCompletedTasksBody =>
      'Completed tasks will show up here so they stay traceable.';

  @override
  String get emptyDeletedTasksTitle => 'Nothing in recently deleted';

  @override
  String get emptyDeletedTasksBody =>
      'Deleted tasks stay here for 30 days so you can restore them.';

  @override
  String get deletedRetentionHint => 'Deleted tasks stay here for 30 days.';

  @override
  String get historyCompletedTitle => 'Recently completed';

  @override
  String get historyDeletedTitle => 'Recently deleted';

  @override
  String appShellLaunchRoutedFeedback(String destination) {
    return 'Opened $destination';
  }

  @override
  String appShellLaunchFallbackFeedback(String destination) {
    return 'That entry is unavailable. Returned to $destination.';
  }

  @override
  String get taskDetailTitle => 'Task details';

  @override
  String get taskEditorTitle => 'New task';

  @override
  String get taskEditorHelperText =>
      'The full editor handles title, note, due time, pinning, privacy, and reminder mode in one place.';

  @override
  String get taskDetailMissing => 'This task isn\'t available right now.';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get taskNoteLabel => 'Note';

  @override
  String get taskNoteEmpty => 'Add notes';

  @override
  String get taskDueLabel => 'Due time';

  @override
  String get taskDueEmpty => 'No due time yet';

  @override
  String get taskPinnedLabel => 'Pin this task';

  @override
  String get taskPrivateLabel => 'Hide on lock screen';

  @override
  String get taskReminderModeLabel => 'Reminder mode';

  @override
  String get taskReminderModeNormal => 'Normal reminder';

  @override
  String get taskReminderModePersistent => 'Persistent reminder';

  @override
  String get taskPreviewTitle => 'Lock screen preview';

  @override
  String get taskPreviewHideContentTitle => 'Hide content';

  @override
  String get taskPreviewHideContentBody => 'Only show a safe summary.';

  @override
  String get taskPreviewShowContentTitle => 'Show content';

  @override
  String get taskPreviewShowContentBody =>
      'Keep the full content visible inside the app.';

  @override
  String get taskPreviewPrivateOnlyTitle => 'Only visible to you';

  @override
  String get taskPreviewPrivateOnlyBody =>
      'Outward surfaces hide the original text by default.';

  @override
  String get taskSaveChanges => 'Save changes';

  @override
  String get taskSaveAction => 'Save task';

  @override
  String get taskCompleteAction => 'Complete';

  @override
  String get taskDeleteAction => 'Delete';

  @override
  String get taskRestoreAction => 'Restore';

  @override
  String get taskRestoreItemAction => 'Restore task';

  @override
  String get valueEnabled => 'On';

  @override
  String get valueDisabled => 'Off';

  @override
  String get taskRestoreSuccess => 'Restored to current tasks.';

  @override
  String get taskDeleteSuccess =>
      'Deleted. You can restore it from recently deleted.';

  @override
  String get taskCompleteSuccess => 'Moved to recently completed.';

  @override
  String get taskUpdateSuccess => 'Saved your changes.';

  @override
  String get taskLoadFailed => 'Couldn\'t load tasks right now.';

  @override
  String get taskHistoryLoadFailed => 'Couldn\'t load history right now.';

  @override
  String get retryAction => 'Retry';

  @override
  String get statusPinned => 'Pinned';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusToday => 'Today';

  @override
  String get statusPrivate => 'Private';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusDeleted => 'Deleted';

  @override
  String get privateMaskedTitle => 'Private task';

  @override
  String get taskPrivateMaskedBody =>
      'This private task is hidden here and only visible in the detail page.';

  @override
  String get viewTaskDetailAction => 'View details';

  @override
  String get viewOriginalRecordAction => 'View original record';

  @override
  String remainingDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String get deleteDialogTitle => 'Delete this task?';

  @override
  String get deleteDialogBody =>
      'You can restore it from recently deleted within 30 days.';

  @override
  String get restoreDialogTitle => 'Restore to current tasks?';

  @override
  String get restoreDialogBody =>
      'After restoring, it will join the home list and lock screen ranking again.';

  @override
  String get discardDialogTitle => 'Discard unsaved changes?';

  @override
  String get discardDialogBody => 'Your edits on this page won\'t be saved.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get discardAction => 'Discard';

  @override
  String get dueTimeDialogTitle => 'Choose due time';

  @override
  String get dueTimeSetAction => 'Set time';

  @override
  String get dueTimeClearAction => 'Clear time';

  @override
  String get privacyExplainTitle => 'How privacy works';

  @override
  String get privacyExplainBody =>
      'Private tasks won\'t show their original text on lock screen previews or other outward surfaces.';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageHelperText =>
      'Phase two only keeps lock screen display and privacy settings. Notifications, Pro, and system entries stay out of scope.';

  @override
  String get settingsDisplayGroupTitle => 'Display preferences';

  @override
  String get notificationSettingsTitle => 'Notification access';

  @override
  String get notificationSettingsSubtitle =>
      'Only manages reminder availability and keeps the main task flow non-blocking.';

  @override
  String get notificationSettingsEnabled => 'Enabled';

  @override
  String get notificationSettingsDisabled => 'Degraded';

  @override
  String get settingsOpenAction => 'Open';

  @override
  String get settingsFallbackTitle => 'Fallback rule';

  @override
  String get settingsFallbackBody =>
      'Any settings failure should only degrade this page. It must not block home creation, history restore, or detail state changes.';

  @override
  String get widgetSettingsTitle => 'Lock screen display';

  @override
  String get widgetSettingsSubtitle =>
      'Preview the lock screen baseline inside the app. Phase two does not connect to real widget refresh.';

  @override
  String get widgetStyleSelectorTitle => 'Lock screen style';

  @override
  String get widgetPreviewMaskPrivateTitle =>
      'Hide private task body in previews';

  @override
  String get widgetPreviewMaskPrivateBody =>
      'Lock screen, widget, and other outward surfaces should not expose private task text by default.';

  @override
  String get widgetPreviewPrivateState => 'Private task body hidden';

  @override
  String get widgetPreviewEmptyHint =>
      'Nothing is pinned to the lock screen yet';

  @override
  String get widgetPreviewFallbackHint => 'Showing the last valid snapshot';

  @override
  String get widgetSyncAction => 'Sync lock screen snapshot';

  @override
  String get widgetSyncSuccess => 'Synced the latest stable snapshot.';

  @override
  String get widgetSyncFailed =>
      'Sync failed. Keeping the last valid snapshot.';

  @override
  String get widgetPreviewModeMetric => 'Current mode';

  @override
  String get widgetPreviewVisibleMetric => 'Visible items';

  @override
  String get widgetPreviewPrivateMetric => 'Private items';

  @override
  String widgetPreviewPrivateSummary(int itemCount) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '$itemCount tasks hidden',
      one: '1 task hidden',
      zero: 'Private content hidden',
    );
    return '$_temp0';
  }

  @override
  String get widgetPreviewDefaultBody =>
      'Shows time, state, and a safe summary.';

  @override
  String get widgetDisplayModeSingle => 'Single';

  @override
  String get widgetDisplayModeList3 => 'Three items';

  @override
  String get widgetDisplayModeToday => 'Today';

  @override
  String get widgetDisplayModePrivate => 'Private';

  @override
  String get widgetDisplayModeEmpty => 'Empty';

  @override
  String get widgetInstallGuideTitle => 'Add it to your lock screen';

  @override
  String get widgetInstallGuideBody =>
      'Add the Screen Note widget from the system lock screen editor. The app only prepares stable snapshots here and does not promise instant refresh.';

  @override
  String get widgetFallbackPreviewTitle =>
      'Fallback keeps the last safe content';

  @override
  String get syncPlaceholderTitle => 'Sync and backup';

  @override
  String get syncPlaceholderBody =>
      'Future sync and recovery stay as a weak entry for now, without changing the local-first main flow.';

  @override
  String get syncPlaceholderStatus => 'Not enabled';

  @override
  String get proEntryTitle => 'Member center';

  @override
  String get proEntryBody =>
      'Unlock future advanced capabilities without affecting the basic privacy baseline.';

  @override
  String get proBenefitUnlimitedList => 'Unlimited list';

  @override
  String get proBenefitCustomReminder => 'Custom reminder';

  @override
  String get proBenefitDataBackup => 'Data backup';

  @override
  String get widgetPreviewSingleTitle => 'Finish the lock screen widget review';

  @override
  String get widgetPreviewListItemOne => 'Confirm the three-item layout rhythm';

  @override
  String get widgetPreviewListItemTwo =>
      'Export the latest valid fallback snapshot';

  @override
  String get widgetPreviewListItemThree =>
      'Keep the privacy copy unreadable outside the app';

  @override
  String get widgetPreviewTodayTitle => 'Tasks due today stay visible';

  @override
  String get widgetPreviewDueToday => 'Today 18:00';

  @override
  String get widgetPreviewDueYesterday => 'Yesterday 20:00';

  @override
  String get widgetPreviewEmptyBody =>
      'Create or restore a task and the lock screen will pick up the next stable snapshot.';

  @override
  String get privacySettingsTitle => 'Privacy settings';

  @override
  String get privacySettingsSubtitle =>
      'Only manage basic display preferences here. No complex permission flow in phase two.';

  @override
  String get privacySettingsMaskTitle =>
      'Hide private task body in outward previews';

  @override
  String get privacySettingsMaskBody =>
      'Lock screen, widget, notifications, and shortcut entries should not directly expose private task text.';

  @override
  String get privacySettingsSafeTitle => 'Conservative default';

  @override
  String get privacySettingsSafeBody =>
      'If privacy settings fail, the app must keep the safer outward behavior instead of revealing more text.';
}
