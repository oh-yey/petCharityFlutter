import 'dart:math';

import 'package:flutter/material.dart';

//  自定义 密码输入框
class DonateHelpDonationPlayPasswordInputBox extends StatelessWidget {
  const DonateHelpDonationPlayPasswordInputBox(this.passwordLength, {Key? key}) : super(key: key);

  //  当前密码长度
  final int passwordLength;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DonateHelpDonationPlayPasswordInputBoxCustom(context, passwordLength));
  }
}

class DonateHelpDonationPlayPasswordInputBoxCustom extends CustomPainter {
  final BuildContext context;

  // 传入的密码，通过其长度来绘制圆点
  final int pwdLength;

  DonateHelpDonationPlayPasswordInputBoxCustom(this.context, this.pwdLength);

  //  此处Sizes是指使用该类的父布局大小
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    // 密码框画笔
    Paint rectPaint = Paint()
      ..color = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black.withOpacity(0.5)
      //  空心画笔
      ..style = PaintingStyle.stroke;

    double startX = (width - 6 * height) / 2;

    RRect r = RRect.fromLTRBR(startX, 0, startX + height * 6, height, Radius.circular(height / 16));
    // 圆角矩形的绘制
    canvas.drawRRect(r, rectPaint);
    //  画竖线 将其分成六个格子
    for (int i = 1; i < 6; i++) {
      var x = startX + height * i;
      canvas.drawLine(Offset(x, 0), Offset(x, height), rectPaint);
    }

    // 密码画笔
    Paint passwordPaint = Paint()
      ..color = Theme.of(context).textTheme.titleMedium?.color ?? Colors.black
      // 实心画笔
      ..style = PaintingStyle.fill;
    //  画实心圆
    // 半径
    var radio = height / 8;
    //  当前有几位密码，画几个实心圆
    for (int i = 0; i < pwdLength && i < 6; i++) {
      double x = startX + height * i;
      double halfHeight = height / 2;
      canvas.drawArc(
        Rect.fromLTRB(
          x + halfHeight - radio,
          halfHeight - radio,
          x + halfHeight + radio,
          halfHeight + radio,
        ),
        0,
        2 * pi,
        true,
        passwordPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
