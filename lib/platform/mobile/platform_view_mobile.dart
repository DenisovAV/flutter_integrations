import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class PlatformWidget extends StatelessWidget {
  final bool hybridComposition;

  const PlatformWidget({required this.hybridComposition});

  @override
  Widget build(BuildContext context) {
    late final Widget view;
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (hybridComposition) {
        final String viewType = 'INTEGRATION_ANDROID';
        final Map<String, dynamic> creationParams = <String, dynamic>{};

        view = PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      } else {
        view = AndroidView(
          viewType: 'INTEGRATION_ANDROID',
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      view = UiKitView(
        viewType: 'INTEGRATION_IOS',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      view = Text('$defaultTargetPlatform is not yet supported');
    }
    return SizedBox(height: 50, width: 200, child: view);
  }

  void _onPlatformViewCreated(int id) {
    print('PlaformView with id:$id created');
  }
}
