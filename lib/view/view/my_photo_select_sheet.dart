import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<int?> myPhotoSelectSheet(BuildContext context) async {
  return await showModalBottomSheet<int>(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        height: MediaQuery.of(context).size.height / 5.75,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 128.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 200.w),
                    const Text('选择图片来源', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 200.w, child: Center(child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()))),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                        child: InkWell(
                          onTap: () => Navigator.pop(context, 0),
                          child: Card(
                            child: Center(
                              child: Text('照相', style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                        child: InkWell(
                          onTap: () => Navigator.pop(context, 1),
                          child: Card(
                            child: Center(
                              child: Text('相册', style: TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
