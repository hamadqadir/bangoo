# 🎶 Flutter Audio Player with Waveform Visualization

A sleek Flutter audio player app that scans device songs, plays them using `just_audio`, displays a draggable waveform using `audio_waveforms`, and manages state using `provider`.

---

## 🔧 Features

- 🔍 Auto-scan local audio files (`on_audio_query`)
- 🎵 Play, pause, skip next/previous (`just_audio`)
- 🌊 Interactive waveform (drag to seek)
- 📂 Bottom-sheet playlist
- 📲 Works on real devices with runtime permission handling
- 🧠 Provider for playback state management

---

## 📦 Packages Used

| Package              | Purpose                          |
|----------------------|----------------------------------|
| [`just_audio`](https://pub.dev/packages/just_audio)         | Audio playback engine         |
| [`on_audio_query`](https://pub.dev/packages/on_audio_query) | Access audio files from device |
| [`audio_waveforms`](https://pub.dev/packages/audio_waveforms) | Render interactive waveform   |
| [`provider`](https://pub.dev/packages/provider)             | State management              |
| [`permission_handler`](https://pub.dev/packages/permission_handler) | Permission requests           |

---

## 🛠 Setup

### 1. Clone the repo

```bash
git clone https://github.com/your-username/flutter-audio-waveform-player.git
cd flutter-audio-waveform-player
