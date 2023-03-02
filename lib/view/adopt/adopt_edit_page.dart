import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/adopt/pet_adopt.dart';
import 'package:pet_charity/models/pet/pet.dart';

import 'package:pet_charity/service/adopt_server.dart' as adopt_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/adopt/select_pet_page.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class AdoptEditPage extends StatefulWidget {
  final PetAdopt? adopt;
  final bool isAdd;

  const AdoptEditPage({this.isAdd = true, this.adopt, Key? key}) : super(key: key);

  @override
  State<AdoptEditPage> createState() => _AdoptEditPageState();
}

class _AdoptEditPageState extends State<AdoptEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _requirementsFocusNode = FocusNode();

  Pet? _pet;

  @override
  void initState() {
    if (false == widget.isAdd) {
      _pet = widget.adopt?.pet;
      _titleController.text = widget.adopt?.title ?? '';
      _descriptionController.text = widget.adopt?.description ?? '';
      _requirementsController.text = widget.adopt?.requirements ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: widget.isAdd ? '宠物领养添加' : '宠物领养编辑',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _save,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.save)),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(child: _buildPetOtherItems()),
        if (!widget.isAdd) MyOkButton('删除', onTap: _onDel, bgColor: CupertinoColors.destructiveRed.withOpacity(isDark(context) ? 0.5 : 1))
      ],
    );
  }

  Widget _buildPetOtherItems() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      children: [
        _buildItem('领养标题', child: _buildTitleTextField()),
        _buildItem('领养描述', onTap: () => loseFocus(null)),
        _buildTextInput('输入描述信息...', _descriptionController, _descriptionFocusNode),
        _buildItem('领养要求', onTap: () => loseFocus(null)),
        _buildTextInput('输入领养要求...', _requirementsController, _requirementsFocusNode),
        _buildItem('关联宠物', child: _buildText(_pet?.name), onTap: _selectPet),
      ],
    );
  }

  Widget _buildItem(String title, {Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 48.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), if (child != null) Expanded(child: child)],
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      scrollPadding: EdgeInsets.zero,
      textAlign: TextAlign.end,
      textAlignVertical: TextAlignVertical.center,
      decoration: myTransparentInputDecoration(hintText: '输入标题'),
      controller: _titleController,
      focusNode: _titleFocusNode,
      maxLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(32)],
      textInputAction: TextInputAction.done,
      onSubmitted: loseFocus,
    );
  }

  Widget _buildTextInput(String hintText, TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 32.h),
      child: TextField(
        scrollPadding: EdgeInsets.zero,
        decoration: myColorInputDecoration(
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
        ),
        controller: controller,
        focusNode: focusNode,
        onSubmitted: loseFocus,
        minLines: 5,
        maxLines: 10,
        showCursor: true,
      ),
    );
  }

  Widget _buildText(String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        value ?? '点击选择',
        textAlign: TextAlign.end,
        style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(value != null ? 1 : 0.5)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void loseFocus(e) => FocusScope.of(context).requestFocus(FocusNode());

  void _selectPet() async {
    _pet = await gotoSelectPetPage(context) ?? _pet;
    mySetState(() {});
  }

  void _onDel() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('宠物众筹删除'),
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
      },
    );
  }

  void _delPet() async {
    Navigator.pop(context);
    bool isSuccess = await adopt_server.adoptDelete(widget.adopt?.id ?? 0);
    if (isSuccess) {
      BotToast.showText(text: '删除成功');
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      BotToast.showText(text: '删除失败');
    }
  }

  void _save() async {
    if (_verify()) {
      if (widget.isAdd) {
        num code = await adopt_server.adoptCreate(
          petID: _pet?.id ?? 0,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          requirements: _requirementsController.text.trim(),
        );
        if (code == 200) {
          BotToast.showText(text: '创建成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else if (code == 400) {
          BotToast.showText(text: '该宠物已经有一个宠物领养');
        } else {
          BotToast.showText(text: '未知错误');
        }
      } else {
        num code = await adopt_server.adoptUpdate(
          widget.adopt?.id ?? 0,
          petID: _pet?.id ?? 0,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          requirements: _requirementsController.text.trim(),
        );
        if (code == 200) {
          BotToast.showText(text: '修改成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else if (code == 400) {
          BotToast.showText(text: '该宠物已经有一个宠物领养');
        } else {
          BotToast.showText(text: '领养中 无法修改');
        }
      }
    }
  }

  /// 验证
  bool _verify() {
    if (_titleController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
      BotToast.showText(text: '请输入领养宠物标题');
      return false;
    } else if (_descriptionController.text.trim().length < 50) {
      FocusScope.of(context).requestFocus(_descriptionFocusNode);
      BotToast.showText(text: '领养宠物描述需要大于50字！');
      return false;
    } else if (_requirementsController.text.trim().length < 20) {
      FocusScope.of(context).requestFocus(_requirementsFocusNode);
      BotToast.showText(text: '领养宠物要求需要大于20字！');
      return false;
    } else if (_pet == null) {
      BotToast.showText(text: '请选择被领养宠物');
      return false;
    } else {
      return true;
    }
  }
}

Future gotoAdoptEditPage(BuildContext context, PetAdopt adopt) async {
  String encode = Uri.encodeComponent(jsonEncode(adopt.toJson()));
  return await Application.router.navigateTo(context, '${Routes.adoptEdit}?adopt=$encode');
}

Future gotoAdoptAddPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.adoptAdd);
}
