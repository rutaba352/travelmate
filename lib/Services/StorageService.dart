import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(XFile image, String userId) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('user_profile_images')
          .child('$userId.jpg');

      print('Starting upload for userId: $userId');
      UploadTask uploadTask;

      if (kIsWeb) {
        print('Uploading as Web Data');
        final Uint8List bytes = await image.readAsBytes();
        final SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = ref.putData(bytes, metadata);
      } else {
        print('Uploading as File: ${image.path}');
        uploadTask = ref.putFile(File(image.path));
      }

      print('Waiting for upload to complete...');
      // Add timeout for Web mainly, as it hangs if CORS not set
      final TaskSnapshot snapshot = await uploadTask.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          if (kIsWeb) {
             throw Exception('Upload timed out. On Web, this is often due to missing CORS configuration on Firebase Storage bucket. Please configure cors.json.');
          }
           throw Exception('Upload timed out. Check your internet connection.');
        },
      );
      
      print('Upload completed. State: ${snapshot.state}');
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
