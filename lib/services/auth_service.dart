import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  static final Logger _logger = Logger();
  static const String baseUrl = "http://10.0.2.2/gc_api"; // URL base da API

  // LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "login",
        "email": email,
        "senha": password,
      }),
    );

    try {
      final data = json.decode(response.body);

      if (data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userEmail", data["user"]["email"]);
        await prefs.setString("role", data["role"] ?? "usuario");
      }

      return data; // <-- retorna o Map completo
    } catch (e) {
      _logger.e("Erro ao decodificar resposta: ${response.body}");
      return {"success": false, "message": "Erro ao processar resposta do servidor"};
    }
  }

  // REGISTER 
  static Future<Map<String, dynamic>> register(
    String nome,
    String nomeSocial,
    String cpf,
    String cns,
    String dataNascimento,
    String contato,
    String email,
    String senha,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register.php"), // Chama o endpoint register.php
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "register",
        "nome": nome,
        "nomeSocial": nomeSocial,
        "cpf": cpf,
        "cns": cns,
        "dataNascimento": dataNascimento,
        "contato": contato,
        "email": email,
        "senha": senha,
      }),
    );

    try {
      final data = json.decode(response.body);

      if (data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userEmail", data["user"]["email"]);
        await prefs.setString("role", data["role"] ?? "usuario");
      }

      return data; // <-- retorna o Map completo
    } catch (e) {
      _logger.e("Erro ao decodificar resposta: ${response.body}");
      return {"success": false, "message": "Erro ao processar resposta do servidor"};
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    await http.post(Uri.parse("$baseUrl/logout.php"));
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Verifica se usuário já está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("userEmail");
  }
}
