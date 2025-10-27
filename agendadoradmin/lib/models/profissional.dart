class Profissional {
  int? id;
  int idEmpresa;
  String nome;
  String? foto;
  int ativo;

  Profissional({
    this.id,
    required this.idEmpresa,
    required this.nome,
    this.foto,
    this.ativo = 1,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) => Profissional(
        id: json['id'],
        idEmpresa: json['idEmpresa'],
        nome: json['nome'],
        foto: json['foto'],
        ativo: json['ativo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'idEmpresa': idEmpresa,
        'nome': nome,
        'foto': foto,
        'ativo': ativo,
      };
}