import 'dart:convert';

import 'package:drift/drift.dart';

/// `Map<String, Object?>` 与 JSON 字符串之间的转换器。
///
/// 这里把 metadata 固化为字符串列，保持表结构稳定，避免为阶段一骨架额外引入
/// 子表或复杂 JSON 查询约束；后续如果确实需要按字段检索，再单独演进存储方案。
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  /// 创建 JSON 映射转换器。
  const JsonMapConverter();

  @override
  Map<String, Object?> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb);
    if (decoded is Map<String, dynamic>) {
      return Map<String, Object?>.from(decoded);
    }

    return const <String, Object?>{};
  }

  @override
  String toSql(Map<String, Object?> value) {
    return jsonEncode(value);
  }
}
