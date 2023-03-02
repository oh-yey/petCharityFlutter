import 'package:flutter/material.dart';

extension ExtensionState on State {
  void mySetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }
}
