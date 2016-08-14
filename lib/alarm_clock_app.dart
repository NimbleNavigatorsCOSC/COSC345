import 'package:smartwatch/emulator.dart';

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.font = '16px Arimo';
    _emulator.screen.onTap.listen(_onTap);
  }

  @override
  void update(num delta) {}

  @override
  void render() {
    int width = _emulator.screen.width, height = _emulator.screen.height;

    _emulator.screen.drawText(_emulator.getTime(), width / 2, height / 2 + 16,
        font: 'bold 48px Arimo', align: 'center');
    _emulator.screen.drawText(_emulator.getDate(), width / 2, height / 2 + 32,
        font: 'bold 16px Arimo', align: 'center');

    _drawButton('Stopwatch Mode', 0, 0, width / 2, 40);
    _drawButton('Customise', 0, height - 40, width / 2, 40);
    _drawButton('Set Alarm', width / 2, height - 40, width / 2, 40);
  }

  void _drawButton(String text, num x, num y, num w, num h) {
    _emulator.screen
        .drawRectWithInnerStroke(x, y, w, h, fillColour: 'rgba(0, 0, 0, 0.25)');
    _emulator.screen.drawText(text, x + w / 2, y + h / 2 + 4, align: 'center');
  }

  void _onTap(TapEvent e) {
    if (e.y < 40) {
      if (e.x < _emulator.screen.width / 2) {
        // TODO: Implement Stopwatch Mode
        print('Stopwatch Mode');
      }
    } else if (e.y > _emulator.screen.height - 40) {
      if (e.x < _emulator.screen.width / 2) {
        // TODO: Implement Customise
        print('Customise');
      } else {
        // TODO: Implement Set Alarm
        print('Set Alarm');
      }
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
