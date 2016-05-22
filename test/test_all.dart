import 'package:test/test.dart';

import 'hello_test.dart' as hello;
import 'emulator_test.dart' as emulator;

void main() {
  group('hello', hello.main);
  group('emulator', emulator.main);
}