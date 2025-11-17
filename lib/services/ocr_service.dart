import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<RecognizedText> runOcr(String imagePath) async {
    InputImage inputImage = InputImage.fromFilePath(imagePath);

    return await _textRecognizer.processImage(inputImage);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
