import 'package:shared_preferences/shared_preferences.dart';

import '../service/api_service.dart';

class AuthRepository {
  final ApiService apiService;
  final SharedPreferences prefs;
  static const String _tokenKey = 'auth_token';

  AuthRepository({required this.apiService, required this.prefs});

  Future<void> login(String username, String password) async {
    final response = await apiService.login(username, password);
    final token = response['accessToken'] as String?;
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    } else {
      throw Exception('Token not found in login response');
    }
  }

  Future<String?> getToken() async {
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    await prefs.remove(_tokenKey);
  }
}
