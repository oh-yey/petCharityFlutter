import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/address/province.dart';
import 'package:pet_charity/models/address/city.dart';
import 'package:pet_charity/models/address/area.dart';

Future<List<Province>> provinces() async {
  Response response = await DioClient().doGet('/address/province/list');
  List<Province> results = [];
  if (response.statusCode == 200) {
    var json = response.data;
    if (json != null) {
      json.forEach((v) => results.add(Province.fromJson(v)));
    }
  }
  return results;
}

Future<List<City>> cities({num? provinceId}) async {
  Response response = await DioClient().doGet('/address/city/list?belong_province=${provinceId ?? 43}');
  List<City> results = [];
  if (response.statusCode == 200) {
    var json = response.data;
    if (json != null) {
      json.forEach((v) => results.add(City.fromJson(v)));
    }
  }
  return results;
}

Future<List<Area>> areas({num? cityId}) async {
  Response response = await DioClient().doGet('/address/area/list?belong_city=${cityId ?? 4306}');
  List<Area> results = [];
  if (response.statusCode == 200) {
    var json = response.data;
    if (json != null) {
      json.forEach((v) => results.add(Area.fromJson(v)));
    }
  }
  return results;
}
