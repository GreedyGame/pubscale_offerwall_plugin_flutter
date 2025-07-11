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

  String offerwallState = 'nil';
  String offerwallStateText = 'nil';
  bool get isLargeScreen =>
      MediaQuery.of(context).size.width >= 1024; // Adjust threshold as needed

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _pubscaleOfferwallPlugin.offerwallEvents.listen((event) {
      setState(() {
        switch (event['event']) {
          case 'offerwall_init_success':
            offerwallState = 'initialized';
            offerwallStateText = 'Offerwall Initialized';
            break;
          case 'offerwall_init_failed':
            offerwallState = 'init_error';
            offerwallStateText =
                'Offerwall Initialization Failed. \nError: ${event['error']}';
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
          case 'offerwall_launch_failed':
            offerwallState = 'launch_error';
            offerwallStateText =
                'Offerwall Launch Failed. \nError: ${event['error']}';
            break;
        }
      });
    });

    _pubscaleOfferwallPlugin.initializeOfferwall(
      '59549523',
      'UNIQUE_ID',
      false,
      false,
    );

    setState(() {
      offerwallState = 'initializing';
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _pubscaleOfferwallPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void launchOfferwall() {
    _pubscaleOfferwallPlugin.launchOfferwall().catchError((error) {
      print('Error showing offerwall: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 30,
              ),
              child: Image.asset(
                'assets/images/pubscale_logo.png',
                width: 80,
                height: 48,
                alignment: Alignment.centerLeft,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Text(
                'Experience the Offerwall in Action',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: Color(0xFF001D21),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Test the integration flow, simulate offer completions and verify rewards in real time.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500, // closest to React Native's 450
                  color: Color(0xFF7f7f7f),
                ),
              ),
            ),
            if (offerwallState == 'initializing')
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                child: Align(
                  alignment: isLargeScreen
                      ? Alignment.centerLeft
                      : AlignmentDirectional.centerStart,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF00A910),
                    strokeWidth: 2,
                  ),
                ),
              ),
            if (offerwallState == 'init_error')
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                child: Align(
                  alignment: isLargeScreen
                      ? Alignment.centerLeft
                      : AlignmentDirectional.centerStart,
                  child: Text(
                    offerwallStateText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (offerwallState == 'initialized')
              Padding(
                padding: const EdgeInsets.only(
                  top: 24.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    launchOfferwall();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001D21),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Launch Offerwall',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(
                'assets/images/offerwall_ill.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 

 /***
  *  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1024;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (logo, headings, text same as before)
            if (offerwallState == 'initializing')
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                child: Align(
                  alignment: isLargeScreen
                      ? Alignment.centerLeft
                      : AlignmentDirectional.centerStart,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF00A910),
                    strokeWidth: 2,
                  ),
                ),
              ),
            if (offerwallState == 'init_error')
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                child: Align(
                  alignment: isLargeScreen
                      ? Alignment.centerLeft
                      : AlignmentDirectional.centerStart,
                  child: Text(
                    'Initialization Failed',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (offerwallState == 'initialized')
              Padding(
                padding: const EdgeInsets.only(
                  top: 24.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: ElevatedButton(
                  onPressed: launchOfferwall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001D21),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Launch Offerwall',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            // ... (bottom image same as before)
          ],
        ),
      ),
    );
  }
}

  */