import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// Application title used during initialization verification.
  ///
  /// In en, this message translates to:
  /// **'Screen Note'**
  String get appTitle;

  /// Bottom navigation label for the home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabLabel;

  /// Bottom navigation label for the history tab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTabLabel;

  /// Bottom navigation label for the settings tab.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabLabel;

  /// Title used by the global quick add bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Quick add'**
  String get quickAddSheetTitle;

  /// Hint text shown in the bootstrap quick add sheet.
  ///
  /// In en, this message translates to:
  /// **'Open the task editor first, then save with a minimal title, note, and privacy setup.'**
  String get quickAddSheetHint;

  /// Primary action in the quick add sheet that opens the task editor.
  ///
  /// In en, this message translates to:
  /// **'Continue adding'**
  String get quickAddSheetContinue;

  /// Dismiss button label for the bootstrap quick add sheet.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get quickAddSheetDismiss;

  /// Lightweight shared shell feedback shown after the quick add sheet closes.
  ///
  /// In en, this message translates to:
  /// **'Quick add will be connected in the task-flow stage.'**
  String get quickAddFeedbackPlaceholder;

  /// Dismiss button label for the shared shell feedback host.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get appShellFeedbackDismiss;

  /// Greeting headline shown on the bootstrap home placeholder.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingTitle;

  /// Supporting copy shown below the bootstrap home greeting.
  ///
  /// In en, this message translates to:
  /// **'Focus on what matters most today.'**
  String get homeGreetingSubtitle;

  /// Badge label on the bootstrap priority panel.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get homePriorityLabel;

  /// Placeholder priority task title used during bootstrap.
  ///
  /// In en, this message translates to:
  /// **'Bootstrap the shared shell'**
  String get homePriorityTitle;

  /// Placeholder priority task body used during bootstrap.
  ///
  /// In en, this message translates to:
  /// **'Root routing, theme, and startup wiring now have a stable place to land.'**
  String get homePriorityBody;

  /// Section title for the bootstrap queue placeholder.
  ///
  /// In en, this message translates to:
  /// **'Urgent queue'**
  String get homeQueueTitle;

  /// Section title for the lightweight history status summary on the home page.
  ///
  /// In en, this message translates to:
  /// **'History status'**
  String get homeHistoryTitle;

  /// Completed count shown in the home history status summary.
  ///
  /// In en, this message translates to:
  /// **'Completed {count}'**
  String homeHistoryCompletedCount(int count);

  /// Deleted count shown in the home history status summary.
  ///
  /// In en, this message translates to:
  /// **'Deleted {count}'**
  String homeHistoryDeletedCount(int count);

  /// Supporting copy shown in the home history status summary when history is not empty.
  ///
  /// In en, this message translates to:
  /// **'Completed and deleted tasks stay traceable in history so you can review or restore them later.'**
  String get homeHistorySummaryBody;

  /// Supporting copy shown in the home history status summary when history is empty.
  ///
  /// In en, this message translates to:
  /// **'No history yet. Once a task is completed or deleted, a traceable status will appear here.'**
  String get homeHistoryEmptyBody;

  /// Action label shown at the bottom of the home history status summary.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get homeHistoryAction;

  /// Minimal error hint shown when the task-flow home snapshot cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Home snapshot failed to load.'**
  String get taskFlowHomeLoadFailed;

  /// Minimal empty-state title shown when the home snapshot has no active tasks.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs attention right now.'**
  String get taskFlowEmptyTitle;

  /// Minimal empty-state body shown on the priority card when the home snapshot is empty.
  ///
  /// In en, this message translates to:
  /// **'Create or restore a task, and your focus list will appear here.'**
  String get taskFlowEmptyBody;

  /// Safe placeholder text shown instead of private task content on the home page.
  ///
  /// In en, this message translates to:
  /// **'This private task is hidden on the home surface.'**
  String get taskFlowPrivateTaskHint;

  /// Fallback supporting copy shown on the priority card when a task has no visible note.
  ///
  /// In en, this message translates to:
  /// **'Keep moving on the next meaningful step.'**
  String get taskFlowPriorityFallbackBody;

  /// Status label shown for a pinned priority task on the home page.
  ///
  /// In en, this message translates to:
  /// **'Pinned task'**
  String get taskFlowPinnedLabel;

  /// Fallback metadata shown when a home task has no due date.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get taskFlowNoDueDate;

  /// Home task due-date label.
  ///
  /// In en, this message translates to:
  /// **'Due {dateTime}'**
  String taskFlowDueAtLabel(String dateTime);

  /// Home urgent queue label shown for overdue tasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {dateTime}'**
  String taskFlowOverdueAtLabel(String dateTime);

  /// Title shown on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEditorTitle;

  /// Helper copy shown below the task editor title.
  ///
  /// In en, this message translates to:
  /// **'Capture the core task first, then keep the remaining fields minimal before saving.'**
  String get taskEditorHelperText;

  /// Label for the task title input.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// Placeholder text for the task title input.
  ///
  /// In en, this message translates to:
  /// **'For example: Connect the editor save flow'**
  String get taskTitleHint;

  /// Label for the task note input.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get taskNoteLabel;

  /// Placeholder text for the task note input.
  ///
  /// In en, this message translates to:
  /// **'Add context or the next step for this task.'**
  String get taskNoteHint;

  /// Label for the pinned toggle in the task editor.
  ///
  /// In en, this message translates to:
  /// **'Pin as current focus'**
  String get taskPinnedLabel;

  /// Label for the private toggle in the task editor.
  ///
  /// In en, this message translates to:
  /// **'Mark as private'**
  String get taskPrivateLabel;

  /// Primary save button label on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Save task'**
  String get taskSaveAction;

  /// Validation message shown when the task title is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a task title first.'**
  String get taskTitleRequired;

  /// Lightweight error message shown when task creation fails.
  ///
  /// In en, this message translates to:
  /// **'Save failed. Try again shortly.'**
  String get taskCreateFailed;

  /// Placeholder task row label used in the bootstrap queue.
  ///
  /// In en, this message translates to:
  /// **'Placeholder item {index}'**
  String homeQueuePlaceholder(int index);

  /// Title for the bootstrap history placeholder page.
  ///
  /// In en, this message translates to:
  /// **'History center'**
  String get historyPlaceholderTitle;

  /// Body text for the bootstrap history placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Recent completed and recently deleted flows will connect here after the shared bootstrap is stable.'**
  String get historyPlaceholderBody;

  /// Main title shown on the history center page.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Supporting copy shown below the history page title.
  ///
  /// In en, this message translates to:
  /// **'Nothing disappears without a trace. Review what was completed or restore what was deleted.'**
  String get historySubtitle;

  /// Section title for recently completed tasks on the history page.
  ///
  /// In en, this message translates to:
  /// **'Recently completed'**
  String get historyCompletedSectionTitle;

  /// Section title for recently deleted tasks on the history page.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get historyDeletedSectionTitle;

  /// Empty-state title shown when there are no completed or deleted tasks.
  ///
  /// In en, this message translates to:
  /// **'Your history is clear for now.'**
  String get historyEmptyTitle;

  /// Empty-state body shown on the history page.
  ///
  /// In en, this message translates to:
  /// **'Completed and deleted tasks will appear here so you can trust that nothing vanished unexpectedly.'**
  String get historyEmptyBody;

  /// Lightweight error hint shown when the history snapshot cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'History failed to load. Try again shortly.'**
  String get historyLoadFailed;

  /// Timeline metadata shown for a completed task on the history page.
  ///
  /// In en, this message translates to:
  /// **'Completed {dateTime}'**
  String historyCompletedAtLabel(String dateTime);

  /// Timeline metadata shown for a deleted task on the history page.
  ///
  /// In en, this message translates to:
  /// **'Deleted {dateTime}'**
  String historyDeletedAtLabel(String dateTime);

  /// Label for the restore button shown on deleted history rows.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get historyRestoreAction;

  /// Shared feedback message shown after a deleted task is restored from history.
  ///
  /// In en, this message translates to:
  /// **'Task restored to active.'**
  String get historyRestoreSuccess;

  /// Title for the bootstrap settings placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Settings center'**
  String get settingsPlaceholderTitle;

  /// Body text for the bootstrap settings placeholder page.
  ///
  /// In en, this message translates to:
  /// **'Notification, privacy, display, and future membership settings will land here in later module work.'**
  String get settingsPlaceholderBody;

  /// Main title shown on the settings center page.
  ///
  /// In en, this message translates to:
  /// **'Settings Center'**
  String get settingsTitle;

  /// Supporting copy shown below the settings page title.
  ///
  /// In en, this message translates to:
  /// **'Manage how Screen Note behaves across reminders, privacy, widgets, and recovery-safe system surfaces.'**
  String get settingsSubtitle;

  /// Section title for notification settings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// Section title for privacy settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacySection;

  /// Section title for widget and display settings.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplaySection;

  /// Section title for sync settings.
  ///
  /// In en, this message translates to:
  /// **'Sync & Backup'**
  String get settingsSyncSection;

  /// Section title for membership entry.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get settingsMembershipSection;

  /// Title for the notification status row.
  ///
  /// In en, this message translates to:
  /// **'Notification Status'**
  String get settingsNotificationStatusTitle;

  /// Description for the notification status row.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on reminders and task changes.'**
  String get settingsNotificationStatusBody;

  /// Title for the privacy mode row.
  ///
  /// In en, this message translates to:
  /// **'Privacy Mode'**
  String get settingsPrivacyModeTitle;

  /// Description for the privacy mode row.
  ///
  /// In en, this message translates to:
  /// **'Protect task content in previews and widgets.'**
  String get settingsPrivacyModeBody;

  /// Title for the widget display mode row.
  ///
  /// In en, this message translates to:
  /// **'Widget Display Mode'**
  String get settingsWidgetDisplayModeTitle;

  /// Description for the widget display mode row.
  ///
  /// In en, this message translates to:
  /// **'Choose whether widgets show full content or a safe preview.'**
  String get settingsWidgetDisplayModeBody;

  /// Title for the add home widget entry in settings.
  ///
  /// In en, this message translates to:
  /// **'Add Home Widget'**
  String get settingsWidgetInstallTitle;

  /// Description for the add home widget entry in settings.
  ///
  /// In en, this message translates to:
  /// **'See how to place Screen Note on the Home Screen, or request a direct add on supported Android launchers.'**
  String get settingsWidgetInstallBody;

  /// Guide text shown in the widget install bottom sheet on Android.
  ///
  /// In en, this message translates to:
  /// **'Add Screen Note to the Home Screen for faster access. On supported Android launchers, you can request the widget directly here. If the launcher declines, long-press the Home Screen, open Widgets, and choose Screen Note.'**
  String get settingsWidgetInstallAndroidGuide;

  /// Guide text shown in the widget install bottom sheet on iOS.
  ///
  /// In en, this message translates to:
  /// **'Touch and hold the Home Screen, tap Edit, then choose Add Widget and search for Screen Note.'**
  String get settingsWidgetInstallIosGuide;

  /// Action label used to request pinning the widget on supported Android launchers.
  ///
  /// In en, this message translates to:
  /// **'Add to Home Screen'**
  String get settingsWidgetInstallAction;

  /// Title for the theme preference row.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeModeTitle;

  /// Description for the theme preference row.
  ///
  /// In en, this message translates to:
  /// **'Choose whether the app follows the system appearance or stays in a fixed light or dark theme.'**
  String get settingsThemeModeBody;

  /// Title for the language preference row.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Description for the language preference row.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used across the app surfaces.'**
  String get settingsLanguageBody;

  /// Title for the sync status row.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get settingsSyncStatusTitle;

  /// Description for the sync status row.
  ///
  /// In en, this message translates to:
  /// **'This build keeps a safe local source of truth while later sync entry points stay visible here.'**
  String get settingsSyncStatusBody;

  /// Title for the membership row.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsMembershipTitle;

  /// Description for the membership row.
  ///
  /// In en, this message translates to:
  /// **'Membership stays visible but secondary to permissions, privacy, and display safety.'**
  String get settingsMembershipBody;

  /// Value label shown when notifications are enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsNotificationEnabled;

  /// Value label shown when notifications are disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsNotificationDisabled;

  /// Value label shown when notification permissions cannot be read.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get settingsNotificationUnknown;

  /// Title shown in the inline degradation notice for notification permissions.
  ///
  /// In en, this message translates to:
  /// **'Permission downgraded'**
  String get settingsPermissionDowngradedTitle;

  /// Body shown in the inline degradation notice for notification permissions.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Task creation still works, but reminders are reduced.'**
  String get settingsPermissionDowngradedBody;

  /// Action label for reviewing notification permission state.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get settingsReviewAction;

  /// Value label for the safe widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Preview Only'**
  String get settingsWidgetDisplayPreviewOnly;

  /// Value label for the full widget content mode.
  ///
  /// In en, this message translates to:
  /// **'Full Content'**
  String get settingsWidgetDisplayFullContent;

  /// Value label shown for the system theme mode preference.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsThemeModeSystem;

  /// Value label shown for the light theme mode preference.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLight;

  /// Value label shown for the dark theme mode preference.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDark;

  /// Value label shown for the Simplified Chinese language preference.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get settingsLanguageZh;

  /// Value label shown for the English language preference.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// Value label shown when sync is still limited to the local source of truth.
  ///
  /// In en, this message translates to:
  /// **'Local Only'**
  String get settingsSyncLocalOnly;

  /// Value label shown for the secondary membership entry.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get settingsMembershipAvailable;

  /// Title shown in the widget display mode picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose a widget display mode'**
  String get settingsWidgetDisplayPickerTitle;

  /// Title shown in the theme mode picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose a theme'**
  String get settingsThemeModePickerTitle;

  /// Title shown in the language picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get settingsLanguagePickerTitle;

  /// Shared feedback message shown after updating privacy mode.
  ///
  /// In en, this message translates to:
  /// **'Privacy setting updated.'**
  String get settingsPrivacyFeedback;

  /// Shared feedback message shown after updating widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Widget display setting updated.'**
  String get settingsWidgetDisplayFeedback;

  /// Shared feedback message shown after updating the theme mode preference.
  ///
  /// In en, this message translates to:
  /// **'Theme setting updated.'**
  String get settingsThemeModeFeedback;

  /// Shared feedback message shown after updating the language preference.
  ///
  /// In en, this message translates to:
  /// **'Language setting updated.'**
  String get settingsLanguageFeedback;

  /// Shared feedback shown when notification permission becomes available after review.
  ///
  /// In en, this message translates to:
  /// **'Notification access is now available.'**
  String get settingsNotificationGrantedFeedback;

  /// Shared feedback shown when notification permission remains limited after review.
  ///
  /// In en, this message translates to:
  /// **'Notification access is still limited.'**
  String get settingsNotificationDeferredFeedback;

  /// Shared feedback shown after requesting the launcher to pin the widget.
  ///
  /// In en, this message translates to:
  /// **'Widget request sent to the launcher.'**
  String get settingsWidgetInstallRequestedFeedback;

  /// Shared feedback shown when direct widget pinning is unsupported.
  ///
  /// In en, this message translates to:
  /// **'This launcher does not support direct widget pinning.'**
  String get settingsWidgetInstallUnsupportedFeedback;

  /// Shared feedback shown when direct widget pinning fails.
  ///
  /// In en, this message translates to:
  /// **'Widget request failed. Please add it from the system widget picker.'**
  String get settingsWidgetInstallFailedFeedback;

  /// Lightweight error hint shown when the settings snapshot cannot be loaded.
  ///
  /// In en, this message translates to:
  /// **'Settings failed to load. Try again shortly.'**
  String get settingsLoadFailed;

  /// Empty-state title shown inside the widget snapshot when there is no active reminder to project.
  ///
  /// In en, this message translates to:
  /// **'No reminder is ready for the widget yet'**
  String get widgetSnapshotEmptyTitle;

  /// Empty-state body shown inside the widget snapshot when there is no active reminder to project.
  ///
  /// In en, this message translates to:
  /// **'Create or restore a task and the next stable snapshot will appear here.'**
  String get widgetSnapshotEmptyBody;

  /// Hint shown when the widget is rendering a previously valid fallback snapshot.
  ///
  /// In en, this message translates to:
  /// **'Showing the last valid widget snapshot.'**
  String get widgetSnapshotFallbackHint;

  /// Widget title shown when the user selected preview-only mode for non-private reminders.
  ///
  /// In en, this message translates to:
  /// **'Preview is hidden'**
  String get widgetSnapshotPreviewTitle;

  /// Widget title shown when a private reminder must be masked.
  ///
  /// In en, this message translates to:
  /// **'Private reminder is hidden'**
  String get widgetSnapshotPrivateTitle;

  /// Status label shown for a non-private reminder in preview-only mode.
  ///
  /// In en, this message translates to:
  /// **'Safe Preview'**
  String get widgetSnapshotStatusPreview;

  /// Status label shown when a private reminder is masked inside the widget.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get widgetSnapshotStatusPrivate;

  /// Status label shown for reminders due today inside the widget.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get widgetSnapshotStatusToday;

  /// Status label shown for overdue reminders inside the widget.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get widgetSnapshotStatusOverdue;

  /// Status label shown for pinned reminders inside the widget.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get widgetSnapshotStatusPinned;

  /// CTA-like helper text shown in the widget snapshot to indicate the safe handoff back to the app.
  ///
  /// In en, this message translates to:
  /// **'Open in app'**
  String get widgetSnapshotOpenInApp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
