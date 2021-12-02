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

class FLPlatformView: NSObject, FlutterPlatformView, FlutterStreamHandler  {
    private var _view: UIView
    private var _eventSink: FlutterEventSink!

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
    
    @objc
    func onClick(sender: UIButton!) {
        self._eventSink(Int.random(in: 0..<500))
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }

    func createNativeView(view _view: UIView, binaryMessenger messenger: FlutterBinaryMessenger){
        let button = UIButton()
        button.setTitle("iOS Native Button", for: .normal)
        button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        button.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(button)
        
        let channel = FlutterMethodChannel(name: "CALL_METHOD", binaryMessenger: messenger)
        let eventChannel = FlutterEventChannel(name: "CALL_EVENTS",                                                   binaryMessenger: messenger)
        
        eventChannel.setStreamHandler(self)
        
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: FlutterResult) -> Void in
          guard call.method == "CALL" else {
            result(FlutterMethodNotImplemented)
            return
          }
          result(Int.random(in: 0..<500))
        })
    }
}

