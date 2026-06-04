import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:screen_note/core/config/app_environment.dart';

part 'app_dio.g.dart';

/// 统一创建应用级 Dio 客户端，后续所有 Retrofit 接口都应复用这里的基座配置。
@riverpod
Dio appDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: AppEnvironment.apiBaseUrl ?? '',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const <String, Object>{'Accept': 'application/json'},
    ),
  );
}
