import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_ruler_view.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class SelectWeightPage extends StatefulWidget {
  final double? defaultWeight;
  final String? breedName;

  const SelectWeightPage(this.defaultWeight, this.breedName, {Key? key}) : super(key: key);

  @override
  State<SelectWeightPage> createState() => _SelectWeightPageState();
}

class _SelectWeightPageState extends State<SelectWeightPage> {
  late double weight;

  @override
  void initState() {
    weight = widget.defaultWeight ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '',
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(flex: 4),
        Padding(padding: EdgeInsets.only(left: 128.w), child: Text('体重', style: TextStyle(fontSize: 128.sp))),
        const Spacer(flex: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(weight.toStringAsFixed(2), style: TextStyle(fontSize: 128.sp, fontWeight: FontWeight.w700)),
            Padding(
              padding: EdgeInsets.only(bottom: 24.sp),
              child: Text('kg', style: TextStyle(fontSize: 64.sp)),
            ),
          ],
        ),
        SizedBox(height: 32.h),
        MyRulerView(
          width: 1290.w,
          height: 300.h,
          maxValue: 30,
          minValue: 0,
          step: 0.1,
          defaultValue: weight,
          subScaleCountPerScale: 10,
          onSelectedChanged: (w) => mySetState(() => weight = w),
        ),
        const Spacer(flex: 7),
        Center(
          child: Text(
            '${widget.breedName}的正常体重范围为：',
            style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.75)),
          ),
        ),
        SizedBox(height: 24.h),
        Center(child: Text('4.5kg-7.5kg', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 52.sp))),
        const Spacer(flex: 3),
        MyOkButton('开始铲屎生涯', onTap: finish)
      ],
    );
  }

  void finish() {
    Navigator.pop(context, weight);
  }
}

Future<double?> gotoSelectWeightPage(BuildContext context, double defaultWeight, String breedName) async {
  String path = '${Routes.selectWeight}?defaultWeight=$defaultWeight&breedName=${Uri.encodeComponent(breedName)}';
  return await Application.router.navigateTo(context, path);
}
