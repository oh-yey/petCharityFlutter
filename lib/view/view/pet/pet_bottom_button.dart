import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/utils/svg_picture_color.dart';

class PetBottomButtonWidget extends StatelessWidget {
  final String svg;
  final String name;

  final int flex;

  final double? svgSize;
  final double? textSize;

  final Color? color;

  final GestureTapCallback? onTap;

  const PetBottomButtonWidget(this.svg, this.name, {Key? key, this.flex = 1, this.svgSize, this.color, this.textSize, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: InkWell(
        borderRadius: BorderRadius.circular(32.w),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                svg,
                height: svgSize ?? 64.h,
                colorFilter: SvgPictureColor.color(color ?? Theme.of(context).textTheme.titleMedium?.color),
              ),
              SizedBox(height: 12.h),
              Text(name, style: TextStyle(fontSize: textSize ?? 32.sp, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
