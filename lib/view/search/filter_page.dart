import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/filter/filter.dart';
import 'package:pet_charity/models/filter/filter_item.dart';
import 'package:pet_charity/models/filter/filter_result.dart';
import 'package:pet_charity/models/pet/breed.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/pet/select_breed_page.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class FilterPage extends StatefulWidget {
  final FilterResult? filterResult;

  const FilterPage(this.filterResult, {Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<Filter> _filter = [
    Filter('性别', 'sex', null, [
      FilterItem(null, '不限'),
      FilterItem(0, '公'),
      FilterItem(1, '母'),
    ]),
    Filter('种族', 'race', null, [
      FilterItem(null, '不限'),
      FilterItem(0, '猫'),
      FilterItem(1, '狗'),
    ]),
  ];
  Breed? _breed;

  @override
  void initState() {
    _filter[0].value = widget.filterResult?.sex;
    _filter[1].value = widget.filterResult?.breed?.race;
    _breed = widget.filterResult?.breed;
    mySetState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MyScaffold(title: '筛选', body: _body());

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(child: SingleChildScrollView(child: Column(children: _buildChildren()))),
        MyOkButton('提交', onTap: _submit),
      ],
    );
  }

  List<Widget> _buildChildren() {
    if (_filter[1].value != null) {
      return _filter.map((e) => _buildSelect(e)).toList()..add(_buildBreed());
    } else {
      return _filter.map((e) => _buildSelect(e)).toList();
    }
  }

  Widget _buildBreed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 48.w, right: 48.w, top: 32.h, bottom: 16.h),
          child: Text('品种', style: TextStyle(fontSize: 48.sp)),
        ),
        InkWell(
          onTap: () async {
            _breed = await gotoSelectBreedPage(context, race: _filter[1].value) ?? _breed;
            mySetState(() {});
          },
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 48.w),
            child: ListTile(title: Text(_breed?.name ?? '点击选择')),
          ),
        ),
        Divider(height: 0.25.h),
      ],
    );
  }

  Widget _buildSelect(Filter filter, {Widget? widget}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 48.w, right: 48.w, top: 32.h, bottom: 16.h),
          child: Text(filter.name, style: TextStyle(fontSize: 48.sp)),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
          child: widget ??
              Wrap(
                children: filter.items.map((item) {
                  return _FilterButton(
                    item,
                    selectedIndex: filter.value,
                    onTap: () => mySetState(() => filter.value = item.index),
                  );
                }).toList(),
              ),
        ),
        Divider(height: 0.25.h),
      ],
    );
  }

  void _submit() {
    if (_filter[1].value != null && _filter[1].value != _breed?.race) {
      BotToast.showText(text: '种族 品种冲突');
      return;
    }
    Navigator.pop(context, FilterResult(_filter[0].value, _filter[1].value != null ? _breed : null));
  }
}

class _FilterButton extends StatelessWidget {
  final FilterItem filterItem;
  final num? selectedIndex;
  final GestureTapCallback? onTap;

  const _FilterButton(this.filterItem, {this.selectedIndex, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: filterItem.index == selectedIndex ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: onTap,
        child: Ink(
          width: 380.w,
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 12.w),
          child: Text(
            filterItem.name,
            style: TextStyle(
              fontSize: 36.sp,
              color: filterItem.index == selectedIndex ? Colors.white.withOpacity(isDark(context) ? 0.5 : 1) : null,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

Future<FilterResult?> gotoFilterPage(BuildContext context, FilterResult? filterResult) async {
  Map<String, dynamic>? json = filterResult?.toJson();
  json ??= {};
  String encode = Uri.encodeComponent(jsonEncode(json));
  return await Application.router.navigateTo(context, '${Routes.filter}?filterResult=$encode');
}
