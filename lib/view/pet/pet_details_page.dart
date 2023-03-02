import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/pet/pet_images.dart';

import 'package:pet_charity/service/pet_server.dart' as pet_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/pet/pet_cover_image_card.dart';
import 'package:pet_charity/view/pet/pet_edit_page.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/image/my_image.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;

  const PetDetailsPage(this.pet, {Key? key}) : super(key: key);

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  late Pet _pet;

  @override
  void initState() {
    super.initState();
    _pet = widget.pet;
    mySetState(() {});
    _initPet();
  }

  /// 宠物数据初始化
  Future<void> _initPet() async {
    _pet = await pet_server.getPet(_pet.id ?? 0) ?? _pet;
    mySetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '宠物详情',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _editPet,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.edit)),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        PetCoverImageCard(_pet),
        // 领养描述
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: _buildPetDescriptionCard(),
        ),
        const Spacer(),
        MyOkButton('删除', onTap: _onDel, bgColor: CupertinoColors.destructiveRed.withOpacity(isDark(context) ? 0.5 : 1))
      ],
    );
  }

  // 宠物详情卡片
  Widget _buildPetDescriptionCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 48.h, bottom: 72.h),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 48.h,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                SizedBox(width: 24.w),
                Text('详情图片', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900)),
              ],
            ),
            SizedBox(height: 8.h),
            _buildAdoptImages(),
          ],
        ),
      ),
    );
  }

  // 宠物图片
  Widget _buildAdoptImages() {
    List<PetImages>? images = _pet.images;
    if (images == null || images.isEmpty == true) {
      return const SizedBox();
    }
    return SizedBox(
      height: 600.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(left: index > 0 ? 24.w : 0, right: index == images.length - 1 ? 24.w : 0),
            child: MyImage(images[index].image ?? ''),
          ),
        ),
      ),
    );
  }

  void _editPet() async {
    bool? isSuccess = await gotoPetEditPage(context, _pet);
    if (isSuccess == true) {
      _initPet();
    }
  }

  void _onDel() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('宠物删除'),
            content: const Text('删除操作不可恢复'),
            actions: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
              ),
              CupertinoButton(
                onPressed: _delPet,
                child: Text('确认', style: TextStyle(color: CupertinoColors.destructiveRed.withOpacity(isDark(context) ? 0.5 : 1))),
              ),
            ],
          );
        });
  }

  void _delPet() async {
    Navigator.pop(context);
    bool isSuccess = await pet_server.petDelete(_pet.id ?? 0);
    if (isSuccess) {
      BotToast.showText(text: '删除成功');
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      BotToast.showText(text: '领养中 无法删除');
    }
  }
}

Future<void> gotoPetDetailsPage(BuildContext context, Pet pet) async {
  String encode = Uri.encodeComponent(jsonEncode(pet.toJson()));
  await Application.router.navigateTo(context, '${Routes.petDetails}?pet=$encode');
}
