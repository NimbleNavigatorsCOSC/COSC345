part of emulator;

class Emulator {
  static const int FRAMES_PER_SECOND = 30;
  static const Duration FRAME_DURATION = const Duration(
      milliseconds: Duration.MILLISECONDS_PER_SECOND ~/ FRAMES_PER_SECOND);
  final EmulatorScreen screen;
  final EmulatorApplication _application;
  Timer _frameTimer;

  Emulator(
      Element parentElem, int screenWidth, int screenHeight, this._application)
      : screen = new EmulatorScreen(parentElem, screenWidth, screenHeight);

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
}
