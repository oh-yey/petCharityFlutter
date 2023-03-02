import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/address/province.dart';
import 'package:pet_charity/models/address/city.dart';
import 'package:pet_charity/models/address/area.dart';

import 'package:pet_charity/service/address_server.dart' as address_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class SelectAddressPage extends StatefulWidget {
  final Area? area;

  const SelectAddressPage({this.area, Key? key}) : super(key: key);

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  List<Province> _provinces = [];
  Province? _selectedProvince;
  List<City> _cities = [];
  City? _selectedCity;
  List<Area> _areas = [];
  Area? _selectedArea;

  @override
  void initState() {
    _initProvince();
    super.initState();
  }

  void _initProvince() async {
    _provinces = await address_server.provinces();
    _selectedProvince = _provinces.firstWhere((element) => element.id == widget.area?.belongCity?.belongProvince?.id);
    if (_provinces.isNotEmpty) {
      _selectedProvince ??= _provinces.first;
    }
    mySetState(() {});
  }

  void _initCity() async {
    _cities = await address_server.cities(provinceId: _selectedProvince?.id);
    _selectedCity = _cities.first;
    mySetState(() {});
  }

  void _initArea() async {
    _areas = await address_server.areas(cityId: _selectedCity?.id);
    _selectedArea = _areas.first;
    mySetState(() {});
  }

  @override
  Widget build(BuildContext context) => MyScaffold(title: '选择地址', body: _body());

  int _position = 0;

  Widget _body() {
    return Stepper(
      currentStep: _position,
      onStepTapped: _onStepTapped,
      onStepContinue: _onStepContinue,
      onStepCancel: _onStepCancel,
      controlsBuilder: (_, ControlsDetails details) {
        return Row(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
              ),
              onPressed: details.onStepContinue,
              child: const Icon(Icons.check, color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(isDark(context) ? 0.5 : 1),
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
              ),
              onPressed: details.onStepCancel,
              child: const Icon(Icons.keyboard_backspace, color: Colors.white),
            ),
          ],
        );
      },
      steps: [
        Step(
          title: Text('选择省', style: TextStyle(color: _textColor(0))),
          isActive: _isSelected(0),
          state: _getState(0),
          content: _buildProvinces(),
        ),
        Step(
          title: Text('选择市', style: TextStyle(color: _textColor(1))),
          isActive: _isSelected(1),
          state: _getState(1),
          content: _buildCities(),
        ),
        Step(
          title: Text('选择区', style: TextStyle(color: _textColor(2))),
          isActive: _isSelected(2),
          state: _getState(2),
          content: _buildAreas(),
        ),
      ],
    );
  }

  Color? _textColor(int index) => _isSelected(index) ? null : Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5);

  Widget _buildProvinces() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Province?>(
          value: _selectedProvince,
          elevation: 1,
          icon: const Icon(Icons.expand_more),
          items: _provinces.map(_buildProvinceItem).toList(),
          onChanged: (Province? province) => mySetState(() => _selectedProvince = province ?? _selectedProvince),
        ),
      ),
    );
  }

  DropdownMenuItem<Province> _buildProvinceItem(Province province) {
    return DropdownMenuItem<Province>(value: province, child: Text(province.province ?? ''));
  }

  Widget _buildCities() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<City?>(
          value: _selectedCity,
          elevation: 1,
          icon: const Icon(Icons.expand_more),
          items: _cities.map(_buildCityItem).toList(),
          onChanged: (City? city) => mySetState(() => _selectedCity = city ?? _selectedCity),
        ),
      ),
    );
  }

  DropdownMenuItem<City> _buildCityItem(City city) {
    return DropdownMenuItem<City>(value: city, child: Text(city.city ?? ''));
  }

  Widget _buildAreas() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Area?>(
          value: _selectedArea,
          elevation: 1,
          icon: const Icon(Icons.expand_more),
          items: _areas.map(_buildAreaItem).toList(),
          onChanged: (Area? area) => mySetState(() => _selectedArea = area ?? _selectedArea),
        ),
      ),
    );
  }

  DropdownMenuItem<Area> _buildAreaItem(Area area) {
    return DropdownMenuItem<Area>(value: area, child: Text(area.area ?? ''));
  }

  /// 上一步
  void _onStepCancel() {
    if (_position > 0) {
      mySetState(() => _position--);
    }
  }

  /// 下一步
  void _onStepContinue() {
    switch (_position) {
      case 0:
        _position = 1;
        _initCity();
        break;
      case 1:
        _position = 2;
        _initArea();
        break;
      case 2:
        Navigator.pop(context, _selectedArea);
        break;
    }
  }

  /// 直接点击时
  void _onStepTapped(index) {
    if (index < _position) {
      mySetState(() => _position = index);
    }
  }

  StepState _getState(int index) {
    if (_isSelected(index)) return StepState.editing;
    if (_position > index) return StepState.complete;
    return StepState.indexed;
  }

  bool _isSelected(int index) => _position == index;
}

Future<Area?> gotoSelectAddressPage(BuildContext context, Area? area) async {
  Map<String, dynamic>? json = area?.toJson();
  json ??= {};
  String encode = Uri.encodeComponent(jsonEncode(json));
  String path = '${Routes.selectAddress}?area=$encode';
  return await Application.router.navigateTo(context, path);
}
