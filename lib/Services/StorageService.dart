import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(XFile image, String userId) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('user_profile_images')
          .child('$userId.jpg');

      print('Starting upload for userId: $userId');

      // Read file bytes first to ensure we can access the file locally
      final Uint8List bytes = await image.readAsBytes();
      print('File read successfully. Size: ${bytes.length} bytes');

      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': image.path},
      );

      final UploadTask uploadTask = ref.putData(bytes, metadata);

      print('Waiting for upload to complete...');

      // Monitor the task
      uploadTask.snapshotEvents.listen(
        (TaskSnapshot snapshot) {
          print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}',
          );
        },
        onError: (e) {
          print('Upload stream error: $e');
        },
      );

      final TaskSnapshot snapshot = await uploadTask;
      print('Upload completed. State: ${snapshot.state}');

      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        print('Download URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception: ${e.code} - ${e.message}');
      throw Exception('Firebase Upload Error: ${e.message}');
    } catch (e) {
      print('Generic Upload Error: $e');
      throw Exception('Failed to upload image: $e');
    }
  }
}
