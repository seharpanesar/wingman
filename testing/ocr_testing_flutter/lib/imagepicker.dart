import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      return File(image.path); 
    } on PlatformException catch(e) {
      // TODO tell user to enable photo permissions
      print("Failed to pick image $e"); 
      return null;
    }
  }