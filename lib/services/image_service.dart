import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:logger/logger.dart';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class ImageService {
  final SupabaseClient _client;
  final AuthService _authService;
  final _picker = ImagePicker();
  final Logger _logger;

  ImageService(this._client, this._authService, this._logger);

  Future<Uint8List?> pickImage() async {
    if (kIsWeb) {
      // Use image_picker_web to pick the image.
      var mediaInfo = await ImagePickerWeb.getImageInfo;
      if (mediaInfo != null && mediaInfo.data != null) {
        return mediaInfo.data;
      } else {
        _logger.i('No image selected.');
        return null;
      }
    } else {
      // Use image_picker to pick the image.
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return await pickedFile.readAsBytes();
      } else {
        _logger.i('No image selected.');
        return null;
      }
    }
  }

  Future<String?> uploadImage(Uint8List imageData) async {
    try {
      // Generate a unique image name based on user id and current timestamp.
      String imageName =
          '${_authService.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the Uint8List to Supabase.
      final response = await _client.storage
          .from('avatars')
          .uploadBinary(imageName, imageData);

      if (response.isEmpty) {
        _logger.e('Error during file upload');
        return null;
      } else {
        try {
          final urlResponse =
              _client.storage.from('avatars').getPublicUrl(imageName);
          if (urlResponse.isEmpty) {
            _logger.e('Error fetching avatar URL');
          } else {
            return urlResponse;
          }
        } catch (e) {
          _logger.e('Exception fetching avatar URL: $e');
        }
      }
    } catch (e) {
      _logger.e('Exception during file upload: $e');
      return null;
    }
  }
}
