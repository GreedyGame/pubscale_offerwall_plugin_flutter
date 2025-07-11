import 'pubscale_offerwall_plugin_platform_interface.dart';
import 'package:flutter/services.dart';

class PubscaleOfferwallPlugin {
  static const EventChannel _eventChannel = EventChannel(
    'pubscale_offerwall_plugin/events',
  );

  Stream<dynamic> get offerwallEvents => _eventChannel.receiveBroadcastStream();
  Future<String?> getPlatformVersion() {
    return PubscaleOfferwallPluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> initializeOfferwall(
    String appKey,
    String uniqueId,
    bool sandbox,
    bool fullscreen,
  ) {
    return PubscaleOfferwallPluginPlatform.instance.initializeOfferwall(
      appKey,
      uniqueId,
      sandbox,
      fullscreen,
    );
  }

  Future<void> launchOfferwall() {
    return PubscaleOfferwallPluginPlatform.instance.launchOfferwall();
  }
}
