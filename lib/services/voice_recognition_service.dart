import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class VoiceRecognitionService extends GetxService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  bool _hasPermission = false;

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  bool get hasPermission => _hasPermission;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _hasPermission = await _requestMicrophonePermission();
    if (_hasPermission) {
      _speech.initialize(
        onStatus: (status) {
          _isListening = status == stt.SpeechToText.listeningStatus;
          update();
        },
        onError: (error) {
          _isListening = false;
          update();
        },
      );
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    }
    return false;
  }

  Future<void> startListening() async {
    if (!_hasPermission) {
      _hasPermission = await _requestMicrophonePermission();
      if (!_hasPermission) return;
    }
    
    if (!_isListening) {
      _recognizedText = '';
      await _speech.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          update();
        },
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      );
      _isListening = true;
      update();
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
      update();
    }
  }

  Future<void> cancelListening() async {
    await _speech.cancel();
    _isListening = false;
    _recognizedText = '';
    update();
  }

  void reset() {
    _recognizedText = '';
    update();
  }

  @override
  void onClose() {
    _speech.cancel();
    super.onClose();
  }
}