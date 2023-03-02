String calculateAge(String? data) {
  if (data == null) return '不确定';
  DateTime birth = DateTime.parse(data);
  DateTime now = DateTime.now();
  int day = now.difference(birth).inDays;
  if (day < 30) return '$day天龄';
  if (day < 700) return '${day ~/ 30}月龄';
  return '${day ~/ 365}岁龄';
}
