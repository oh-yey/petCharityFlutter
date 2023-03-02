import 'package:flutter/material.dart';

class MyLoadingView extends StatelessWidget {
  final double size;

  const MyLoadingView({this.size = 100, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primaryContainer),
      ),
    );
  }
}
