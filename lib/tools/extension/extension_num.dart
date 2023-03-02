extension ExtensionNum on num {
  String get money {
    List<String> sub = toStringAsFixed(2).split('');
    // 添加 ,
    for (int index = sub.length - 7; index >= 0; index -= 3) {
      sub[index] += ',';
    }
    return sub.join('');
  }

  String get moneySymbol {
    return '￥$money';
  }
}
