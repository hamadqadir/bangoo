import 'package:bangoo/album_show_Screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  Map<String, List<SongModel>> folderSongs = {};
  bool isLoading = true;


  
Future<Map<String, List<SongModel>>> fetchSongsGroupedByFolder() async {
  List<SongModel> allSongs = await _audioQuery.querySongs();

  // Group songs by folder (directory)
  Map<String, List<SongModel>> folderMap = {};

  for (var song in allSongs) {
    final folderPath = song.data.substring(0, song.data.lastIndexOf('/'));

    if (!folderMap.containsKey(folderPath)) {
      folderMap[folderPath] = [];
    }

    folderMap[folderPath]!.add(song);
  }

  return folderMap;
}



  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  Future<void> loadFolders() async {
    if (!await _audioQuery.permissionsStatus()) {
      if (!await _audioQuery.permissionsRequest()) return;
    }

    folderSongs = await fetchSongsGroupedByFolder();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final folders = folderSongs.keys.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Folders'),
         actions: [
          IconButton(onPressed: (){}, icon:  Icon(Icons.download, color: Colors.white)),
        ],
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                final folderPath = folders[index];
                final folderName = folderPath.split('/').last;
                final songs = folderSongs[folderPath]!;

                return ListTile(
                  title: Text(folderName, style: TextStyle(color: Colors.white)),
                  subtitle: Text('${songs.length} songs', style: TextStyle(color: Colors.white70)),
                  leading: Icon(Icons.folder, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FolderSongsScreen(folderName: folderName, songs: songs),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
