@TestOn('browser')
import 'package:test/test.dart';

import 'package:smartwatch/emulator.dart';

void main() {
  group('Time', () {
    test('ctor() doesn\'t accept nulls', () {
      expect(() => new Time(null, null, null), throwsArgumentError);
      expect(() => new Time(1, null, null), throwsArgumentError);
      expect(() => new Time(1, 1, null), throwsArgumentError);
      expect(() => new Time(1, 1, 1), returnsNormally);
    });
    test('hour must be >= 0 && <= 23', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Time(i, 1, 1),
            (i < 0 || i > 23) ? throwsArgumentError : returnsNormally);
      }
    });
    test('minute must be >= 0 && <= 59', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Time(1, i, 1),
            (i < 0 || i > 59) ? throwsArgumentError : returnsNormally);
      }
    });
    test('second must be >= 0 && <= 59', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Time(1, 1, i),
            (i < 0 || i > 59) ? throwsArgumentError : returnsNormally);
      }
    });
    test('toString() is in form \'HH:MM:SS (AM|PM)\'', () {
      expect(new Time(12, 15, 34).toString(), matches("12:15:34 PM"));
    });
  });
  group('Date', () {
    test('ctor() doesn\'t accept nulls', () {
      expect(() => new Date(null, null, null), throwsArgumentError);
      expect(() => new Date(1, null, null), throwsArgumentError);
      expect(() => new Date(1, 1, null), throwsArgumentError);
      expect(() => new Date(1, 1, 1), returnsNormally);
    });
    test('day must be >= 1 && <= 31', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Date(i, 1, 1),
            (i < 1 || i > 31) ? throwsArgumentError : returnsNormally);
      }
    });
    test('month must be >= 1 && <= 12', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Date(1, i, 1),
            (i < 1 || i > 12) ? throwsArgumentError : returnsNormally);
      }
    });
    test('year must be >= 0', () {
      for (int i = -100; i < 100; ++i) {
        expect(() => new Date(1, 1, i),
            (i < 0) ? throwsArgumentError : returnsNormally);
      }
    });
    test('toString() is in form \'Weekday, Month Day, Year\'', () {
      expect(
          new Date(13, 4, 1996).toString(), equals("Saturday, April 13, 1996"));
      expect(new Date(26, 11, 2019).toString(),
          equals("Tuesday, November 26, 2019"));
    });
  });
}
