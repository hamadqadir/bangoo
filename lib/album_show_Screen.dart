import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'provider/audio_player_provider.dart';
import 'audio_player_screen.dart';

class FolderSongsScreen extends StatelessWidget {
  final String folderName;
  final List<SongModel> songs;

  const FolderSongsScreen({required this.folderName, required this.songs});

  List<String> get audioPaths => songs.map((s) => s.data).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(folderName),
        backgroundColor: Colors.orange,
       
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              controller: OnAudioQuery(),
              nullArtworkWidget: Icon(Icons.music_note, color: Colors.white),
            ),
            title: Text(song.title, style: TextStyle(color: Colors.white)),
            subtitle: Text(song.artist ?? 'Unknown', style: TextStyle(color: Colors.white70)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => AudioPlayerProvider(
                      audioPaths: audioPaths,
                      currentIndex: index,
                      songs: songs,
                    ),
                    child: AudioPlayerScreen(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
