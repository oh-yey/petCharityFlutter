import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/pet/pet_list.dart';

import 'package:pet_charity/view/pet/pet_list_item_card.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/svg_picture_color.dart';

class PersonalPetView extends StatelessWidget {
  final GestureTapCallback onTap;
  final PetList? petList;

  const PersonalPetView(this.petList, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48.w),
        gradient: LinearGradient(
          colors: isDark(context) ? [Colors.black54, Colors.black87] : [Colours.gradient1, Colours.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: 1290.w,
      height: 420.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(48.w),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.only(top: 48.h, left: 32.w, right: 32.w, bottom: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/personal/宠物.svg",
                    height: 64.w,
                    colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color),
                  ),
                  SizedBox(width: 32.w),
                  Text("我的主子们", style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w700)),
                  count > 0 ? Text('（$count）', style: TextStyle(fontSize: 48.sp)) : const SizedBox(),
                ],
              ),
              Expanded(child: PetListItemCard(firstPet, color: isDark(context) ? Colors.black26 : Colors.white))
            ],
          ),
        ),
      ),
    );
  }

  num get count {
    return petList?.count ?? 0;
  }

  Pet? get firstPet {
    if (petList?.results?.isNotEmpty ?? false) {
      return petList?.results?.first;
    }
    return null;
  }
}
