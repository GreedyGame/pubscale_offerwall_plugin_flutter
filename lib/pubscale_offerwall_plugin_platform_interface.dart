import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pubscale_offerwall_plugin_method_channel.dart';

abstract class PubscaleOfferwallPluginPlatform extends PlatformInterface {
  /// Constructs a PubscaleOfferwallPluginPlatform.
  PubscaleOfferwallPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static PubscaleOfferwallPluginPlatform _instance =
      MethodChannelPubscaleOfferwallPlugin();

  /// The default instance of [PubscaleOfferwallPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelPubscaleOfferwallPlugin].
  static PubscaleOfferwallPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PubscaleOfferwallPluginPlatform] when
  /// they register themselves.
  static set instance(PubscaleOfferwallPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> initializeOfferwall(
    String appKey,
    String uniqueId,
    bool sandbox,
    bool fullscreen,
  ) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> launchOfferwall() {
    throw UnimplementedError('showOfferwall() has not been implemented.');
  }
}
