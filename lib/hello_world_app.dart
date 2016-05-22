import 'dart:math';

import 'package:smartwatch/emulator.dart';

class HelloWorldApp implements EmulatorApplication {
  Emulator _emulator;
  int _frameCount;
  num _x, _y;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _frameCount = 0;
  }

  @override
  void update() {
    _x = (sin(_frameCount * PI / 180.0) + 1.0) * _emulator.screen.width / 2.0;
    _y = (cos(_frameCount * PI / 180.0) + 1.0) * _emulator.screen.height / 2.0;
    _frameCount++;
  }

  @override
  void render() {
    _emulator.screen.drawTextCentered("Hello World! $_frameCount", _x, _y);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
