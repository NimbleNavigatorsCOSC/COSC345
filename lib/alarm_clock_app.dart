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

typedef void OnItemSelectedCallback(String item);

class OptionList {
  static const _ITEMS_PER_PAGE = 6;
  final List<String> _items;
  final num _x, _y, _w, _h;
  final num _itemH;
  final OnItemSelectedCallback _onItemSelected;
  int _listOffset = 0;
  int _selectedItem = 0;

  String get selected => _items[_selectedItem];
  set selected(String item) {
    int idx = _items.indexOf(item);
    if (idx == -1) idx = 0;
    _selectedItem = idx;
  }

  OptionList(
      this._items, this._x, this._y, this._w, num h, this._onItemSelected)
      : _h = h,
        _itemH = h / _ITEMS_PER_PAGE;

  void draw(EmulatorScreen screen) {
    num y = _y;
    bool toggle = false;
    for (int i = _listOffset;
        i < _items.length && i < _listOffset + _ITEMS_PER_PAGE;
        ++i) {
      screen.drawRect(_x, y, _w, _itemH,
          colour: 'rgba(0, 0 , 0, ' + (toggle ? '0.25' : '0.125') + ')');
      screen.drawText(_items[i], _x + _w / 2, y + _itemH / 2 + 6,
          font: '16px Arimo', align: 'center');
      if (i == _selectedItem)
        screen.innerStrokeRect(_x, y, _w, _itemH,
            colour: 'blue', strokeWidth: 2);

      y += _itemH;
      toggle = !toggle;
    }
    num scrollLen = _h / (_items.length / _ITEMS_PER_PAGE).ceil();
    num scrollOffset = _listOffset / _ITEMS_PER_PAGE * scrollLen;
    screen.drawRect(_x + _w, _y + scrollOffset, 10, scrollLen,
        colour: 'rgba(0, 0, 0, 0.5)');
  }

  bool inBounds(num x, num y) {
    return x >= _x && x < _x + _w && y >= _y && y < _y + _h;
  }

  void tapped(num x, num y) {
    int hitItem = (y - _y) ~/ _itemH;
    if (_listOffset + hitItem < _items.length) {
      _selectedItem = _listOffset + hitItem;
      if (_onItemSelected != null) _onItemSelected(_items[_selectedItem]);
    }
  }

  void swiped(SwipeDirection dir) {
    if (dir == SwipeDirection.UP &&
        _listOffset + _ITEMS_PER_PAGE < _items.length) {
      _listOffset += _ITEMS_PER_PAGE;
    } else if (dir == SwipeDirection.DOWN &&
        _listOffset - _ITEMS_PER_PAGE >= 0) {
      _listOffset -= _ITEMS_PER_PAGE;
    }
  }
}

enum AlarmClockScreen {
  MAIN,
  STOPWATCH,
  CUSTOMISE,
  CUSTOMISE_TONE,
  CUSTOMISE_BACKGROUND,
  CUSTOMISE_TEXT_COLOUR,
  SET_ALARM
}

class AlarmClockApp implements EmulatorApplication {
  static const Map<String, String> _TONES = const {
    'Sony Alarm Clock': 'sony_alarm_clock',
    'Old School Alarm Clock': 'old_school_alarm_clock'
  };
  static const Map<String, String> _BACKGROUNDS = const {
    'Fireworks Fractal': 'fireworks_fractal',
    'The Void': 'the_void',
    'Galaxy': 'galaxy'
  };
  static const Map<String, String> _COLOURS = const {
    'Aqua': 'aqua',
    'Black': 'black',
    'Blue': 'blue',
    'Fuchsia': 'fuchsia',
    'Gray': 'gray',
    'Green': 'green',
    'Lime': 'lime',
    'Maroon': 'maroon',
    'Navy': 'navy',
    'Olive': 'olive',
    'Orange': 'orange',
    'Purple': 'purple',
    'Red': 'red',
    'Silver': 'silver',
    'Teal': 'teal',
    'White': 'white',
    'Yellow': 'yellow'
  };

