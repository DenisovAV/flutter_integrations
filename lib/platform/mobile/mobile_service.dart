import 'package:flutter/services.dart';
import 'package:flutter_integrations/ffi_bridge.dart';
import 'package:flutter_integrations/platform/service.dart';

class PlatformServiceImpl implements PlatformService {
  static const stream = EventChannel('CALL_EVENTS');
  final _bridge = FFIBridge();

  @override
  int getValue() {
    try {
      return _bridge.getCValue();
    } on PlatformException catch (e) {
      print("Failed to get value: '${e.message}'.");
      return 0;
    }
  }

  @override
  Stream<int> getStream() => stream.receiveBroadcastStream().map((event) => event as int);
}
