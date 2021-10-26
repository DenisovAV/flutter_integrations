import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "integrations.gdg.dev/channel",
                                                  binaryMessenger: controller.binaryMessenger)
        let eventChannel = FlutterEventChannel(name: "integrations.gdg.dev/events",                                                   binaryMessenger: controller.binaryMessenger)
        
        GeneratedPluginRegistrant.register(with: self)
        
        eventChannel.setStreamHandler(StreamHandler())

        weak var registrar = self.registrar(forPlugin: "integration-test")

        let factory = FLPlatformViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<integration-test>")!.register(
            factory,
            withId: "integrations.gdg.dev/ios")
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

class StreamHandler:NSObject, FlutterStreamHandler {
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      var count = 100
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
          if (count == 500) {
              timer.invalidate()
          }
          events(count)
          count += 50
      }
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    return nil
  }
}
