import 'package:flutter/material.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

import 'package:pet_charity/view/utils/dark.dart';

class MyShaderMask extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final List<double>? linearColors;
  static const List<double> defaultLinearColors = [1.0, 0.9, 0.8, 0.65, 0.4, 0.0];

  const MyShaderMask(this.width, this.height, {this.child, this.linearColors, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isDark(context)) {
      return SizedBox(width: width, height: height, child: _buildChild());
    }
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: (linearColors ?? defaultLinearColors).map((e) => Color.fromRGBO(0, 0, 0, e)).toList(),
        ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
      },
      blendMode: BlendMode.dstIn,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colours.gradient1, Colours.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        width: width,
        height: height,
        child: _buildChild(),
      ),
    );
  }

  SafeArea? _buildChild() => child != null ? SafeArea(bottom: false, child: child!) : null;
}
