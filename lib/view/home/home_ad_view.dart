import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/common/config.dart';

import 'package:pet_charity/view/view/image/my_image.dart';

class HomeADView extends StatefulWidget {
  const HomeADView({Key? key}) : super(key: key);

  @override
  State<HomeADView> createState() => _HomeADViewState();
}

class _HomeADViewState extends State<HomeADView> {
  final List<String> _adList = [
    'http://${Config.ip}:${Config.port}/statics/shuffling/img1.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img2.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img3.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img4.jpg',
  ];

  late ScrollController _controller;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onController);
  }

  @override
  void dispose() {
    _controller.removeListener(_onController);
    _timer?.cancel();
    super.dispose();
  }

  void _onController() {
    debugPrint(_controller.offset.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1290.w,
      height: 450.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            // onTap: () => gotoPetAdoptList(context),
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: MyImage(_adList[index], width: 1266.w, fit: BoxFit.fitHeight),
              ),
            ),
          );
        },
        itemCount: _adList.length,
      ),
    );
  }
}
