import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bangoo/provider/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioPlayerProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      title: Consumer<AudioPlayerProvider>(
          builder: (context, provider, _) => Text(
            provider.currentTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
            
          ),
      ),
      backgroundColor: Colors.orange,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),),
      
        actions: [
          IconButton(
            icon: const Icon(Icons.queue_music),
            onPressed: () => showModalBottomSheet(
              backgroundColor: Colors.black,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: provider.audioPaths.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    
                    title: Text(
                      provider.audioPaths[index].split('/').last,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎨 Album Art Placeholder
            Container(
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.music_note, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // 🎧 Audio Waveform Visualizer
            Consumer<AudioPlayerProvider>(
  builder: (context, provider, _) {
    return Slider(
      value: provider.totalDuration.inMilliseconds == 0
          ? 0
          : provider.currentPosition.inMilliseconds.clamp(0, provider.totalDuration.inMilliseconds).toDouble(),
      max: provider.totalDuration.inMilliseconds.toDouble(),
      min: 0,
      onChanged: (value) {
        provider.seekTo(value / provider.totalDuration.inMilliseconds);
      },
      activeColor: Colors.orange,
      inactiveColor: Colors.orange.shade200,
    );
  },
),


            const SizedBox(height: 16),

            // ⏲️ Duration Display
            Consumer<AudioPlayerProvider>(
              builder: (context, provider, _) {
                String formatDuration(Duration d) {
                  final minutes = d.inMinutes.toString().padLeft(2, '0');
                  final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
                  return '$minutes:$seconds';
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDuration(provider.currentPosition),
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      formatDuration(provider.totalDuration),
                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
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
                      icon: const Icon(Icons.skip_previous, size: 36),
                      onPressed: provider.playPrevious,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          provider.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 48,
                          color: Colors.white,
                        ),
                        onPressed: provider.playPause,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 36),
                      onPressed: provider.playNext,
                      color: Colors.orange,
                    ),
                  ],
                );
              },
            ),

            const Spacer(), // Pushes content up, leaving space at the bottom
          ],
        ),
      ),
    );
  }
}