import 'package:pet_charity/models/filter/filter_item.dart';

class Filter {
  String name;
  String jsonName;
  num? value;
  List<FilterItem> items;
  Filter(this.name, this.jsonName, this.value, this.items);
}
