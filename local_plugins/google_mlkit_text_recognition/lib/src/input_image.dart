import 'dart:io';

class InputImage {
  final String filePath;

  InputImage._(this.filePath);

  static InputImage fromFile(File file) {
    return InputImage._(file.path);
  }

  static InputImage fromFilePath(String filePath) {
    return InputImage._(filePath);
  }
}
