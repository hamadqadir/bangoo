import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final List<String> audioPaths;
  int currentIndex;

  final AudioPlayer _player = AudioPlayer();
  // final PlayerController _waveformController = PlayerController();

  bool isLoading = false;
  bool get isPlaying => _player.playing;
  String get currentTitle => audioPaths[currentIndex].split('/').last;

  AudioPlayer get player => _player;
  // PlayerController get waveformController => _waveformController;

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  bool _isSeeking = false;
  Timer? _seekDebounce;

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
    // Player completion
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // _waveformController.pausePlayer();
      }
      notifyListeners();
    });

    // Audio player position updates
    _player.positionStream.listen((position) {
      if (!_isSeeking) {
        currentPosition = position;
        notifyListeners();
      } else {
        _isSeeking = false; // reset flag after user seek
      }
    });

    // Duration updates
    _player.durationStream.listen((duration) {
      if (duration != null) {
        totalDuration = duration;
        notifyListeners();
      }
    });

    // Waveform drag to seek
    // _waveformController.onCurrentDurationChanged.listen((milliseconds) {
    //   _seekDebounce?.cancel();
    //   _seekDebounce = Timer(const Duration(milliseconds: 200), () {
    //     _isSeeking = true;
    //     final newPosition = Duration(milliseconds: milliseconds);
    //     _player.seek(newPosition);
    //     currentPosition = newPosition;
    //     notifyListeners();
    //   });
    // });

    await _loadTrack();
  }

  Future<void> _loadTrack() async {
    _setLoading(true);
    try {
      await _player.setFilePath(audioPaths[currentIndex]);
      // await _waveformController.preparePlayer(
      //   path: audioPaths[currentIndex],
      //   shouldExtractWaveform: true,
      // );
      await _player.play();
      // await _waveformController.startPlayer();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
    _setLoading(false);
  }

  void playPause() async {
    if (_player.playing) {
      await _player.pause();
      // await _waveformController.pausePlayer( );
    } else {
      await _player.play();
      // await _waveformController.startPlayer( forceRefresh: false);
    }
    notifyListeners();
  }

  void playNext() async {
    if (currentIndex < audioPaths.length - 1) {
      currentIndex++;
      await _changeTrack();
    }
  }

  void playPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await _changeTrack();
    }
  }

  void jumpTo(int index) async {
    currentIndex = index;
    await _changeTrack();
  }

  Future<void> _changeTrack() async {
    await _player.stop();
    // await _waveformController.stopPlayer();
    await _loadTrack();
  }

  void seekTo(double percent) {
    final position = totalDuration * percent;
    _isSeeking = true;
    _player.seek(position);
    // _waveformController.seekTo(position.inMilliseconds);
    currentPosition = position;
    notifyListeners();
  }

  @override
  void dispose() {
    _seekDebounce?.cancel();
    _player.dispose();
    // _waveformController.dispose();
    super.dispose();
  }
}
