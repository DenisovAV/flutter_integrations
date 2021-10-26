import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integrations/platform_view.dart';

import 'ffi_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  StreamSubscription? _subscription;
  static const platform = MethodChannel('integrations.gdg.dev/channel');
  static const stream = EventChannel('integrations.gdg.dev/events');

  final FFIBridge _ffiBridge = FFIBridge();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                child: PlatformWidget(),
                height: 50,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          child: const Icon(Icons.get_app),
          onPressed: _getCValue,
          heroTag: null,
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          child: const Icon(Icons.call_received),
          onPressed: _subscribe,
        ),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          child: const Icon(Icons.send),
          onPressed: _send,
        )
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _send() async {
    try {
      await platform.invokeMethod('ping', 'Text from Flutter');
    } on PlatformException catch (e) {
      print("Failed to ping: '${e.message}'.");
    }
  }

  Future<void> _getCValue() async {
    try {
      setState(() {
        _counter = _ffiBridge.getCValue();
      });
    } on PlatformException catch (e) {
      print("Failed to ping: '${e.message}'.");
    }
  }

  Future<void> _subscribe() async {
    _subscription?.cancel();
    try {
      _subscription = stream.receiveBroadcastStream().listen((event) => setState(() {
            _counter = event;
          }));
    } on PlatformException catch (e) {
      print("Failed to ping: '${e.message}'.");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
