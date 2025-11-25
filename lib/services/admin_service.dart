import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AdminService {
  static final Logger _logger = Logger();
  static const String baseUrl = "http://10.0.2.2/gc_api/controllers/admin_crud.php";

  // ==========================================================
// CRUD PARA TABELA USUÁRIO (ADMIN)
// ==========================================================

static Future<List<Map<String, dynamic>>> listarUsuarios() async {
  try {
    //final baseUrl = await ApiConfig.getBaseUrl();
    final url = Uri.parse("$baseUrl?action=listar_usuario");

    final response = await http.get(url);
    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (jsonData["success"] == true && jsonData["data"] is List) {
      return List<Map<String, dynamic>>.from(jsonData["data"]);
    } else {
      final msg = jsonData["message"] ?? "Erro desconhecido ao listar usuários.";
      _logger.e("Erro ao listar usuários: $msg");
      return [];
    }
  } catch (e) {
    _logger.e("Falha na requisição listarUsuarios: $e");
    return [];
  }
}

// ==========================================================
// CADASTRAR NOVO USUÁRIO
// ==========================================================
static Future<(bool, String)> cadastrarUsuario(Map<String, dynamic> usuario) async {
  try {
    final url = Uri.parse("$baseUrl?action=cadastrar_usuario");

    final response = await http.post(url, body: usuario);
    final Map<String, dynamic> jsonData = json.decode(response.body);

    final bool ok = jsonData["success"] == true;
    final String msg = (jsonData["message"] as String?) ??
        (ok ? "Usuário adicionado com sucesso." : "Falha ao adicionar usuário.");

    return (ok, msg);
  } catch (e) {
    _logger.e("Erro ao adicionar usuário: $e");
    return (false, "Erro na requisição: $e");
  }
}

// ==========================================================
// EDITAR USUÁRIO EXISTENTE
// ==========================================================
static Future<(bool, String)> editarUsuario(int id, Map<String, dynamic> dados) async {
  try {
    //  Monta o corpo da requisição com tudo convertido para String
    final Map<String, String> body = {
      "idUsuario": id.toString(),
      ...dados.map((key, value) {
        if (value == null) return MapEntry(key, '');
        return MapEntry(key, value.toString());
      }),
    };

    final response = await http.post(
      Uri.parse("$baseUrl?action=editar_usuario"),
      body: body,
    );

    final Map<String, dynamic> jsonData = json.decode(response.body);
    final bool success = jsonData["success"] == true;
    final String message = (jsonData["message"] as String?) ??
        (success ? "Profissional atualizado com sucesso!" : "Erro ao editar profissional.");

    return (success, message);
  } catch (e) {
    _logger.e("Erro ao editar profissional: $e");
    return (false, "Falha na conexão com o servidor.");
  }
}

// ==========================================================
// EXCLUIR USUÁRIO
// ==========================================================
static Future<(bool, String)> excluirUsuario(int idUsuario) async {
  try {
    final url = Uri.parse("$baseUrl?action=excluir_usuario&idUsuario=$idUsuario");

    final response = await http.get(url);
    final Map<String, dynamic> jsonData = json.decode(response.body);

    final bool ok = jsonData["success"] == true;
    final String msg = (jsonData["message"] as String?) ??
        (ok ? "Usuário excluído com sucesso." : "Falha ao excluir usuário.");

    return (ok, msg);
  } catch (e) {
    _logger.e("Erro ao excluir usuário: $e");
    return (false, "Erro na requisição: $e");
  }
}

// ==========================================================
// VISUALIZAR / BUSCAR USUÁRIO ESPECÍFICO
// ==========================================================
static Future<Map<String, dynamic>?> verUsuario({required String id}) async {
      try {
        final url = Uri.parse("$baseUrl/?action=listar_usuario&id=$id");
        _logger.i("Buscando usuário por ID: $id | URL: $url");

        final response = await http.get(url);

        if (response.statusCode != 200) {
          _logger.w("Erro HTTP: ${response.statusCode}");
          return null;
        }

        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Verifica sucesso e conteúdo
        if (jsonData["success"] == true && jsonData["data"] != null) {
          final data = jsonData["data"];

          if (data is List && data.isNotEmpty) {
            return Map<String, dynamic>.from(data.first);
          } else if (data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(data);
          }
        }

        _logger.w("Nenhum dado encontrado para o ID: $id");
        return null;
      } catch (e, stack) {
        _logger.e("Erro ao buscar profissional por ID: $e", stackTrace: stack);
        return null;
      }
    }


//-------------------------------------------------------------------------------
//-------------------------------PROFISSIONAIS -------------------------------
//-------------------------------------------------------------------------------

  /// LISTAR PROFISSIONAIS
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
//=======================================================================
      ///  BUSCAR PROFISSIONAL POR ID (usado no perfil)
/// ======================================================
    static Future<Map<String, dynamic>?> getProfissionalById({required String id}) async {
      try {
        final url = Uri.parse("$baseUrl/?action=listar_profissional&id=$id");
        _logger.i("Buscando profissional por ID: $id | URL: $url");

        final response = await http.get(url);

        if (response.statusCode != 200) {
          _logger.w("Erro HTTP: ${response.statusCode}");
          return null;
        }

        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Verifica sucesso e conteúdo
        if (jsonData["success"] == true && jsonData["data"] != null) {
          final data = jsonData["data"];

          if (data is List && data.isNotEmpty) {
            return Map<String, dynamic>.from(data.first);
          } else if (data is Map<String, dynamic>) {
            return Map<String, dynamic>.from(data);
          }
        }

        _logger.w("Nenhum dado encontrado para o ID: $id");
        return null;
      } catch (e, stack) {
        _logger.e("Erro ao buscar profissional por ID: $e", stackTrace: stack);
        return null;
      }
    }

//=======================================================================
  /// CADASTRAR PROFISSIONAL
//=======================================================================
  static Future<(bool, String)> cadastrarProfissional(Map<String, dynamic> dados) async {
    try {
      // Converte valores nulos para string vazia
      final Map<String, String> body = dados.map((key, value) {
        return MapEntry(key, value?.toString() ?? '');
      });

      final response = await http.post(
        Uri.parse("$baseUrl?action=cadastrar_profissional"),
        body: body,
      );

      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ??
          (success ? "Profissional cadastrado com sucesso!" : "Erro ao cadastrar profissional.");

      return (success, message);
    } catch (e) {
      _logger.e("Erro ao cadastrar profissional: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }


//=======================================================================
// EDITAR PROFISSIONAL
//=======================================================================
static Future<(bool, String)> editarProfissional(int id, Map<String, dynamic> dados) async {
  try {
    //  Monta o corpo da requisição com tudo convertido para String
    final Map<String, String> body = {
      "idProfissional": id.toString(),
      ...dados.map((key, value) {
        if (value == null) return MapEntry(key, '');
        return MapEntry(key, value.toString());
      }),
    };

    final response = await http.post(
      Uri.parse("$baseUrl?action=editar_profissional"),
      body: body,
    );

    final Map<String, dynamic> jsonData = json.decode(response.body);
    final bool success = jsonData["success"] == true;
    final String message = (jsonData["message"] as String?) ??
        (success ? "Profissional atualizado com sucesso!" : "Erro ao editar profissional.");

    return (success, message);
  } catch (e) {
    _logger.e("Erro ao editar profissional: $e");
    return (false, "Falha na conexão com o servidor.");
  }
}


  /// EXCLUIR PROFISSIONAL 
static Future<(bool, String)> excluirProfissional(int id) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl?action=excluir_profissional"),
      body: {"idProfissional": id.toString()},
    );

    // Log útil para debugging (mantém no logger, não no UI)
    _logger.i("Resposta excluir_profissional (status ${response.statusCode}): ${response.body}");

    // Tenta decodificar JSON. Se falhar, trata de forma segura.
    try {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final bool success = jsonData["success"] == true;
      final String message = (jsonData["message"] as String?) ??
          (success ? "Profissional excluído com sucesso!" : "Erro ao excluir profissional.");
      return (success, message);
    } on FormatException catch (e) {
      // Resposta não é JSON — sanitiza e retorna mensagem genérica
      _logger.e("Excluir profissional: resposta inválida JSON: $e");

      // Remove tags HTML (simples) e limita o tamanho da mensagem
      String sanitized = response.body.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
      if (sanitized.length > 300) sanitized = '${sanitized.substring(0, 300)}...';

      // Mensagem amigável para mostrar no app
      final String userMessage = "Resposta inesperada do servidor. Conteúdo: $sanitized";

      return (false, userMessage);
    }
  } catch (e, st) {
    _logger.e("Erro ao excluir profissional: $e\n$st");
    return (false, "Falha na conexão com o servidor.");
  }
}

// ===============================================================
  // ======================= ATIVIDADES ============================
  // ===============================================================

  /// Listar todas as atividades
  static Future<List<dynamic>> listarAtividades() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'action': 'listar_atividades'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['success'] == true) {
          return data['data'] ?? [];
        }
      }
    } catch (e) {
      _logger.e("Erro ao listar atividades: $e");
    }
    return [];
  }

  ///  Buscar detalhes de uma atividade específica
  static Future<Map<String, dynamic>?> detalharAtividade(
      int idAtividade) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'action': 'buscar_atividade', 'id': idAtividade.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['success'] == true) return data['data'];
      }
    } catch (e) {
      _logger.e("Erro ao detalhar atividade: $e");
    }
    return null;
  }

  ///  Criar nova atividade (com upload de imagem)
  static Future<(bool, String)> criarAtividade({
    required String tituloAtividade,
    required String descAtividade,
    required String data,
    required String hora,
    required String localAtividade,
    required int profissionalId,
    required int voluntarioId,
    required String imagemPath,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl))
        ..fields['action'] = 'criar_atividade'
        ..fields['tituloAtividade'] = tituloAtividade
        ..fields['descAtividade'] = descAtividade
        ..fields['data'] = data
        ..fields['hora'] = hora
        ..fields['localAtividade'] = localAtividade
        ..fields['profissional_idProfissional'] = profissionalId.toString()
        ..fields['useridVoluntario'] = voluntarioId.toString();

      if (imagemPath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('imagem', imagemPath));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseBody);

      final bool success = jsonData['success'] == true;
      final String message = (jsonData['message'] as String?) ?? 'Erro ao criar atividade.';
      return (success, message);
    } catch (e) {
      _logger.e("Erro ao criar atividade: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  ///  Editar atividade existente
  static Future<(bool, String)> editarAtividade({
    required int idAtividade,
    required String tituloAtividade,
    required String descAtividade,
    required String data,
    required String hora,
    required String localAtividade,
    String? imagemPath,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl))
        ..fields['action'] = 'editar_atividade'
        ..fields['idAtividade'] = idAtividade.toString()
        ..fields['tituloAtividade'] = tituloAtividade
        ..fields['descAtividade'] = descAtividade
        ..fields['data'] = data
        ..fields['hora'] = hora
        ..fields['localAtividade'] = localAtividade;

      if (imagemPath != null && imagemPath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('imagem', imagemPath));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseBody);

      final bool success = jsonData['success'] == true;
      final String message = (jsonData['message'] as String?) ?? 'Erro ao editar atividade.';
      return (success, message);
    } catch (e) {
      _logger.e("Erro ao editar atividade: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  /// Excluir atividade
  static Future<(bool, String)> excluirAtividade(int idAtividade) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {'action': 'excluir_atividade', 'idAtividade': idAtividade.toString()},
      );

      final data = jsonDecode(response.body);
      final bool success = data['success'] == true;
      final String message = (data['message'] as String?) ?? 'Erro ao excluir.';
      return (success, message);
    } catch (e) {
      _logger.e("Erro ao excluir atividade: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }

  ///  Usuário participa de uma atividade
  static Future<(bool, String)> participarAtividade({
    required int idUsuario,
    required int idAtividade,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'participar_atividade',
          'idUsuario': idUsuario.toString(),
          'idAtividade': idAtividade.toString(),
        },
      );

      final data = jsonDecode(response.body);
      final bool success = data['success'] == true;
      final String message = (data['message'] as String?) ?? 'Erro ao registrar participação.';
      return (success, message);
    } catch (e) {
      _logger.e("Erro ao participar atividade: $e");
      return (false, "Falha na conexão com o servidor.");
    }
  }
 
}