import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {

  final bool hybridComposition;

  const PlatformWidget({required this.hybridComposition});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: HtmlElementView(
        viewType: 'web-button',
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
    );
  }

  void _onPlatformViewCreated(int id) {
    print('PlaformView with id:$id created');
  }
}
