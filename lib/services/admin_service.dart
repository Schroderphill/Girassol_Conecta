import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AdminService {
  static final Logger _logger = Logger();
  static const String baseUrl = "http://10.0.2.2/gc_api/admin_crud.php";

  /// LISTAR TODOS OS USUÁRIOS
  static Future<List<Map<String, dynamic>>> listarUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?action=listar"),
      );

      final data = json.decode(response.body);

      if (data["success"] == true && data["data"] is List) {
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        _logger.e("Erro ao listar usuários: ${data['message']}");
        return [];
      }
    } catch (e) {
      _logger.e("Erro na requisição listarUsuarios(): $e");
      return [];
    }
  }

  /// EXCLUIR USUÁRIO
  static Future<bool> excluirUsuario(int idUsuario) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          "action": "excluir",
          "id": idUsuario.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        return true;
      } else {
        _logger.e("Erro ao excluir usuário: ${data['message']}");
        return false;
      }
    } catch (e) {
      _logger.e("Erro na requisição excluirUsuario(): $e");
      return false;
    }
  }

//-------------------------------------------------------------------------------
//-------------------------------PROFISSIONAIS -------------------------------
//-------------------------------------------------------------------------------

  /// ✅ 1. LISTAR PROFISSIONAIS
  static Future<List<Map<String, dynamic>>> listarProfissionais({String? tipo}) async {
    try {
       final url = tipo == null || tipo.isEmpty
        ? Uri.parse("$baseUrl?action=listar_profissional")
        : Uri.parse("$baseUrl?action=listar_profissional&tipo=$tipo");

    final response = await http.get(url);

      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData["success"] == true && jsonData["data"] is List) {
        return List<Map<String, dynamic>>.from(jsonData["data"]);
      } else {
        final msg = jsonData["message"] ?? "Erro desconhecido ao listar profissionais.";
        _logger.e("Erro ao listar profissionais: $msg");
        return [];
      }
    } catch (e) {
      _logger.e("Falha na requisição listarProfissionais: $e");
      return [];
    }
  }

  /// ✅ 2. CADASTRAR PROFISSIONAL
  static Future<(bool, String)> cadastrarProfissional(Map<String, dynamic> dados) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl?action=cadastrar_profissional"),
        body: dados,
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ?? (success ? "Profissional cadastrado com sucesso!" : "Erro ao cadastrar profissional.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao cadastrar profissional: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  /// ✅ 3. EDITAR PROFISSIONAL
  static Future<(bool, String)> editarProfissional(int id, Map<String, dynamic> dados) async {
    try {
      final Map<String, dynamic> body = {
        "id": id.toString(),
        ...dados,
      };

      final response = await http.post(
        Uri.parse("$baseUrl?action=editar_profissional"),
        body: body,
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ?? (success ? "Profissional atualizado com sucesso!" : "Erro ao editar profissional.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao editar profissional: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  /// ✅ 4. EXCLUIR PROFISSIONAL
  static Future<(bool, String)> excluirProfissional(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl?action=excluir_profissional"),
        body: {"id": id.toString()},
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ?? (success ? "Profissional excluído com sucesso!" : "Erro ao excluir profissional.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao excluir profissional: $e");
      return (false, "Falha na conexão com o servidor.");
    }

  }

  //=============================================================
  //===========================EVENTOS===========================
  //=============================================================

  /// LISTAR EVENTOS
  static Future<List<Map<String, dynamic>>> listarEvento() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl?action=listar_evento"),
      );

      final data = json.decode(response.body);

      if (data["success"] == true && data["data"] is List) {
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        _logger.e("Erro ao listar eventos: ${data['message']}");
        return [];
      }
    } catch (e) {
      _logger.e("Erro na requisição listarEventos(): $e");
      return [];
    }
  }

  /// CRIAR EVENTO
  static Future<(bool, String)> criarEvento(Map<String, dynamic> dados) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl?action=criar_evento"),
        body: dados,
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ?? (success ? "Evento criado com sucesso!" : "Erro ao criar evento.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao criar evento: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  /// EXCLUIR EVENTO
  static Future<(bool, String)> excluirEvento(int idEvento) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          "action": "excluir_evento",
          "id": idEvento.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data["success"] == true) {
        return (true, "Evento excluído com sucesso!");
      } else {
        final msg = data["message"] ?? "Erro desconhecido ao excluir evento.";
        _logger.e("Erro ao excluir evento: $msg");
        return ( msg);
      }
    } catch (e) {
      _logger.e("Erro na requisição excluirEvento(): $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  //EDITAR EVENTO
  static Future<(bool, String)> editarEvento(int id, Map<String, dynamic> dados) async {
    try {
      final Map<String, dynamic> body = {
        "id": id.toString(),
        ...dados,
      };

      final response = await http.post(
        Uri.parse("$baseUrl?action=editar_evento"),
        body: body,
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ?? (success ? "Evento atualizado com sucesso!" : "Erro ao editar evento.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao editar evento: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

}
