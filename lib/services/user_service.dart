// services/user_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class UserService {
  final SupabaseClient _client;
  final AuthService _authService;
  final Logger _logger;

  UserService(this._client, this._authService, this._logger);

  Future<UserModel?> getUserData() async {
    try {
      final userId = _authService.userId;
      if (userId == null) {
        _logger.i('No authenticated user.');
        return null;
      }

      final response =
          await _client.from('users').select().eq('id', userId).maybeSingle();

      if (response == null) {
        _logger.i('No user data available for this user id.');
        return null;
      }

      return UserModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      _logger.e('Exception fetching user data: $e');
      return null;
    }
  }

  Stream<UserModel?> streamUserChanges() {
    final userId = _authService.userId;
    if (userId == null) {
      _logger.i('No authenticated user.');
      return Stream.value(null);
    }

    return _client
        .from('users')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) {
          if (data.isEmpty) {
            _logger.e('No data found for user: $userId');
            return null;
          }
          return UserModel.fromJson(data.first);
        });
  }

  Future<void> updateUserDetails({
    String? name,
    String? email,
    String? avatarUrl,
  }) async {
    try {
      final userId = _authService.currentUser?.id;
      if (userId == null) {
        _logger.i('No authenticated user.');
        return;
      }

      // Build the fields map
      final fields = <String, String>{};
      if (name != null) {
        fields['name'] = name;
      }
      if (email != null) {
        fields['email'] = email;
      }
      if (avatarUrl != null) {
        fields['avatar_url'] = avatarUrl;
      }

      print('Fields: $fields');

      // Check if the user already exists
      final userExistsResponse =
          await _client.from('users').select().eq('id', userId).maybeSingle();

      print('User Exists Response: $userExistsResponse');

      print('UserId = $userId');

      if (userExistsResponse == null) {
        // The user doesn't exist, so insert the new user
        await _client.from('users').insert({
          'id': userId,
          ...fields,
        });
      } else {
        // The user exists, so update the user
        await _client.from('users').update(fields).eq('id', userId);

        // Update the current user in AuthService
        if (name != null) _authService.currentUser?.name = name;
        if (avatarUrl != null) {
          _authService.currentUser?.avatarUrl = avatarUrl;
        }

        // Notify listeners after updating currentUser
        _authService.currentUser = _authService.currentUser;
      }
    } catch (e) {
      _logger.e('Exception updating user details: $e');
    }
  }

  Future<void> updateUserCredits(int credits) async {
    // implement this
  }
}
