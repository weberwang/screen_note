import 'package:intl/intl.dart';

/// 统一时间格式化工具。
abstract final class ScreenNoteDateTimeFormatter {
  /// 格式化日期时间。
  static String formatDateTime(DateTime value) {
    return DateFormat('yyyy-MM-dd HH:mm').format(value);
  }

  /// 格式化日期。
  static String formatDate(DateTime value) {
    return DateFormat('yyyy-MM-dd').format(value);
  }
}
