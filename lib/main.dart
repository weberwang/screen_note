import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:screen_note/app/app.dart';
import 'package:screen_note/app/bootstrap/app_bootstrap.dart';

/// 启动应用并挂载根壳层。
void main() async {
  await bootstrap(child: const ProviderScope(child: ScreenNoteApp()));
}
