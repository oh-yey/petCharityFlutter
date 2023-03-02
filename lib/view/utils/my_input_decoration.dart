import 'package:flutter/material.dart';

InputDecoration myTransparentInputDecoration({String? hintText}) {
  return InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.zero,
    focusedBorder: _transparentInputBorder,
    disabledBorder: _transparentInputBorder,
    errorBorder: _transparentInputBorder,
    focusedErrorBorder: _transparentInputBorder,
    enabledBorder: _transparentInputBorder,
    border: _transparentInputBorder,
    hintText: hintText,
  );
}

InputDecoration myColorInputDecoration({String? hintText, Color color = Colors.red, EdgeInsetsGeometry? contentPadding}) {
  return InputDecoration(
    contentPadding: contentPadding,
    focusedBorder: _myColorInputBorder(color),
    disabledBorder: _myColorInputBorder(color.withOpacity(0.1)),
    errorBorder: _myColorInputBorder(color.withOpacity(0.5)),
    focusedErrorBorder: _myColorInputBorder(color.withOpacity(0.5)),
    enabledBorder: _myColorInputBorder(color.withOpacity(0.5)),
    border: _myColorInputBorder(color.withOpacity(0.5)),
    hintText: hintText,
  );
}

InputBorder _myColorInputBorder(Color color) {
  return OutlineInputBorder(borderSide: BorderSide(color: color));
}

InputBorder get _transparentInputBorder {
  return const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent));
}
