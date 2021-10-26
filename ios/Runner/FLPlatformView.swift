import Flutter
import UIKit

class FLPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLPlatformView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLPlatformView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        super.init()
        createNativeView(view: _view, binaryMessenger: messenger)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, binaryMessenger messenger: FlutterBinaryMessenger){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
        
        let channel = FlutterMethodChannel(name: "integrations.gdg.dev/channel", binaryMessenger: messenger)
        
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: FlutterResult) -> Void in
          guard call.method == "ping" else {
            result(FlutterMethodNotImplemented)
            return
          }
          nativeLabel.text = call.arguments != nil ? "\(call.arguments!)" : ""
          result(nil)
        })
    }
}
