import 'package:test/test.dart';

import 'emulator_test.dart' as emulator;
import 'time_test.dart' as time;

void main() {
  group('emulator', emulator.main);
  group('time', time.main);
}
