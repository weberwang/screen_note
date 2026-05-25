import 'package:json_annotation/json_annotation.dart';

part 'widget_display_mode.g.dart';

/// 锁屏 Widget 展示模式。
///
/// 这里只保留阶段三约定的五种稳定模式，避免 Flutter 预览、共享快照
/// 与原生 Widget 各自发明新的分支名字。
@JsonEnum(alwaysCreate: true)
enum WidgetDisplayMode {
  @JsonValue('single')
  single,

  @JsonValue('list3')
  list3,

  @JsonValue('today')
  today,

  @JsonValue('private')
  private,

  @JsonValue('empty')
  empty,
}
