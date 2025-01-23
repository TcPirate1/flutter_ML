import 'package:flutter/material.dart';
import 'package:flutter_application_cards/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';
import 'package:flutter_application_cards/main.dart'; // Update with your app's import

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
}
