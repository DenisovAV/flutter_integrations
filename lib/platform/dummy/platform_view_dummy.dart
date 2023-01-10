import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final bool hybridComposition;

  const PlatformWidget({Key? key, required this.hybridComposition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 200,
      child: Text('Platform is not supported'),
    );
  }
}
