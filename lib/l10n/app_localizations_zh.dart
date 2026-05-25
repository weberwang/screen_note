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
  String get taskSaveChanges => '保存修改';

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
}
