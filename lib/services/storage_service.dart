import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File imageFile, String userId) async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('users/$userId/scans/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }


  /// **Save API Data to Firestore**
  Future<void> saveScanData(String userId, String imageUrl, Map<String, dynamic> apiResponse) async {
    try {
      final docRef = _firestore.collection('users').doc(userId).collection('scans').doc();

      await docRef.set({
        'imageUrl': imageUrl,
        'classification': apiResponse['classification'],
        'estimation': apiResponse['estimation'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Data successfully saved to Firestore!");
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  /// **Complete Flow: Upload Image → Store API Data**
  Future<void> processAndStoreScan(File imageFile, String userId, Map<String, dynamic> apiResponse) async {
    String? imageUrl = await uploadImage(imageFile, userId);

    if (imageUrl != null) {
      await saveScanData(userId, imageUrl, apiResponse);
    } else {
      print("Failed to upload image. Data not saved.");
    }
  }
}
