import 'package:flutter_application_cards/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:opencv_core/opencv.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'widget_test.mocks.dart'; // Import the generated mocks

@GenerateMocks([ImagePicker])
@GenerateMocks([TextRecognizer])
void main() {
  late final Mat testImg;
  late final Mat grayImg;
  setUpAll(() {
    testImg = imread("test/asset_test/fake_image.jpg");
    grayImg = cvtColor(testImg, COLOR_BGR2GRAY);
  });
  testWidgets('Take Picture Button Test', (WidgetTester tester) async {
    final mockImagePicker = MockImagePicker();

    // Stub the pickImage method
    when(mockImagePicker.pickImage(source: ImageSource.camera))
        .thenAnswer((_) async => XFile('test/asset_test/fake_image.jpg'));

    // Create a widget tree with the mocked ImagePicker
    await tester.pumpWidget(MyApp(imgPicker: mockImagePicker));

    // Verify the "Take Picture" button exists
    final takePictButton = find.text('Take Photo');
    expect(takePictButton, findsOneWidget);

    // Tap the "Take Picture" button
    await tester.tap(takePictButton);
    await tester.pumpAndSettle();

    // Verify the mock pickImage was called
    verify(mockImagePicker.pickImage(source: ImageSource.camera)).called(1);
  });

  test("Edge detection with OpenCV core", () async {
    expect(testImg.isEmpty, isFalse);

    final blurredImg = gaussianBlur(grayImg, (5,5), 0);
    // ksize = kernal size == Apeture Size. Why does it have to be odd???

    final edge = canny(blurredImg, 100, 200);

    expect(edge.isEmpty, isFalse);
  });

  test("Image blurry or not blurry detection", () async {
    Mat lapImg = laplacian(grayImg, MatType.CV_64F);
    final double variance = lapImg.variance().val1;
    final double threshold = 100.0;

    if (variance < threshold) {
      print("image is blurry");
    }
    else {
      print("image is fine");
    }

    expect(variance, isNonZero);
  });

  late MockTextRecognizer mockTxtRecognizer;
  late InputImage inputImg;
  setUp(() {
    mockTxtRecognizer = MockTextRecognizer();
    inputImg = InputImage.fromFilePath('test/asset_test/fake_image.jpg');
  });
  test ("Find text in the image", () async {
    final mockRecognizedTxt = RecognizedText(text: "Brave\nIf 1 or less Time Counters are placed on Fake, Fake cannot attack or block.\nWhen you receive a point of damage, place 1 Time Counter on Fake.", blocks: []);
    when(mockTxtRecognizer.processImage(any)).thenAnswer((_) async => mockRecognizedTxt);

    final result = await mockTxtRecognizer.processImage(inputImg);
    expect(result.text, contains("Fake"));
    expect(result.text, contains("Brave"));
    expect(result.text, contains("Time Counter"));
    expect(result.text, contains("Time Counters"));
  });
}
