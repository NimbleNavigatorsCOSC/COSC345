import 'dart:html';

import 'package:smartwatch/emulator.dart';
import 'package:smartwatch/hello_world_app.dart';

void main() {
  var emulator = new Emulator(querySelector('#hello_world'), 320, 320, new HelloWorldApp());
  emulator.start();
}
