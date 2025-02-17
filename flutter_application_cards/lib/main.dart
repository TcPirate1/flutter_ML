import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.imgPicker});

  final ImagePicker? imgPicker;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FF photos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'FF photos',
        imagePicker: imgPicker ?? ImagePicker(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.imagePicker});

  final String title;
  final ImagePicker imagePicker;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _mediaFile;
  String _recognizedText = '';

  /// Picks an image from the selected source (Gallery or Camera)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await widget.imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _mediaFile = pickedFile;
        });
        _processImage(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  /// Processes the image and extracts text using Google ML Kit
  Future<void> _processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      setState(() {
        _recognizedText = recognizedText.text;
      });
      print('Recognized Text:\n$_recognizedText');
    } catch (e) {
      print('Error recognizing text: $e');
    } finally {
      textRecognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _mediaFile == null
                ? const Text('No image selected.')
                : Image.file(File(_mediaFile!.path), height: 250),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick from Gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a Picture'),
            ),
            const SizedBox(height: 20),
            _recognizedText.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(_recognizedText),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
