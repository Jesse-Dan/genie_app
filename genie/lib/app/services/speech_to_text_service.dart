import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechtt;

class SpeechServices {
  static final _speech = speechtt.SpeechToText();

  static Future<bool> togglerecord({
    required Function(String text) onResult,
    required ValueChanged<bool> onlistening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }
    final isAvalible = await _speech.initialize(
        onStatus: ((status) => onlistening(_speech.isListening)),
        onError: (errorNotification) => print(errorNotification));

    if (isAvalible) {
      _speech.listen(onResult: ((result) => onResult(result.recognizedWords)));
    }

    return isAvalible;
  }

  static bool checkDone() {
    if (_speech.hasRecognized) {
      if (_speech.isNotListening) {
        return true;
      }
      return true;
    } else {
      return false;
    }
  }
}
