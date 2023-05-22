import 'package:spacesavers/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final SupabaseClient _client;
  final Logger _logger;
  late final Stream<User?> authStateChanges;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  set currentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  String? get userId => _client.auth.currentUser?.id;

  AuthService(this._client, this._logger) {
    authStateChanges =
        _client.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  Future<UserModel?> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      final response =
          await _client.auth.signUp(email: email, password: password);
      final user = response.user;

      if (user != null) {
        currentUser = UserModel(
          id: user.id,
          email: user.email ?? '',
        );
        return currentUser;
      } else {
        _logger.e('Sign up error: no user data received');
        return null;
      }
    } catch (e) {
      _logger.e('Sign up error', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> signIn(
      String email, String password, UserService userService) async {
    try {
      isLoading.value = true;
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      final user = response.user;

      if (user != null) {
        UserModel? fullUser = await userService.getUserData();
        currentUser = fullUser ??
            UserModel(
              id: user.id,
              email: user.email ?? '',
            );
        return currentUser;
      } else {
        _logger.e('Sign in error: no user data received');
        return null;
      }
    } catch (e) {
      _logger.e('Sign in error', e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      // Also clear the currentUser when the user signs out
      currentUser = null;
    } catch (e) {
      _logger.e('Sign out error', e);
    }
  }

  void dispose() {
    // cancel any other resources or subscriptions...
  }
}
