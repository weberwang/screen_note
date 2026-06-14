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
  String get homePriorityLabel => '当前重点';

  @override
  String get homePriorityTitle => '先把共享壳层启动起来';

  @override
  String get homePriorityBody => '根路由、共享主题和启动装配现在已经有了稳定落点。';

  @override
  String get homeQueueTitle => '紧急队列';

  @override
  String get taskFlowHomeLoadFailed => '首页快照加载失败';

  @override
  String get taskFlowEmptyTitle => '还没有待处理事项';

  @override
  String get taskFlowEmptyBody => '创建或恢复一条事项后，这里会出现新的关注列表。';

  @override
  String get taskFlowPrivateTaskHint => '这条私密事项会在首页隐藏正文';

  @override
  String get taskFlowPriorityFallbackBody => '先继续推进下一步最有价值的动作。';

  @override
  String get taskFlowPinnedLabel => '置顶事项';

  @override
  String get taskFlowNoDueDate => '未设置截止时间';

  @override
  String taskFlowDueAtLabel(String dateTime) {
    return '截止 $dateTime';
  }

  @override
  String taskFlowOverdueAtLabel(String dateTime) {
    return '已逾期，原截止 $dateTime';
  }

  @override
  String get taskEditorTitle => '编辑事项';

  @override
  String get taskEditorHelperText => '先写下这条事项的核心内容，其他字段保持最小输入即可保存。';

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
  String get historyEmptyTitle => '当前还没有历史记录';

  @override
  String get historyEmptyBody => '完成或删除过的事项会出现在这里，方便你确认它们仍然可追溯、可找回。';

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
  String get settingsSubtitle => '统一管理提醒、隐私、小组件展示以及后续系统能力入口，同时保持主链路可继续使用。';

  @override
  String get settingsNotificationsSection => '通知';

  @override
  String get settingsPrivacySection => '隐私';

  @override
  String get settingsDisplaySection => '展示';

  @override
  String get settingsSyncSection => '同步与备份';

  @override
  String get settingsMembershipSection => '权益入口';

  @override
  String get settingsNotificationStatusTitle => '通知状态';

  @override
  String get settingsNotificationStatusBody => '查看提醒与事项状态变化是否还能被正常送达。';

  @override
  String get settingsPrivacyModeTitle => '隐私模式';

  @override
  String get settingsPrivacyModeBody => '保护锁屏预览和小组件中的事项正文不被直接暴露。';

  @override
  String get settingsWidgetDisplayModeTitle => 'Widget 展示模式';

  @override
  String get settingsWidgetDisplayModeBody => '选择小组件显示完整内容，还是只显示安全预览。';

  @override
  String get settingsSyncStatusTitle => '同步状态';

  @override
  String get settingsSyncStatusBody => '当前版本以本地真源为主，后续同步入口会继续挂在这里。';

  @override
  String get settingsMembershipTitle => '高级权益';

  @override
  String get settingsMembershipBody => '权益入口继续可见，但它必须弱于通知、隐私和展示安全这些核心设置。';

  @override
  String get settingsNotificationEnabled => '已开启';

  @override
  String get settingsNotificationDisabled => '未开启';

  @override
  String get settingsNotificationUnknown => '未知';

  @override
  String get settingsPermissionDowngradedTitle => '能力已降级';

  @override
  String get settingsPermissionDowngradedBody => '通知未开启。事项创建仍可继续，但提醒链路会降级运行。';

  @override
  String get settingsReviewAction => '复查';

  @override
  String get settingsWidgetDisplayPreviewOnly => '仅安全预览';

  @override
  String get settingsWidgetDisplayFullContent => '显示完整内容';

  @override
  String get settingsSyncLocalOnly => '仅本地';

  @override
  String get settingsMembershipAvailable => '可查看';

  @override
  String get settingsWidgetDisplayPickerTitle => '选择 Widget 展示模式';

  @override
  String get settingsPrivacyFeedback => '隐私设置已更新';

  @override
  String get settingsWidgetDisplayFeedback => 'Widget 展示设置已更新';

  @override
  String get settingsNotificationGrantedFeedback => '通知权限现在可用了';

  @override
  String get settingsNotificationDeferredFeedback => '通知权限仍然受限';

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
}
