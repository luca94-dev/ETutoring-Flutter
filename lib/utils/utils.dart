import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

String formatDate(date) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(date);
  return formatted;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

var _kEventSource = Map.fromIterable(List.generate(2, (index) => index),
    key: (item) => DateTime.utc(2020, 10, item * 5),
    value: (item) =>
        List.generate(1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({});

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);
