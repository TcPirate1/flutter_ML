import 'package:opencv_core/opencv.dart';

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
}