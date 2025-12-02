class AgendaItem {
  final String data;
  final String hora;
  final String nomeCliente;
  final String descricaoServico;
  final String tipo;

  AgendaItem({
    required this.data,
    required this.hora,
    required this.nomeCliente,
    required this.descricaoServico,
    required this.tipo,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    return AgendaItem(
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      nomeCliente: json['nomeCliente'] ?? '',
      descricaoServico: json['descricaoServico'] ?? '',
      tipo: json['tipo'] ?? '',
    );
  }
}
