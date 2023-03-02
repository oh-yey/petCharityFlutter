import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/common/config.dart';

import 'package:pet_charity/states/theme.dart';
import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/pet/pet_list.dart';

import 'package:pet_charity/service/user_server.dart' as user_server;
import 'package:pet_charity/service/pet_server.dart' as pet_server;

import 'package:pet_charity/view/adopt/my_adopt_list_page.dart';
import 'package:pet_charity/view/personal/personal_pet_view.dart';
import 'package:pet_charity/view/personal/personal_center_page.dart';
import 'package:pet_charity/view/pet/pet_list_page.dart';
import 'package:pet_charity/view/utils/svg_picture_color.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_shader_mask.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/view/my_photo_select_sheet.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({Key? key}) : super(key: key);

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  final String _defaultHead = 'http://${Config.ip}:${Config.port}/statics/user/head/head.png';

  User? _user;
  PetList? _petList;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    await _initUser();
    await _initPet();
    mySetState(() {});
  }

  Future<void> _initUser() async {
    User? user = await user_server.getInformationByToken();
    if (!mounted) return;
    if (user != null) {
      Provider.of<UserModel>(context, listen: false).user = user;
      _user = user;
    } else {
      Provider.of<UserModel>(context, listen: false).user = null;
      BotToast.showText(text: '登录过期，请重新登录');
    }
  }

  Future<void> _initPet() async {
    _petList = await pet_server.petList(_user?.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTop(),
        _buildPersonal(),
        PersonalPetView(_petList, _gotoPetList),
        _buildBottomInkWell("assets/personal/联系.svg", "联系我们", () {}),
        _buildBottomInkWell("assets/personal/分享.svg", "分享给好友", () {}),
        _buildBottomInkWell("assets/personal/意见.svg", "意见反馈", () {}),
        _buildBottomInkWell("assets/personal/协议.svg", "用户协议", () {}),
        _buildBottomInkWell("assets/personal/关于.svg", "关于我们", () {}),
      ],
    );
  }

  InkWell _buildBottomInkWell(String icon, String title, GestureTapCallback onTap) {
    ColorFilter? colorFilter = SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color);
    return InkWell(
      onTap: onTap,
      child: Ink(
        height: 200.h,
        width: 1290.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            SvgPicture.asset(icon, height: 72.w, colorFilter: colorFilter),
            SizedBox(width: 32.w),
            Text(title, style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w500)),
            const Spacer(),
            Icon(CupertinoIcons.forward, color: Theme.of(context).textTheme.titleMedium?.color),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return MyShaderMask(
      1290.w,
      320.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(32.w),
            onTap: _themeSetting,
            child: Consumer<ThemeModel>(
              builder: (BuildContext context, ThemeModel themeModel, _) {
                String name = '白天';
                switch (themeModel.theme) {
                  case ThemeMode.light:
                    name = '夜间';
                    break;
                  case ThemeMode.dark:
                    name = '自动';
                    break;
                  default:
                    name = '白天';
                }
                return Ink(
                  padding: EdgeInsets.all(20.w),
                  child: SvgPicture.asset('assets/personal/$name.svg',
                      height: 72.w, colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color)),
                );
              },
            ),
          ),
          SizedBox(width: 32.w),
        ],
      ),
    );
  }

  Widget _buildPersonal() {
    return Consumer<UserModel>(builder: (context, UserModel userModel, _) {
      User? user = userModel.user;
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            width: 1290.w,
            height: 280.h,
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(200.w),
                  onTap: _onTapHead,
                  child: ClipImage(
                    user?.head != null
                        ? user?.head ?? ''
                        : user?.qq != null
                            ? 'https://q1.qlogo.cn/g?b=qq&nk=' "${user?.qq ?? ''}" '&s=5'
                            : _defaultHead,
                    size: 200.w,
                  ),
                ),
                SizedBox(width: 48.w, height: 200.h),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.nickname ?? '--', style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w700)),
                      Text(user?.introduction ?? '--',
                          style: TextStyle(fontSize: 48.sp, color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5))),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: _gotoPersonalCenter,
                  child: Ink(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Text("个人信息", style: TextStyle(fontSize: 48.sp, color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.625))),
                        Icon(
                          CupertinoIcons.forward,
                          size: 60.h,
                          color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.625),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 16.h),
            // color: Colors.red,
            width: 1290.w,
            height: 280.h,
            child: Row(
              children: [
                _buildButton("粉丝", '${user?.followersCount ?? 0}', () {}),
                _buildButton("关注", '${user?.followingCount ?? 0}', () {}),
                _buildButton("收藏", '${user?.collectCount ?? 0}', () {}),
                _buildButton("发布", "0", _gotoMyAdoptList),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildButton(String title, String number, GestureTapCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(number, style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 20.h),
              Text(title, style: TextStyle(fontSize: 42.sp, color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5))),
            ],
          ),
        ),
      ),
    );
  }

  void _themeSetting() {
    if (ThemeMode.light == context.read<ThemeModel>().theme) {
      Provider.of<ThemeModel>(context, listen: false).theme = ThemeMode.dark;
    } else if (ThemeMode.dark == context.read<ThemeModel>().theme) {
      Provider.of<ThemeModel>(context, listen: false).theme = ThemeMode.system;
    } else {
      Provider.of<ThemeModel>(context, listen: false).theme = ThemeMode.light;
    }
  }

  void _onTapHead() async {
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
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '截取用户 头像图片',
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
        debugPrint(croppedFile.path);

        bool isSuccess = await user_server.upload(croppedFile.path);
        if (isSuccess) {
          _initUser();
          BotToast.showText(text: '修改成功');
        } else {
          BotToast.showText(text: '修改失败 请稍后再试');
        }
      }
    }
  }

  void _gotoPersonalCenter() async {
    bool? isUpdate = await gotoPersonalCenterPage(context);
    if (true == isUpdate) {
      _initUser();
    }
  }

  void _gotoMyAdoptList() async {
    bool? isUpdate = await gotoMyAdoptListPage(context);
    if (true == isUpdate) {
      _initUser();
    }
  }

  void _gotoPetList() => gotoPetListPage(context);
}
