class ProfissionalServico {
  final int idServico;
  int idProfissional;
  int habilitado;
  final String descricao;

  ProfissionalServico({
    required this.idServico,
    required this.idProfissional,
    required this.habilitado,
    required this.descricao,
  });

  factory ProfissionalServico.fromJson(Map<String, dynamic> json) =>
      ProfissionalServico(
        idServico: json['idServico'],
        idProfissional: json['idProfissional'] ?? 0,
        habilitado: json['habilitado'],
        descricao: json['descricao'],
      );

  Map<String, dynamic> toJson() => {
    'idServico': idServico,
    'idProfissional': idProfissional,
    'habilitado': habilitado,
    'descricao': descricao,
  };
}
