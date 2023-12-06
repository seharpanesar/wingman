import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class ServerHelper {
  static Future<Response> sendPhoto(File selectedPhoto) async {
    // Replace 'your_server_url' with your Flask server URL
    var url = Uri.parse('http://your_server_url/upload');

    // Read the image file as bytes
    List<int> imageBytes = await selectedPhoto.readAsBytes();

    // Make a POST request with the image bytes
    Future<Response> response = http.post(
      url,
      body: imageBytes,
      headers: {"Content-Type": "application/octet-stream"}, // Set the content type as octet-stream
    );
    // Handle the response

    return response;
  }
}