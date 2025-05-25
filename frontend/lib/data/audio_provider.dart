import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  AudioProvider() {
    _initializeAudio();
  }

  bool get isMuted => _isMuted;

  Future<void> _initializeAudio() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.setSource(AssetSource('audio/momentum.mp3'));
    _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
  }

  Future<void> playAudio() async {
    await _audioPlayer.resume();
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
