import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
      home: MyHomePage(title: 'FF photos', imagePicker: imgPicker ?? ImagePicker()),
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

  Future<void> _takePicture() async {
    try {
    final XFile? takenPic = await widget.imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _mediaFile = takenPic;
    });
    } catch (e) {
      print(e);
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
                ? Text('No image selected.')
                : Image.file(File(_mediaFile!.path)),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Take Photo'),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
