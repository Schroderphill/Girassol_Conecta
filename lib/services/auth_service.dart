import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  static final Logger _logger = Logger();
  static const String baseUrl = "http://10.0.2.2/gc_api"; // URL base da API

  static Future<bool> login(String email, String password) async {
  final response = await http.post(
    Uri.parse("$baseUrl/login.php"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  try {
    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userEmail", data['user']['email']);
      return true;
    } else {
      _logger.e("Login falhou: ${data['message']}");
    }
    return false;
  } catch (e) {
    _logger.e("Erro ao decodificar resposta: ${response.body}");
    return false;
  }
}
  static Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    try {
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userEmail", data['user']['email']);
        return true;
      }
      return false;
    } catch (e) {
      _logger.e("Erro ao decodificar resposta: ${response.body}");
      return false;
    }
  }
  static Future<void> logout() async {
    await http.post(Uri.parse("$baseUrl/logout.php"));
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("userEmail");
  }
}
