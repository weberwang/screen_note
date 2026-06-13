import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 该别名只用于把 `flutter_screenutil` 固定为项目初始化的尺寸适配基线，
/// 真实 `ScreenUtilInit` 接线必须留到 bootstrap 阶段。
typedef ScreenNoteScreenUtilContract = ScreenUtilInit;

/// 冻结共享设计视口，后续启动阶段必须按这个尺寸基线接入 `ScreenUtilInit`。
const Size screenNoteDesignSize = Size(390, 844);

