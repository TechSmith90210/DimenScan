import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import '../services/api_service.dart';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;

  const AnalysisScreen({super.key, required this.imagePath});

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
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    var result = await ApiService.analyzeImage(widget.imagePath);

    print("API Response: $result"); // ✅ Debugging

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
      appBar: AppBar(
        title: const Text(
          'Analysis Results',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Annotated Image Display
            Card(
              child: InstaImageViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : (_responseData != null && _responseData!["image_path"] != null)
                      ? Image.file(
                    File(widget.imagePath),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(widget.imagePath),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
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
              _buildDetectionSummary(), // ✅ Face Detection → Classification → Estimation
            ],
          ],
        ),
      ),
    );
  }

  /// 🔹 **Build API Response Summary in Correct Order**
  Widget _buildDetectionSummary() {
    List<dynamic> faces = _responseData?["face_detection"]?["faces"] ?? [];
    List<dynamic> predictions = _responseData?["classification"]?["predictions"] ?? [];
    Map<String, dynamic>? estimation = _responseData?["estimation"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🟢 Face Detection First
        if (faces.isNotEmpty) ...[
          const Text(
            'Face Detection Results:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (var face in faces)
            _buildDetailRow("Face Size", "Width: ${face["width_cm"]} cm, Height: ${face["height_cm"]} cm"),
          const SizedBox(height: 20),
        ],

        // 🔵 Classification Next
        if (predictions.isNotEmpty) ...[
          const Text(
            'Classification Results:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (var prediction in predictions)
            _buildDetailRow(
              prediction["label"],
              '${(prediction["confidence"] * 100).toStringAsFixed(2)}%',
            ),
          const SizedBox(height: 20),
        ],

        // 🟠 Estimation Last
        if (estimation != null) ...[
          const Text(
            'Estimation Results:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildDetailRow("Estimated Height", "${estimation["estimated_height"]} cm"),
          _buildDetailRow("Estimated Weight", "${estimation["estimated_weight"]} kg"),
          _buildDetailRow("Estimated Age", "${estimation["estimated_age"]} years"),
        ],
      ],
    );
  }

  /// 🔹 **Reusable Detail Row**
  Widget _buildDetailRow(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
