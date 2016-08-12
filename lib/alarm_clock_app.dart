import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;
  String _notifyText;
  int _notifyTimer = 0;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.font = '16px Arimo';
    _emulator.screen.bgStyle = 'cyan';
    _emulator.screen.onTap
        .listen((pos) => _notify('tapped @ (x=${pos.x}, y=${pos.y})'));
    _emulator.screen.onSwipe.listen((dir) => _notify('swiped $dir'));
    _emulator.screen.onSwipe.listen((dir) => _emulator.speaker.setVolume(
        _emulator.speaker.getVolume() +
            (dir == SwipeDirection.UP
                ? 10
                : dir == SwipeDirection.DOWN ? -10 : 0)));
  }

  void _notify(String text) {
    _emulator.speaker.playSound('kick_drum');
    _notifyText = text;
    _notifyTimer = 500;
  }

  @override
  void update(num delta) {
    if (_notifyTimer > 0) {
      _notifyTimer -= delta;
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
