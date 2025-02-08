# flutter_ML
Combining ML with photos. Analyze photos and store information gained into a database.

# Setup
- https://docs.flutter.dev/get-started/install/linux/android
- https://flutter.dev/learn

# Useful notes
- "transitive dependencies" = dependencies that the added packages depend on.
- `flutter pub cache clean` and `flutter pub get` to install and remove packages in projects.
- [Adding and removing flutter packages](https://stackoverflow.com/questions/57213340/how-to-add-a-package-from-command-line-in-flutter)
- Google ML kit for text recognition.
- [OpenCV using Canny Edge Detection Algorithm](https://pub.dev/packages/opencv_core)
- [App scripts for Google Sheets automation.](https://developers.google.com/apps-script) [Use rest api to programatically manipulate the sheets.](https://developers.google.com/apps-script/api/concepts)
- [The opencv package requires dartcv to also be installed otherwise one of the needed libraries cannot be used](https://github.com/rainyl/dartcv/tree/main). Then find the library using `find / -name libdartcv.so`, in my case the path is "dartcv/build/dartcv/libdartcv.so" and "dartcv/build/install/lib/libdartcv.so"

# TODO
- Find packages/frameworks for the last point in [Useful notes](#Useful-notes)
- [Tensorflow model training](https://www.tensorflow.org/guide/keras/training_with_built_in_methods)
- [Study App scripts](https://developers.google.com/codelabs/apps-script-fundamentals-1#1)
- Find out why paste command doesn't work on Code oss (linux)