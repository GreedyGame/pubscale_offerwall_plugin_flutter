import 'package:flutter_test/flutter_test.dart';
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin.dart';
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin_platform_interface.dart';
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPubscaleOfferwallPluginPlatform
    with MockPlatformInterfaceMixin
    implements PubscaleOfferwallPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PubscaleOfferwallPluginPlatform initialPlatform = PubscaleOfferwallPluginPlatform.instance;

  test('$MethodChannelPubscaleOfferwallPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPubscaleOfferwallPlugin>());
  });

  test('getPlatformVersion', () async {
    PubscaleOfferwallPlugin pubscaleOfferwallPlugin = PubscaleOfferwallPlugin();
    MockPubscaleOfferwallPluginPlatform fakePlatform = MockPubscaleOfferwallPluginPlatform();
    PubscaleOfferwallPluginPlatform.instance = fakePlatform;

    expect(await pubscaleOfferwallPlugin.getPlatformVersion(), '42');
  });
}
