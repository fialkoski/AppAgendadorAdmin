import 'package:intl/intl.dart';

class ErroRequisicao {
  final int status;
  final String mensagem;
  final String codigo;
  final String timestamp;

  ErroRequisicao(
      {required this.status,
      required this.mensagem,
      required this.codigo,
      required this.timestamp});

  String mensagemFormatada() {
    return '$mensagem\nData:$timestamp\nStatus:$status';
  }

  factory ErroRequisicao.fromJson(Map<String, dynamic> json) {
    return ErroRequisicao(
      status: json['status'] ?? 0,
      mensagem: json['mensagem'].toString(),
      codigo: json['codigo'] ?? "",
      timestamp: DateFormat('dd/MM/yyyy HH:mm:ss').format(
          DateTime.parse(json['timestamp']).add(const Duration(hours: -3))),
    );
  }
}
