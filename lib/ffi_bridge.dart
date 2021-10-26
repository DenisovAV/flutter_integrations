import 'dart:ffi';
import 'dart:io';

typedef SimpleFunction = Int8 Function();
typedef SimpleFunctionDart = int Function();

class FFIBridge {
  late SimpleFunctionDart _getCValue;

  FFIBridge() {
    final dl = Platform.isAndroid ? DynamicLibrary.open('libsimple.so') : DynamicLibrary.process();
    _getCValue = dl.lookupFunction<SimpleFunction, SimpleFunctionDart>('get_value');
  }

  int getCValue() => _getCValue();
}
