// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/services/acolhimento_service.dart';
import '/services/agenda_service.dart';
import '/widgets/acolhimento_adm_modal.dart';

class AcolhimentoController {
  final AcolhimentoService _service = AcolhimentoService();
  final AgendaService _auxService = AgendaService();

  // ============================================================
  // 1) CONTROLLERS DO NÚCLEO FAMILIAR
  // ============================================================

  final TextEditingController familiarNomeCtrl = TextEditingController();
  final TextEditingController familiarNomeSocialCtrl = TextEditingController();
  final TextEditingController familiarIdadeCtrl = TextEditingController();
  final TextEditingController familiarGeneroCtrl = TextEditingController();
  final TextEditingController familiarEscolaridadeCtrl = TextEditingController();
  final TextEditingController familiarParentescoCtrl = TextEditingController();
  final TextEditingController familiarProfissaoCtrl = TextEditingController();
  final TextEditingController familiarDrogasCtrl = TextEditingController(); // Sim/Nao


  // ============================================================
  // 2) CONTROLLERS DO CADASTRO SOCIOECONÔMICO
  // ============================================================

  final TextEditingController economicoEstadoCivilCtrl = TextEditingController();
  final TextEditingController economicoNaturalidadeCtrl = TextEditingController();
  final TextEditingController economicoCorCtrl = TextEditingController();
  final TextEditingController economicoBeneficioSocCtrl = TextEditingController();

  final TextEditingController economicoEnderecoCtrl = TextEditingController();
  final TextEditingController economicoBairroCtrl = TextEditingController();
  final TextEditingController economicoNumeroCtrl = TextEditingController();
  final TextEditingController economicoNrNisCtrl = TextEditingController();

  final TextEditingController economicoRendaCtrl = TextEditingController();
  final TextEditingController economicoProfissaoCtrl = TextEditingController();
  final TextEditingController economicoEmpresaCtrl = TextEditingController();
  final TextEditingController economicoEscolaridadeCtrl = TextEditingController();

  final TextEditingController economicoMoradiaTipoCtrl = TextEditingController();  
  final TextEditingController economicoQtdComodosCtrl = TextEditingController();

  final TextEditingController economicoEsfCtrl = TextEditingController();
  final TextEditingController economicoProjetoSocialCtrl = TextEditingController();
  final TextEditingController economicoDoencaCronicaCtrl = TextEditingController();
  final TextEditingController economicoUsaDrogasCtrl = TextEditingController();



  // ======================================================================
  // 🔹 3) ABRIR MODAL PRINCIPAL — APENAS EXIBE INFORMAÇÕES (READ)
  // ======================================================================
  Future<void> abrirAcolhimentoModal(
    BuildContext context,
    Map dados,
  ) async {
    final nome = dados["Nome_Usuario"] ?? "N/A";
    final profissional = dados["Nome_Profissional"] ?? "N/A";
    final data = dados["DataAtendimento"] ?? "N/A";
    final hora = dados["HoraAtendimento"] ?? "N/A";

    // → Esses dados virão do backend no futuro
    final familiarWidgets = <Widget>[
      _info("Núcleo Familiar:", "Nenhum registro encontrado"),
    ];

    final economicoWidgets = <Widget>[
      _info("Cadastro Socioeconômico:", "Nenhum registro encontrado"),
    ];

    await AcolhimentoAdmModals.showAcolhimentoModal(
      context: context,
      nomeUsuario: nome,
      profissional: profissional,
      data: data,
      hora: hora,
      familiarDataWidgets: familiarWidgets,
      economicoDataWidgets: economicoWidgets,
      onEditFamiliar: () {},     // edição será na próxima fase (Finalizado)
      onEditEconomico: () {},    // edição será na próxima fase (Finalizado)
    );
  }



  // ======================================================================
  // 🔹 4) CREATE — NÚCLEO FAMILIAR  (BOTÃO Icons.group_add)
  // ======================================================================
  Future<void> abrirCreateFamiliarModal(
    BuildContext context,
    String usuarioId,
    String nomeUsuario,
  ) async {
    // limpar campos
    familiarNomeCtrl.clear();
    familiarNomeSocialCtrl.clear();
    familiarIdadeCtrl.clear();
    familiarGeneroCtrl.clear();
    familiarEscolaridadeCtrl.clear();
    familiarParentescoCtrl.clear();
    familiarProfissaoCtrl.clear();
    familiarDrogasCtrl.clear();

    final form = <Widget>[
      _field(familiarNomeCtrl, "Nome", required: true),
      _field(familiarNomeSocialCtrl, "Nome Social"),
      _field(familiarIdadeCtrl, "Idade", keyboard: TextInputType.number),
      _field(familiarGeneroCtrl, "Gênero"),
      _field(familiarEscolaridadeCtrl, "Escolaridade"),
      _field(familiarParentescoCtrl, "Parentesco", required: true),
      _field(familiarProfissaoCtrl, "Profissão"),
      _field(familiarDrogasCtrl, "Usa Drogas (Sim/Nao)"),
    ];

    await AcolhimentoAdmModals.showCreateFamiliarModal(
      context: context,
      nomeUsuario: "Novo familiar de $nomeUsuario",
      formFields: form,
      onSave: () async {

        final data = {
          "Usuario_idUsuario": usuarioId,
          "Nome": familiarNomeCtrl.text,
          "NomeSocial": familiarNomeSocialCtrl.text,
          "Idade": familiarIdadeCtrl.text,
          "Genero": familiarGeneroCtrl.text,
          "Escolaridade": familiarEscolaridadeCtrl.text,
          "Parentesco": familiarParentescoCtrl.text,
          "Profissao": familiarProfissaoCtrl.text,
          "Drogas": familiarDrogasCtrl.text,
        };

        await _service.addAcolhimentoFamilia(data);

        Navigator.pop(context);
        alerta(context, "Membro familiar cadastrado com sucesso!");
      },
    );
  }



