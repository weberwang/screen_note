// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '屏记';

  @override
  String get homeTabLabel => '首页';

  @override
  String get historyTabLabel => '历史';

  @override
  String get settingsTabLabel => '设置';

  @override
  String get quickAddSheetTitle => '快速添加';

  @override
  String get quickAddSheetHint => '先进入事项编辑页，完成标题、备注和隐私等最小录入后再保存。';

  @override
  String get quickAddSheetContinue => '继续添加';

  @override
  String get quickAddSheetDismiss => '关闭';

  @override
  String get quickAddFeedbackPlaceholder => '快速添加链路将在 task-flow 阶段接入';

  @override
  String get appShellFeedbackDismiss => '知道了';

  @override
  String get homeGreetingTitle => '早上好';

  @override
  String get homeGreetingSubtitle => '先把今天最重要的事放在最前面。';

  @override
  String get homeTodayChip => '今天';

  @override
  String get homePriorityLabel => '当前重点';

  @override
  String get homePriorityTitle => '先把共享壳层启动起来';

  @override
  String get homePriorityBody => '根路由、共享主题和启动装配现在已经有了稳定落点。';

  @override
  String get homeQueueTitle => '紧急队列';

  @override
  String get homeHistoryTitle => '历史状态';

  @override
  String homeHistoryCompletedCount(int count) {
    return '已完成 $count';
  }

  @override
  String homeHistoryDeletedCount(int count) {
    return '已删除 $count';
  }

  @override
  String get homeHistorySummaryBody => '完成或删除过的事项会留在历史里，方便你继续追溯或恢复。';

  @override
  String get homeHistoryEmptyBody => '当前还没有历史记录；完成或删除后，这里会保留可追溯线索。';

  @override
  String get homeHistoryAction => '查看历史';

  @override
  String get taskFlowHomeLoadFailed => '首页快照加载失败';

  @override
  String get taskFlowEmptyTitle => '还没有待处理事项';

  @override
  String get taskFlowEmptyBody => '创建或恢复一条事项后，这里会出现新的关注列表。';

  @override
  String get taskFlowPrivateTaskHint => '首页已隐藏内容';

  @override
  String get taskFlowPriorityFallbackBody => '继续处理下一步';

  @override
  String get taskFlowPriorityContinueAction => '继续处理';

  @override
  String get taskFlowPriorityEmptyAction => '开始添加';

  @override
  String get taskFlowPrivateTitle => '私密事项';

  @override
  String get taskFlowPinnedLabel => '置顶事项';

  @override
  String get taskFlowNoDueDate => '未设置截止时间';

  @override
  String taskFlowDueAtLabel(String dateTime) {
    return '截止 $dateTime';
  }

  @override
  String get taskFlowDueTodayLabel => '今天截止';

  @override
  String taskFlowOverdueAtLabel(String dateTime) {
    return '已逾期，原截止 $dateTime';
  }

  @override
  String get taskFlowOverdueSectionTitle => '逾期';

  @override
  String get taskFlowUpNextSectionTitle => '接下来';

  @override
  String get taskFlowHomeDegradationTitle => '部分能力已降级';

  @override
  String get taskFlowHomePermissionDegradationBody =>
      '通知权限当前不可用，但事项仍可继续创建、编辑和完成。';

  @override
  String get taskFlowHomeRefreshDegradationBody => '首页已保留上次快照，稍后重试即可恢复最新状态。';

  @override
  String get taskEditorTitle => '编辑事项';

  @override
  String get taskEditorTopSaveAction => '保存';

  @override
  String get taskEditorHelperText => '先写下这条事项的核心内容，其他字段保持最小输入即可保存。';

  @override
  String get taskEditorDueDateLabel => '截止日期';

  @override
  String get taskEditorDueTimeLabel => '截止时间';

  @override
  String get taskEditorNoDueDate => '未设置';

  @override
  String get taskEditorNoDueTime => '未设置';

  @override
  String get taskEditorFocusLabel => '当前重点';

  @override
  String get taskEditorFocusPinnedValue => '置顶事项';

  @override
  String get taskEditorFocusNormalValue => '普通事项';

  @override
  String get taskEditorPrivacyFieldLabel => '隐私';

  @override
  String get taskEditorPrivacyPublicValue => '公开';

  @override
  String get taskEditorPrivacyPrivateValue => '私密';

  @override
  String get taskTitleLabel => '标题';

  @override
  String get taskTitleHint => '例如：补齐编辑页保存主链路';

  @override
  String get taskNoteLabel => '备注';

  @override
  String get taskNoteHint => '补充这条事项的上下文或下一步。';

  @override
  String get taskPinnedLabel => '置顶为当前重点';

  @override
  String get taskPrivateLabel => '标记为私密事项';

  @override
  String get taskSaveAction => '保存事项';

  @override
  String get taskTitleRequired => '请先输入事项标题';

  @override
  String get taskCreateFailed => '保存失败，请稍后重试';

  @override
  String homeQueuePlaceholder(int index) {
    return '占位事项 $index';
  }

  @override
  String get historyPlaceholderTitle => '历史中心';

  @override
  String get historyPlaceholderBody => '最近完成与最近删除会在共享启动链稳定后接入这里。';

  @override
  String get historyTitle => '历史';

  @override
  String get historySubtitle => '事项不会无故消失。你可以回看已经完成的内容，也可以找回刚刚删除的事项。';

  @override
  String get historyCompletedSectionTitle => '最近完成';

  @override
  String get historyDeletedSectionTitle => '最近删除';

  @override
  String get historyEmptyTitle => '还没有历史记录';

  @override
  String get historyEmptyBody => '当你完成或删除事项时，它们会在需要时出现在这里。';

  @override
  String get historyEmptyAddAction => '新建事项';

  @override
  String get historyLoadFailed => '历史记录加载失败，请稍后再试';

  @override
  String historyCompletedAtLabel(String dateTime) {
    return '完成于 $dateTime';
  }

  @override
  String historyDeletedAtLabel(String dateTime) {
    return '删除于 $dateTime';
  }

  @override
  String get historyRestoreAction => '恢复';

  @override
  String get historyRestoreSuccess => '事项已恢复到 active';

  @override
  String get settingsPlaceholderTitle => '设置中心';

  @override
  String get settingsPlaceholderBody => '通知、隐私、展示偏好和后续权益入口会在后续模块工作中接入这里。';

  @override
  String get settingsTitle => '设置中心';

  @override
  String get settingsSubtitle => '管理提醒、隐私和显示';

  @override
  String get settingsNotificationsSection => '通知';

  @override
  String get settingsPrivacySection => '隐私';

  @override
  String get settingsDisplaySection => '小组件';

  @override
  String get settingsSyncSection => '同步';

  @override
  String get settingsMembershipSection => '会员';

  @override
  String get settingsNotificationStatusTitle => '通知';

  @override
  String get settingsNotificationStatusBody => '保存与同步提醒';

  @override
  String get settingsPrivacyModeTitle => '隐私模式';

  @override
  String get settingsPrivacyModeBody => '隐藏预览内容';

  @override
  String get settingsWidgetDisplayModeTitle => 'Widget 展示模式';

  @override
  String get settingsWidgetDisplayModeBody => '选择小组件内容';

  @override
  String get settingsWidgetInstallTitle => '添加桌面小组件';

  @override
  String get settingsWidgetInstallBody =>
      '查看把 Screen Note 放到桌面的步骤；在支持的 Android 桌面上也可直接请求添加。';

  @override
  String get settingsWidgetInstallAndroidGuide =>
      '把 Screen Note 放到桌面后可以更快查看当前事项。在支持的 Android 桌面上，你可以直接在这里请求添加；如果桌面不支持，请长按桌面后打开“小组件”，再选择 Screen Note。';

  @override
  String get settingsWidgetInstallIosGuide =>
      '长按主屏幕，点“编辑”，再选“添加小组件”，然后搜索 Screen Note。';

  @override
  String get settingsWidgetInstallAction => '添加到桌面';

  @override
  String get settingsThemeModeTitle => '主题';

  @override
  String get settingsThemeModeBody => '选择应用跟随系统外观，还是固定保持浅色或深色主题。';

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsLanguageBody => '选择应用内统一使用的语言。';

  @override
  String get settingsSyncStatusTitle => '同步状态';

  @override
  String get settingsSyncStatusBody => '刚刚同步';

  @override
  String get settingsMembershipTitle => 'Screen Note Pro';

  @override
  String get settingsMembershipBody => '管理方案与权益';

  @override
  String get settingsNotificationEnabled => '已开启';

  @override
  String get settingsNotificationDisabled => '未开启';

  @override
  String get settingsNotificationUnknown => '未知';

  @override
  String get settingsPermissionDowngradedTitle => '通知已关闭。';

  @override
  String get settingsPermissionDowngradedBody => '你可能错过重要提醒';

  @override
  String get settingsReviewAction => '启用';

  @override
  String get settingsWidgetDisplayPreviewOnly => '模糊预览';

  @override
  String get settingsPrivacyModeOn => '开启';

  @override
  String get settingsPrivacyModeOff => '关闭';

  @override
  String get settingsWidgetDisplayFullContent => '显示完整内容';

  @override
  String get settingsThemeModeSystem => '跟随系统';

  @override
  String get settingsThemeModeLight => '浅色';

  @override
  String get settingsThemeModeDark => '深色';

  @override
  String get settingsLanguageZh => '简体中文';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSyncLocalOnly => '仅本地';

  @override
  String get settingsSyncSynced => '已同步';

  @override
  String get settingsMembershipAvailable => '可查看';

  @override
  String get settingsPrivacyProtectionTitle => '隐私模式已开启。';

  @override
  String get settingsPrivacyProtectionBody => '最近项目和小组件会模糊显示';

  @override
  String get settingsPrivacyProtectionAction => '了解更多';

  @override
  String get settingsMembershipSupportTitle => '你正在使用 Screen Note Pro';

  @override
  String get settingsMembershipSupportBody => '感谢支持更专注的记录体验';

  @override
  String get settingsMembershipActive => '已激活';

  @override
  String get settingsWidgetDisplayPickerTitle => '选择 Widget 展示模式';

  @override
  String get settingsThemeModePickerTitle => '选择主题';

  @override
  String get settingsLanguagePickerTitle => '选择语言';

  @override
  String get settingsPrivacyFeedback => '隐私设置已更新';

  @override
  String get settingsWidgetDisplayFeedback => 'Widget 展示设置已更新';

  @override
  String get settingsThemeModeFeedback => '主题设置已更新';

  @override
  String get settingsLanguageFeedback => '语言设置已更新';

  @override
  String get settingsNotificationGrantedFeedback => '通知权限现在可用了';

  @override
  String get settingsNotificationDeferredFeedback => '通知权限仍然受限';

  @override
  String get settingsNotificationDisableInSystemFeedback => '请在系统设置中关闭通知';

  @override
  String get settingsNotificationDisableDialogTitle => '关闭通知？';

  @override
  String get settingsNotificationDisableDialogBody => '通知需要在系统设置中关闭，是否现在前往？';

  @override
  String get settingsNotificationDisableDialogCancel => '取消';

  @override
  String get settingsNotificationDisableDialogConfirm => '前往设置';

  @override
  String get settingsNotificationOpenSettingsFailed => '无法打开系统设置，请稍后重试';

  @override
  String get settingsWidgetInstallRequestedFeedback => '已向桌面发出小组件添加请求';

  @override
  String get settingsWidgetInstallUnsupportedFeedback => '当前桌面不支持直接添加小组件';

  @override
  String get settingsWidgetInstallFailedFeedback => '添加请求失败，请从系统小组件列表手动添加';

  @override
  String get settingsLoadFailed => '设置内容加载失败，请稍后再试';

  @override
  String get widgetSnapshotEmptyTitle => '当前还没有可投影到 Widget 的事项';

  @override
  String get widgetSnapshotEmptyBody => '新增或恢复一条事项后，这里会显示下一次稳定快照。';

  @override
  String get widgetSnapshotFallbackHint => '当前展示的是最近一次有效的 Widget 快照。';

  @override
  String get widgetSnapshotPreviewTitle => '预览内容已隐藏';

  @override
  String get widgetSnapshotPrivateTitle => '隐私事项内容已隐藏';

  @override
  String get widgetSnapshotStatusPreview => '安全预览';

  @override
  String get widgetSnapshotStatusPrivate => '受保护';

  @override
  String get widgetSnapshotStatusToday => '今天';

  @override
  String get widgetSnapshotStatusOverdue => '已过期';

  @override
  String get widgetSnapshotStatusPinned => '置顶';

  @override
  String get widgetSnapshotOpenInApp => '点按后回到应用查看';

  @override
  String get widgetSettingsTitle => 'Widget 预览';

  @override
  String get widgetSettingsSubtitle => '预览当前稳定快照，并在需要时手动同步到系统小组件。';

  @override
  String get widgetSyncSuccess => '已同步最新稳定快照。';

  @override
  String get widgetSyncFailed => '同步 Widget 快照失败。';

  @override
  String get widgetPreviewModeMetric => '显示模式';

  @override
  String get widgetPreviewVisibleMetric => '可见条目';

  @override
  String get widgetPreviewPrivateMetric => '私密条目';

  @override
  String get widgetDisplayModeSingle => '单条聚焦';

  @override
  String get widgetDisplayModeList3 => '三条列表';

  @override
  String get widgetDisplayModeToday => '今日优先';

  @override
  String get widgetDisplayModePrivate => '私密遮罩';

  @override
  String get widgetDisplayModeEmpty => '空态占位';

  @override
  String get widgetFallbackPreviewTitle => '手动同步';

  @override
  String get widgetSyncAction => '立即同步';

  @override
  String get retryAction => '重试';
}
