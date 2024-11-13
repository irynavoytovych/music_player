import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';
import 'package:music_player/models/song.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlaylistProvider playListProvider;

  @override
  void initState() {
    super.initState();
    playListProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex, {bool playIfNotPlaying = false}) {
    if (playListProvider.currentSongIndex != songIndex) {
      playListProvider.currentSongIndex = songIndex;
      if (playIfNotPlaying) {
        playListProvider.currentSongIndex = songIndex;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('P L A Y L I S T'),
      ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) {
          final List<Song> playlist = value.playlist;
          final currentSongIndex = value.currentSongIndex ?? 0;
          final currentSong =
              playlist.isNotEmpty ? playlist[currentSongIndex] : null;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final Song song = playlist[index];
                    return ListTile(
                      title: Text(
                        song.songName,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        song.artistName,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      leading: Image.asset(song.albumArtImagePath,
                      ),
                      onTap: () => goToSong(
                        index,
                        playIfNotPlaying: true,
                      ),
                    );
                  },
                ),
              ),
              if (currentSong != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => goToSong(currentSongIndex),
                    child: Column(
                      children: [
                        Text(
                          currentSong.songName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          currentSong.artistName,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 0,
                  ),
                ),
                child: Slider(
                  activeColor: Colors.black,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: value.totalDuration.inSeconds.toDouble(),
                  value: value.currentDuration.inSeconds.toDouble(),
                  onChanged: (double double) {
                  },
                  onChangeEnd: (double double) {
                    value.seek(Duration(seconds: double.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: value.playPreviousSong,
                    ),
                    IconButton(
                      icon: value.isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      onPressed: value.pauseOrResume,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: value.playNextSong,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
