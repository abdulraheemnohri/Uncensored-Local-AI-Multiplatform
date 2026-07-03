import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TextToSpeechService extends GetxService {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  double _volume = 1.0;
  double _rate = 0.5;
  double _pitch = 1.0;

  bool get isSpeaking => _isSpeaking;
  double get volume => _volume;
  double get rate => _rate;
  double get pitch => _pitch;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setVolume(_volume);
    await _tts.setSpeechRate(_rate);
    await _tts.setPitch(_pitch);
    
    _tts.setStartHandler(() {
      _isSpeaking = true;
      update();
    });
    
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      update();
    });
    
    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      update();
    });
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    if (_isSpeaking) {
      await stop();
    }
    
    await _tts.speak(text);
    _isSpeaking = true;
    update();
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
    update();
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> resume() async {
    await _tts.resume();
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _tts.setVolume(_volume);
    update();
  }

  Future<void> setRate(double rate) async {
    _rate = rate.clamp(0.1, 2.0);
    await _tts.setSpeechRate(_rate);
    update();
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _tts.setPitch(_pitch);
    update();
  }

  Future<void> setLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  Future<List<String>> getAvailableLanguages() async {
    return await _tts.getLanguages;
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}