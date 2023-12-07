import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';


void main(List<String> arguments) async {
  print(getOCR());
  
}

Future<String> getOCR() async {
  String text = await FlutterTesseractOcr.extractText('./images/image1.png', language: 'eng',
  args: {
    "psm": "4",
    "preserve_interword_spaces": "1",
  });

  return text;
} 
