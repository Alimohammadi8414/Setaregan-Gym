import 'package:persian_datetime_picker/persian_datetime_picker.dart';

Jalali endDateCalculator(Jalali registerDate, int months) {
  final d = registerDate;

  int newMonth = d.month + months;
  int newYear = d.year;

  if (newMonth > 12) {
    newMonth -= 12;
    newYear += 1;
  }

  final targetMonthLength = Jalali(newYear, newMonth).monthLength;

  final isEndOfMonth = d.monthLength == d.day;

  final int newDay = isEndOfMonth
      ? targetMonthLength
      : (d.day <= targetMonthLength ? d.day : targetMonthLength);

  return Jalali(newYear, newMonth, newDay);
}
