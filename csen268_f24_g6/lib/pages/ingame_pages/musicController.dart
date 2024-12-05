import 'package:just_audio/just_audio.dart';

class MusicController {
  static final MusicController _instance = MusicController._internal();
  late AudioPlayer _audioPlayer;

  // Tracks for different states
  final String initialMusic = 'assets/music/initialmusic.mp3';
  final String dayMusic = 'assets/music/day_music.mp3';
  final String nightMusic = 'assets/music/night_music.mp3';

  factory MusicController() {
    return _instance;
  }

  MusicController._internal() {
    _audioPlayer = AudioPlayer();
  }


  Future<void> playInitialMusic() async {
    await _playMusic(initialMusic);
  }

  Future<void> playDayMusic() async {
    await _playMusic(dayMusic);
  }

  Future<void> playNightMusic() async {
    await _playMusic(nightMusic);
  }

  Future<void> _playMusic(String musicPath) async {
    try {
      await _audioPlayer.setAudioSource(AudioSource.asset(musicPath));
      _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void stopMusic() {
    print("stop music pressed");
    _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }

}
