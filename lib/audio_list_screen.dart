import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'audio_player_screen.dart';
import 'provider/audio_player_provider.dart';
import 'package:provider/provider.dart';

class AudioListScreen extends StatefulWidget {
  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> songs = [];
  bool isLoading = true;

  // ✅ Provide valid audio file paths
  List<String> get audioPaths => songs.map((s) => s.data).toList();

  @override
  void initState() {
    super.initState();
    requestPermissionAndFetchSongs();
  }

  Future<void> requestPermissionAndFetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();

    if (!permissionStatus) {
      permissionStatus = await _audioQuery.permissionsRequest();
      if (!permissionStatus) {
        print('User denied permission');
        return;
      }
    }

    try {
      songs = await _audioQuery.querySongs();
      print('Found ${songs.length} songs');
    } catch (e) {
      print('Error querying songs: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Audio Files'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        scrolledUnderElevation: 0.1,
        backgroundColor: Colors.orange,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : songs.isEmpty
              ? Center(child: Text("No audio files found"))
              : ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        song.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.artist ?? "Unknown Artist",
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChangeNotifierProvider(
                                  create:
                                      (_) => AudioPlayerProvider(
                                        audioPaths: audioPaths,
                                        currentIndex: index,
                                      ),
                                  child: AudioPlayerScreen(),
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
