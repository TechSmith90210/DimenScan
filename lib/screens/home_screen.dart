import 'dart:math';
import 'dart:ui';

import 'package:analysis_app/screens/analysis_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Import

import 'package:shadcn_flutter/shadcn_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          header: Text(
            'Snap. Analyze. Measure.',
            style: TextStyle(fontSize: 12),
          ),
          title: const Text(
            'DimenScan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: [
            OutlineButton(
              onPressed: () {},
              density: ButtonDensity.icon,
              child: const Icon(Icons.person),
            ),
          ],
        ),
        const Divider(),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                    child: quickActionButton(
                        'Take Selfie', Icons.camera_alt, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisScreen(),));
                    })),
                Expanded(
                    child: quickActionButton(
                        'Upload Photo', Icons.upload_file_rounded, () {})),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Recent Snapshots',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 3,
            ),
            Expanded(
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                    },
                  ),
                  child: MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 5,
                    itemBuilder: (context, index) {
                      return tile(
                        index: index,
                        extent: (index % 5 + 1) * 100,
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget tile({required int index, required double extent}) {
    final width =
        150 + Random().nextInt(150); // Random width between 150 and 300
    final height = 50 + Random().nextInt(250); // Minimum height of 50, max 300
    return Container(
      decoration: BoxDecoration(
        color: Colors.gray[200],
        borderRadius: BorderRadius.circular(10),
        // image: DecorationImage(
        //   image: NetworkImage(
        //       'https://source.unsplash.com/random/200x300?sig=$index'),
        //   fit: BoxFit.cover,
        // ),
      ),
      height: height.toDouble(),
      width: width.toDouble(),
    );
  }

  Widget quickActionButton(String title, IconData icon, VoidCallback onPressed) {
    return PrimaryButton(
        size: ButtonSize.large,
        shape: ButtonShape.rectangle,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            Icon(
              icon,
              size: 25,
            ),
          ],
        ));
  }
}
