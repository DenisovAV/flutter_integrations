@JS('ClicksNamespace')
library interop;

import 'dart:async';
import 'package:js/js.dart';
import 'dart:ui' as ui;

@JS('JsInteropEvent')
class _JsInteropEvent {
  external int value;
}

@JS('JsInteropEventType')
class EventType {
  // ignore: non_constant_identifier_names
  external static String get InteropEvent;
}

typedef _ClicksManagerEventListener = void Function(_JsInteropEvent event);

@JS('JsInteropManager')
class _JsInteropManager {
  external dynamic get buttonElement;

  external int getValueFromJs();

  external void addEventListener(
      String event,
      _ClicksManagerEventListener listener,
      );

  external void removeEventListener(
      String event,
      _ClicksManagerEventListener listener,
      );
}

class _EventStreamProvider {
  final _JsInteropManager _eventTarget;
  final List<StreamController<dynamic>> _controllers = [];

  _EventStreamProvider.forTarget(this._eventTarget);

  Stream<T> forEvent<T extends _JsInteropEvent>(String eventType) {
    late StreamController<T> controller;
    void _onEventReceived(event) {
      controller.add(event as T);
    }

    final _interropted = allowInterop(_onEventReceived);

    controller = StreamController.broadcast(
      onCancel: () => _eventTarget.removeEventListener(
        eventType,
        _interropted,
      ),
      onListen: () => _eventTarget.addEventListener(
        eventType,
        _interropted,
      ),
    );

    _controllers.add(controller);

    return controller.stream;
  }

  void dispose() {
    _controllers.forEach((controller) => controller.close());
  }
}

class InteropManager {
  final _interop = _JsInteropManager();
  late Stream<int> _buttonClicked;

  InteropManager() {

    final _streamProvider = _EventStreamProvider.forTarget(_interop);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'web-button',
          (viewId) => _interop.buttonElement,
    );

    _buttonClicked = _streamProvider
        .forEvent<_JsInteropEvent>(
      'InteropEvent',
    )
        .map((event) => event.value);
  }

  int getValueFromJs() => _interop.getValueFromJs();

  Stream<int> get buttonClicked => _buttonClicked;
}
