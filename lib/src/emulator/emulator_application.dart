part of emulator;

abstract class EmulatorApplication {
  void init(Emulator emulator);

  void update(num delta);

  void render();

  void destroy();
}
