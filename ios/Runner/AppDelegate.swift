import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
          let settingsChannel = FlutterMethodChannel(name: "com.progressiveitservices.Shubhvite/settings",
                                                    binaryMessenger: controller.binaryMessenger)
          settingsChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "openSettings") {
              // Open the iOS settings app
              if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  result(true)
                } else {
                  result(FlutterError(code: "UNAVAILABLE",
                                      message: "Cannot open settings",
                                      details: nil))
                }
              } else {
                result(FlutterError(code: "UNAVAILABLE",
                                    message: "Invalid URL",
                                    details: nil))
              }
            } else {
              result(FlutterMethodNotImplemented)
            }
          })
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

