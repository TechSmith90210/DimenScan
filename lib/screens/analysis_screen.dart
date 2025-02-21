import 'package:shadcn_flutter/shadcn_flutter.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          header: const Text(
            'Result',
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
          ),
          title: const Text(
            'Success',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.green),
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
          spacing: 5,
          children: [
            // 📸 Image placeholder
            Card(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.gray[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.image, size: 48, color: Colors.gray),
              ),
            ),
            const SizedBox(height: 20),

            // 📝 Detection Summary
            const Text(
              '1 Face and 3 Objects\nDetected',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🧑 Face Details
            _sectionHeader('Face 1'),
            _buildDetailRow('Height', '30 cm'),
            _buildDetailRow('Weight', '60 kg'),
            _buildDetailRow('Age', '30 - 36 years'),
            _buildDetailRow('Emotion', 'Happy'),

            const SizedBox(height: 20),

            // 📦 Object Details
            _sectionHeader('Object 1'),
            _buildDetailRow('Height', '30 cm'),
            _buildDetailRow('Width', '40 cm'),
            _buildDetailRow('Color', 'Brown'),
            _buildDetailRow('Material Estimation', 'Wood'),
            _buildDetailRow('Aspect Ratio', '1 : 1 (Book)'),
            _buildDetailRow('Distance From Camera', '1.2 meters'),
          ],
        ),
      ),
    );
  }

  // 🔹 Section Header
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
