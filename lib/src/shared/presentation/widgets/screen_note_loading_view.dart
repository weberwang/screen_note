import 'package:flutter/material.dart';

/// 通用加载占位视图，供阶段一骨架页面复用统一布局。
class ScreenNoteLoadingView extends StatelessWidget {
  /// 创建通用加载占位视图。
  const ScreenNoteLoadingView({super.key, this.message});

  /// 可选外部文案，避免组件内部硬编码新增用户可见文本。
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          if (message case final String text) Text(text),
        ],
      ),
    );
  }
}
