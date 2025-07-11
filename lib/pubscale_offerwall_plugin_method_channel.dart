import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pubscale_offerwall_plugin_platform_interface.dart';

/// An implementation of [PubscaleOfferwallPluginPlatform] that uses method channels.
class MethodChannelPubscaleOfferwallPlugin
    extends PubscaleOfferwallPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pubscale_offerwall_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> initializeOfferwall(
    String appKey,
    String uniqueId,
    bool sandbox,
    bool fullscreen,
  ) async {
    if (appKey.isEmpty) {
      throw ArgumentError('appKey cannot be empty');
    }
    final result = await methodChannel.invokeMethod<String?>(
      'initializeOfferwall',
      {'app_key': appKey},
    );
    return result;
  }

  @override
  Future<void> launchOfferwall() {
    final result = methodChannel.invokeMethod<void>('launchOfferwall');
    return result;
  }
}
