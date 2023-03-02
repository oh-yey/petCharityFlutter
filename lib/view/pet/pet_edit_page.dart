import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/pet/breed.dart';
import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/pet/pet_images.dart';

import 'package:pet_charity/service/pet_server.dart' as pet_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/pet/select_breed_page.dart';
import 'package:pet_charity/view/pet/select_weight_page.dart';
import 'package:pet_charity/view/utils/date.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/image/my_image.dart';
import 'package:pet_charity/view/view/my_photo_select_sheet.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class PetEditPage extends StatefulWidget {
  final Pet? pet;
  final bool isAdd;

  const PetEditPage({this.isAdd = true, this.pet, Key? key}) : super(key: key);

  @override
  State<PetEditPage> createState() => _PetEditPageState();
}

class _PetEditPageState extends State<PetEditPage> {
  final TextEditingController _petNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late Pet _pet;
  late List<PetImages> _petImageList;

  int? _opIndex;
  Color? _delBtnColor;

  @override
  void initState() {
    if (false == widget.isAdd) {
      _pet = widget.pet ?? Pet();
    } else {
      _pet = Pet();
    }
    _pet.weight ??= 0;
    _pet.sex ??= 0;
    _pet.breed ??= Breed(race: 0);
    _pet.breed?.race ??= 0;
    _pet.visual ??= true;
    _pet.birth ??= dateToString(DateTime.now());

    _petImageList = _pet.images ?? [];
    _petNameController.text = _pet.name ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: widget.isAdd ? '宠物添加' : '宠物编辑',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _save,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.save)),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        _buildPetOtherItems(),
        _buildPetImages(),
      ],
    );
  }

  Widget _buildPetOtherItems() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildItem('宠物名称', Expanded(child: _buildPetNameInputBox()), () => _onTap('name')),
        _buildItem('体重', Text('${_pet.weight?.toStringAsFixed(2) ?? "--"}kg'), () => _onTap('weight')),
        _buildItem('性别', Text(_pet.sex == 0 ? '公' : '母'), () => _onTap('sex')),
        _buildItem('它是一只', Text(_pet.breed?.race == 0 ? '喵星人' : '汪星人'), () => _onTap('race')),
        _buildItem('品种', Text(_pet.breed?.name ?? ''), () => _onTap('breed')),
        _buildItem('是否可见', Text(_pet.visual == true ? '可见' : '不可见'), () => _onTap('visual')),
        _buildItem('出生日期', Text(_pet.birth ?? ''), () => _onTap('birth')),
      ],
    );
  }

  Widget _buildItem(String title, Widget child, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 48.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), child],
        ),
      ),
    );
  }

  // 名字输入框
  Widget _buildPetNameInputBox() {
    return TextField(
      textAlign: TextAlign.end,
      textAlignVertical: TextAlignVertical.center,
      decoration: myTransparentInputDecoration(hintText: '输入宠物名称'),
      scrollPadding: EdgeInsets.zero,
      controller: _petNameController,
      focusNode: _focusNode,
      maxLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(32)],
      textInputAction: TextInputAction.done,
      onSubmitted: (e) => loseFocus(),
    );
  }

  // 图片
  Widget _buildPetImages() {
    return GridView(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 24.h,
        crossAxisSpacing: 24.w,
        childAspectRatio: 1,
      ),
      children: _buildPetImagesChildren(),
    );
  }

  List<Widget> _buildPetImagesChildren() {
    List<Widget> items = <Widget>[];
    for (int i = 0; i < _petImageList.length; i++) {
      items.add(_buildPetImageDraggable(i));
    }
    items.add(_opIndex == null ? _buildAddInkWell() : _buildDeleteDragTarget());
    return items;
  }

  // 生成可拖动的item
  Widget _buildPetImageDraggable(int index) {
    return Draggable(
      data: index,
      maxSimultaneousDrags: 1,
      feedback: _buildPetImageDraggableChild(index, 0.75),
      onDragStarted: () {
        debugPrint('开始 $index');
        // 记录开始拖拽的数据
        mySetState(() => _opIndex = index);
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        debugPrint('取消 $index');
        // 清空标记进行重绘
        mySetState(() => _opIndex = null);
      },
      onDragCompleted: () {
        debugPrint('完成');
        mySetState(() => _opIndex = null);
      },
      child: DragTarget(
        builder: (context, candidateData, rejectedData) => _buildPetImageDraggableChild(index, 1.0),
        onWillAccept: (moveIndex) => _movePetImage(moveIndex, index),
        onAccept: (int moveIndex) {
          debugPrint('松手 $_opIndex');
          mySetState(() => _opIndex = null);
        },
      ),
    );
  }

  // 基础展示的item 此处设置width,height对GridView 无效，主要是偷懒给feedback用
  Widget _buildPetImageDraggableChild(int index, double opacity) {
    return Opacity(
      opacity: index == _opIndex ? 0.2 : opacity,
      child: MyImage(_petImageList[index].image ?? '', height: 360.h),
    );
  }

  DragTarget<int> _buildDeleteDragTarget() {
    return DragTarget(
      builder: (context, candidateData, rejectedData) => Center(child: Icon(Icons.delete, color: _delBtnColor, size: 128.h)),
      onWillAccept: (_) => true,
      onAccept: (int moveIndex) {
        debugPrint('删除');
        _petImageList.removeAt(moveIndex);
        mySetState(() => _delBtnColor = null);
      },
      onMove: (_) {
        mySetState(() => _delBtnColor = Colors.red);
      },
      onLeave: (_) {
        mySetState(() => _delBtnColor = null);
      },
    );
  }

  InkWell _buildAddInkWell() {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: _addImage,
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        width: 360.w,
        height: 360.h,
        child: Center(child: Icon(CupertinoIcons.add, size: 128.h)),
      ),
    );
  }

  /// 重新排序
  /// moveIndex 拖动的下标
  /// toIndex 目标下标
  bool _movePetImage(moveIndex, toIndex) {
    debugPrint('移动: $moveIndex --> $toIndex');
    mySetState(() {
      PetImages tmp = _petImageList[moveIndex];
      _petImageList.removeAt(moveIndex);
      _petImageList.insert(toIndex, tmp);
      // 目标变透明
      _opIndex = toIndex;
    });
    return true;
  }

  void _onTap(String key) async {
    if (key == 'name') {
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      loseFocus();
      switch (key) {
        case 'sex':
          mySetState(() => _pet.sex = _pet.sex == 0 ? 1 : 0);
          break;
        case 'weight':
          double? weight = await gotoSelectWeightPage(context, _pet.weight ?? 0, _pet.breed?.name ?? 'xx');
          mySetState(() => _pet.weight = weight ?? _pet.weight);
          break;
        case 'race':
          _pet.breed?.race = _pet.breed?.race == 0 ? 1 : 0;
          mySetState(() {});
          break;
        case 'breed':
          Breed? breed = await gotoSelectBreedPage(context, race: _pet.breed?.race);
          mySetState(() => _pet.breed = breed ?? _pet.breed);
          break;
        case 'visual':
          mySetState(() => _pet.visual = true != _pet.visual);
          break;
        case 'birth':
          _birthDateSelect();
          break;
      }
    }
  }

  // 日期选择
  void _birthDateSelect() async {
    DateTime today = DateTime.now();
    DateTime initialDateTime = stringToDate(_pet.birth ?? '');
    await showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 680.h,
          child: CupertinoDatePicker(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDateTime,
            minimumYear: today.year - 30,
            maximumDate: today,
            onDateTimeChanged: (DateTime selected) {
              mySetState(() => _pet.birth = dateToString(selected));
            },
          ),
        );
      },
    );
  }

  void loseFocus() => FocusScope.of(context).requestFocus(FocusNode());

  void _addImage() async {
    final ImagePicker picker = ImagePicker();

    int? selected = await myPhotoSelectSheet(context);
    XFile? photo;
    if (selected == 0) {
      photo = await picker.pickImage(source: ImageSource.camera);
    } else if (selected == 1) {
      photo = await picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '截取宠物图片',
            toolbarColor: Colors.orangeAccent,
            toolbarWidgetColor: Colors.blueAccent,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '截取宠物图片',
            doneButtonTitle: '裁剪',
            minimumAspectRatio: 0.1,
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            resetButtonHidden: true,
          ),
        ],
      );
      if (croppedFile != null) {
        String petName = _petNameController.text.trim();
        debugPrint(croppedFile.path);
        PetImages? image = await pet_server.imageUpload(croppedFile.path, petName: petName.length > 1 ? petName : null);
        if (image != null) {
          _petImageList.add(image);
          mySetState(() {});
          BotToast.showText(text: '上传成功');
        } else {
          BotToast.showText(text: '上传失败 请稍后再试');
        }
      }
    }
  }

  void _save() async {
    if (_verify()) {
      if (widget.isAdd) {
        bool isSuccess = await pet_server.petCreate(
          name: _petNameController.text.trim(),
          breed: _pet.breed?.id ?? 0,
          sex: _pet.sex ?? 0,
          weight: _pet.weight ?? 0,
          birth: _pet.birth ?? '',
          visual: _pet.visual ?? true,
          images: _petImageList.map((e) => e.id ?? 0).toList(),
          coverImage: _petImageList.first.id ?? 0,
        );
        if (isSuccess) {
          BotToast.showText(text: '创建成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          BotToast.showText(text: '未知错误');
        }
      } else {
        bool isSuccess = await pet_server.petUpdate(
          _pet.id ?? 0,
          name: _petNameController.text.trim(),
          breed: _pet.breed?.id ?? 0,
          sex: _pet.sex ?? 0,
          weight: _pet.weight ?? 0,
          birth: _pet.birth ?? '',
          visual: _pet.visual ?? true,
          images: _petImageList.map((e) => e.id ?? 0).toList(),
          coverImage: _petImageList.first.id ?? 0,
        );
        if (isSuccess) {
          BotToast.showText(text: '修改成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          BotToast.showText(text: '领养中 无法修改');
        }
      }
    }
  }

  /// 验证
  bool _verify() {
    if (_petNameController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_focusNode);
      BotToast.showText(text: '请输入宠物名称');
      return false;
    } else if ((_pet.weight ?? 0) <= 0) {
      BotToast.showText(text: '请修改宠物体重');
      return false;
    } else if (_pet.breed == null) {
      BotToast.showText(text: '请选择宠物品种');
      return false;
    } else if (_petImageList.length <= 1) {
      BotToast.showText(text: '请添加宠物图片');
      return false;
    } else {
      return true;
    }
  }
}

Future gotoPetEditPage(BuildContext context, Pet pet) async {
  String encode = Uri.encodeComponent(jsonEncode(pet.toJson()));
  return await Application.router.navigateTo(context, '${Routes.petEdit}?pet=$encode');
}

Future gotoPetAddPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.petAdd);
}
