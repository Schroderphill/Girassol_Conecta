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
        final user = data["user"];
        await prefs.setString("userEmail", data["user"]["email"]);
        await prefs.setString("role", data["role"] ?? "usuario");

         // Salva o ID retornado pelo backend (user["id"])
      if (user["id"] != null) {
        await prefs.setInt("userId", user["id"]);
      }

      // Salva o status do Termo de Uso (se existir)
      if (user["TermoUso"] != null) {
        await prefs.setString("userTermoUso", user["TermoUso"]);
      }

      // salvar nome para exibir no Drawer ou Header
      if (user["nome"] != null) {
        await prefs.setString("userNome", user["nome"]);
      }

      _logger.i("Sessão salva: ID=${user["id"]}, Role=${data["role"]}");
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
        final user = data["user"]; // Pega o mapa do usuario

        await prefs.setString("userEmail", data["user"]["email"]);
        await prefs.setString("role", data["role"] ?? "usuario");

        //Salva o status inicial do Termo de Uso
        if (user["TermoUso"] != null) {
          await prefs.setString("userTermoUso", user["TermoUso"]);
        }
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

    // Retorna userId como String (ou null)
  static Future<String?> getUserId() async {  
    final prefs = await SharedPreferences.getInstance();
    // tenta ler como inteiro (se foi salvo com setInt)
    final int? idInt = prefs.getInt("userId");
    if (idInt != null) return idInt.toString();
    // fallback para string (se foi salvo com setString)
    return prefs.getString("userId");
  }

  // ACEITAR TERMOS DE USO
  // Atualiza o status do termo de uso no backend e no cache local
  static Future<bool> aceitarTermos(int idUsuario) async {
    // 1. Prepara os dados (Form Data)
    final Map<String, String> bodyData = {
      "action": "editar_usuario", // Usa o action existente
      "idUsuario": idUsuario.toString(),
      "TermoUso": "Sim", // O campo que queremos atualizar
    };

    final response = await http.post(
      // Sua API provavelmente está em index.php ou outro arquivo que roteia as actions
      Uri.parse("$baseUrl/controllers/admin_crud.php"), // Adapte este endpoint se necessário
      headers: {
        // Envia como Form Data, o que popula $_POST no PHP
        "Content-Type": "application/x-www-form-urlencoded", 
      },
      // Envia os dados como string codificada em URL
      body: bodyData,
    );

    try {
      final data = json.decode(response.body);

      if (data["success"] == true) {
        // Atualiza o SharedPreferences local após o sucesso no servidor
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userTermoUso", "Sim"); 

        _logger.i("Termos de uso aceitos e cache atualizado para Sim para o ID: $idUsuario");
        return true;
      } else {
        _logger.w("Falha ao aceitar termos no servidor: ${data["message"]}");
        return false;
      }
    } catch (e) {
      _logger.e("Erro ao processar resposta do servidor para aceitar termos: $e");
      return false;
    }
  }
}
