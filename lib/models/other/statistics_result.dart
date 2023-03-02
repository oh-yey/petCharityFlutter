import 'package:pet_charity/models/abstract/data_result.dart';
import 'package:pet_charity/models/other/statistics.dart';

class StatisticsResult extends DataResult<Statistics> {
  StatisticsResult.fromJson(dynamic json) : super(json['code'], json['detail']) {
    data = json['data'] != null ? Statistics.fromJson(json['data']) : null;
  }
}
