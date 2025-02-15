import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'text_recognizer_abstract_class.dart';

class GoogleMlTextRecognizerMock implements TxtRecognizer {
  @override
  Future<String> recognizeText(String filePath) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognizedText.text;
    }
  }