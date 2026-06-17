import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_note/app/bootstrap/app_bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bootstrap 会切换到 edge-to-edge 系统 UI 模式', () async {
    final List<MethodCall> calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (MethodCall call) async {
          calls.add(call);
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await configureEdgeToEdgeSystemUi();

    expect(
      calls,
      contains(
        isA<MethodCall>().having(
          (MethodCall call) => call.method,
          'method',
          'SystemChrome.setEnabledSystemUIMode',
        ),
      ),
    );
  });
}
