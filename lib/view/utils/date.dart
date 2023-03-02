DateTime stringToDate(String date) {
  if (date.length != 10) {
    return DateTime.now();
  }
  return DateTime(int.parse(date.substring(0, 4)), int.parse(date.substring(5, 7)), int.parse(date.substring(8, 10)));
}

String dateToString(DateTime date) => dateStringToString(date.toString());

String dateStringToString(String string) => string.substring(0, 10);
