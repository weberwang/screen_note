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

  /// Context chip shown below the home greeting.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTodayChip;

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
  /// **'Completed and deleted items stay in history.'**
  String get homeHistorySummaryBody;

  /// Supporting copy shown in the home history status summary when history is empty.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
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

  /// Primary CTA label shown on the home priority card.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get taskFlowPriorityContinueAction;

  /// Primary CTA label shown on the empty home priority card.
  ///
  /// In en, this message translates to:
  /// **'Start task'**
  String get taskFlowPriorityEmptyAction;

  /// Safe title shown for a private task on the home surface.
  ///
  /// In en, this message translates to:
  /// **'Private task'**
  String get taskFlowPrivateTitle;

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

  /// Home task status label shown when the task is due today.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get taskFlowDueTodayLabel;

  /// Home urgent queue label shown for overdue tasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {dateTime}'**
  String taskFlowOverdueAtLabel(String dateTime);

  /// Section title shown for overdue tasks on the home page.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskFlowOverdueSectionTitle;

  /// Section title shown for non-overdue tasks on the home page.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get taskFlowUpNextSectionTitle;

  /// Inline degradation notice title shown on the task-flow home page.
  ///
  /// In en, this message translates to:
  /// **'Some capabilities are degraded'**
  String get taskFlowHomeDegradationTitle;

  /// Inline degradation notice body shown when notification permission is unavailable on the task-flow home page.
  ///
  /// In en, this message translates to:
  /// **'Notification access is currently unavailable, but tasks can still be created, edited, and completed.'**
  String get taskFlowHomePermissionDegradationBody;

  /// Inline degradation notice body shown when the task-flow home snapshot refresh fails but previous data is preserved.
  ///
  /// In en, this message translates to:
  /// **'The home page kept the last snapshot. Retry later to restore the latest state.'**
  String get taskFlowHomeRefreshDegradationBody;

  /// Title shown on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskEditorTitle;

  /// Lightweight save action shown at the top of the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get taskEditorTopSaveAction;

  /// Helper copy shown below the task editor title.
  ///
  /// In en, this message translates to:
  /// **'Capture the core task first, then keep the remaining fields minimal before saving.'**
  String get taskEditorHelperText;

  /// Field label shown for the due date row on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get taskEditorDueDateLabel;

  /// Field label shown for the due time row on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Due time'**
  String get taskEditorDueTimeLabel;

  /// Fallback value shown when the due date is not set on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get taskEditorNoDueDate;

  /// Fallback value shown when the due time is not set on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get taskEditorNoDueTime;

  /// Field label shown for the focus row on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Current focus'**
  String get taskEditorFocusLabel;

  /// Value shown when the task is pinned on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Pinned task'**
  String get taskEditorFocusPinnedValue;

  /// Value shown when the task is not pinned on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Regular task'**
  String get taskEditorFocusNormalValue;

  /// Field label shown for the privacy row on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get taskEditorPrivacyFieldLabel;

  /// Value shown when the task is visible on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get taskEditorPrivacyPublicValue;

  /// Value shown when the task is private on the task editor page.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get taskEditorPrivacyPrivateValue;

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
  /// **'No history yet'**
  String get historyEmptyTitle;

  /// Empty-state body shown on the history page.
  ///
  /// In en, this message translates to:
  /// **'Completed or deleted tasks will appear here when you need them.'**
  String get historyEmptyBody;

  /// Tooltip and accessibility label for the add action shown on the history empty state.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get historyEmptyAddAction;

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
  /// **'Manage how Screen Note works across your device and keep your notes safe.'**
  String get settingsSubtitle;

  /// Section title for notification settings.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsNotificationsSection;

  /// Section title for privacy settings.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get settingsPrivacySection;

  /// Section title for widget and display settings.
  ///
  /// In en, this message translates to:
  /// **'WIDGET'**
  String get settingsDisplaySection;

  /// Section title for sync settings.
  ///
  /// In en, this message translates to:
  /// **'SYNC'**
  String get settingsSyncSection;

  /// Section title for membership entry.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP'**
  String get settingsMembershipSection;

  /// Title for the notification status row.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationStatusTitle;

  /// Description for the notification status row.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on saves and sync activity.'**
  String get settingsNotificationStatusBody;

  /// Title for the privacy mode row.
  ///
  /// In en, this message translates to:
  /// **'Privacy Mode'**
  String get settingsPrivacyModeTitle;

  /// Description for the privacy mode row.
  ///
  /// In en, this message translates to:
  /// **'Hide sensitive content in previews.'**
  String get settingsPrivacyModeBody;

  /// Title for the widget display mode row.
  ///
  /// In en, this message translates to:
  /// **'Widget Display Mode'**
  String get settingsWidgetDisplayModeTitle;

  /// Description for the widget display mode row.
  ///
  /// In en, this message translates to:
  /// **'Choose what shows in your widget.'**
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
  /// **'Last synced just now'**
  String get settingsSyncStatusBody;

  /// Title for the membership row.
  ///
  /// In en, this message translates to:
  /// **'Screen Note Pro'**
  String get settingsMembershipTitle;

  /// Description for the membership row.
  ///
  /// In en, this message translates to:
  /// **'Manage your plan and benefits.'**
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
  /// **'Notifications are turned off.'**
  String get settingsPermissionDowngradedTitle;

  /// Body shown in the inline degradation notice for notification permissions.
  ///
  /// In en, this message translates to:
  /// **'You may miss important updates about your notes.'**
  String get settingsPermissionDowngradedBody;

  /// Action label for reviewing notification permission state.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get settingsReviewAction;

  /// Value label for the safe widget preview mode.
  ///
  /// In en, this message translates to:
  /// **'Blurred Previews'**
  String get settingsWidgetDisplayPreviewOnly;

  /// Current privacy mode value shown on the settings row when safe preview protection is enabled.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsPrivacyModeOn;

  /// Current privacy mode value shown on the settings row when safe preview protection is disabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsPrivacyModeOff;

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

  /// Current sync state value shown on the settings row when the screenshot-approved design displays a synced state.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get settingsSyncSynced;

  /// Value label shown for the secondary membership entry.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get settingsMembershipAvailable;

  /// Inline supportive title shown under the privacy mode row when the current safe mode is active.
  ///
  /// In en, this message translates to:
  /// **'Privacy mode is on.'**
  String get settingsPrivacyProtectionTitle;

  /// Inline supportive body shown under the privacy mode row to explain the current preview protection behavior.
  ///
  /// In en, this message translates to:
  /// **'Previews are blurred in recents and widgets.'**
  String get settingsPrivacyProtectionBody;

  /// Inline secondary action shown in the privacy support notice.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get settingsPrivacyProtectionAction;

  /// Secondary membership support note title shown below the main membership row.
  ///
  /// In en, this message translates to:
  /// **'You\'re using Screen Note Pro'**
  String get settingsMembershipSupportTitle;

  /// Secondary membership support note body shown below the main membership row.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting a focused and private note-taking experience.'**
  String get settingsMembershipSupportBody;

  /// Current membership state value shown on the settings row when the screenshot-approved design displays an active subscription.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settingsMembershipActive;

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

  /// Capability-boundary feedback shown when the user tries to disable notifications inside the app.
  ///
  /// In en, this message translates to:
  /// **'Turn off notifications in system settings.'**
  String get settingsNotificationDisableInSystemFeedback;

  /// Confirmation title shown before sending the user to system settings to turn off notifications.
  ///
  /// In en, this message translates to:
  /// **'Turn off notifications?'**
  String get settingsNotificationDisableDialogTitle;

  /// Confirmation body shown before sending the user to system settings to turn off notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications can only be turned off in system settings. Open settings now?'**
  String get settingsNotificationDisableDialogBody;

  /// Cancel action in the notification disable confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsNotificationDisableDialogCancel;

  /// Confirm action in the notification disable confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get settingsNotificationDisableDialogConfirm;

  /// Shared feedback shown when the app fails to open system settings.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open system settings. Try again later.'**
  String get settingsNotificationOpenSettingsFailed;

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

  /// Title shown on the widget bridge preview page.
  ///
  /// In en, this message translates to:
  /// **'Widget Preview'**
  String get widgetSettingsTitle;

  /// Supporting copy shown below the widget bridge page title.
  ///
  /// In en, this message translates to:
  /// **'Preview the current stable snapshot and manually sync it to the system widget when needed.'**
  String get widgetSettingsSubtitle;

  /// Feedback shown after manually syncing the widget snapshot.
  ///
  /// In en, this message translates to:
  /// **'Latest stable widget snapshot synced.'**
  String get widgetSyncSuccess;

  /// Feedback shown when manually syncing the widget snapshot fails.
  ///
  /// In en, this message translates to:
  /// **'Widget snapshot sync failed.'**
  String get widgetSyncFailed;

  /// Metric label for the current widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Display mode'**
  String get widgetPreviewModeMetric;

  /// Metric label for the count of currently visible widget items.
  ///
  /// In en, this message translates to:
  /// **'Visible items'**
  String get widgetPreviewVisibleMetric;

  /// Metric label for the count of private items in the widget snapshot.
  ///
  /// In en, this message translates to:
  /// **'Private items'**
  String get widgetPreviewPrivateMetric;

  /// Label for the single-focus widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Single Focus'**
  String get widgetDisplayModeSingle;

  /// Label for the three-item widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Three-item List'**
  String get widgetDisplayModeList3;

  /// Label for the today-priority widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Today First'**
  String get widgetDisplayModeToday;

  /// Label for the private-safe widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Private Safe'**
  String get widgetDisplayModePrivate;

  /// Label for the empty-state widget display mode.
  ///
  /// In en, this message translates to:
  /// **'Empty Placeholder'**
  String get widgetDisplayModeEmpty;

  /// Title shown above the manual sync action on the widget bridge page.
  ///
  /// In en, this message translates to:
  /// **'Manual Sync'**
  String get widgetFallbackPreviewTitle;

  /// Action label used to manually sync the widget snapshot.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get widgetSyncAction;

  /// Generic retry action label.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;
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
