import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension ExtensionState on State {
  void mySetState(VoidCallback fn) {
    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    if (schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(fn);
      });
    } else {
      if (!mounted) return;
      setState(fn);
    }
  }
}
