import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/pet/pet.dart';

import 'package:pet_charity/tools/pet/date.dart';

import 'package:pet_charity/view/view/image/my_image.dart';

class PetListItemCard extends StatelessWidget {
  final Pet? pet;
  final Color? color;
  final GestureTapCallback? onTap;

  const PetListItemCard(this.pet, {this.color, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: MyImage(pet?.coverImage?.image ?? '', width: 180.w, height: 180.h, fit: BoxFit.cover),
              ),
              SizedBox(width: 48.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(pet?.name ?? '', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w500)),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(pet?.sex == 0 ? 'assets/pet/男.svg' : 'assets/pet/女.svg', height: 48.w),
                        SizedBox(width: 16.w),
                        Text(
                          calculateAge(pet?.birth),
                          style: TextStyle(fontSize: 36.sp, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
