
class Agenda {
  final String data;
  final String dataPorExtenso;
  final List<ProfissionalAgenda> profissionais;

  Agenda({
    required this.data,
    required this.dataPorExtenso,
    required this.profissionais,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      data: json['data'] as String,
      dataPorExtenso: json['dataPorExtenso'] as String,
      profissionais: (json['profissionais'] as List<dynamic>)
          .map((e) => ProfissionalAgenda.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfissionalAgenda {
  final int id;
  final String nome;
  final String? foto;
  final List<String> horarios;

  ProfissionalAgenda({
    required this.id,
    required this.nome,
    this.foto,
    required this.horarios,
  });

  factory ProfissionalAgenda.fromJson(Map<String, dynamic> json) {
    return ProfissionalAgenda(
      id: json['id'] as int,
      nome: json['nome'] as String,
      foto: json['foto'] as String?,
      horarios: (json['horarios'] as List<dynamic>).cast<String>(),
    );
  }
}