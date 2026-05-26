// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '屏幕便签';

  @override
  String get homePageTitle => '今天别忘了';

  @override
  String get homePageSubtitle => '把不能忘的小事放到一直看得见的地方。';

  @override
  String get quickInputPlaceholder => '写下不能忘的小事';

  @override
  String get quickInputSubmit => '添加';

  @override
  String get quickInputHelperText => '默认先保留标题，截止时间、置顶和隐私作为轻量补充。';

  @override
  String get quickAddPageTitle => '快速添加';

  @override
  String get quickAddPageBody => '这里接住系统入口失败后的草稿，你可以补一句话内容并继续创建，不需要重新开始。';

  @override
  String get quickAddSheetBody => '首页轻入口只保留一句话输入和少量默认值，方便你在 3 秒内完成创建。';

  @override
  String get quickAddInputLabel => '事项内容';

  @override
  String get quickAddDefaultPinnedTitle => '默认置顶';

  @override
  String get quickAddDefaultPrivacyTitle => '默认隐私';

  @override
  String get quickAddDefaultEnableAction => '开启';

  @override
  String get quickAddDefaultDisableAction => '关闭';

  @override
  String get quickAddNonBlockingTitle => '入口失败也不拦主链路';

  @override
  String get quickAddNonBlockingBody =>
      '如果系统入口没有直接完成创建，我们会先把内容留在应用层，回到 App 后继续补全。';

  @override
  String get quickAddSheetHintBody => '这里不会展开完整编辑流程，失败时也会把草稿先留住，方便你稍后继续。';

  @override
  String get quickAddDraftRestoredBody => '刚才的草稿已经恢复到这里，你可以直接继续补完并提交。';

  @override
  String get quickAddSourceHome => '来自首页';

  @override
  String get quickAddSourceAppIntent => '来自 App Intent';

  @override
  String get quickAddSourceControlCenter => '来自控制中心';

  @override
  String get quickAddSourceLockScreen => '来自锁屏入口';

  @override
  String get quickAddSourceActionButton => '来自 Action Button';

  @override
  String get quickAddSourceDeepLink => '来自深链回流';

  @override
  String get quickAddSourceFallback => '来自失败兜底';

  @override
  String get taskTitleRequired => '先写下一件重要的事。';

  @override
  String get taskCreateSuccess => '已放到锁屏提醒。';

  @override
  String get taskCreateFailed => '暂时还没保存成功，但输入内容还在。';

  @override
  String get activeTasksSectionTitle => '当前事项';

  @override
  String get completedHistoryEntry => '最近完成';

  @override
  String get deletedHistoryEntry => '最近删除';

  @override
  String get taskEditorEntry => '完整新建';

  @override
  String get settingsEntry => '设置';

  @override
  String get emptyActiveTasksTitle => '现在还没有要记的事';

  @override
  String get emptyActiveTasksBody => '写下一件事，它就会稳定留在这里。';

  @override
  String get emptyCompletedTasksTitle => '还没有最近完成';

  @override
  String get emptyCompletedTasksBody => '完成过的事项会留在这里，方便之后追溯。';

  @override
  String get emptyDeletedTasksTitle => '最近删除还是空的';

  @override
  String get emptyDeletedTasksBody => '删除的事项会在这里保留 30 天，方便你恢复。';

  @override
  String get deletedRetentionHint => '删除事项会在这里保留 30 天。';

  @override
  String get historyCompletedTitle => '最近完成';

  @override
  String get historyDeletedTitle => '最近删除';

  @override
  String get taskDetailTitle => '事项详情';

  @override
  String get taskEditorTitle => '新建事项';

  @override
  String get taskEditorHelperText => '完整新建页负责标题、备注、时间、置顶、隐私与提醒模式的统一录入。';

  @override
  String get taskDetailMissing => '这条事项暂时不可用。';

  @override
  String get taskTitleLabel => '标题';

  @override
  String get taskNoteLabel => '备注';

  @override
  String get taskDueLabel => '截止时间';

  @override
  String get taskDueEmpty => '还没设置截止时间';

  @override
  String get taskPinnedLabel => '置顶这条事项';

  @override
  String get taskPrivateLabel => '在锁屏隐藏正文';

  @override
  String get taskReminderModeLabel => '提醒模式';

  @override
  String get taskReminderModeNormal => '普通提醒';

  @override
  String get taskReminderModePersistent => '强提醒';

  @override
  String get taskSaveChanges => '保存修改';

  @override
  String get taskSaveAction => '保存事项';

  @override
  String get taskCompleteAction => '完成';

  @override
  String get taskDeleteAction => '删除';

  @override
  String get taskRestoreAction => '恢复';

  @override
  String get taskRestoreItemAction => '恢复事项';

  @override
  String get valueEnabled => '开启';

  @override
  String get valueDisabled => '关闭';

  @override
  String get taskRestoreSuccess => '已恢复到当前事项。';

  @override
  String get taskDeleteSuccess => '已删除，可在最近删除里恢复。';

  @override
  String get taskCompleteSuccess => '已移到最近完成。';

  @override
  String get taskUpdateSuccess => '修改已经保存。';

  @override
  String get taskLoadFailed => '暂时无法加载事项列表。';

  @override
  String get taskHistoryLoadFailed => '暂时无法加载历史记录。';

  @override
  String get retryAction => '重试';

  @override
  String get statusPinned => '置顶';

  @override
  String get statusOverdue => '过期';

  @override
  String get statusToday => '今天';

  @override
  String get statusPrivate => '隐私';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusDeleted => '已删除';

  @override
  String get privateMaskedTitle => '隐私事项';

  @override
  String get taskPrivateMaskedBody => '隐私事项内容已隐藏，仅在详情页内可见。';

  @override
  String get viewTaskDetailAction => '查看详情';

  @override
  String get viewOriginalRecordAction => '查看原记录';

  @override
  String remainingDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '还剩 $days 天',
      one: '还剩 1 天',
      zero: '今天到期',
    );
    return '$_temp0';
  }

  @override
  String get deleteDialogTitle => '删除这条事项？';

  @override
  String get deleteDialogBody => '删除后 30 天内可在最近删除恢复。';

  @override
  String get restoreDialogTitle => '恢复到当前事项？';

  @override
  String get restoreDialogBody => '恢复后会重新出现在首页和锁屏排序中。';

  @override
  String get discardDialogTitle => '放弃还没保存的修改？';

  @override
  String get discardDialogBody => '这页上的编辑内容不会被保存。';

  @override
  String get cancelAction => '取消';

  @override
  String get discardAction => '放弃修改';

  @override
  String get dueTimeDialogTitle => '选择截止时间';

  @override
  String get dueTimeSetAction => '设置时间';

  @override
  String get dueTimeClearAction => '清除时间';

  @override
  String get privacyExplainTitle => '隐私模式说明';

  @override
  String get privacyExplainBody => '隐私事项不会在锁屏预览或其他外露场景里显示原始正文。';

  @override
  String get settingsPageTitle => '设置';

  @override
  String get settingsPageHelperText => '阶段二只保留锁屏显示与隐私设置，不提前扩展通知、Pro 或系统入口。';

  @override
  String get settingsDisplayGroupTitle => '展示偏好';

  @override
  String get settingsOpenAction => '进入';

  @override
  String get settingsFallbackTitle => '降级原则';

  @override
  String get settingsFallbackBody => '任何设置异常都只能影响当前页展示，不允许阻断首页创建、历史恢复或详情页状态切换。';

  @override
  String get widgetSettingsTitle => '锁屏显示';

  @override
  String get widgetSettingsSubtitle => '在 App 内预览锁屏展示基线，阶段二不接真实 Widget 刷新。';

  @override
  String get widgetPreviewMaskPrivateTitle => '预览里隐藏隐私事项正文';

  @override
  String get widgetPreviewMaskPrivateBody => '锁屏、小组件和其他外露入口默认不泄露隐私事项正文。';

  @override
  String get widgetPreviewPrivateState => '隐私事项内容已隐藏';

  @override
  String get widgetPreviewEmptyHint => '锁屏上还没有可展示的事项';

  @override
  String get widgetPreviewFallbackHint => '当前保留最后一次有效快照';

  @override
  String widgetPreviewPrivateSummary(int itemCount) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: '已隐藏 $itemCount 条隐私事项',
      one: '已隐藏 1 条隐私事项',
      zero: '隐私内容已隐藏',
    );
    return '$_temp0';
  }

  @override
  String get widgetPreviewDefaultBody => '显示时间、状态和安全摘要。';

  @override
  String get widgetDisplayModeSingle => '单条';

  @override
  String get widgetDisplayModeList3 => '三条';

  @override
  String get widgetDisplayModeToday => '今日';

  @override
  String get widgetDisplayModePrivate => '隐私';

  @override
  String get widgetDisplayModeEmpty => '空态';

  @override
  String get widgetInstallGuideTitle => '把它加到锁屏上';

  @override
  String get widgetInstallGuideBody =>
      '请在系统锁屏编辑器里添加 Screen Note 小组件。App 这里只准备稳定快照，不承诺实时刷新。';

  @override
  String get widgetFallbackPreviewTitle => '刷新失败时保留最后有效内容';

  @override
  String get widgetPreviewSingleTitle => '完成锁屏小组件验收';

  @override
  String get widgetPreviewListItemOne => '确认三条模式的节奏';

  @override
  String get widgetPreviewListItemTwo => '导出最后一次有效快照';

  @override
  String get widgetPreviewListItemThree => '确保隐私正文不外露';

  @override
  String get widgetPreviewTodayTitle => '今天到期的事项保持可见';

  @override
  String get widgetPreviewDueToday => '今天 18:00';

  @override
  String get widgetPreviewDueYesterday => '昨天 20:00';

  @override
  String get widgetPreviewEmptyBody => '新增或恢复一条事项后，锁屏会读取下一次稳定快照。';

  @override
  String get privacySettingsTitle => '隐私设置';

  @override
  String get privacySettingsSubtitle => '只管理基础展示偏好，不引入复杂权限流程。';

  @override
  String get privacySettingsMaskTitle => '外露预览里隐藏隐私事项正文';

  @override
  String get privacySettingsMaskBody => '锁屏、小组件、通知和系统快捷入口默认不直接泄露隐私正文。';

  @override
  String get privacySettingsSafeTitle => '保守默认值';

  @override
  String get privacySettingsSafeBody => '隐私设置异常时必须维持保守默认值，而不是放宽外露展示。';
}
