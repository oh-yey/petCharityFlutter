import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

class CustomChapter extends CustomPainter {
  static const Color paintColor = Colours.lilac;

  // 外圆
  final Paint _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = paintColor
    ..strokeWidth = 2.w;

  // 圆半径
  final double _radius = 150.w;

  // 文字画笔
  final TextPainter _textPainter = TextPainter(textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制圆  圆心
    canvas.drawCircle(const Offset(0, 0), _radius, _circlePaint);

    String title = '平台监管认证';

    canvas.rotate(deg2Rad(-18 * title.length + 40));
    // 绘制文字
    for (int i = 0; i < title.length; i++) {
      canvas.save(); // 保存当前画布
      canvas.translate(0, -_radius + 42.h);
      _textPainter.text = TextSpan(text: title[i], style: TextStyle(color: paintColor, fontSize: 32.sp, fontWeight: FontWeight.w100));
      _textPainter.layout();
      _textPainter.paint(canvas, Offset(-_textPainter.width / 2, -_textPainter.height / 2));
      canvas.restore(); // 画布重置,恢复到控件中心
      canvas.rotate(deg2Rad(36)); // 画布旋转，把数字和刻度对应起来
    }
  }

  // 角度转弧度
  double deg2Rad(double deg) => deg * (pi / 180);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
