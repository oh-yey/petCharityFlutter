import 'dart:math';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/adopt/pet_adopt.dart';

import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/view/my_wrap.dart';

class AdoptCard extends StatelessWidget {
  final PetAdopt adopt;

  final GestureTapCallback gotoDetails;

  const AdoptCard(this.adopt, this.gotoDetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: gotoDetails,
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            height: 468.h,
            child: Stack(
              children: [
                Positioned(left: 0, top: 0, child: _buildPetImage()),
                Positioned(left: 400.w, top: 0, right: 0, height: 420.h, child: _buildPetInformation(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    return ClipPath(
      clipper: PetImageClipper(),
      child: ClipImage(adopt.pet?.coverImage?.image ?? '', width: 450.w, height: 420.h, radius: 12, tag: adopt.pet?.coverImage?.image),
    );
  }

  Widget _buildPetInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(adopt.title ?? '', style: TextStyle(fontSize: 64.sp, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
        const Spacer(flex: 1),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Wrap(
            spacing: 24.w,
            children: [
              MyWrap(adopt.pet?.breed?.name ?? ''),
              MyWrap(adopt.pet?.breed?.variety ?? ''),
              MyWrap(adopt.pet?.sexValue ?? ''),
              MyWrap('${adopt.pet?.weight ?? "--"}kg'),
            ],
          ),
        ),
        const Spacer(flex: 2),
        Padding(
          padding: EdgeInsets.only(left: 32.w),
          child: Text(
            adopt.description ?? '',
            style: TextStyle(fontSize: 36.sp, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.625)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(flex: 2),
        Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Text(
            '领养要求： ${adopt.requirements ?? ""}',
            style: TextStyle(fontSize: 36.sp, color: Theme.of(context).textTheme.displayMedium?.color?.withOpacity(0.625)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class PetImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var p1 = Offset(size.width - 96.w, 0);
    var p2 = Offset(size.width, size.height * ((sqrt(5) - 1) / 2));
    var p3 = Offset(size.width - 72.w, size.height);

    path.lineTo(p1.dx, p1.dy);
    // 二次方贝兹曲线
    path.quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);

    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
