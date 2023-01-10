import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_integrations/platform/service.dart';
import 'package:flutter_integrations/platform/dummy/platform_view_dummy.dart'
    if (dart.library.html) 'package:flutter_integrations/platform/web/platform_view_web.dart'
    if (dart.library.io) 'package:flutter_integrations/platform/mobile/platform_view_mobile.dart';

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
  int _platformValue = 0;
  bool _hybridComposition = false;
  StreamSubscription? _subscription;
  final service = getService();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'UI component from platform:',
              style: style,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: PlatformWidget(
                  hybridComposition: _hybridComposition,
                ),
              ),
            ),
            Text(
              'Stream from platform:',
              style: style,
            ),
            StreamBuilder<int>(
              stream: service.getStream(),
              builder: (context, snapshot) => Text(
                '${snapshot.hasData ? snapshot.data : 'No data'}',
                style: style,
              ),
            ),
            Text(
              'Value from platform:',
              style: style,
            ),
            Text(
              '$_platformValue',
              style: style,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: _getValue,
          child: const Icon(Icons.get_app),
        ),
        const SizedBox(
          height: 10,
        ),
        if (defaultTargetPlatform == TargetPlatform.android)
          FloatingActionButton(
            onPressed: _changeComposition,
            child: const Icon(Icons.replay),
          ),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _changeComposition() {
    setState(() {
      _hybridComposition = !_hybridComposition;
    });
  }

  void _getValue() {
    final value = service.getValue();
    setState(() {
      _platformValue = value;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
