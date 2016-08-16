part of emulator;

class Time {
  static final DateFormat _format = new DateFormat('hh:mm:ss a', 'en_US');

  final int hour, minute, second;

  Time._internal(this.hour, this.minute, this.second);

  factory Time(int hour, int minute, int second) {
    if (hour == null) throw new ArgumentError.notNull('hour');
    if (hour < 0 || hour > 23)
      throw new ArgumentError.value(hour, 'hour', 'must be >= 0 && <= 23');
    if (minute == null) throw new ArgumentError.notNull('minute');
    if (minute < 0 || minute > 59)
      throw new ArgumentError.value(minute, 'minute', 'must be >= 0 && <= 59');
    if (second == null) throw new ArgumentError.notNull('second');
    if (second < 0 || second > 59)
      throw new ArgumentError.value(second, 'second', 'must be >= 0 && <= 59');

    return new Time._internal(hour, minute, second);
  }

  String toString() {
    return _format.format(new DateTime(0, 1, 1, hour, minute, second));
  }
}

class Date {
  static final DateFormat _format =
      new DateFormat('EEEE, MMMM dd, yyyy', 'en_US');

  final int day, month, year;

  Date._internal(this.day, this.month, this.year);

  factory Date(int day, int month, int year) {
    if (day == null) throw new ArgumentError.notNull('day');
    if (day < 1 || day > 31)
      throw new ArgumentError.value(day, 'day', 'must be >= 1 && <= 31');
    if (month == null) throw new ArgumentError.notNull('month');
    if (month < 1 || month > 12)
      throw new ArgumentError.value(month, 'month', 'must be >= 1 && <= 12');
    if (year == null) throw new ArgumentError.notNull('year');
    if (year < 0) throw new ArgumentError.value(year, 'year', 'must be >= 0');

    return new Date._internal(day, month, year);
  }

  String toString() {
    return _format.format(new DateTime(year, month, day));
  }
}
