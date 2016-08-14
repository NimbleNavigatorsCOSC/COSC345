import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.font = '16px Arimo';
  }

  @override
  void update(num delta) {

  }

  @override
  void render() {
    int width = _emulator.screen.width, height = _emulator.screen.height;
    _emulator.screen.drawText(_emulator.getDate(), width / 2, height / 2 - 12,
        align: 'center');
    _emulator.screen.drawText(_emulator.getTime(), width / 2, height / 2 + 12,
        align: 'center');

    _emulator.screen.drawRectInnerStroke(0, height - 40, width / 2, 40);
    _emulator.screen.drawRectInnerStroke(width / 2, height - 40, width / 2, 40);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
