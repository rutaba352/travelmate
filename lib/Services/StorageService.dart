import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class StorageService {
  // TODO: Replace with your actual Cloudinary credentials
  static const String _cloudName = 'dzkyjhx28';
  static const String _uploadPreset = 'travelMateProfileImages';

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    _cloudName,
    _uploadPreset,
    cache: false,
  );

  Future<String> uploadProfileImage(XFile image, String userId) async {
    try {
      print('Starting Cloudinary upload for userId: $userId');

      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'travelMateProfileImages',
          publicId:
              '${userId}_${DateTime.now().millisecondsSinceEpoch}', // Unique name to bypass CDN cache
        ),
      );

      print('Cloudinary upload successful. URL: ${response.secureUrl}');
      // Append timestamp to force cache refresh on client side
      final String uniqueUrl =
          '${response.secureUrl}?v=${DateTime.now().millisecondsSinceEpoch}';
      return uniqueUrl;
    } on CloudinaryException catch (e) {
      print('Cloudinary Exception: ${e.message}');
      print('Request: ${e.request}');
      throw Exception('Cloudinary Upload Error: ${e.message}');
    } catch (e) {
      print('Generic Cloudinary Upload Error: $e');
      throw Exception('Failed to upload image to Cloudinary: $e');
    }
  }
}
