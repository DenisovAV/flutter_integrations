import 'dummy/dummy_service.dart'
    if (dart.library.html) 'web/web_service.dart'
    if (dart.library.io) 'mobile/mobile_service.dart';

abstract class PlatformService {
  int getValue();

  Stream<int> getStream();
}

PlatformService getService() {
  return PlatformServiceImpl();
}
