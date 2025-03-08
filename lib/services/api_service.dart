import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://beb9-182-66-237-180.ngrok-free.app"; // Update with your FastAPI server IP

  // Analyze image (classification → estimation → detect faces)
  static Future<Map<String, dynamic>?> analyzeImage(String imagePath) async {
    try {
      // Step 1: Classify the Image
      var classificationResult = await classifyImage(imagePath);
      if (classificationResult == null || classificationResult.containsKey("error")) {
        return classificationResult; // Return error if classification fails
      }

      // Step 2: Estimate Characteristics
      var estimationResult = await estimateCharacteristics(imagePath);
      if (estimationResult == null || estimationResult.containsKey("error")) {
        return estimationResult; // Return error if estimation fails
      }

      // Step 3: Detect Faces
      var faceDetectionResult = await detectFaces(imagePath);
      if (faceDetectionResult == null || faceDetectionResult.containsKey("error")) {
        return faceDetectionResult; // Return error if face detection fails
      }

      // Merge all responses
      return {
        "classification": classificationResult,
        "estimation": estimationResult,
        "face_detection": faceDetectionResult,
      };
    } catch (e) {
      return {"error": "Analysis failed: $e"};
    }
  }

  // Upload image for classification
  static Future<Map<String, dynamic>?> classifyImage(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/classify/"));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Classification failed: ${response.statusCode}\n${response.body}"};
      }
    } catch (e) {
      return {"error": "Classification failed: $e"};
    }
  }

  // Upload image for characteristic estimation
  static Future<Map<String, dynamic>?> estimateCharacteristics(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/estimate/"));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Estimation failed: ${response.statusCode}\n${response.body}"};
      }
    } catch (e) {
      return {"error": "Estimation failed: $e"};
    }
  }

  // Upload image for face detection
  static Future<Map<String, dynamic>?> detectFaces(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/detect_faces/"));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Face detection failed: ${response.statusCode}\n${response.body}"};
      }
    } catch (e) {
      return {"error": "Face detection failed: $e"};
    }
  }
}
