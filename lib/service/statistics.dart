import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/other/statistics_result.dart';

/// 数据统计
Future<StatisticsResult> statistics() async {
  Response response = await DioClient().doGet('/statistics');
  return StatisticsResult.fromJson(response.data);
}
