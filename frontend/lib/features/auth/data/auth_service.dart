import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';

class AuthService {
  AuthService._();

  static const _googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  static const _googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static const _accessTokenKey = 'access_token';
  static const _userIdKey = 'user_id';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _googleIosClientId.isEmpty ? null : _googleIosClientId,
    serverClientId: _googleServerClientId.isEmpty
        ? null
        : _googleServerClientId,
  );

  static bool get isGoogleConfigured => _googleServerClientId.isNotEmpty;

  static String get googleConfigurationHelp =>
      'Missing GOOGLE_SERVER_CLIENT_ID. Run with --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>.';

  // 앱 시작 시 저장된 토큰을 Dio 헤더에 복원한다.
  static Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    if (token == null || token.isEmpty) return false;
    ApiClient.instance.setAccessToken(token);
    return true;
  }

  static Future<void> signOutAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_userIdKey);
    ApiClient.instance.setAccessToken(null);

    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  static Future<void> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final idToken = credential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Failed to get Apple identity token');
    }

    final response = await ApiClient.instance.dio.post(
      '/auth/apple',
      data: {'id_token': idToken},
    );

    await _saveAuthResponse(response.data as Map<String, dynamic>);
  }

  static Future<void> signInWithGoogle() async {
    if (!isGoogleConfigured) {
      throw Exception(googleConfigurationHelp);
    }

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

    await _saveAuthResponse(response.data as Map<String, dynamic>);
  }

  static Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.instance.dio.post(
      '/auth/login',
      data: {'email': email.trim().toLowerCase(), 'password': password},
    );

    await _saveAuthResponse(response.data as Map<String, dynamic>);
  }

  static Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final response = await ApiClient.instance.dio.post(
      '/auth/signup',
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
        'nickname': nickname.trim(),
      },
    );

    await _saveAuthResponse(response.data as Map<String, dynamic>);
  }

  static Future<String?> requestPasswordReset(String email) async {
    final response = await ApiClient.instance.dio.post(
      '/auth/forgot-password',
      data: {'email': email.trim().toLowerCase()},
    );

    final data = response.data as Map<String, dynamic>;
    return data['reset_token'] as String?;
  }

  static Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await ApiClient.instance.dio.post(
      '/auth/reset-password',
      data: {'token': token.trim(), 'new_password': newPassword},
    );
  }

  static Future<void> _saveAuthResponse(Map<String, dynamic> data) async {
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
