import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
  }

  @override
  void update() {
    // TODO: implement update
  }

  @override
  void render() {
    _emulator.screen.drawTextCentered(_emulator.getDate(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 - 12);
    _emulator.screen.drawTextCentered(_emulator.getTime(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 + 12);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
