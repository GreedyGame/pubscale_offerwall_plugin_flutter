import AdSupport
import Flutter
import SafariServices
import UIKit

public class PubscaleOfferwallPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  var appKey: String = ""
  var uniqueId: String = ""
  var sandbox: Bool = false
  var isInitialized: Bool = false
  var viewController: UIViewController?
  var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "pubscale_offerwall_plugin", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "pubscale_offerwall_plugin/events", binaryMessenger: registrar.messenger())

    let instance = PubscaleOfferwallPlugin()
    instance.viewController = UIApplication.shared.delegate?.window??.rootViewController

    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "initializeOfferwall":
      guard let args = call.arguments as? [String: Any] else {
        result(
          FlutterError(code: "INVALID_ARGUMENTS", message: "Expected a dictionary", details: nil))
        return
      }

      guard let appKeyArg = args["app_key"] as? String, !appKeyArg.isEmpty else {
        eventSink?(["event": "offerwall_init_failed", "error": "Missing or empty appKey"])
        result(
          FlutterError(
            code: "MISSING_APP_KEY", message: "app_key is required and must be a non-empty string",
            details: nil))
        return
      }

      appKey = appKeyArg
      uniqueId = args["unique_id"] as? String ?? ""
      sandbox = args["sandbox"] as? Bool ?? false
      isInitialized = true

      print(
        "[Pubscale] Offerwall initialized with appKey: \(appKey), uniqueId: \(uniqueId), sandbox: \(sandbox)"
      )
      eventSink?(["event": "offerwall_init_success"])
      result("iOS Offerwall initialized")

    case "launchOfferwall":
      guard isInitialized else {
        eventSink?(["event": "offerwall_launch_failed", "error": "Offerwall not initialized"])
        result(
          FlutterError(code: "NOT_INITIALIZED", message: "Offerwall not initialized", details: nil))
        return
      }

      let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
      let sandboxParam = sandbox ? "true" : "false"

      guard
        let url = URL(
          string:
            "https://wow.pubscale.com?app_id=\(appKey)&user_id=\(uniqueId)&sandbox=\(sandboxParam)&idfa=\(idfa)"
        )
      else {
        eventSink?(["event": "offerwall_launch_failed", "error": "Invalid URL"])
        result(
          FlutterError(
            code: "INVALID_URL", message: "Could not construct offerwall URL", details: nil))
        return
      }

      openSafariViewController(url: url)
      result("Offerwall launched")

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func openSafariViewController(url: URL) {
    guard let viewController = self.viewController else {
      eventSink?(["event": "offerwall_launch_failed", "error": "No root view controller found"])
      print("[Pubscale] No root view controller found")
      return
    }

    let safariVC = SFSafariViewController(url: url)
    safariVC.delegate = self  // 👈 Assign delegate to capture close
    safariVC.modalPresentationStyle = .overFullScreen
    viewController.present(safariVC, animated: true, completion: nil)
    eventSink?(["event": "offerwall_showed"])
  }

  // MARK: - FlutterStreamHandler
  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    print("[Pubscale] onListen")
    self.eventSink = eventSink
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("[Pubscale] onCancel")
    self.eventSink = nil
    return nil
  }
}

// MARK: - SFSafariViewControllerDelegate
extension PubscaleOfferwallPlugin: SFSafariViewControllerDelegate {
  public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    print("[Pubscale] Safari closed")
    eventSink?(["event": "offerwall_closed"])
  }
}
