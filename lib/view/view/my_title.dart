import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTitle extends StatelessWidget {
  final String title;
  final Widget? rightView;

  const MyTitle(this.title, {this.rightView, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120.w,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                child: const Center(child: Icon(Icons.arrow_back_ios_new)),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          Expanded(child: Center(child: Text(title, style: TextStyle(fontSize: 68.sp), maxLines: 1, overflow: TextOverflow.ellipsis))),
          SizedBox(
            width: 120.w,
            child: Material(
              color: Colors.transparent,
              child: rightView,
            ),
          ),
        ],
      ),
    );
  }
}
