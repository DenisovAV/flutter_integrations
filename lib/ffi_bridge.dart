import 'dart:ffi';
import 'dart:io';

typedef SimpleFunction = Int16 Function();
typedef SimpleFunctionDart = int Function();

class FFIBridge {
  late SimpleFunctionDart _getRandomValue;

  FFIBridge() {
    final dl = Platform.isAndroid ? DynamicLibrary.open('librandom.so') : DynamicLibrary.process();
    _getRandomValue = dl.lookupFunction<SimpleFunction, SimpleFunctionDart>('get_value');
  }

  int getCValue() => _getRandomValue();
}
