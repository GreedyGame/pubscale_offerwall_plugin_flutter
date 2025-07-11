# pubscale_offerwall_plugin

A Flutter plugin to integrate [Pubscale Offerwall SDK](https://pubscale.com) into your Android and iOS apps. This plugin enables in-app monetization through offerwalls—allowing users to earn rewards by completing offers.

---

## 🔧 Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  pubscale_offerwall_plugin: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🛠️ Platform Setup

### Android

- **Min SDK Version**  
  Ensure `minSdkVersion` is set to **21** or higher in `android/app/build.gradle`.

- **Permissions**  
  Add internet permission in `AndroidManifest.xml`:

  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```

### iOS

- **Deployment Target**  
  Set the platform version to at least **11.0** in `ios/Podfile`.

- **IDFA Permission (Optional)**  
  Add to `Info.plist`:

  ```xml
  <key>NSUserTrackingUsageDescription</key>
  <string>This identifier will be used to personalize offers.</string>
  ```

- Run:

  ```bash
  cd ios
  pod install
  ```

---

## 🚀 Usage

### 1. Import

```dart
import 'package:pubscale_offerwall_plugin/pubscale_offerwall_plugin.dart';
```

### 2. Initialize

```dart
final plugin = PubscaleOfferwallPlugin();

plugin.initializeOfferwall(
  'YOUR_APP_ID',        // from Pubscale dashboard
  'UNIQUE_USER_ID',     // user identifier
  sandbox: false,       // true for testing
  fullscreen: false,    // true for full-screen mode
);
```

### 3. Listen to Events

```dart
plugin.offerwallEvents.listen((event) {
  switch (event['event']) {
    case 'offerwall_init_success':
      print('Initialized');
      break;
    case 'offerwall_reward':
      print('Reward: ${event['amount']} ${event['currency']}');
      break;
    case 'offerwall_launch_failed':
      print('Launch failed: ${event['error']}');
      break;
  }
});
```

### 4. Launch the Offerwall

```dart
plugin.launchOfferwall();
```

---

## 📡 Event Types

| Event | Description |
|-------|-------------|
| `offerwall_init_success` | Initialization succeeded |
| `offerwall_init_failed`  | Initialization failed (with `error`) |
| `offerwall_showed`       | Offerwall launched successfully |
| `offerwall_closed`       | User closed the offerwall |
| `offerwall_reward`       | User earned a reward (amount, currency, token) |
| `offerwall_launch_failed`| Launch failed (with `error`) |

---

## 📱 Example App

You can find a working demo under the `example/` directory. Run it with:

```bash
flutter run
```

---

## 📣 About Pubscale

Pubscale provides monetization solutions via SDKs and APIs to boost app revenues through gamified experiences. Visit [pubscale.com](https://pubscale.com) for more info.

---

## 📄 License

MIT
