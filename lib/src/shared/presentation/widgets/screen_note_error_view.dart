import 'package:flutter/material.dart';

/// 通用错误占位视图，统一承接骨架页面的异常展示。
class ScreenNoteErrorView extends StatelessWidget {
  /// 创建通用错误占位视图。
  const ScreenNoteErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  /// 由外部注入的错误文案，保证国际化文本来源可控。
  final String message;

  /// 可选重试动作，占位阶段仅提供结构不绑定具体业务。
  final VoidCallback? onRetry;

  /// 可选重试按钮文案，避免组件擅自新增硬编码文案。
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final String? effectiveRetryLabel = retryLabel;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          if (onRetry != null && effectiveRetryLabel != null)
            FilledButton(
              onPressed: onRetry,
              child: Text(effectiveRetryLabel),
            ),
        ],
      ),
    );
  }
}
