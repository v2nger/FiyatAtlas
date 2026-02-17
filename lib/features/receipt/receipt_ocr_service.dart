import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ReceiptOcrService {
  Future<String> extractText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    final recognizedText = await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    return recognizedText.text;
  }

  double? extractPrice(String text) {
    final regex = RegExp(r'(\d+[.,]\d{2})');

    final match = regex.firstMatch(text);

    if (match != null) {
      return double.parse(match.group(0)!.replaceAll(",", "."));
    }

    return null;
  }
}
