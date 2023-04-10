String calculateAge(String? data) {
  if (data == null) return '不确定';
  DateTime birth = DateTime.parse(data);
  DateTime now = DateTime.now();
  int day = now.difference(birth).inDays;
  if (day < 30) return '$day天龄';
  if (day < 700) return '${day ~/ 30}月龄';
  return '${day ~/ 365}岁龄';
}

String calculateHowLongTime(String? dataStr) {
  if (dataStr == null) return '不确定';
  DateTime data = DateTime.parse(dataStr);
  DateTime now = DateTime.now();
  var difference = now.difference(data);
  int day = difference.inDays;
  if (day == 0) {
    int hours = difference.inHours;
    if (hours == 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '$hours小时前';
    }
  } else if (day < 8) {
    return '$day天前';
  } else {
    return "${data.year.toString()}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
  }
}