import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/view/my_shader_mask.dart';
import 'package:pet_charity/view/view/my_title.dart';

class MyScaffold extends StatelessWidget {
  final String title;
  final Widget? rightView;
  final Widget body;

  const MyScaffold({required this.title, this.rightView, required this.body, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyShaderMask(1290.w, 1200.h),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 1290.w,
                  height: 120.h,
                  child: MyTitle(title, rightView: rightView),
                ),
                SizedBox(height: 32.h),
                Expanded(child: body)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
