/// Widget 共享存储底层驱动。
///
/// Store 只关心“按键读写字符串”和“请求一次原生刷新”这三个能力，
/// 具体是 HomeWidget、UserDefaults 还是其他桥接实现，都封装在这里。
abstract interface class WidgetSnapshotStorageDriver {
  /// 读取字符串值。
  Future<String?> readString(String key);

  /// 写入字符串值。
  Future<void> writeString(String key, String value);

  /// 请求原生 Widget 刷新。
  Future<void> reloadWidget();
}
