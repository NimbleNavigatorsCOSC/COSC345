import 'package:smartwatch/emulator.dart';

typedef void ButtonCallback();

class Button {
  final String _text;
  final num _x, _y, _w, _h;
  final ButtonCallback _cb;

  Button(this._text, this._x, this._y, this._w, this._h, this._cb);

  void draw(EmulatorScreen screen) {
    screen.drawRectWithInnerStroke(_x, _y, _w, _h,
        fillColour: 'rgba(0, 0, 0, 0.25)');
    screen.drawText(_text, _x + _w / 2, _y + _h / 2 + 4, align: 'center');
  }

  bool inBounds(num x, num y) {
    return x >= _x && x < _x + _w && y >= _y && y < _y + _h;
  }

  void tapped() {
    _cb();
  }
}

enum AlarmClockScreen { MAIN, STOPWATCH, CUSTOMISE, SET_ALARM }

class AlarmClockApp implements EmulatorApplication {
  Emulator _emulator;
  AlarmClockScreen _currentScreen;
  Map<AlarmClockScreen, List<Button>> _screenButtons;
  Time _currentAlarm;
  int _setAlarmHour, _setAlarmMinute;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.font = '16px Arimo';
    _emulator.screen.onTap.listen(_onTap);
    int width = _emulator.screen.width, height = _emulator.screen.height;
    _currentScreen = AlarmClockScreen.MAIN;
    _screenButtons = {
      AlarmClockScreen.MAIN: [
        new Button('Stopwatch', 0, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.STOPWATCH),
        new Button('Customise', 0, height - 40, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.CUSTOMISE),
        new Button('Set Alarm', width / 2, height - 40, width / 2, 40, () {
          if (_currentAlarm != null) {
            _setAlarmHour = _currentAlarm.hour;
            _setAlarmMinute = _currentAlarm.minute;
          } else {
            _setAlarmHour = 0;
            _setAlarmMinute = 0;
          }
          _currentScreen = AlarmClockScreen.SET_ALARM;
        })
      ],
      AlarmClockScreen.STOPWATCH: [],
      AlarmClockScreen.CUSTOMISE: [],
      AlarmClockScreen.SET_ALARM: [
        new Button('+', 60, 80, 40, 40,
            () => _setAlarmHour = (_setAlarmHour + 1) % 24),
        new Button('-', 60, height - 120, 40, 40,
            () => _setAlarmHour = (_setAlarmHour - 1) % 24),
        new Button('+', 130, 80, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute + 1) % 60),
        new Button('-', 130, height - 120, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute - 1) % 60),
        new Button('Save & Return', width - 120, 0, 120, 40, () {
          _currentAlarm = new Time(_setAlarmHour, _setAlarmMinute, 0);
          _currentScreen = AlarmClockScreen.MAIN;
        }),
        new Button('Cancel', width - 120, height - 40, 120, 40,
            () => _currentScreen = AlarmClockScreen.MAIN)
      ]
    };
  }

  @override
  void update(num delta) {}

  @override
  void render() {
    int width = _emulator.screen.width, height = _emulator.screen.height;

    switch (_currentScreen) {
      case AlarmClockScreen.MAIN:
        _emulator.screen.drawText(
            _emulator.getTime().toString(), width / 2, height / 2 + 16,
            font: 'bold 48px Arimo', align: 'center');
        _emulator.screen.drawText(
            _emulator.getDate().toString(), width / 2, height / 2 + 32,
            font: 'bold 16px Arimo', align: 'center');
        break;
      case AlarmClockScreen.STOPWATCH:
        break;
      case AlarmClockScreen.CUSTOMISE:
        break;
      case AlarmClockScreen.SET_ALARM:
        _emulator.screen.drawText(
            new Time(_setAlarmHour, _setAlarmMinute, 0).toString(false),
            width / 2,
            height / 2 + 16,
            font: 'bold 48px Arimo',
            align: 'center');
        break;
    }

    for (Button bn in _screenButtons[_currentScreen]) {
      bn.draw(_emulator.screen);
    }
  }

  void _onTap(TapEvent e) {
    for (Button bn in _screenButtons[_currentScreen]) {
      if (bn.inBounds(e.x, e.y)) {
        bn.tapped();
        break;
      }
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
