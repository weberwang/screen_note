import 'package:flutter/material.dart';

import 'package:screen_note/shared/presentation/theme/screen_note_theme.dart';

/// 统一应用骨架布局，保证阶段一页面在亮暗主题下都使用一致壳层。
class ScreenNoteScaffold extends StatelessWidget {
  /// 创建统一应用骨架布局。
  const ScreenNoteScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.footer,
  });

  /// 页面标题，由调用方结合国际化资源传入。
  final Widget title;

  /// 页面主体内容，占位阶段只承载简单可编译视图。
  final Widget body;

  /// 页面右上角操作。
  final List<Widget>? actions;

  /// 页面底部补充内容。
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final ScreenNoteThemePalette palette = context.screenNotePalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            palette.backgroundTop,
            palette.backgroundBottom,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: title, actions: actions),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: body),
              if (footer != null) footer!,
            ],
          ),
        ),
      ),
    );
  }
}
