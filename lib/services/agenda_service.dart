import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AgendaService {
  static final Logger _logger = Logger();
  static const String baseUrl =
      "http://10.0.2.2/gc_api/controllers/agenda_crud.php";

  /// 🔹 Buscar todas as agendas simples (CRUD read)
    Future<List<dynamic>> fetchAgendas({Map<String, dynamic>? filtros}) async {
    try {
      // 1. Constrói a URL base com a action
      String url = '$baseUrl?action=agenda_read';

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
        
        // ... o restante da sua lógica de tratamento de resposta permanece o mesmo
        if (decoded is Map && decoded['data'] != null) {
          final List<dynamic> agendas = decoded['data'];
          _logger.i('Fetched ${agendas.length} agendas successfully.');
          return agendas;
        }
        _logger.w('Response body não contém campo "data".');
        return [];
      } else {
        _logger.e(
          'Failed to load agendas. Status code: ${response.statusCode}');
        throw Exception('Failed to load agendas');
      }
    } catch (e) {
      _logger.e('Error fetching agendas: $e');
      rethrow;
    }
  }

  /// 🔹 Buscar agendamentos com INNER JOIN (tipo + sessão)
  Future<List<dynamic>> fetchAgendaView({
    String? tipoProfissional,
    String? idSessao,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'agenda_view',
          if (tipoProfissional != null) 'tipoProfissional': tipoProfissional,          
          if (idSessao != null) 'idSessao': idSessao,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          final List<dynamic> data = decoded['data'];
          _logger.i('Fetched ${data.length} agendamentos com sucesso.');
          return data;
        } else {
          _logger.w('Agenda view retornou erro: ${decoded['message']}');
          return [];
        }
      } else {
        _logger.e(
            'Failed to load agenda view. Status code: ${response.statusCode}');
        throw Exception('Failed to load agenda view');
      }
    } catch (e) {
      _logger.e('Error fetching agenda view: $e');
      rethrow;
    }
  }

  /// 🔹 Buscar prontuarios com INNER JOIN (view)
  Future<List<dynamic>> fetchProntuarioView({
    String? status,
    String? idSessao,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'prontuario_view', // Alterado a action
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

  /// 🔹 Criar novo agendamento
  Future<bool> addAgenda(Map<String, dynamic> agendaData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'agenda_create',
          ...agendaData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Agenda added successfully.');
          return true;
        } else {
          _logger.w('Erro ao adicionar agenda: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to add agenda. Status code: ${response.statusCode}');
        throw Exception('Failed to add agenda');
      }
    } catch (e) {
      _logger.e('Error adding agenda: $e');
      rethrow;
    }
  }

  /// 🔹 Atualizar agendamento
  Future<bool> updateAgenda(String id, Map<String, dynamic> agendaData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'agenda_update',
          'idAtendimento': id,
          ...agendaData,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Agenda updated successfully.');
          return true;
        } else {
          _logger.w('Erro ao atualizar agenda: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to update agenda. Status code: ${response.statusCode}');
        throw Exception('Failed to update agenda');
      }
    } catch (e) {
      _logger.e('Error updating agenda: $e');
      rethrow;
    }
  }

  /// 🔹 Deletar agendamento
  Future<bool> deleteAgenda(String agendaId) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'agenda_delete',
          'id': agendaId,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true) {
          _logger.i('Agenda deleted successfully.');
          return true;
        } else {
          _logger.w('Erro ao deletar agenda: ${decoded['message']}');
          return false;
        }
      } else {
        _logger.e(
            'Failed to delete agenda. Status code: ${response.statusCode}');
        throw Exception('Failed to delete agenda');
      }
    } catch (e) {
      _logger.e('Error deleting agenda: $e');
      rethrow;
    }
  }
}