  Emulator _emulator;
  AlarmClockScreen _currentScreen;
  Map<AlarmClockScreen, List<Button>> _screenButtons;
  Time _currentAlarm;
  int _setAlarmHour, _setAlarmMinute;
  bool _playedAlarm;
  bool _stopwatchRunning;
  num _stopwatchTime;
  String _currentTone, _currentBackground, _currentTextColour;
  OptionList _toneList, _backgroundList, _textColourList;

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
      AlarmClockScreen.STOPWATCH: [
        new Button('Return', width / 2, height - 40, width / 2, 40, () {
          _stopwatchRunning = false;
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ],
      AlarmClockScreen.CUSTOMISE: [
        new Button('Tones', width / 4, 70, width / 2, 40, () {
          _toneList.selected = _currentTone;
          _currentScreen = AlarmClockScreen.CUSTOMISE_TONE;
        }),
        new Button('Backgrounds', width / 4, 130, width / 2, 40, () {
          _backgroundList.selected = _currentBackground;
          _currentScreen = AlarmClockScreen.CUSTOMISE_BACKGROUND;
        }),
        new Button('Text Colour', width / 4, 190, width / 2, 40, () {
          _textColourList.selected = _currentTextColour;
          _currentScreen = AlarmClockScreen.CUSTOMISE_TEXT_COLOUR;
        }),
        new Button('Return', width / 2, height - 40, width / 2, 40, () {
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ],
      AlarmClockScreen.CUSTOMISE_TONE: [
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.CUSTOMISE),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentTone = _toneList.selected;
          _saveState();
          _currentScreen = AlarmClockScreen.CUSTOMISE;
        })
      ],
      AlarmClockScreen.CUSTOMISE_BACKGROUND: [
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.CUSTOMISE),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentBackground = _backgroundList.selected;
          _saveState();
          _currentScreen = AlarmClockScreen.CUSTOMISE;
        })
      ],
      AlarmClockScreen.CUSTOMISE_TEXT_COLOUR: [
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.CUSTOMISE),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentTextColour = _textColourList.selected;
          _saveState();
          _currentScreen = AlarmClockScreen.CUSTOMISE;
        })
      ],
      AlarmClockScreen.SET_ALARM: [
        new Button('+', width / 2 - 100, height / 2 - 80, 40, 40,
            () => _setAlarmHour = (_setAlarmHour + 1) % 24),
        new Button('-', width / 2 - 100, height / 2 + 40, 40, 40,
            () => _setAlarmHour = (_setAlarmHour - 1) % 24),
        new Button('+', width / 2 - 30, height / 2 - 80, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute + 1) % 60),
        new Button('-', width / 2 - 30, height / 2 + 40, 40, 40,
            () => _setAlarmMinute = (_setAlarmMinute - 1) % 60),
        new Button('Cancel', width / 2, 0, width / 2, 40,
            () => _currentScreen = AlarmClockScreen.MAIN),
        new Button('Save & Return', width / 2, height - 40, width / 2, 40, () {
          _currentAlarm = new Time(_setAlarmHour, _setAlarmMinute, 0);
          _saveState();
          _currentScreen = AlarmClockScreen.MAIN;
        })
      ]
    };

    _currentAlarm = null;
    _setAlarmHour = 0;
    _setAlarmMinute = 0;
    _playedAlarm = false;
    _stopwatchRunning = false;
    _stopwatchTime = 0;

    _toneList = new OptionList(_TONES.keys.toList(), 20, 70, width - 40,
        height - 130, (tone) => _emulator.speaker.playSound(_TONES[tone], 1));
    _currentTone = _toneList.selected;
    _backgroundList = new OptionList(
        _BACKGROUNDS.keys.toList(), 20, 70, width - 40, height - 130, null);
    _currentBackground = _backgroundList.selected;
    _textColourList = new OptionList(
        _COLOURS.keys.toList(), 20, 70, width - 40, height - 130, null);
    _currentTextColour = 'White';
    _textColourList.selected = _currentTextColour;

    _loadState();
  }

  @override
  void update(num delta) {
    if (_emulator.getTime().equalsIgnoreSeconds(_currentAlarm)) {
      if (!_playedAlarm) {
        // TODO:  dismissing it etc.
        _emulator.speaker.playSound(_TONES[_currentTone]);
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

    _emulator.screen.textColour = _COLOURS[
        _currentScreen == AlarmClockScreen.CUSTOMISE_TEXT_COLOUR
            ? _textColourList.selected
            : _currentTextColour];

    _emulator.screen.drawImage(
        _BACKGROUNDS[_currentScreen == AlarmClockScreen.CUSTOMISE_BACKGROUND
            ? _backgroundList.selected
            : _currentBackground],
        0,
        0,
        width,
        height);

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
        _emulator.screen.drawText('Customise', width / 2, 50,
            font: 'bold 36px Arimo', align: 'center');
        break;
      case AlarmClockScreen.CUSTOMISE_TONE:
        _emulator.screen.drawText('Customise Alarm Tone', width / 2, 64,
            font: 'bold 18px Arimo', align: 'center');
        _toneList.draw(_emulator.screen);
        break;
      case AlarmClockScreen.CUSTOMISE_BACKGROUND:
        _emulator.screen.drawText('Customise Background', width / 2, 64,
            font: 'bold 18px Arimo', align: 'center');
        _backgroundList.draw(_emulator.screen);
        break;
      case AlarmClockScreen.CUSTOMISE_TEXT_COLOUR:
        _emulator.screen.drawText('Customise Text Colour', width / 2, 64,
            font: 'bold 18px Arimo', align: 'center');
        _textColourList.draw(_emulator.screen);
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
    } else if (_currentScreen == AlarmClockScreen.CUSTOMISE_TONE &&
        _toneList.inBounds(e.x, e.y)) {
      _toneList.tapped(e.x, e.y);
    } else if (_currentScreen == AlarmClockScreen.CUSTOMISE_BACKGROUND &&
        _backgroundList.inBounds(e.x, e.y)) {
      _backgroundList.tapped(e.x, e.y);
    } else if (_currentScreen == AlarmClockScreen.CUSTOMISE_TEXT_COLOUR &&
        _textColourList.inBounds(e.x, e.y)) {
      _textColourList.tapped(e.x, e.y);
    }
  }

  void _onSwipe(SwipeDirection dir) {
    switch (_currentScreen) {
      case AlarmClockScreen.CUSTOMISE_TONE:
        _toneList.swiped(dir);
        break;
      case AlarmClockScreen.CUSTOMISE_BACKGROUND:
        _backgroundList.swiped(dir);
        break;
      case AlarmClockScreen.CUSTOMISE_TEXT_COLOUR:
        _textColourList.swiped(dir);
        break;
      default:
        break;
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

  void _saveState() {
    _emulator.storeData('AlarmClock', {
      'alarm': (_currentAlarm != null ? _currentAlarm.toString(false) : null),
      'alarmTone': _currentTone,
      'background': _currentBackground,
      'textColour': _currentTextColour
    });
  }

  void _loadState() {
    Map<String, dynamic> data = _emulator.retrieveData('AlarmClock');
    if (data != null) {
      if (data['alarm'] != null) _currentAlarm = Time.parse(data['alarm']);
      if (data['alarmTone'] != null) _currentTone = data['alarmTone'];
      if (data['background'] != null) _currentBackground = data['background'];
      if (data['textColour'] != null) _currentTextColour = data['textColour'];
    }
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }
}
