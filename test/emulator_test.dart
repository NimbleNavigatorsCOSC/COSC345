@TestOn('browser')
import 'dart:html';
import 'package:test/test.dart';

import 'package:smartwatch/emulator.dart';

class TestApp implements EmulatorApplication {
  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void init(Emulator emulator) {
    // TODO: implement init
  }

  @override
  void render() {
    // TODO: implement render
  }

  @override
  void update() {
    // TODO: implement update
  }
}

void main() {
  Emulator emulator =
      new Emulator(querySelector('#emulator'), 320, 320, new TestApp());

  group('getTime()', () {
    test('result is in form \'HH:MM:SS (AM|PM)\'', () {
      expect(emulator.getTime(), matches(r"^\d\d:\d\d:\d\d (?:AM|PM)$"));
    });
  });
  group('getDate()', () {
    test('result is in form \'Weekday, Month Day, Year\'', () {
      expect(
          emulator.getDate(), matches(r"^[A-z]+day, [A-z]+ \d\d?, \d\d\d\d$"));
    });
  });
  // TODO: implement testing for screen stuff
}
