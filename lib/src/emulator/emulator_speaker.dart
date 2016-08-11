part of emulator;

class EmulatorSpeaker {
  final AudioContext _context;
  final GainNode _gainNode;
  final Map<String, AudioBuffer> _audioBuffers = {};
  int _volume = 100;

  factory EmulatorSpeaker() {
    return new EmulatorSpeaker._internal(new AudioContext());
  }

  EmulatorSpeaker._internal(AudioContext context)
      : _context = context,
        _gainNode = context.createGain();

  void _loadSound(String sound, void cb(AudioBuffer)) {
    if (_audioBuffers.containsKey(sound)) return cb(_audioBuffers[sound]);

    HttpRequest request = new HttpRequest();
    request.open('GET', 'assets/sound/$sound.wav');
    request.responseType = 'arraybuffer';
    request.onLoad.listen((e) {
      print('Loaded sound: $sound');
      _context.decodeAudioData(request.response).then((AudioBuffer buffer) {
        if (buffer == null) {
          // TODO: better error handling
          print('Failed to decode sound: $sound');
          return;
        }

        print('Decoded sound: $sound');
        _audioBuffers[sound] = buffer;
        cb(buffer);
      });
    });
    request.onError.listen((e) {
      // TODO: better error handling
      print('Failed to load sound: $sound');
    });

    request.send();
  }

  void playSound(String sound) {
    _loadSound(sound, (AudioBuffer buffer) {
      AudioBufferSourceNode source = _context.createBufferSource();
      source.connectNode(_gainNode);
      _gainNode.connectNode(_context.destination);
      source.buffer = buffer;

      print('Playing sound: $sound');
      source.start(0);
    });
  }

  void setVolume(int volume) {
    _volume = volume < 0 ? 0 : (volume > 100 ? 100 : volume);
    num fraction = _volume / 100;
    _gainNode.gain.value = fraction * fraction;
  }

  int getVolume() {
    return _volume;
  }
}