  // ======================================================================
  // 🔹 5) CREATE — CADASTRO SOCIOECONÔMICO  (BOTÃO attach_money)
  // ======================================================================
  Future<void> abrirCreateEconomicoModal(
    BuildContext context,
    String usuarioId,
    String nomeUsuario,
  ) async {
    // limpar campos
    economicoEstadoCivilCtrl.clear();
    economicoNaturalidadeCtrl.clear();
    economicoCorCtrl.clear();
    economicoBeneficioSocCtrl.clear();
    economicoEnderecoCtrl.clear();
    economicoBairroCtrl.clear();
    economicoNumeroCtrl.clear();
    economicoNrNisCtrl.clear();
    economicoRendaCtrl.clear();
    economicoProfissaoCtrl.clear();
    economicoEmpresaCtrl.clear();
    economicoEscolaridadeCtrl.clear();
    economicoMoradiaTipoCtrl.clear();    
    economicoQtdComodosCtrl.clear();
    economicoEsfCtrl.clear();
    economicoProjetoSocialCtrl.clear();
    economicoDoencaCronicaCtrl.clear();
    economicoUsaDrogasCtrl.clear();

    final form = <Widget>[
      _field(economicoEstadoCivilCtrl, "Estado Civil"),
      _field(economicoNaturalidadeCtrl, "Naturalidade"),
      _field(economicoCorCtrl, "Cor"),
      _field(economicoBeneficioSocCtrl, "Benefício Social"),
      _field(economicoEnderecoCtrl, "Endereço", required: true),
      _field(economicoBairroCtrl, "Bairro", required: true),
      _field(economicoNumeroCtrl, "Número"),
      _field(economicoNrNisCtrl, "NR NIS"),
      _field(economicoRendaCtrl, "Renda", keyboard: TextInputType.number, required: true),
      _field(economicoProfissaoCtrl, "Profissão", required: true),
      _field(economicoEmpresaCtrl, "Empresa"),
      _field(economicoEscolaridadeCtrl, "Escolaridade"),
      _field(economicoMoradiaTipoCtrl, "Moradia Tipo"),      
      _field(economicoQtdComodosCtrl, "Qtd Cômodos", keyboard: TextInputType.number),
      _field(economicoEsfCtrl, "ESF"),
      _field(economicoProjetoSocialCtrl, "Projeto Social"),
      _field(economicoDoencaCronicaCtrl, "Doença Crônica"),
      _field(economicoUsaDrogasCtrl, "Usa Drogas (Sim/Nao)"),
    ];

    await AcolhimentoAdmModals.showCreateEconomicoModal(
      context: context,
      nomeUsuario: "Cadastro socioeconômico de $nomeUsuario",
      formFields: form,
      onSave: () async {
        final data = {
          "Usuario_idUsuario": usuarioId,
          "EstadoCivil": economicoEstadoCivilCtrl.text,
          "Naturalidade": economicoNaturalidadeCtrl.text,
          "Cor": economicoCorCtrl.text,
          "BeneficioSoc": economicoBeneficioSocCtrl.text,
          "Endereco": economicoEnderecoCtrl.text,
          "Bairro": economicoBairroCtrl.text,
          "Numero": economicoNumeroCtrl.text,
          "NR_NIS": economicoNrNisCtrl.text,
          "Renda": economicoRendaCtrl.text,
          "Profissao": economicoProfissaoCtrl.text,
          "Empresa": economicoEmpresaCtrl.text,
          "Escolaridade": economicoEscolaridadeCtrl.text,
          "MoradiaTipo": economicoMoradiaTipoCtrl.text,          
          "QtdComodos": economicoQtdComodosCtrl.text,
          "ESF": economicoEsfCtrl.text,
          "ProjetoSocial": economicoProjetoSocialCtrl.text,
          "DoencaCronica": economicoDoencaCronicaCtrl.text,
          "UsaDrogas": economicoUsaDrogasCtrl.text,
        };

        await _service.addAcolhimentoSocioecon(data);

        Navigator.pop(context);
        alerta(context, "Cadastro socioeconômico salvo com sucesso!");
      },
    );
  }

   /// =============================================
  /// 6) ABRIR MODAL DE FIM DE ACOLHIMENTO
  /// =============================================
  Future<void> abrirFimAcolhimentoModal(BuildContext context, String idAtendimento) async {
    await AcolhimentoAdmModals.showFimAcolhimentoModal(
      context: context,
      onConfirm: () async {
        await _auxService.updateAgenda(
          idAtendimento,
          {"Status": "Finalizado"},
        );

        Navigator.pop(context);
        alerta(context, "Acolhimento finalizado!");
      },
    );
  }

  // ============================================================
  // 6) UTILITÁRIOS
  // ============================================================

  static Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "$label ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool required = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: required ? "$label *" : label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void alerta(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
