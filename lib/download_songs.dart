import 'package:flutter/material.dart';

class DownloadSongs extends StatelessWidget {
  const DownloadSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Download Songs'),
      ),
      body: Center(
        child: Text('No songs to download'),
      ),
    );
  }
}