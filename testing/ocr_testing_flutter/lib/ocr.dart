import 'package:flutter_tesseract_ocr/android_ios.dart';



Future<String> getOCR(String filepath) async {
  DateTime startTime = DateTime.now();
  String text = await FlutterTesseractOcr.extractText(filepath, language: 'eng',);
  // args: {
  //   "psm": "4",
  //   "preserve_interword_spaces": "1",
  // });
  DateTime endTime = DateTime.now();

  Duration executionTime = endTime.difference(startTime);

  double executionSeconds = executionTime.inMicroseconds / Duration.microsecondsPerSecond;
  print("Execution time: $executionSeconds seconds");
  return text;
} 
