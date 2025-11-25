import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AcolhimentoService {
  static final Logger _logger = Logger();
  // Alterado o endpoint para 'acolhimento_crud.php'
  static const String baseUrl =
      "http://10.0.2.2/gc_api/controllers/acolhimento_crud.php"; 

  // --- MÉTODOS CRUD BÁSICOS ---

  /// 🔹 Buscar todos os acolhimentos simples (CRUD read)
 /* Future<List<dynamic>> fetchAcolhimentos({Map<String, dynamic>? filtros}) async {
    try {
      // 1. Constrói a URL base com a action
      String url = '$baseUrl?action=acolhimento_read'; // Alterado a action

      // 2. Adiciona filtros se existirem
      if (filtros != null && filtros.isNotEmpty) {
        // Itera sobre os filtros e adiciona cada par chave/valor à URL
        filtros.forEach((key, value) {
          // Encodifica a chave e o valor para uso seguro na URL
          url += '&${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value.toString())}';
        });
      }

      // 3. Realiza a requisição HTTP com a URL construída
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        
        if (decoded is Map && decoded['data'] != null) {
          final List<dynamic> acolhimentos = decoded['data'];
          _logger.i('Fetched ${acolhimentos.length} acolhimentos successfully.');
          return acolhimentos;
        }
        _logger.w('Response body não contém campo "data".');
        return [];
      } else {
        _logger.e(
          'Failed to load acolhimentos. Status code: ${response.statusCode}');
        throw Exception('Failed to load acolhimentos');
      }
    } catch (e) {
      _logger.e('Error fetching acolhimentos: $e');
      rethrow;
    }
  }*/

  /// 🔹 Buscar acolhimentos com INNER JOIN (view)
  Future<List<dynamic>> fetchAcolhimentoView({
    String? status,
    String? idSessao,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'acolhimento_view', // Alterado a action
         if (status != null) 'Status': status,
          if (idSessao != null) 'idSessao': idSessao,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          final List<dynamic> data = decoded['data'];
          _logger.i('Fetched ${data.length} acolhimentos view com sucesso.');
          return data;
        } else {
          _logger.w('Acolhimento view retornou erro: ${decoded['message']}');
          return [];
        }
      } else {
        _logger.e(
            'Failed to load acolhimento view. Status code: ${response.statusCode}');
        throw Exception('Failed to load acolhimento view');
      }
    } catch (e) {
      _logger.e('Error fetching acolhimento view: $e');
      rethrow;
    }
  }
  //============================================================
  /// CRIA E ATUALIZA ACOLHIMENTO FAMILIAR
  ///============================================================
  Future<bool> addAcolhimentoFamilia(Map<String, dynamic> acolhimentoData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'nucleofamiliar_create', // Alterado a action
          ...acolhimentoData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Acolhimento added successfully.');
          return true;
        } else {
          _logger.w('Erro ao adicionar acolhimento: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to add acolhimento. Status code: ${response.statusCode}');
        throw Exception('Failed to add acolhimento');
      }
    } catch (e) {
      _logger.e('Error adding acolhimento: $e');
      rethrow;
    }
  }

  /// 🔹 Atualizar acolhimento
  Future<bool> updateAcolhimentoFamilia(String id, Map<String, dynamic> acolhimentoData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'nucleofamiliar_update', // Alterado a action
          // Supondo que a chave de ID seja a mesma da Agenda (idAtendimento)
          'Usuario_idUsuario': id, 
          ...acolhimentoData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Acolhimento updated successfully.');
          return true;
        } else {
          _logger.w('Erro ao atualizar acolhimento: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to update acolhimento. Status code: ${response.statusCode}');
        throw Exception('Failed to update acolhimento');
      }
    } catch (e) {
      _logger.e('Error updating acolhimento: $e');
      rethrow;
    }
  }

  //============================================================
  /// CRIA E ATUALIZA CAD SOCIOECONÔMICO
  ///============================================================
  
  Future<bool> addAcolhimentoSocioecon(Map<String, dynamic> acolhimentoData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'cadsocioecon_create', // Alterado a action
          ...acolhimentoData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Acolhimento added successfully.');
          return true;
        } else {
          _logger.w('Erro ao adicionar acolhimento: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to add acolhimento. Status code: ${response.statusCode}');
        throw Exception('Failed to add acolhimento');
      }
    } catch (e) {
      _logger.e('Error adding acolhimento: $e');
      rethrow;
    }
  }

  /// 🔹 Atualizar acolhimento
  Future<bool> updateAcolhimentoSocioecon(String id, Map<String, dynamic> acolhimentoData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'cadsocioecon_update', // Alterado a action
          // Supondo que a chave de ID seja a mesma da Agenda (idAtendimento)
          'Usuario_idUsuario': id, 
          ...acolhimentoData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Acolhimento updated successfully.');
          return true;
        } else {
          _logger.w('Erro ao atualizar acolhimento: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to update acolhimento. Status code: ${response.statusCode}');
        throw Exception('Failed to update acolhimento');
      }
    } catch (e) {
      _logger.e('Error updating acolhimento: $e');
      rethrow;
    }
  }

  
}