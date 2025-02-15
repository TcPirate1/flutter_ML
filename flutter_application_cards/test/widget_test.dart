import 'dart:io';

import 'package:flutter_application_cards/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:opencv_core/opencv.dart';
// Update with your app's import

import 'widget_test.mocks.dart'; // Import the generated mocks

@GenerateMocks([ImagePicker])
void main() {
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
    final testImg = imread("test/asset_test/fake_image.jpg");
    expect(testImg.isEmpty, isFalse);

    final Mat grayImg = cvtColor(testImg, COLOR_BGR2GRAY);

    final blurredImg = gaussianBlur(grayImg, (5,5), 0);
    // ksize = kernal size == Apeture Size. Why does it have to be odd???

    final edge = canny(blurredImg, 100, 200);

    expect(edge.isEmpty, isFalse);
  });
  // @GenerateMocks([google_mlkit_text_recognition])
  test ("Find text in the image", () async {
    final txtRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await txtRecognizer.processImage(InputImage.fromFile(File('test/asset_test/fake_image.jpg')));
    print(recognizedText);
    txtRecognizer.close();
  });
}
