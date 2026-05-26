import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:screen_note/src/app/app.dart';

/// 启动应用并挂载根壳层。
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ScreenNoteApp()));
}
