import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// 打开原生平台数据库连接，使用应用文档目录持久化 task-flow 数据。
QueryExecutor openTaskFlowDatabaseConnection() {
  return LazyDatabase(() async {
    final Directory baseDirectory = await getApplicationDocumentsDirectory();
    final File databaseFile = File(
      path.join(baseDirectory.path, 'screen_note_task_flow.sqlite'),
    );
    return NativeDatabase.createInBackground(databaseFile);
  });
}
