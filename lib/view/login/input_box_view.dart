import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

//  自定义 输入框
class VCodeInputBoxView extends StatelessWidget {
  final String vCode;

  const VCodeInputBoxView(this.vCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: VCodeInputBoxCustom(vCode));
  }
}

class VCodeInputBoxCustom extends CustomPainter {
  final String vCode;

  VCodeInputBoxCustom(this.vCode);

  @override
  void paint(Canvas canvas, Size size) {
    int vCodeLength = vCode.length;

    // 画笔
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double sideLength = size.height;
    double sideDistance = (size.width - sideLength * 4) / 3;

    for (int i = 0; i < 4; i++) {
      /// 绘制实心方块
      double left = (sideLength + sideDistance) * i;
      double right = (sideLength + sideDistance) * i + sideLength;
      RRect r = RRect.fromLTRBR(left, 0, right, sideLength, Radius.circular(sideLength / 8));
      canvas.drawRRect(r, paint);

      /// 绘制文字
      if (i < vCodeLength) {
        final TextPainter textPainter = TextPainter()
          ..text = TextSpan(text: vCode.substring(i, i + 1), style: TextStyle(color: Colors.black, fontSize: 96.sp, fontWeight: FontWeight.w700))
          ..textDirection = TextDirection.ltr
          ..layout();
        textPainter.paint(canvas, Offset(left + (200.h - textPainter.width) / 2, (200.h - textPainter.height) / 2));
      }
    }
    if (vCodeLength < 4) {
      // 空心
      paint.style = PaintingStyle.stroke;
      paint.color = Colors.black;
      paint.strokeWidth = 4.w;
      // 绘制当前输入边框
      RRect r = RRect.fromLTRBR(
        (sideLength + sideDistance) * vCodeLength,
        0,
        (sideLength + sideDistance) * vCodeLength + sideLength,
        sideLength,
        Radius.circular(sideLength / 8),
      );
      canvas.drawRRect(r, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
