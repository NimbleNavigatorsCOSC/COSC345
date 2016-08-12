part of emulator;

enum SwipeDirection { UP, DOWN, LEFT, RIGHT }

class EmulatorScreen {
  static const String DEFAULT_FONT = '20px Arial';
  static const int _SWIPE_MINOR_AXIS_THRESHOLD = 40,
      _SWIPE_MAJOR_AXIS_THRESHOLD = 80,
      _TAP_THRESHOLD = 5;
  final int width;
  final int height;
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context;
  final StreamController<Point<num>> _onTapController =
      new StreamController<Point<num>>.broadcast();
  final StreamController<SwipeDirection> _onSwipeController =
      new StreamController<SwipeDirection>.broadcast();
  Point<num> _origCoord;
  Point<num> _finalCoord;

  Stream<Point<num>> get onTap => _onTapController.stream;
  Stream<SwipeDirection> get onSwipe => _onSwipeController.stream;

  factory EmulatorScreen(Element parentElem, int width, int height) {
    final canvasElem = new CanvasElement(width: width, height: height);
    parentElem.append(canvasElem);
    return new EmulatorScreen._internal(canvasElem);
  }

  EmulatorScreen._internal(CanvasElement canvas)
      : _canvas = canvas,
        _context = canvas.getContext('2d'),
        width = canvas.width,
        height = canvas.height {
    _canvas.onMouseDown.listen((me) => _origCoord = me.offset);
    _canvas.onMouseMove.listen((me) => _finalCoord = me.offset);
    _canvas.onMouseUp.listen(_mouseUp);
  }

  void _mouseUp(MouseEvent me) {
    num deltaX = _finalCoord.x - _origCoord.x;
    num deltaY = _finalCoord.y - _origCoord.y;
    SwipeDirection dir;

    if (deltaY.abs() < _SWIPE_MINOR_AXIS_THRESHOLD &&
        deltaX.abs() > _SWIPE_MAJOR_AXIS_THRESHOLD) {
      dir = deltaX.isNegative ? SwipeDirection.LEFT : SwipeDirection.RIGHT;
    } else if (deltaX.abs() < _SWIPE_MINOR_AXIS_THRESHOLD &&
        deltaY.abs() > _SWIPE_MAJOR_AXIS_THRESHOLD) {
      dir = deltaY.isNegative ? SwipeDirection.UP : SwipeDirection.DOWN;
    }

    if (dir != null) {
      _onSwipeController.add(dir);
    } else if (deltaX.abs() < _TAP_THRESHOLD && deltaY.abs() < _TAP_THRESHOLD) {
      _onTapController.add(_finalCoord);
    }
  }

  void begin() {
    _context.beginPath();

    // Clear drawing area
    _context.clearRect(0, 0, width, height);
    drawRect(0, 0, width, height, style: 'white');
  }

  void drawRect(num x, num y, num w, num h, {String style: 'black'}) {
    _context.fillStyle = style;
    _context.fillRect(x, y, w, h);
  }

  void drawText(String text, num x, num y,
      {String font: DEFAULT_FONT,
      String style: 'black',
      String align: 'left'}) {
    _context.font = font;
    _context.textAlign = align;
    _context.fillStyle = style;
    _context.fillText(text, x, y);
  }

  void drawTextCentered(String text, num x, num y,
      {String font: DEFAULT_FONT, String style: 'black'}) {
    drawText(text, x, y, font: font, style: style, align: 'center');
  }

  num textWidth(String text, {String font: DEFAULT_FONT}) {
    _context.font = font;
    return _context.measureText(text).width;
  }

  void end() {
    _context.closePath();
  }
}
