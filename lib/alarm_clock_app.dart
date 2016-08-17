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
    screen.drawText(_text, _x + _w / 2, _y + _h / 2 + 8, align: 'center');
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
  static const Map<String, String> _TONES = const {
    'Sony Alarm Clock': 'sony_alarm_clock',
    'Old School Alarm Clock': 'old_school_alarm_clock'
  };
  static const int _TONES_PER_PAGE = 6;
  static const num _TONE_LIST_X = 20, _TONE_LIST_Y = 70;
  static const num _TONE_LIST_W = 280, _TONE_LIST_H = 192;
  static const num _TONE_LIST_ITEM_H = _TONE_LIST_H / _TONES_PER_PAGE;
  static final num _TONE_LIST_SCROLL_LEN =
      _TONE_LIST_H / (_TONES.length / _TONES_PER_PAGE).ceil();

  Emulator _emulator;
  AlarmClockScreen _currentScreen;
  Map<AlarmClockScreen, List<Button>> _screenButtons;
  Time _currentAlarm;
  int _setAlarmHour = 0, _setAlarmMinute = 0;
  bool _playedAlarm = false;
  bool _stopwatchRunning = false;
  num _stopwatchTime = 0;
  int _toneListOffset = 0;
  int _currentTone = 0;
  int _customiseSelectedTone = 0;

  @override
  void init(Emulator emulator) {
    _emulator = emulator;
    _emulator.screen.font = '24px Arimo';
    _emulator.screen.onTap.listen(_onTap);
    _emulator.screen.onSwipe.listen(_onSwipe);
    int width = _emulator.screen.width, height = _emulator.screen.height;
    _currentScreen = AlarmClockScreen.MAIN;
    _screenButtons = {
      AlarmClockScreen.MAIN: [
        new Button('Stopwatch', 0, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.STOPWATCH),
        new Button('Customise', 0, height - 40, width / 2, 40, () {
          _customiseSelectedTone = _currentTone;
          _currentScreen = AlarmClockScreen.CUSTOMISE;
        }),
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
      AlarmClockScreen.STOPWATCH: [
        new Button('Return', width / 2, height - 40, width / 2, 40, () {
          _stopwatchRunning = false;
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ],
      AlarmClockScreen.CUSTOMISE: [
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.MAIN),
        new Button('Backgrounds', 0, height - 40, width / 2, 40,
            () => print('Backgrounds')),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentTone = _customiseSelectedTone;
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ],
      AlarmClockScreen.SET_ALARM: [
        new Button('+', 60, 80, 40, 40,
            () => _setAlarmHour = (_setAlarmHour + 1) % 24),
        new Button('-', 60, height - 120, 40, 40,
            () => _setAlarmHour = (_setAlarmHour - 1) % 24),
        new Button('+', 130, 80, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute + 1) % 60),
        new Button('-', 130, height - 120, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute - 1) % 60),
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.MAIN),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentAlarm = new Time(_setAlarmHour, _setAlarmMinute, 0);
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ]
    };
  }

  @override
  void update(num delta) {
    if (_emulator.getTime().equals(_currentAlarm, true)) {
      if (!_playedAlarm) {
        // TODO:  dismissing it etc.
        _emulator.speaker.playSound(_TONES.values.elementAt(_currentTone));
        _playedAlarm = true;
      }
    } else if (_playedAlarm) {
      _playedAlarm = false;
    }

    if (_stopwatchRunning) {
      _stopwatchTime += delta;
    }
  }

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
        _emulator.screen.drawText('Stopwatch Mode', width / 2, height / 4 - 8,
            font: 'bold 24px Arimo', align: 'center');
        _emulator.screen.drawText(
            'Touch to Start/Stop', width / 2, height / 4 + 16,
            font: 'bold 16px Arimo', align: 'center');
        _emulator.screen.drawText(
            _formatStopwatch(_stopwatchTime), width / 2, height / 2 + 16,
            font: 'bold 48px Arimo', align: 'center');
        break;
      case AlarmClockScreen.CUSTOMISE:
        _emulator.screen.drawText('Choose a Tone For The Alarm', width / 2, 64,
            font: 'bold 18px Arimo', align: 'center');
        _drawToneList();
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

  void _drawToneList() {
    num y = _TONE_LIST_Y;
    bool toggle = false;
    for (int i = _toneListOffset;
        i < _TONES.keys.length && i < _toneListOffset + _TONES_PER_PAGE;
        ++i) {
      _emulator.screen.drawRect(
          _TONE_LIST_X, y, _TONE_LIST_W, _TONE_LIST_ITEM_H,
          colour: 'rgba(0, 0 , 0, ' + (toggle ? '0.25' : '0.125') + ')');
      _emulator.screen.drawText(_TONES.keys.elementAt(i),
          _TONE_LIST_X + _TONE_LIST_W / 2, y + _TONE_LIST_ITEM_H / 2 + 6,
          font: '16px Arimo', align: 'center');
      if (i == _customiseSelectedTone)
        _emulator.screen.innerStrokeRect(
            _TONE_LIST_X, y, _TONE_LIST_W, _TONE_LIST_ITEM_H,
            colour: 'blue', strokeWidth: 2);

      y += _TONE_LIST_ITEM_H;
      toggle = !toggle;
    }
    num scrollOffset =
        _toneListOffset / _TONES_PER_PAGE * _TONE_LIST_SCROLL_LEN;
    _emulator.screen.drawRect(_TONE_LIST_X + _TONE_LIST_W,
        _TONE_LIST_Y + scrollOffset, 10, _TONE_LIST_SCROLL_LEN,
        colour: 'rgba(0, 0, 0, 0.5)');
  }

  void _onTap(TapEvent e) {
    for (Button bn in _screenButtons[_currentScreen]) {
      if (bn.inBounds(e.x, e.y)) {
        bn.tapped();
        return;
      }
    }

    if (_currentScreen == AlarmClockScreen.STOPWATCH) {
      if (!_stopwatchRunning) {
        _stopwatchTime = 0;
        _stopwatchRunning = true;
      } else {
        _stopwatchRunning = false;
      }
    }

    if (_currentScreen == AlarmClockScreen.CUSTOMISE) {
      if (e.y >= _TONE_LIST_Y &&
          e.y < _TONE_LIST_Y + _TONE_LIST_H &&
          e.x >= _TONE_LIST_X &&
          e.x < _TONE_LIST_X + _TONE_LIST_W) {
        int hitItem = (e.y - _TONE_LIST_Y) ~/ _TONE_LIST_ITEM_H;
        if (_toneListOffset + hitItem < _TONES.length) {
          _customiseSelectedTone = _toneListOffset + hitItem;
          _emulator.speaker
              .playSound(_TONES.values.elementAt(_customiseSelectedTone), 3);
        }
      }
    }
  }

  void _onSwipe(SwipeDirection dir) {
    if (_currentScreen == AlarmClockScreen.CUSTOMISE) {
      switch (dir) {
        case SwipeDirection.UP:
          if (_toneListOffset + _TONES_PER_PAGE < _TONES.length)
            _toneListOffset += _TONES_PER_PAGE;
          break;
        case SwipeDirection.DOWN:
          if (_toneListOffset - _TONES_PER_PAGE >= 0)
            _toneListOffset -= _TONES_PER_PAGE;
          break;
        default:
          break;
      }
    }
  }

  static String _pad(int n, int w) {
    return n.toString().padLeft(w, '0');
  }

  static String _formatStopwatch(num stopwatchTime) {
    int milliseconds = stopwatchTime.toInt();
    int seconds = milliseconds ~/ 1000;
    milliseconds %= 1000;
    int minutes = seconds ~/ 60;
    seconds %= 60;
    int hours = minutes ~/ 60;
    minutes %= 60;
    return '${_pad(hours, 2)}:${_pad(minutes, 2)}:${_pad(seconds, 2)}.${_pad(milliseconds, 3)}';
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
