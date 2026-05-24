import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

/// 启动 Flutter 应用并挂载根组件。
void main() {
  runApp(const MainApp());
}

/// 应用根组件，集中注册路由、主题与国际化代理。
class MainApp extends StatelessWidget {
  const MainApp({super.key, this.locale});

  /// 测试或设置模块指定的应用语言；为空时跟随系统语言。
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

/// 应用首页，当前只展示本地化后的应用名称。
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        // 标题从本地化资源读取，避免后续页面扩展时混入硬编码文案。
        title: Text(localizations.appTitle),
      ),
      body: Center(child: Text(localizations.appTitle)),
    );
  }
}
