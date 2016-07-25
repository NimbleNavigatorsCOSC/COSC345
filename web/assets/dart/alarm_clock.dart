import 'dart:html';

import 'package:smartwatch/emulator.dart';
import 'package:smartwatch/alarm_clock_app.dart';


void main() {
  var emulator = new Emulator(querySelector('#alarm_clock'), 320, 320, new AlarmClockApp());
  emulator.start();
}
