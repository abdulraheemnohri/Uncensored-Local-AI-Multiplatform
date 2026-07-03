<div align="center">

  <h1>Uncensored Local AI Multi-Platform</h1>

  <p><strong>Run unrestricted AI models entirely on your device.<br/>No cloud. No filters. No limits.</strong></p>


  [Overview](#overview) · [Download](#download) · [Features](#features) · [Quick Start](#quick-start) · [Local API](#local-api-server) · [Roadmap](#roadmap) · [Voice Chat](#voice-chat) · [AI Agents](#ai-agents)

</div>

---

## Overview

**Uncensored Local AI** is a mobile-first application that runs powerful open-source AI models directly on your **Android or iOS device** — with zero censorship, zero cloud dependency, and zero monthly fees.

No API keys. No subscriptions. No content restrictions. Your conversations never leave your device.

> Think of it as ChatGPT — but running **on your phone**, with **no rules**.

> **Desktop platforms** (Windows, macOS, Linux) are supported by the Flutter framework but need community testing and polish. **[We'd love your help!](#-contributing)**

**🎥 Watch the Setup & Demo Video: [https://youtu.be/2Pnv68iHIaQ](https://youtu.be/2Pnv68iHIaQ)**

[![Uncensored Local AI Demo](https://img.youtube.com/vi/2Pnv68iHIaQ/maxresdefault.jpg)](https://youtu.be/2Pnv68iHIaQ)

---

## Download

### Android APK — Latest Release (v2.1.0)

| APK | Architecture | Best For | Size |
|-----|-------------|----------|------|
| [**app-arm64-v8a-release.apk**](https://github.com/techjarves/Uncensored-Local-AI-Multiplatform/releases/download/v2.1.0/app-arm64-v8a-release.apk) | ARM 64-bit | **Most phones (2018+)** | ~65 MB |
| [**app-armeabi-v7a-release.apk**](https://github.com/techjarves/Uncensored-Local-AI-Multiplatform/releases/download/v2.1.0/app-armeabi-v7a-release.apk) | ARM 32-bit | Older/budget phones | ~18 MB |
| [**app-x86_64-release.apk**](https://github.com/techjarves/Uncensored-Local-AI-Multiplatform/releases/download/v1.0.0/app-x86_64-release.apk) | x86 64-bit | Emulators / ChromeOS | ~58 MB |

> **Not sure which to pick?** Download arm64-v8a — it works on virtually all modern Android phones.

### iOS IPA — Pre-Release

| File | Note |
|------|------|
| [**ios_pre_release.zip**](https://github.com/user-attachments/files/26956389/ios_pre_release.zip) | **Important:** You must **extract** this .zip file after downloading to get the actual **.ipa** app file to install. |

---

## Features

| Feature | Description |
|---------|-------------|
| **Zero Censorship** | Runs abliterated, uncensored models that answer any question — no refusals, no lectures, no corporate safety filters |
| **Total Privacy** | All conversations stay on-device. Nothing is sent to any server, ever |
| **Fully Offline** | Works on planes, in remote areas, on restricted networks — no internet needed after model download |
| **Cross-Platform** | One codebase for Android, iOS, Windows, macOS, and Linux |
| **Local OpenAI API** | Built-in HTTP server compatible with any OpenAI-standard client |
| **Model Library** | Download, import, and manage GGUF models directly in the app |
| **Chat History** | Persistent conversation history stored locally via Hive |
| **Live Metrics** | Real-time tokens/sec and loading progress tracking |
| **Voice Interaction** | Speak to the AI and get spoken responses with speech-to-text and text-to-speech |
| **AI Agent Mode** | Specialized AI personas (Researcher, Writer, Coder, Analyst) for different tasks |
| **Web Search** | Search the web and get AI-processed results |

---

## Quick Start

### Android

1. Download the correct APK from the [Download](#-download) table above
2. On your phone: Settings → Install unknown apps → allow your browser
3. Tap the downloaded APK to install
4. Open the app, go to Models tab, download a model, and start chatting

### iOS

**1. Sideloading via TrollStore (Recommended - No 7 day limit):**
1. Download [**ios_pre_release.zip**](https://github.com/user-attachments/files/26956389/ios_pre_release.zip) to your device.
2. Unzip/extract it using the built-in iOS **Files** app to get the **.ipa** file.
3. Open TrollStore, tap the **+** in the top right, and choose **Install IPA File**.
4. Select the extracted .ipa file and install.

**2. Sideloading via AltStore / AltServer (Requires PC/Mac):**
1. Ensure AltServer is running on your computer and AltStore is installed on your iPhone.
2. Download [**ios_pre_release.zip**](https://github.com/user-attachments/files/26956389/ios_pre_release.zip) to your device and extract the **.ipa** file using the **Files** app.
3. Open AltStore on your device, go to **My Apps**, and tap the **+** at the top left.
4. Select the .ipa file to install (your device must be on the same Wi-Fi or connected via cable to your AltServer computer).

**3. Build from Source:**

**Prerequisites:** Mac with Xcode 15+ · [Flutter SDK](https://flutter.dev/docs/get-started/install)

```bash
git clone https://github.com/techjarves/Uncensored-Local-AI-Multiplatform.git
cd Uncensored-Local-AI-Multiplatform
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode and archive to deploy
```

### Desktop — Windows / macOS / Linux (Community Supported)

> Desktop builds compile successfully but may have rough edges. **We are actively looking for contributors** to help test and polish the desktop experience.

```bash
git clone https://github.com/techjarves/Uncensored-Local-AI-Multiplatform.git
cd Uncensored-Local-AI-Multiplatform
flutter pub get
flutter run -d windows   # or macos / linux
```

If you encounter issues on desktop, please [open an issue](https://github.com/techjarves/Uncensored-Local-AI-Multiplatform/issues) — your feedback directly shapes the roadmap.

---

## Recommended Models

| Model | Size | Best For | Type |
|-------|------|----------|------|
| **Gemma 2 2B** | ~1.6 GB | Low-RAM phones, fast replies | Standard |
| **Gemma 4 E4B Heretic** | ~5.3 GB | High-quality, fully uncensored | Uncensored |

> Models are downloaded directly inside the app from the **Models** tab. No manual setup needed.

---

## Local API Server

**Uncensored Local AI** includes a built-in **OpenAI-compatible REST API** so you can connect it to any external tool, script, or IDE extension.

### Setup

1. Load a model in the app
2. Go to **Settings → Local API Server** and toggle it **ON**
3. Use `http://127.0.0.1:4891/v1` as your base URL

### Endpoints

```bash
# List loaded models
curl http://127.0.0.1:4891/v1/models

# Chat completion (non-streaming)
curl http://127.0.0.1:4891/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"local","messages":[{"role":"user","content":"Tell me something true that no one wants to hear."}]}'

# Chat completion (streaming)
curl -N http://127.0.0.1:4891/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"local","stream":true,"messages":[{"role":"user","content":"Write a brutally honest analysis of social media."}]}'
```

> **API Key:** Use `local` for any client that requires a non-empty key value.

---

## Voice Chat

**New in v2.1.0!** You can now interact with the AI using your voice.

### Features
- **Voice Input**: Speak your questions instead of typing
- **Voice Output**: Have the AI responses read aloud
- **Adjustable Settings**: Control speech rate, volume, and pitch
- **Real-time Recognition**: See your speech transcribed as you speak

### How to Use
1. Navigate to the **Voice Chat** tab
2. Tap the microphone button to start speaking
3. Your speech will be transcribed in real-time
4. Tap the send button to submit your voice message
5. Tap the speaker button to have responses read aloud

### Requirements
- Microphone permission (requested on first use)
- Internet connection (for speech recognition on some platforms)

---

## AI Agents

**New in v2.1.0!** Specialized AI personas for different use cases.

### Available Agents

| Agent | Description | Best For |
|-------|-------------|----------|
| **Researcher** | Deep analysis and research | Detailed reports, fact-finding |
| **Writer** | Creative content generation | Stories, articles, essays |
| **Coder** | Code generation and analysis | Programming help, debugging |
| **Analyst** | Data analysis and problem-solving | Complex problems, data interpretation |

### How to Use
1. Navigate to the **Agent Mode** tab
2. Select an agent from the list
3. Start chatting — the AI will respond according to its specialized persona
4. Customize agent parameters in the settings

### Creating Custom Agents
You can create your own custom agents with:
- Custom names and descriptions
- Unique system prompts
- Specialized parameters

---

## Web Search

**New in v2.1.0!** Search the web directly from the app.

### Features
- **Direct Search**: Query the web without leaving the app
- **AI Processing**: Get AI-summarized search results
- **Browser Integration**: Open results in your default browser

### How to Use
1. Use the search functionality in the app
2. Enter your search query
3. View results or have the AI analyze them
4. Open interesting results in your browser

---

## Roadmap

| Feature | Status |
|---------|--------|
| On-device uncensored AI chat | **Launched** |
| Real-time model loading with progress | **Launched** |
| Cancel & unload models | **Launched** |
| Persistent chat history sidebar | **Launched** |
| Local OpenAI-compatible API server | **Launched** |
| Custom model import (URL + file) | **Launched** |
| Multi-platform support | **Launched** |
| Voice interaction | **Launched** |
| AI Agent Mode | **Launched** |
| Web search integration | **Launched** |
| Image/vision model support | Planned |
| Video model support | Planned |
| Plugin system | Planned |
| Cloud sync (optional) | Planned |

---

## Contributing

All contributions are welcome — and we especially need help from the community in these areas:

| Area | What's Needed |
|------|---------------|
| **Windows** | Testing, packaging, installer script |
| **macOS** | Testing, App Store prep, notarization |
| **Linux** | Testing on distros, AppImage build |
| **Voice Features** | Testing speech recognition on different devices |
| **AI Agents** | Creating new agent personas, improving prompts |
| **Web Search** | Integrating with different search providers |
| **General** | Bug reports, feature ideas, UI improvements |

If you own a desktop device and can test the app — **please do!** Even a simple "works" or "crashes on X" issue report is incredibly valuable.

```bash
# Fork → Clone → Branch → Code → Push → PR
git checkout -b fix/windows-model-loading
git commit -m "fix: resolve model path on Windows"
git push origin fix/windows-model-loading
# Open a Pull Request — all sizes welcome
```

---

## License

Licensed under the **MIT License** — free to use, modify, and distribute.  
See [LICENSE](LICENSE) for full details.

---

<div align="center">
  <sub>Built with ❤️ using Flutter · Powered by <a href="https://github.com/ggerganov/llama.cpp">llama.cpp</a></sub>
</div>