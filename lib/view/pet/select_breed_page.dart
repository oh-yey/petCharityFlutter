import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/pet/breed.dart';

import 'package:pet_charity/service/pet_server.dart' as pet_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';

class SelectBreedPage extends StatefulWidget {
  final int race;

  const SelectBreedPage({this.race = 0, Key? key}) : super(key: key);

  @override
  State<SelectBreedPage> createState() => _SelectBreedPageState();
}

class _SelectBreedPageState extends State<SelectBreedPage> {
  bool _shouldShow = false;
  List<Breed>? _breedList;

  @override
  void initState() {
    _initBreed();
    super.initState();
  }

  Future<void> _initBreed() async {
    _breedList = await pet_server.breedList(race: widget.race);
    _shouldShow = true;
    mySetState(() {});
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
        Padding(padding: EdgeInsets.only(left: 128.w), child: Text('请选择宠物品种', style: TextStyle(fontSize: 72.sp))),
        SizedBox(height: 48.h),
        Expanded(child: _buildListView())
      ],
    );
  }

  Widget _buildListView() {
    if (!_shouldShow) {
      return MyLoadingView(size: 300.w);
    }
    return ListView.builder(itemCount: _breedList?.length ?? 0, itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    Breed breedList = _breedList![index];
    return InkWell(
      onTap: () {
        Navigator.pop(context, breedList);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        child: ListTile(
          leading: ClipImage(breedList.path ?? '', size: 172.w, fit: BoxFit.contain, bgColor: Colors.white),
          title: Text(breedList.name ?? '', style: TextStyle(fontSize: 68.sp)),
        ),
      ),
    );
  }
}

Future<Breed?> gotoSelectBreedPage(BuildContext context, {num? race}) async {
  String path = '${Routes.selectBreed}?race=${race ?? 0}';
  return await Application.router.navigateTo(context, path);
}
