import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOcrService {
  static Future<String> extractText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await recognizer.processImage(inputImage);

    await recognizer.close();
    return recognizedText.text;
  }
}
