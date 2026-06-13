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
  String get quickAddSheetHint => '真实快速添加链路会在 task-flow 模块阶段接入。';

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
  String homeQueuePlaceholder(int index) {
    return '占位事项 $index';
  }

  @override
  String get historyPlaceholderTitle => '历史中心';

  @override
  String get historyPlaceholderBody => '最近完成与最近删除会在共享启动链稳定后接入这里。';

  @override
  String get settingsPlaceholderTitle => '设置中心';

  @override
  String get settingsPlaceholderBody => '通知、隐私、展示偏好和后续权益入口会在后续模块工作中接入这里。';
}
