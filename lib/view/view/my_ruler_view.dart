import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyRulerView extends StatefulWidget {
  final double width;
  final double height;

  final int maxValue; // 最大值
  final int minValue; // 最小值
  final double defaultValue; // 默认值

  // 步数 一个刻度的值
  final double step;

  // 每个大刻度的子刻度数
  final int subScaleCountPerScale;

  // 每一刻度的宽度
  final double subScaleWidth;

  // 刻度尺选择回调
  final void Function(double) onSelectedChanged;

  // 计算总刻度数
  double get totalSubScaleCount => (maxValue - minValue) / step;

  const MyRulerView({
    required this.width,
    required this.height,
    required this.maxValue,
    required this.minValue,
    required this.step,
    this.defaultValue = 0,
    this.subScaleCountPerScale = 10,
    this.subScaleWidth = 8,
    required this.onSelectedChanged,
    Key? key,
  })  : assert(minValue <= defaultValue || defaultValue <= maxValue, '默认值 不能低于最小值 或者大于最大值'),
        assert(((maxValue - minValue) / step) % (subScaleCountPerScale) == 0, '总刻度数必须是大刻度子刻度数的倍数'),
        super(key: key);

  @override
  State<MyRulerView> createState() => _MyRulerViewState();
}

class _MyRulerViewState extends State<MyRulerView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // 初始化初始位置
    _scrollController = ScrollController(initialScrollOffset: (widget.defaultValue - widget.minValue) / widget.step * widget.subScaleWidth);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          NotificationListener(
            onNotification: _onNotification,
            child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: widget.width / 2, height: 0),
                    _build(),
                    SizedBox(width: widget.width / 2, height: 0),
                  ],
                )),
          ),
          // 指示器
          Container(width: 2, height: widget.height / 2, color: Theme.of(context).colorScheme.primaryContainer),
        ],
      ),
    );
  }

  Widget _build() {
    double width = widget.subScaleWidth * widget.totalSubScaleCount;
    return CustomPaint(
      size: Size(width, widget.height),
      painter: RulerViewPainter(
        minValue: widget.minValue,
        step: widget.step,
        subScaleWidth: widget.subScaleWidth,
        fontSize: 48.sp,
        scaleWidth: 1,
        scaleColor: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
        scaleTextColor: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
        subScaleCountPerScale: widget.subScaleCountPerScale,
      ),
    );
  }

  /// 监听刻度尺滚动通知
  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      double centerValue = widget.minValue + (notification.metrics.pixels / widget.subScaleWidth) * widget.step;
      debugPrint("----------刻度尺----------:$centerValue");
      // 选中值回调
      widget.onSelectedChanged(centerValue);
    }
    return true; //停止通知
  }
}

class RulerViewPainter extends CustomPainter {
  final int minValue;

  // 步数 一个刻度的值
  final double step;

  // 每个大刻度的子刻度数
  final int subScaleCountPerScale;

  // 每一刻度的宽度
  final double subScaleWidth;

  // 刻度尺宽度
  final double scaleWidth;

  // 刻度尺颜色
  final Color scaleColor;

  // 刻度尺文本颜色
  final Color scaleTextColor;

  // 刻度尺文本大小
  final double fontSize;

  late final Paint linePaint;

  late final TextPainter textPainter;

  RulerViewPainter({
    required this.minValue,
    required this.step,
    required this.subScaleCountPerScale,
    required this.subScaleWidth,
    required this.scaleWidth,
    required this.scaleColor,
    required this.scaleTextColor,
    required this.fontSize,
  }) {
    // 刻度尺
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = scaleWidth
      ..color = scaleColor;

    // 数字
    textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// 绘制线
    canvas.drawLine(Offset(0, scaleWidth), Offset(size.width, scaleWidth), linePaint);
    // 第几个小格子
    int index = 0;
    // 绘制竖线
    for (double x = 0; x <= size.width; x += subScaleWidth) {
      if (index % (subScaleCountPerScale) == 0) {
        linePaint.color = scaleColor;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height / 2.25), linePaint);
      } else if (index % (subScaleCountPerScale / 2) == 0) {
        linePaint.color = scaleColor.withOpacity(0.875);
        canvas.drawLine(Offset(x, 0), Offset(x, size.height / 3), linePaint);
      } else {
        linePaint.color = scaleColor.withOpacity(0.5);
        canvas.drawLine(Offset(x, 0), Offset(x, size.height / 4), linePaint);
      }
      index++;
    }

    /// 绘制数字
    canvas.save();
    // 坐标移动（0，0）点
    canvas.translate(0, 0);
    // 每个大格子的宽度
    double offsetX = subScaleWidth * subScaleCountPerScale;
    index = 0;
    // 绘制数字
    for (double x = 0; x <= size.width; x += offsetX) {
      textPainter.text =
          TextSpan(text: (minValue + index * step * subScaleCountPerScale).toStringAsFixed(1), style: TextStyle(color: scaleTextColor, fontSize: fontSize));
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, size.height - textPainter.height));
      index++;
      canvas.translate(offsetX, 0);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
