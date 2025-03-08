import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:analysis_app/screens/analysis_screen.dart';
import 'package:analysis_app/screens/login_screen.dart';
import 'package:analysis_app/services/auth_service.dart';
import 'package:analysis_app/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  final StorageService _storageService = StorageService();

  Future<void> _pickImage(bool isUpload, BuildContext context) async {
    final pickedFile =
    await ImagePicker().pickImage(source: isUpload ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }


  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          header: const Text(
            'Snap. Analyze. Measure.',
            style: TextStyle(fontSize: 12),
          ),
          title: const Text(
            'DimenScan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: [
            OutlineButton(
              onPressed: () {
                showDropdown(
                  context: context,
                  builder: (context) {
                    return const DropdownMenu(
                      children: [
                        MenuLabel(child: Text('My Account')),
                        MenuDivider(),
                        MenuButton(
                          child: Text('Log out'),
                        ),
                      ],
                    );
                  },
                ).future.then((_) {
                  AuthService _auth = AuthService();
                  _auth.signOut();
                  if (_auth.getCurrentUser() == null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  }
                });
              },
              density: ButtonDensity.icon,
              child: const Icon(Icons.person),
            )
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
            const SizedBox(height: 10),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: quickActionButton('Take Selfie', Icons.camera_alt, () {
                    _pickImage(false, context);
                  }),
                ),
                Expanded(
                  child: quickActionButton('Upload Photo', Icons.upload_file_rounded, () {
                    _pickImage(true, context);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Snapshots',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getRecentSnapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No recent snapshots"));
                  }

                  var docs = snapshot.data!.docs;

                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 5,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      return snapshotTile(data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Fetch Recent Snapshots from Firestore**
  Stream<QuerySnapshot> _getRecentSnapshots() {
    String? userId = AuthService().getCurrentUser()?.uid;
    if (userId == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('scans')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// **Snapshot Tile (Image Preview)**
  Widget snapshotTile(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.gray,
        borderRadius: BorderRadius.circular(10),
        image: data['imageUrl'] != null
            ? DecorationImage(
          image: NetworkImage(data['imageUrl']),
          fit: BoxFit.cover,
        )
            : null,
      ),
      height: 180,
      width: 150,
    );
  }

  /// **Quick Action Button**
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
          Icon(icon, size: 25),
        ],
      ),
    );
  }
}