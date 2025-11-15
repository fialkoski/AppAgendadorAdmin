class ProfissionalHorario {
  final int idProfissional;
  final int diaSemana;
  final String hora;

  ProfissionalHorario({
    required this.idProfissional,
    required this.diaSemana,
    required this.hora,
  });

  factory ProfissionalHorario.fromJson(Map<String, dynamic> json) =>
      ProfissionalHorario(
        idProfissional: json['idProfissional'],
        diaSemana: json['diaSemana'],
        hora: json['hora'],
      );

  Map<String, dynamic> toJson() => {
    'idProfissional': idProfissional,
    'diaSemana': diaSemana,
    'hora': hora,
  };
}
