part of emulator;

class Emulator {
  static const String _STORAGE_PREFIX = 'NimbleNavigatorsCOSC/SmartWatch/';
  final EmulatorScreen screen;
  final EmulatorSpeaker speaker;
  final EmulatorApplication _application;
  bool _running;
  num _lastTime;

  Emulator(
      Element parentElem, int screenWidth, int screenHeight, this._application)
      : screen = new EmulatorScreen(parentElem, screenWidth, screenHeight),
        speaker = new EmulatorSpeaker();

  void start() {
    _running = true;
    _application.init(this);
    window.animationFrame.then((num time) {
      _lastTime = time;
      _update(time);
    });
  }

  void _update(num time) {
    _application.update(time - _lastTime);

    screen.begin();

    _application.render();

    screen.end();

    _lastTime = time;

    if (_running) window.animationFrame.then(_update);
  }

  void stop() {
    _running = false;
    _application.destroy();
  }

  Time getTime() {
    DateTime dt = new DateTime.now();
    return new Time(dt.hour, dt.minute, dt.second);
  }

  Date getDate() {
    DateTime dt = new DateTime.now();
    return new Date(dt.day, dt.month, dt.year);
  }

  void storeData(String key, Map<String, dynamic> data) {
    window.localStorage[_STORAGE_PREFIX + key] = JSON.encode(data);
  }

  Map<String, dynamic> retrieveData(String key) {
    if (!window.localStorage.containsKey(_STORAGE_PREFIX + key)) return null;
    return JSON.decode(window.localStorage[_STORAGE_PREFIX + key]);
  }
}
