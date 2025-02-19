import 'package:opencv_core/opencv.dart';

Future<void> isImgBlurry(Mat img, {double threshold = 100.0}) async {
  // Convert to grayscale
  final Mat grayImg = cvtColor(img, COLOR_BGR2GRAY);

  // Use laplacian method
  print(laplacian(grayImg, MatType.CV_64F).variance());
}