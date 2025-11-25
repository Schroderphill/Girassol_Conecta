// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/agenda_service.dart';
import '/services/admin_service.dart';
import '/widgets/agenda_adm_modal.dart';

class AgendasController {
  final AgendaService _service = AgendaService();

  /// Controllers de texto para DATA e HORA
  final TextEditingController dataCtrl = TextEditingController();
  final TextEditingController horaCtrl = TextEditingController();

  //Controllers texto AnotaAtendimento
  final TextEditingController anotaAtendimentoCtrl = TextEditingController();

  /// DROPDOWN SELECTED VALUES
  String? profissionalSelecionadoId;
  String? usuarioSelecionadoId;
  String tipoAtendimento = "Acolhimento";

  /// =============================================
  /// 1) CARREGAR DROPDOWNS
  /// =============================================
  Future<List<Map<String, dynamic>>> fetchProfissionais() async {
    return await AdminService.listarProfissionais();
  }

  Future<List<Map<String, dynamic>>> fetchUsuarios() async {
    return await AdminService.listarUsuarios();
  }

  List<String> fetchTiposAtendimento() {
    return ["Acolhimento", "Consulta"];
  }

  /// =============================================
  /// 2) SELETORES DE DATA E HORA
  /// =============================================
  Future<void> selecionarData(BuildContext context) async {
    final hoje = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje.subtract(const Duration(days: 0)),
      lastDate: hoje.add(const Duration(days: 365)),
    );

    if (picked != null) {
      dataCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selecionarHora(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      horaCtrl.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  /// =============================================
  /// 3) VALIDAR FORMULÁRIO
  /// =============================================
  bool validarFormulario(BuildContext context) {
    if (profissionalSelecionadoId == null) {
      alerta(context, "Selecione um profissional.");
      return false;
    }
    if (usuarioSelecionadoId == null) {
      alerta(context, "Selecione um usuário.");
      return false;
    }
    if (dataCtrl.text.isEmpty) {
      alerta(context, "Selecione a data.");
      return false;
    }
    if (horaCtrl.text.isEmpty) {
      alerta(context, "Selecione a hora.");
      return false;
    }
    return true;
  }

  void alerta(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// =============================================
  /// 4) ABRIR O MODAL DE NOVO AGENDAMENTO
  /// =============================================
  Future<void> abrirAddModal(BuildContext context) async {
    dataCtrl.clear();
    horaCtrl.clear();
    profissionalSelecionadoId = null;
    usuarioSelecionadoId = null;

    // DROPDOWNS CARREGADOS DO CONTROLLER
    final profissionais = await fetchProfissionais();
    final usuarios = await fetchUsuarios();
    final tipos = fetchTiposAtendimento();

    await AgendaAdmModals.showAddModal(
      context: context,
      profissionalDropdown: _buildProfissionalDropdown(profissionais),
      usuarioDropdown: _buildUsuarioDropdown(usuarios),
      tipoDropdown: _buildTipoDropdown(tipos),

      dataCtrl: dataCtrl,
      horaCtrl: horaCtrl,
      onSelectData: () => selecionarData(context),
      onSelectHora: () => selecionarHora(context),

      onSave: () async {
        if (!validarFormulario(context)) return;

        await _service.addAgenda({
        'Profissional_idProfissional': profissionalSelecionadoId!,
        'Usuario_idUsuario': usuarioSelecionadoId!,
        'Tipo_solicitacao': tipoAtendimento,
        'DataAtendimento': dataCtrl.text,
        'HoraAtendimento': horaCtrl.text,
        });

        Navigator.pop(context);
        alerta(context, "Agendamento criado com sucesso!");
      },
    );
  }

  /// =============================================
  /// 5) ABRIR O MODAL DE EDIÇÃO
  /// =============================================
  Future<void> abrirEditModal(BuildContext context, Map agenda) async {
    dataCtrl.text = agenda["DataAtendimento"] ?? '';
    horaCtrl.text = agenda["HoraAtendimento"] ?? '';

    await AgendaAdmModals.showEditModal(
      context: context,
      dataCtrl: dataCtrl,
      horaCtrl: horaCtrl,
      onSelectData: () => selecionarData(context),
      onSelectHora: () => selecionarHora(context),
      onSave: () async {
        await _service.updateAgenda(
          agenda["idAtendimento"].toString(),
          {
            "DataAtendimento": dataCtrl.text,
            "HoraAtendimento": horaCtrl.text,
            "Status": "Agendado",
          },
        );

        Navigator.pop(context);
        alerta(context, "Agendamento atualizado!");
      },
    );
  }


  Future<void> abrirAtendeModal(BuildContext context, Map agenda) async {
    anotaAtendimentoCtrl.text = agenda["AnotaAtendimento"] ?? '';
    //horaCtrl.text = agenda["HoraAtendimento"] ?? '';

    await AgendaAdmModals.showFinalizeModal(
      context: context,
      anotaAtendimentoCtrl: anotaAtendimentoCtrl,
      //dataCtrl: dataCtrl,
     // horaCtrl: horaCtrl,
     // onSelectData: () => selecionarData(context),
     // onSelectHora: () => selecionarHora(context),
      onSave: () async {
        await _service.updateAgenda(
          agenda["idAtendimento"].toString(),
          {
            "AnotaAtendimento": anotaAtendimentoCtrl.text,
            //"HoraAtendimento": horaCtrl.text,
            "Status": "Finalizado",
          },
        );

        Navigator.pop(context);
        alerta(context, "Atendimento Finalizado!");
      },
    );
  }

  /// =============================================
  /// 6) ABRIR MODAL DE CANCELAMENTO
  /// =============================================
  Future<void> abrirCancelModal(BuildContext context, String idAtendimento) async {
    await AgendaAdmModals.showCancelModal(
      context: context,
      onConfirm: () async {
        await _service.updateAgenda(
          idAtendimento,
          {"Status": "Cancelado"},
        );

        Navigator.pop(context);
        alerta(context, "Agendamento cancelado!");
      },
    );
  }

  /// =============================================
  /// 7) WIDGETS PARA DROPDOWN DINÂMICO
  /// =============================================
  Widget _buildProfissionalDropdown(List<Map<String, dynamic>> items) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Profissional",
        border: OutlineInputBorder(),
      ),
      items: items.map((p) {
        return DropdownMenuItem(
          value: p["idProfissional"].toString(),
          child: Text(p["NomeSocial"].toString()),
        );
      }).toList(),
      onChanged: (v) => profissionalSelecionadoId = v,
    );
  }

  Widget _buildUsuarioDropdown(List<Map<String, dynamic>> items) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Usuário",
        border: OutlineInputBorder(),
      ),
      items: items.map((p) {
        return DropdownMenuItem(
          value: p["idUsuario"].toString(),
          child: Text(p["NomeSocial"].toString()),
        );
      }).toList(),
      onChanged: (v) => usuarioSelecionadoId = v,
    );
  }

  Widget _buildTipoDropdown(List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Tipo Atendimento",
        border: OutlineInputBorder(),
      ),
      initialValue: tipoAtendimento,
      items: items.map((t) {
        return DropdownMenuItem(
          value: t,
          child: Text(t),
        );
      }).toList(),
      onChanged: (v) => tipoAtendimento = v!,
    );
  }
}