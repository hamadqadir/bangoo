import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final List<String> audioPaths;
  int currentIndex;

  final AudioPlayer _player = AudioPlayer();
  final PlayerController _waveformController = PlayerController();

  bool isLoading = false;
  bool get isPlaying => _player.playing;
  String get currentTitle => audioPaths[currentIndex].split('/').last;

  AudioPlayer get player => _player;
  PlayerController get waveformController => _waveformController;

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  AudioPlayerProvider({
    required this.audioPaths,
    required this.currentIndex,
  }) {
    _init();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _init() async {
    _player.playerStateStream.listen((state) {
      notifyListeners();
    });

    _player.positionStream.listen((position) {
      currentPosition = position;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration = duration;
        notifyListeners();
      }
    });

    await _loadTrack();
  }

  Future<void> _loadTrack() async {
    _setLoading(true);
    print("Waveform extracted: ${_waveformController.waveformData != null}");

    try {
      await _player.setFilePath(audioPaths[currentIndex]);

      // Enable waveform extraction
      await _waveformController.preparePlayer(
        path: audioPaths[currentIndex],
        shouldExtractWaveform: true,
      );

      await _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }

    _setLoading(false);
  }

  void playPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  void playNext() {
    if (currentIndex < audioPaths.length - 1) {
      currentIndex++;
      _changeTrack();
    }
  }

  void playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
      _changeTrack();
    }
  }

  void jumpTo(int index) {
    currentIndex = index;
    _changeTrack();
  }

  void _changeTrack() async {
    await _loadTrack();
  }

  void seekTo(double percent) {
    final position = totalDuration * percent;
    _player.seek(position);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    _waveformController.dispose();
    super.dispose();
  }
}
