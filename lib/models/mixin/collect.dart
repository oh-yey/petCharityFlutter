mixin Collect {
  num? collectCount;
  bool? isCollect;

  void collectFromJson(dynamic json) {
    collectCount = json['collect_count'];
    isCollect = json['is_collect'];
  }

  void collectToJson(map) {
    map['collect_count'] = collectCount;
    map['is_collect'] = isCollect;
  }
}
