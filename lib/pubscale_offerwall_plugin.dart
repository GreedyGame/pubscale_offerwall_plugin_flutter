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

  /// Initializes the offerwall with the provided parameters.
  /// /// [appKey] is the application key provided by Pubscale.
  /// [uniqueId] is a unique identifier for the user or device.
  /// [sandbox] indicates whether to run in sandbox mode (for testing).
  /// [fullscreen] indicates whether to display the offerwall in fullscreen mode.
  /// Success and failure events will be emitted through the `offerwallEvents` stream.
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

  /// Launches the offerwall.
  /// This method will trigger the offerwall to be displayed.
  /// Success and failure events will be emitted through the `offerwallEvents` stream.
  /// Make sure to call `initializeOfferwall` before calling this method.
  Future<void> launchOfferwall() {
    return PubscaleOfferwallPluginPlatform.instance.launchOfferwall();
  }
}
