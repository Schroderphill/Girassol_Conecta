// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/agenda_service.dart';


// ===============================================================
//    MODAL — TERMOS DE USO (UI revisada)
// ===============================================================

Future<void> showTermsModal(BuildContext context, Map<String, dynamic> user) async {
  bool concordo = false;

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.black.withAlpha((255 * 0.6).round()),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Termos de Uso",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Informamos que os dados mantidos pelo Girassol serão "
                        "excluídos completamente após solicitação formal via "
                        "e-mail oficial (GirassolConecta@girassol.org.br), "
                        "garantindo a conformidade com as normas do sistema "
                        "e com a Lei Geral de Proteção de Dados (LGPD).",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15, height: 1.35),
                      ),

                      const SizedBox(height: 22),

                      CheckboxListTile(
                        value: concordo,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        onChanged: (v) => setState(() => concordo = v!),
                        title: const Text("Concordo com os Termos de Uso"),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: concordo
                              ? () async {
                                  final int userId = int.tryParse(
                                          user['idUsuario'].toString()) ??
                                      0;

                                  await AuthService.aceitarTermos(userId);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Confirmar"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}


// ===============================================================
//    MODAL — PRIMEIRA SOLICITAÇÃO (UI revisada)
// ===============================================================

Future<void> showFirstSolicitacaoModal(
  BuildContext context,
  Map<String, dynamic> user,
) async {
  final agendaService = AgendaService();

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.black.withAlpha((255 * 0.6).round()),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Primeira Solicitação de Atendimento",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Bem-vinde ao Girassol Conecta! Para continuar, "
                    "você precisa solicitar seu primeiro atendimento de "
                    "acolhimento.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.35),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Tipo: ACOLHIMENTO",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text("Status: SOLICITADO"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await agendaService.addAgenda({
                          "Usuario_idUsuario": user['idUsuario'].toString(),
                          "TipoAtendimento": "Acolhimento",
                          "Status": "Solicitado",
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Solicitar Atendimento"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
