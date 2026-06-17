import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 原生平台数据库连接，统一把任务真源落到应用沙箱目录。
QueryExecutor openTaskFlowDatabaseConnection() {
  return LazyDatabase(() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(p.join(directory.path, 'task_flow.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
