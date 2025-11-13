class Servico {
  final int id;
  final String descricao;
  final String tempo;
  final double preco;
  final int idEmpresa;
  int ativo;

  Servico({
    required this.id,
    required this.descricao,
    required this.tempo,
    required this.preco,
    required this.idEmpresa,
    this.ativo = 1,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      descricao: json['descricao'],
      tempo: json['tempo'].toString(),
      preco: (json['preco'] as num).toDouble(),
      idEmpresa: json['idEmpresa'], 
      ativo: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'tempo': tempo,
      'preco': preco,
      'idEmpresa': idEmpresa,
      'ativo': ativo,
    };
  }
}