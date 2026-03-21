import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';

class AuthService {
  AuthService._();

  static const _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static const _accessTokenKey = 'access_token';
  static const _userIdKey = 'user_id';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleServerClientId.isEmpty
        ? null
        : _googleServerClientId,
  );

  static Future<void> signOutAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userIdKey);
    ApiClient.instance.setAccessToken(null);

    // Ignore errors for first-time users who are not signed in yet.
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  static Future<void> signInWithGoogle() async {
    // Force account picker every time the Google button is tapped.
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign-in was canceled');
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to get Google id_token');
    }

    final response = await ApiClient.instance.dio.post(
      '/auth/google',
      data: {'id_token': idToken},
    );

    final data = response.data as Map<String, dynamic>;
    final accessToken = data['access_token'] as String?;
    final user = data['user'] as Map<String, dynamic>?;
    final userId = user?['id'] as String?;

    if (accessToken == null ||
        accessToken.isEmpty ||
        userId == null ||
        userId.isEmpty) {
      throw Exception('Invalid auth response from server');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_userIdKey, userId);

    ApiClient.instance.setAccessToken(accessToken);
  }
}
