import 'package:e_tutoring/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('formatDate return a date in format string dd-MM-yyyy', () async {
    DateTime date = DateTime.parse('2021-05-28');
    expect(formatDate(date), "28-05-2021");
  });

  test('Date Format EEEE return a string day of the week', () async {
    expect(DateFormat('EEEE').format(DateTime.parse("2021-05-28")), "Friday");
  });

  test('Event class with title passed as argument', () async {
    Event event = new Event("test event");
    expect(event.title, "test event");
  });
}
