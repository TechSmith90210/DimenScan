import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String baseUrl = "http://192.168.0.153:8000/upload"; // Update with your FastAPI URL

  static Future<Map<String, dynamic>?> uploadImage(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse JSON response
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('error')) {
          return {"error": jsonResponse['error']};
        }

        // Extract base64 image data from response
        String? base64Image = jsonResponse['annotated_image'];
        if (base64Image != null && base64Image.isNotEmpty) {
          // Decode base64 string to bytes
          List<int> imageBytes = base64Decode(base64Image);

          // Save annotated image to local storage
          Directory tempDir = await getTemporaryDirectory();
          File imageFile = File('${tempDir.path}/annotated.jpg');
          await imageFile.writeAsBytes(imageBytes);

          jsonResponse['image_path'] = imageFile.path; // Return saved image path
        }

        return jsonResponse;
      } else {
        return {"error": "Error: ${response.statusCode}\n${response.body}"};
      }
    } catch (e) {
      return {"error": "Upload failed: $e"};
    }
  }
}
