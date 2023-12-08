import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'constants.dart';


class ServerHelper {

  // send photo and response style from device -> server
  static Future<Response> sendPhoto(File selectedPhoto, String responseStyle) async {
    // Replace 'your_server_url' with your Flask server URL
    var url = Uri.parse(Constants.serverUrl);

    // Read the image file as bytes
    List<int> imageBytes = await selectedPhoto.readAsBytes();

    // Make a POST request with the image bytes
    Future<Response> response = http.post(
      url,
      body: imageBytes,                             // include the photo bytes (for OCR in server)
      headers: {
        "Content-Type": "application/octet-stream", // Set the content type as octet-stream
        "Response-Style": responseStyle             // user defined style 
      }, 
    );

    // Handle the response
    return response;
  }


  // given a json response, parse it and return the relevant parts. 
  static String parseResponse(Response r) {
    // Convert the string to a Map
    Map<String, dynamic> jsonMap = {};

    try {
      jsonMap = json.decode(r.body);
    } on FormatException catch (e) {
      return "Error: Unable to generate a response.";
    } 
    
    // basic error handling
    if (jsonMap.keys.contains(Constants.errorKey)) {
      return "Error: Unable to generate a response.";
    }

    // otherwise, return chatgpt's response
    assert(jsonMap.keys.contains(Constants.responseKey));
    return jsonMap[Constants.responseKey];
  }
}