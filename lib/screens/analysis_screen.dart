import 'dart:io';
import 'dart:convert';

import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../services/api_service.dart';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;

  const AnalysisScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  Map<String, dynamic>? _responseData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  Future<void> _uploadImage() async {
    var result = await ApiService.uploadImage(widget.imagePath);

    print("API Response: $result"); // ✅ Print the full response for debugging

    if (result!.containsKey("error")) {
      setState(() {
        _isLoading = false;
        _errorMessage = result["error"];
      });
    } else {
      setState(() {
        _isLoading = false;
        _responseData = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          header: const Text(
            'Analysis Results',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          title: const Text(
            'Success',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          leading: [
            OutlineButton(
              density: ButtonDensity.icon,
              size: ButtonSize.normal,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
            ),
          ],
        )
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            // 📸 Annotated Image Display
            Card(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_responseData != null &&
                            _responseData!["image_path"] != null)
                        ? Image.file(
                            File(_responseData!["image_path"]),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : (_responseData != null &&
                                _responseData!["image_path"] != null)
                            ? Image.memory(
                                base64Decode(_responseData!["image_path"]),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(widget.imagePath),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
              ),
            ),
            const SizedBox(height: 20),

            // API Response Handling
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (_errorMessage != null) ...[
              Text(
                "Error: $_errorMessage",
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ] else if (_responseData != null) ...[
              _buildDetectionSummary(),
              _buildFaceDetails(),
              _buildObjectDetails(),
            ],
          ],
        ),
      ),
    );
  }

  // 🔹 Detection Summary
  Widget _buildDetectionSummary() {
    List<dynamic> faces = _responseData?["face_details"] ?? [];
    List<dynamic> objects = _responseData?["object_predictions"] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detection Results:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "${faces.length} Face(s) and ${objects.length} Object(s) Detected",
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  // 🔹 Face Details
  Widget _buildFaceDetails() {
    List<dynamic> faces = _responseData?["face_details"] ?? [];

    if (faces.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _sectionHeader("Face Details"),
        for (int i = 0; i < faces.length; i++) ...[
          _sectionHeader("Face ${i + 1}"),
          _buildDetailRow('Width', '${faces[i]["width_cm"]} cm'),
          _buildDetailRow('Height', '${faces[i]["height_cm"]} cm'),
          _buildDetailRow('Bounding Box',
              'X: ${faces[i]["bounding_box"]["x"]}, Y: ${faces[i]["bounding_box"]["y"]}'),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // 🔹 Object Details
  Widget _buildObjectDetails() {
    List<dynamic> objects = _responseData?["object_predictions"] ?? [];

    if (objects.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < objects.length; i++) ...[
          _sectionHeader("Object ${i + 1}"),
          _buildDetailRow('Label', objects[i]["label"]),
          _buildDetailRow('Confidence',
              '${(objects[i]["confidence"] * 100).toStringAsFixed(2)}%'),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  // 🔹 Section Header
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Card(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
