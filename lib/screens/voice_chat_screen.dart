import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../services/voice_recognition_service.dart';
import '../services/text_to_speech_service.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final ChatController _chatController = Get.find();
  final VoiceRecognitionService _voiceService = Get.find();
  final TextToSpeechService _ttsService = Get.find();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _voiceService.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_voice),
            onPressed: _showVoiceSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                final message = _chatController.messages[index];
                return _buildMessageBubble(message);
              },
            )),
          ),
          _buildVoiceInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: SelectableText(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Obx(() => IconButton(
            icon: Icon(
              _ttsService.isSpeaking ? Icons.stop : Icons.volume_up,
            ),
            onPressed: _ttsService.isSpeaking 
                ? _ttsService.stop 
                : _speakLastResponse,
            color: _ttsService.isSpeaking ? Colors.red : Colors.blue,
          )),
          Expanded(
            child: Obx(() => Text(
              _voiceService.isListening 
                  ? 'Listening...' 
                  : _voiceService.recognizedText.isNotEmpty 
                      ? _voiceService.recognizedText 
                      : 'Tap microphone to speak',
              style: TextStyle(
                color: _voiceService.isListening ? Colors.blue : Colors.grey,
              ),
            )),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: _toggleListening,
            color: _isListening ? Colors.red : Colors.blue,
            iconSize: 28,
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendVoiceMessage,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      await _voiceService.startListening();
      setState(() => _isListening = true);
    }
  }

  void _sendVoiceMessage() async {
    if (_voiceService.recognizedText.isNotEmpty) {
      await _chatController.sendMessage(_voiceService.recognizedText);
      _voiceService.reset();
    }
  }

  void _speakLastResponse() async {
    final messages = _chatController.messages;
    if (messages.isNotEmpty && !messages.last.isUser) {
      await _ttsService.speak(messages.last.content);
    }
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildVoiceSettingsSheet(),
    );
  }

  Widget _buildVoiceSettingsSheet() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Voice Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() => SwitchListTile(
            title: const Text('Enable Voice Input'),
            value: _voiceService.hasPermission,
            onChanged: (value) async {
              if (value) {
                await _voiceService.startListening();
              } else {
                await _voiceService.stopListening();
              }
            },
          )),
          ListTile(
            title: const Text('Speech Rate'),
            trailing: Obx(() => Slider(
              value: _ttsService.rate,
              min: 0.1,
              max: 2.0,
              onChanged: _ttsService.setRate,
            )),
          ),
          ListTile(
            title: const Text('Volume'),
            trailing: Obx(() => Slider(
              value: _ttsService.volume,
              min: 0.0,
              max: 1.0,
              onChanged: _ttsService.setVolume,
            )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _voiceService.stopListening();
    _ttsService.stop();
    super.dispose();
  }
}