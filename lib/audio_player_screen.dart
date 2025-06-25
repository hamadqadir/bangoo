import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bangoo/provider/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.currentTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.queue_music),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => ListView.builder(
                itemCount: provider.audioPaths.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(provider.audioPaths[index].split('/').last),
                    onTap: () {
                      provider.jumpTo(index);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 100),
            const SizedBox(height: 20),

            // 🎧 Audio Waveform Visualizer
            Consumer<AudioPlayerProvider>(
              
              builder: (context, provider, _) {
                return AudioFileWaveforms(
  playerController: provider.waveformController,
  size: Size(MediaQuery.of(context).size.width, 100),
  enableSeekGesture: true,
  waveformType: WaveformType.fitWidth,
  playerWaveStyle: PlayerWaveStyle(
    fixedWaveColor: Colors.blue.shade200,
    liveWaveColor: Colors.blue,
    spacing: 3.5,
    waveThickness: 1.5,
    showSeekLine: true,
    seekLineColor: Colors.red,
    seekLineThickness: 2,
    // ✅ Seeking through waveform:
    seekHandler: (duration) {
      provider.player.seek(duration);
    },
  ),
);
              },
            ),

            Consumer<AudioPlayerProvider>(
  builder: (context, provider, _) {
    String formatDuration(Duration d) {
      return d.toString().split('.').first.padLeft(8, "0");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formatDuration(provider.currentPosition)),
          Text(formatDuration(provider.totalDuration)),
        ],
      ),
    );
  },
),


            const SizedBox(height: 20),

            // 🎛️ Controls
            Consumer<AudioPlayerProvider>(
              builder: (context, provider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous),
                      iconSize: 40,
                      onPressed: provider.playPrevious,
                    ),
                    IconButton(
                      icon: Icon(provider.isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 60,
                      onPressed: provider.playPause,
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      iconSize: 40,
                      onPressed: provider.playNext,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
