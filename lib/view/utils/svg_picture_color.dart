import 'package:flutter/material.dart';

class SvgPictureColor {
  static ColorFilter? color(Color? color, {BlendMode? colorBlendMode}) {
    return color == null ? null : ColorFilter.mode(color, colorBlendMode ?? BlendMode.srcIn);
  }
}
