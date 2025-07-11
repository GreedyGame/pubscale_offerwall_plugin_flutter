import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPubscaleOfferwallPlugin platform = MethodChannelPubscaleOfferwallPlugin();
  const MethodChannel channel = MethodChannel('pubscale_offerwall_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
