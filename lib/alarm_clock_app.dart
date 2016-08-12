import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;
  String _notifyText;
  int _notifyTimer = 0;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.onTap(_onTap);
  }

  void _onTap(num x, num y) {
    _emulator.speaker.playSound('kick_drum');
    _notifyText = "tapped @ (x=$x, y=$y)";
    _notifyTimer = 30;
  }

  @override
  void update() {
    if (_notifyTimer > 0) {
      --_notifyTimer;
    }
  }

  @override
  void render() {
    _emulator.screen.drawTextCentered(_emulator.getDate(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 - 12);
    _emulator.screen.drawTextCentered(_emulator.getTime(),
        _emulator.screen.width / 2, _emulator.screen.height / 2 + 12);

    if (_notifyTimer > 0) {
      _emulator.screen
          .drawRect(0, 0, _emulator.screen.width, 20, style: 'blue');
      _emulator.screen.drawText(_notifyText, 4, 12,
          font: 'bold 12px Monospace', style: 'yellow');
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
