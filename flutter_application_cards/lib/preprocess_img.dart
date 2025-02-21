import 'dart:io';

import 'package:opencv_core/opencv.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

Future<void> isImgBlurry(File img, {double threshold = 100.0}) async {
  final test = imread(img.path);

  // Convert to grayscale
  final Mat grayImg = cvtColor(test, COLOR_BGR2GRAY);

  // Use laplacian method
  Mat lapImg = laplacian(grayImg, MatType.CV_64F);
  final double variance = lapImg.variance().val1;

  if (variance < threshold) {
    print("$variance, blurry");
  }
  else {
    print("Not blurry");
  }
  
  Mat rgbColor = cvtColor(test, COLOR_BGR2RGB);

  String osdData = await FlutterTesseractOcr.extractText(img.path, args: {"psm": "0"});
  // psm 0 = Orientation and script detection (OSD) only.
  // String is empty
  print("Image osd:\n$osdData");
  
  int orientation = 0;
  int rotate = 0;
  String script = "N/A";

  RegExp orientationRegExp = RegExp(r'Orientation in degrees: (\d+)');
  RegExp rotateRegExp = RegExp(r'Rotate: (\d+)');
  RegExp scriptRegExp = RegExp(r'Script: (\w+)');

  Match? orientationMatch = orientationRegExp.firstMatch(osdData);
  Match? rotateMatch = rotateRegExp.firstMatch(osdData);
  Match? scriptMatch = scriptRegExp.firstMatch(osdData);

  if (orientationMatch != null) {
    orientation = int.parse(orientationMatch.group(1)!);
  }
  if (rotateMatch != null) {
    rotate = int.parse(rotateMatch.group(1)!);
  }
  if (scriptMatch != null) {
    script = scriptMatch.group(1)!;
  }

  // Output the extracted information
  print("Detected Orientation: $orientation degrees");
  print("Rotate by: $rotate degrees to correct");
  print("Detected Script: $script");
}