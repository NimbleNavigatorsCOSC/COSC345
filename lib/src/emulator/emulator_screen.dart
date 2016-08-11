part of emulator;

class EmulatorScreen {
  static const String DEFAULT_FONT = '20px Arial';
  final int width;
  final int height;
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context;
  bool _wasTapped;
  int tapX, tapY;

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
    _canvas.onClick.listen((MouseEvent me) {
      _wasTapped = true;
      tapX = me.offset.x;
      tapY = me.offset.y;
    });
  }

  bool tapped() {
    if (_wasTapped) {
      _wasTapped = false;
      return true;
    }
    return false;
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
