import 'package:flutter_integrations/platform/service.dart';

class PlatformServiceImpl implements PlatformService {
  @override
  int getValue() {
    return 10;
  }

  @override
  Stream<int> getStream() => Stream.periodic(const Duration(seconds: 3), (i) => i * 50);
}
