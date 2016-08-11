part of emulator;

class Emulator {
  static const int FRAMES_PER_SECOND = 30;
  static const Duration FRAME_DURATION = const Duration(
      milliseconds: Duration.MILLISECONDS_PER_SECOND ~/ FRAMES_PER_SECOND);
  static final DateFormat _timeFormat = new DateFormat('hh:mm:ss a', 'en_US');
  static final DateFormat _dateFormat = new DateFormat('EEEE, MMMM dd, yyyy', 'en_US');
  final EmulatorScreen screen;
  final EmulatorSpeaker speaker;
  final EmulatorApplication _application;
  Timer _frameTimer;

  Emulator(
      Element parentElem, int screenWidth, int screenHeight, this._application)
      : screen = new EmulatorScreen(parentElem, screenWidth, screenHeight),
        speaker = new EmulatorSpeaker();

  void start() {
    _application.init(this);
    _frameTimer = new Timer.periodic(FRAME_DURATION, (t) => this._update());
  }

  void _update() {
    _application.update();

    screen.begin();

    _application.render();

    screen.end();
  }

  void stop() {
    _frameTimer.cancel();
    _application.destroy();
  }

  String getTime() {
    return _timeFormat.format(new DateTime.now());
  }

  String getDate() {
    return _dateFormat.format(new DateTime.now());
  }
}
