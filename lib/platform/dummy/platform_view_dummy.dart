import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final bool hybridComposition;

  const PlatformWidget({required this.hybridComposition});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 200,
      child: Text('Platform is not supported'),
    );
  }
}
