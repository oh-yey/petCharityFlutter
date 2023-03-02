import 'package:flutter/material.dart';

class MyProgress extends StatelessWidget {
  final num total;

  final num cur;

  final double height;

  final Radius? roundedEdges;

  final Gradient? selectedGradient;

  final Gradient? unselectedGradient;

  final Color selectedColor;

  final Color unselectedColor;

  const MyProgress({
    required this.total,
    required this.cur,
    required this.height,
    this.selectedGradient,
    this.unselectedGradient,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.white,
    this.roundedEdges,
    Key? key,
  })  : assert(total > 0, "total必须大于 0"),
        assert(cur >= 0, "cur必须大于或等于 0"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _builder);
  }

  Widget _builder(BuildContext context, constraints) {
    double length = constraints.maxWidth != double.infinity ? constraints.maxWidth : 300;
    return Row(children: _buildOptimizedSteps(length));
  }

  List<Widget> _buildOptimizedSteps(double length) {
    final leftLength = length * (cur / total);
    final rightLength = length - leftLength;
    List<Widget> list = [];
    if (leftLength > 0) {
      list.add(_applyShaderMask(
        selectedGradient,
        _ProgressStep(
          color: selectedColor,
          width: leftLength,
          height: height,
          roundedEdges: roundedEdges,
          isOnlyOneStep: _isOnlyOneStep,
          isFirstStep: true,
        ),
      ));
    }
    if (rightLength > 0) {
      list.add(_applyShaderMask(
        unselectedGradient,
        _ProgressStep(
          color: unselectedColor,
          width: rightLength,
          height: height,
          roundedEdges: roundedEdges,
          isOnlyOneStep: _isOnlyOneStep,
          isLastStep: true,
        ),
      ));
    }

    return list;
  }

  bool get _isOnlyOneStep => total == cur || cur == 0;

  Widget _applyShaderMask(Gradient? gradient, Widget child) {
    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (rect) => gradient.createShader(rect),
        blendMode: BlendMode.modulate,
        child: child,
      );
    } else {
      return child;
    }
  }
}

class _ProgressStep extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final bool isFirstStep;
  final bool isLastStep;
  final bool isOnlyOneStep;
  final Radius? roundedEdges;

  const _ProgressStep({
    required this.color,
    required this.width,
    required this.height,
    this.isFirstStep = false,
    this.isLastStep = false,
    this.isOnlyOneStep = false,
    this.roundedEdges,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _shouldClip
        ? ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: _shouldClipTopLeft ? roundedEdges! : Radius.zero,
              bottomRight: _shouldClipBottomRight ? roundedEdges! : Radius.zero,
              bottomLeft: _shouldClipBottomLeft ? roundedEdges! : Radius.zero,
              topRight: _shouldClipTopRight ? roundedEdges! : Radius.zero,
            ),
            child: _buildContainer(),
          )
        : _buildContainer();
  }

  Widget _buildContainer() => Container(width: width, height: height, color: color);

  bool get _shouldClip => (isFirstStep || isLastStep || isOnlyOneStep) && roundedEdges != null;

  bool get _shouldClipTopLeft => isOnlyOneStep || isFirstStep;

  bool get _shouldClipTopRight => isOnlyOneStep || isLastStep;

  bool get _shouldClipBottomLeft => isOnlyOneStep || isFirstStep;

  bool get _shouldClipBottomRight => isOnlyOneStep || isLastStep;
}
