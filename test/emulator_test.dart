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
  void update(num delta) {
    // TODO: implement update
  }
}

void main() {
  Emulator emulator =
      new Emulator(querySelector('#emulator'), 320, 320, new TestApp());

  // TODO: implement testing for screen stuff
}
