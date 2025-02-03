import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Result - ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Success',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                
                // Image placeholder
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.image, size: 48, color: Colors.grey),
                ),
                
                // Detection results header
                const Text(
                  '1 Face and 3 Objects\nDetected',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Face details
                const Text(
                  'Face 1:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Height', '30 cm'),
                _buildDetailRow('Weight', '60 kg'),
                _buildDetailRow('Age', '30 - 36 years'),
                _buildDetailRow('Emotion', 'Happy'),
                
                const SizedBox(height: 20),
                
                // Object details
                const Text(
                  'Object 1:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Height', '30 cm'),
                _buildDetailRow('Width', '40 cm'),
                _buildDetailRow('Color', 'Brown'),
                _buildDetailRow('Material Estimation', 'Wood'),
                _buildDetailRow('Aspect Ratio', '1 : 1 (Book)'),
                _buildDetailRow('Distance From Camera', 'Wood'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label = ',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}