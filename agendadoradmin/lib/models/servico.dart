class Servico {
  final int id;
  final String descricao;
  final String tempo;
  final double preco;
  final int idEmpresa;

  Servico({
    required this.id,
    required this.descricao,
    required this.tempo,
    required this.preco,
    required this.idEmpresa,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      tempo: json['tempo'].toString(), // Converte int para String
      preco: (json['preco'] as num).toDouble(),
      idEmpresa: json['idEmpresa'] ?? 1, // Valor padrão se não estiver no JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'tempo': tempo,
      'preco': preco,
      'idEmpresa': idEmpresa,
    };
  }
}