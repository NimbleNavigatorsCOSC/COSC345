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

  Future<AudioBuffer> _loadSound(String soundName) async {
    if (soundName == null) {
      throw new ArgumentError.notNull('soundName');
    }

    if (_audioBuffers.containsKey(soundName)) return _audioBuffers[soundName];

    HttpRequest request;
    try {
      request = await HttpRequest.request('assets/sound/$soundName.wav',
          responseType: 'arraybuffer');
    } catch (e) {
      throw new ArgumentError.value(
          soundName, 'soundName', 'Could not load the sound named');
    }

    AudioBuffer buffer;
    try {
      buffer = await _context.decodeAudioData(request.response);
    } catch (e) {
      throw new ArgumentError.value(
          soundName, 'soundName', 'Could not decode the sound named');
    }

    _audioBuffers[soundName] = buffer;
    return buffer;
  }

  Future playSound(String soundName, [num forDuration]) async {
    AudioBuffer buffer = await _loadSound(soundName);
    AudioBufferSourceNode source = _context.createBufferSource();
    source.connectNode(_gainNode);
    _gainNode.connectNode(_context.destination);
    source.buffer = buffer;
    source.start(0);
    if (forDuration != null) source.stop(_context.currentTime + forDuration);
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
