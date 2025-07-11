import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _pubscaleOfferwallPlugin = PubscaleOfferwallPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _pubscaleOfferwallPlugin.offerwallEvents.listen((event) {
      switch (event['event']) {
        case 'offerwall_init_success':
          print('offerwall_init_success');
          break;
        case 'offerwall_init_failed':
          print('offerwall_init_failed: ${event['error']}');
          break;
        case 'offerwall_showed':
          print('offerwall_showed');
          break;
        case 'offerwall_closed':
          print('offerwall_closed');
          break;
        case 'offerwall_reward':
          print('Reward: ${event['amount']} ${event['currency']}');
          break;
        case 'offerwall_failed':
          print('offerwall_failed: ${event['error']}');
          break;
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _pubscaleOfferwallPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _pubscaleOfferwallPlugin.initializeOfferwall(
                  "your-app-key", // Replace with real values
                  "unique-user-id", // e.g., user id or device id
                  true, // sandbox mode
                  true, // fullscreen mode
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Offerwall Initialized')),
                );
              },
              child: const Text('Initialize Offerwall'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _pubscaleOfferwallPlugin.launchOfferwall();
              },
              child: const Text('Launch Offerwall'),
            ),
          ],
        ),
      ),
    );
  }
}
