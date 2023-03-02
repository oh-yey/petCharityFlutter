import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/pet/pet.dart';

import 'package:pet_charity/tools/pet/date.dart';

import 'package:pet_charity/view/view/my_wrap.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';

class PetCoverImageCard extends StatelessWidget {
  final Pet? pet;

  const PetCoverImageCard(this.pet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1290.w,
      height: 892.h,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 48.w,
            bottom: 48.h,
            right: 48.w,
            child: ClipImage(
              pet?.coverImage?.image ?? '',
              width: 1194.w,
              height: 800.h,
              radius: 12,
              tag: pet?.coverImage?.image,
            ),
          ),
          Positioned(
            bottom: 72.h,
            right: 72.w,
            child: Wrap(
              spacing: 24.w,
              children: [
                MyWrap(pet?.name ?? ''),
                MyWrap(pet?.breed?.name ?? ''),
                MyWrap(pet?.breed?.variety ?? ''),
                MyWrap('${pet?.weight ?? "--"}kg'),
                _buildPetWrapBirth(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MyWrap _buildPetWrapBirth() {
    bool sex = pet?.sex == 0;
    return MyWrap(
      '${calculateAge(pet?.birth)}-${sex ? "DD" : "MM"}',
      textColor: sex ? const Color(0xff409afa) : const Color(0xFFf47590),
      bgColor: sex ? const Color(0xFFdbecff) : const Color(0xFFffdfe0),
    );
  }
}
