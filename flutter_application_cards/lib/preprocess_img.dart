import 'package:opencv_core/opencv.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

Future<void> isImgBlurry(Mat img, {double threshold = 100.0}) async {
  // Convert to grayscale
  final Mat grayImg = cvtColor(img, COLOR_BGR2GRAY);

  // Use laplacian method
  Mat lapImg = laplacian(grayImg, MatType.CV_64F);
  final double variance = lapImg.variance().val1;

  if (variance < threshold) {
    print("$variance, blurry");
  }
  else {
    print("Not blurry");
  }
  
  Mat rgbColor = cvtColor(lapImg, COLOR_BGR2RGB);
  // CvException Unsupported depth of input image:> 'VDepth::contains(depth)'> where> 'depth' is 6 (CV_64F)

  String osdData = await FlutterTesseractOcr.extractText(img.toString());
  // _AssertionError ('package:flutter_tesseract_ocr/android_ios.dart': Failed assertion: line 24 pos 12: 'await File(imagePath).exists()': true)
  
  print(osdData);
}