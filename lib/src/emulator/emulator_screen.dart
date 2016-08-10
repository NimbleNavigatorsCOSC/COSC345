part of emulator;

class EmulatorScreen {
  final int width;
  final int height;
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context;

  factory EmulatorScreen(Element parentElem, int width, int height) {
    final canvasElem = new CanvasElement(width: width, height: height);
    parentElem.append(canvasElem);
    return new EmulatorScreen._internal(canvasElem);
  }

  EmulatorScreen._internal(CanvasElement canvas)
      : _canvas = canvas,
        _context = canvas.getContext('2d'),
        width = canvas.width,
        height = canvas.height;

  void begin() {
    _context.beginPath();

    // Clear drawing area
    _context.clearRect(0, 0, width, height);
    _context.fillStyle = 'white';
    _context.strokeStyle = 'black';
    _context.fillRect(0, 0, width, height);
  }

  void drawText(String text, num x, num y,
      {String font: '20px Arial',
      String style: 'black',
      String align: 'left'}) {
    _context.font = font;
    _context.textAlign = align;
    _context.fillStyle = style;
    _context.fillText(text, x, y);
  }

  void drawTextCentered(String text, num x, num y,
      {String font: '20px Arial', String style: 'black'}) {
    drawText(text, x, y, font: font, style: style, align: 'center');
  }

  void end() {
    _context.closePath();
  }
}
