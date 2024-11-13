import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {

  final List<Song> _playlist = [
    Song(
        songName: 'Teardrops',
        artistName: 'Liam Payne',
        albumArtImagePath: 'assets/images/liam_payne.jpg',
        audioPath: 'audio/Liam Payne - Teardrops (Lyric Video) - LiamPayneVEVO.mp3',
    ),
    Song(
      songName: 'Look Mom I Can Fly',
      artistName: 'Livingston',
      albumArtImagePath: 'assets/images/livingston.jpg',
      audioPath: 'audio/Livingston_Look_mom_I_can_fly.mp3',
    ),
    Song(
      songName: 'As It Was',
      artistName: 'Harry Styles',
      albumArtImagePath: 'assets/images/harry_styles_as_it_was.jpg',
      audioPath: 'audio/Harry Styles - As It Was.mp3',
    ),
  ];

  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume () async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek (Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if(_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length-1) {
        currentSongIndex = currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void shuffle() {
    final random = Random();
    final randomIndex = random.nextInt(_playlist.length);
    currentSongIndex = randomIndex;
    play();
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      }
      else {
        _currentSongIndex = _playlist.length - 1;
      }
      play();(_playlist[_currentSongIndex!]);
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}