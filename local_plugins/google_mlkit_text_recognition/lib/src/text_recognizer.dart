import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'input_image.dart';
import 'recognized_text.dart';

class TextRecognizer {
  static const MethodChannel _channel = MethodChannel('google_mlkit_text_recognition');

  Future<RecognizedText> processImage(InputImage inputImage) async {
    try {
      final result = await _channel.invokeMethod('processImage', {
        'imagePath': inputImage.filePath,
      });
      
      return RecognizedText(result['text'] ?? '');
    } catch (e) {
      throw Exception('Text recognition failed: $e');
    }
  }

  void close() {
    // Cleanup if needed
  }
}
