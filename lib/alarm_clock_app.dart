import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;
  String _notifyText;
  int _notifyTimer = 0;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
  }

  @override
  void update() {
    if (_notifyTimer > 0) {
      --_notifyTimer;
    }

    if (_emulator.screen.tapped()) {
      _notifyText =
          "tapped @ (x=${_emulator.screen.tapX}, y=${_emulator.screen.tapY})";
      _notifyTimer = 30;
    }
  }

  @override
  void render() {
    _emulator.screen.drawTextCentered(_emulator.getDate(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 - 12);
    _emulator.screen.drawTextCentered(_emulator.getTime(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 + 12);

    if (_notifyTimer > 0) {
      _emulator.screen.drawText(_notifyText, 4, 16,
          font: 'bold 12px Monospace', style: 'green');
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
